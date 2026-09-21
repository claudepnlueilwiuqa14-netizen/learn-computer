param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Strict
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-StateCount {
    param([string[]]$States)
    $result = [ordered]@{ '⬜' = 0; '🔄' = 0; '✅' = 0; '⚠️' = 0; '❌' = 0; Other = 0 }
    foreach ($state in $States) {
        if ($result.Contains($state)) { $result[$state]++ } else { $result.Other++ }
    }
    return $result
}

$evidenceRoot = Join-Path $Root 'evidence'
$courseDirs = @(Get-ChildItem -LiteralPath $evidenceRoot -Directory | Where-Object { $_.Name -notin @('_templates', 'boss') })
$courseRows = @()
$gateStates = [System.Collections.Generic.List[string]]::new()
$sourceRecorded = 0
$courseReadmes = 0
$courseMissingReadme = 0
$labStates = [System.Collections.Generic.List[string]]::new()
$missingLabReadme = 0

foreach ($courseDir in $courseDirs) {
    $readmePath = Join-Path $courseDir.FullName 'README.md'
    if (-not (Test-Path -LiteralPath $readmePath -PathType Leaf)) {
        $courseMissingReadme++
        continue
    }
    $courseReadmes++
    $courseText = Get-Content -Raw -Encoding utf8 $readmePath
    $gates = @([regex]::Matches($courseText, '^- Lv[1-5]：(?<state>[⬜🔄✅⚠️❌])', 'Multiline') | ForEach-Object { $_.Groups['state'].Value })
    foreach ($state in $gates) { $gateStates.Add($state) }
    $sourceMatch = [regex]::Match($courseText, '资料页面/章节/版本/访问日期：(?<value>[^\r\n]*)')
    if ($sourceMatch.Success -and -not [string]::IsNullOrWhiteSpace($sourceMatch.Groups['value'].Value)) { $sourceRecorded++ }
    for ($labNumber = 1; $labNumber -le 5; $labNumber++) {
        $labReadme = Join-Path $courseDir.FullName "labs\lab$labNumber\README.md"
        if (-not (Test-Path -LiteralPath $labReadme -PathType Leaf)) {
            $missingLabReadme++
            continue
        }
        $labText = Get-Content -Raw -Encoding utf8 $labReadme
        $labMatch = [regex]::Match($labText, '^状态：(?<state>[⬜🔄✅⚠️❌])', 'Multiline')
        if ($labMatch.Success) { $labStates.Add($labMatch.Groups['state'].Value) } else { $labStates.Add('Other') }
    }
}

$bossProgressPath = Join-Path $evidenceRoot 'boss\PROGRESS.md'
$bossProgressText = Get-Content -Raw -Encoding utf8 $bossProgressPath
$bossStates = @([regex]::Matches($bossProgressText, '^\| (?:I|II|III|IV|V|VI|VII|VIII) .*? \| (?<state>[⬜🔄✅⚠️❌]) \|', 'Multiline') | ForEach-Object { $_.Groups['state'].Value })

$capstoneRoot = Join-Path $Root 'capstone'
$capstoneRows = @()
foreach ($projectDir in @(Get-ChildItem -LiteralPath $capstoneRoot -Directory | Where-Object { $_.Name -match '^\d{2}_' })) {
    $baselinePath = Join-Path $projectDir.FullName 'evidence\deep-baseline-2026-09-09.json'
    if (-not (Test-Path -LiteralPath $baselinePath -PathType Leaf)) {
        $capstoneRows += [pscustomobject]@{ Project = $projectDir.Name; Machine = 'MISSING'; Graduation = 'MISSING' }
        continue
    }
    $json = Get-Content -Raw -Encoding utf8 $baselinePath | ConvertFrom-Json
    $capstoneRows += [pscustomobject]@{ Project = $projectDir.Name; Machine = [string]$json.status; Graduation = [string]$json.graduation_decision }
}

