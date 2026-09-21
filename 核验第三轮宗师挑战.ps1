param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Strict
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$challengePath = Join-Path $Root '深度增补_2026-09-09_第三轮_宗师挑战.md'
$indexPath = Join-Path $Root '教案_总索引.md'
$boardPath = Join-Path $Root '进度看板.md'
$taskPath = Join-Path $Root '台前任务列表_课程重构.md'
$bossIndexPath = Join-Path $Root 'evidence\boss\README.md'
$bossTemplatePath = Join-Path $Root 'evidence\_templates\boss挑战_README.md'
$bossProgressPath = Join-Path $Root 'evidence\boss\PROGRESS.md'
$initializerPath = Join-Path $Root '初始化Boss挑战证据.ps1'
$text = if (Test-Path -LiteralPath $challengePath -PathType Leaf) { Get-Content -Raw -Encoding utf8 $challengePath } else { '' }

$macroNames = @(
    'I. 预备与编程',
    'II. 算法与数学',
    'III. 计算机系统',
    'IV. 网络与分布式',
    'V. 数据库与数据工程',
    'VI. Web 与产品工程',
    'VII. 安全与逆向',
    'VIII. AI、云原生与端侧'
)
$challengeIds = @()
foreach ($letter in 'A','B','C','D','E','F','G','H') {
    foreach ($number in 1..5) { $challengeIds += "$letter$number" }
}
$missingMacros = @($macroNames | Where-Object { -not $text.Contains("## $_") })
$missingChallenges = @($challengeIds | Where-Object { -not $text.Contains("**$_ ") })
$ladders = ([regex]::Matches($text, '### L6–L10 闯关')).Count
$bossSections = ([regex]::Matches($text, '### 五个 Boss Lab')).Count
$sourceSections = ([regex]::Matches($text, '资料命题：')).Count
$contractFields = @(@('commands.txt', 'tests/', 'artifacts/', 'notes.md', '控制组', '三次重复', '失败分支', '清理记录') | Where-Object { -not $text.Contains($_) })
$bossIndexText = if (Test-Path -LiteralPath $bossIndexPath -PathType Leaf) { Get-Content -Raw -Encoding utf8 $bossIndexPath } else { '' }
$bossTemplateText = if (Test-Path -LiteralPath $bossTemplatePath -PathType Leaf) { Get-Content -Raw -Encoding utf8 $bossTemplatePath } else { '' }
$bossProgressText = if (Test-Path -LiteralPath $bossProgressPath -PathType Leaf) { Get-Content -Raw -Encoding utf8 $bossProgressPath } else { '' }
$mappingGaps = @(@('A1–A5', 'B1–B5', 'C1–C5', 'D1–D5', 'E1–E5', 'F1–F5', 'G1–G5', 'H1–H5') | Where-Object { -not $bossIndexText.Contains($_) })
$templateGaps = @(@('L6 独立复现', 'L7 主动破坏', 'L8 第二种设计', 'L9 研究边界', 'L10 口述答辩') | Where-Object { -not $bossTemplateText.Contains($_) })
$progressRows = ([regex]::Matches($bossProgressText, '^\| (?:I|II|III|IV|V|VI|VII|VIII) ', 'Multiline')).Count
$progressStarted = ([regex]::Matches($bossProgressText, '\| [🔄✅⚠️] ', 'Multiline')).Count
$referencedDocs = @(@($indexPath, $boardPath, $taskPath, $bossIndexPath, $bossTemplatePath, $bossProgressPath, $initializerPath) | Where-Object { -not (Test-Path -LiteralPath $_ -PathType Leaf) })
$referencedTextMissing = @(@($indexPath, $boardPath, $taskPath) | Where-Object {
    (Test-Path -LiteralPath $_ -PathType Leaf) -and -not (Get-Content -Raw -Encoding utf8 $_).Contains('第三轮')
})
$pass = (Test-Path -LiteralPath $challengePath -PathType Leaf) -and $missingMacros.Count -eq 0 -and $missingChallenges.Count -eq 0 -and $ladders -eq 8 -and $bossSections -eq 8 -and $sourceSections -eq 8 -and $contractFields.Count -eq 0 -and $mappingGaps.Count -eq 0 -and $templateGaps.Count -eq 0 -and $progressRows -eq 40 -and $progressStarted -eq 0 -and $referencedDocs.Count -eq 0 -and $referencedTextMissing.Count -eq 0

'=== 第三轮宗师挑战核验 ==='
"ChallengeFile=$([bool](Test-Path -LiteralPath $challengePath -PathType Leaf))"
"MacroSections=$(([regex]::Matches($text, '^## (?:I|II|III|IV|V|VI|VII|VIII)\.', 'Multiline')).Count)"
"Ladders=$ladders BossSections=$bossSections SourceSections=$sourceSections"
"ChallengeIds=$($challengeIds.Count) MissingChallengeIds=$($missingChallenges.Count)"
"ContractFieldGaps=$($contractFields.Count) MappingGaps=$($mappingGaps.Count) TemplateGaps=$($templateGaps.Count) ProgressRows=$progressRows StartedRows=$progressStarted LinkedDocGaps=$($referencedDocs.Count + $referencedTextMissing.Count)"
"Status=$(if ($pass) { 'PASS' } else { 'FAIL' })"
if ($missingMacros.Count -gt 0) { "MissingMacros=$($missingMacros -join ',')" }
if ($missingChallenges.Count -gt 0) { "MissingChallenges=$($missingChallenges -join ',')" }
if ($contractFields.Count -gt 0) { "MissingContractFields=$($contractFields -join ',')" }

$evidenceDir = Join-Path $Root 'evidence'
New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null
$evidencePath = Join-Path $evidenceDir 'third-round-audit-2026-09-09.md'
$report = @(
    '# 第三轮宗师挑战结构核验 · 2026-09-09',
    '',
    '这是第三轮教案内容合同核验，不是学习者完成证明。',
    '',
    "宏域段落：$(([regex]::Matches($text, '^## (?:I|II|III|IV|V|VI|VII|VIII)\.', 'Multiline')).Count)/8；L6–L10 梯度：$ladders/8；Boss Lab：$bossSections/8；资料命题：$sourceSections/8；挑战编号：$($challengeIds.Count - $missingChallenges.Count)/40；进度行：$progressRows/40；已启动行：$progressStarted（应为 0）。",
    "机器审计结论：$(if ($pass) { 'PASS' } else { 'FAIL' })。",
    '',
    '解释边界：结构合同通过只说明每个宏域都有可执行挑战、证据字段和资料命题；学习者仍须在 evidence/<课号>/boss/ 中独立复现、解释和答辩。'
)
Set-Content -LiteralPath $evidencePath -Value ($report -join "`n") -Encoding utf8
"Evidence=$evidencePath"

if ($Strict -and -not $pass) { exit 2 }