$gateCounts = Get-StateCount @($gateStates)
$labCounts = Get-StateCount @($labStates)
$bossCounts = Get-StateCount @($bossStates)
$machinePass = @($capstoneRows | Where-Object Machine -eq 'BASELINE_PASS').Count
$notReady = @($capstoneRows | Where-Object Graduation -eq 'NOT_READY').Count
$summaryPass = $courseDirs.Count -eq 590 -and $courseReadmes -eq 590 -and $courseMissingReadme -eq 0 -and $gateStates.Count -eq 2950 -and $labStates.Count -eq 2950 -and $missingLabReadme -eq 0 -and $bossStates.Count -eq 40 -and $capstoneRows.Count -eq 8 -and $notReady -eq 8

'=== 学习者进度核验（机器不代完成） ==='
"Courses=$($courseDirs.Count) CourseReadmes=$courseReadmes MissingCourseReadmes=$courseMissingReadme"
"LearnerGates=$($gateStates.Count) EmptyGates=$($gateCounts['⬜']) CompletedGates=$($gateCounts['✅'])"
"LearnerLabs=$($labStates.Count) EmptyLabs=$($labCounts['⬜']) CompletedLabs=$($labCounts['✅']) MissingLabReadmes=$missingLabReadme"
"SourceRecords=$sourceRecorded/$courseReadmes"
"BossChallenges=$($bossStates.Count) EmptyBoss=$($bossCounts['⬜']) CompletedBoss=$($bossCounts['✅'])"
"Capstones=$($capstoneRows.Count) MachineBaselinePass=$machinePass GraduationNotReady=$notReady"
"Status=$(if ($summaryPass) { 'PASS' } else { 'FAIL' })"

$evidenceDir = Join-Path $Root 'evidence'
$reportPath = Join-Path $evidenceDir 'LEARNER-PROGRESS-2026-09-09.md'
$lines = @(
    '# 学习者进度快照 · 2026-09-09',
    '',
    '本报告只统计学习者证据目录中的显式状态；自动化基线、结构合同和机器毕业工程证据单独列出，不会转化为学习者完成。',
    '',
    '| 项目 | 总量 | 未开始 | 进行中 | 人工通过 | 阻塞 | 失败/其他 |',
    '|---|---:|---:|---:|---:|---:|---:|',
    "| Lv1–Lv5 关卡 | $($gateStates.Count) | $($gateCounts['⬜']) | $($gateCounts['🔄']) | $($gateCounts['✅']) | $($gateCounts['⚠️']) | $($gateCounts['❌'] + $gateCounts.Other) |",
    "| 基础 Lab 1–5 | $($labStates.Count) | $($labCounts['⬜']) | $($labCounts['🔄']) | $($labCounts['✅']) | $($labCounts['⚠️']) | $($labCounts['❌'] + $labCounts.Other) |",
    "| 第三轮 Boss Lab | $($bossStates.Count) | $($bossCounts['⬜']) | $($bossCounts['🔄']) | $($bossCounts['✅']) | $($bossCounts['⚠️']) | $($bossCounts['❌'] + $bossCounts.Other) |",
    '',
    "课号证据目录：$($courseDirs.Count)，README：$courseReadmes，缺失 README：$courseMissingReadme。",
    "资料实际记录字段：$sourceRecorded/$courseReadmes 个课号 README 已填写；空白字段不能视为读过资料。",
    "八项毕业工程机器基线：$machinePass/8 PASS；毕业决定仍为 NOT_READY：$notReady/8。",
    '',
    '## 解释边界',
    '',
    '- 机器基线 PASS 说明脚本/探针可重复运行，不是学习者完成。',
    '- 空白状态只说明尚未提交或尚未被人工验收，不说明能力不足。',
    '- 学习者提交必须包含版本、命令、原始输出、失败分支、清理、解释和未验证项。'
)
Set-Content -LiteralPath $reportPath -Value ($lines -join "`n") -Encoding utf8
"Evidence=$reportPath"

if ($Strict -and -not $summaryPass) { exit 2 }
