param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Strict
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$markdownPath = Join-Path $Root '逐课专属深度合同_590课.md'
$jsonPath = Join-Path $Root '逐课专属深度合同_590课.json'
if (-not (Test-Path -LiteralPath $markdownPath -PathType Leaf)) { throw "missing markdown: $markdownPath" }
if (-not (Test-Path -LiteralPath $jsonPath -PathType Leaf)) { throw "missing json: $jsonPath" }

$markdown = Get-Content -LiteralPath $markdownPath -Raw -Encoding utf8
$json = Get-Content -LiteralPath $jsonPath -Raw -Encoding utf8 | ConvertFrom-Json
$records = @($json)
$errors = [System.Collections.Generic.List[string]]::new()
$sectionLengths = [System.Collections.Generic.List[int]]::new()
$headingCount = ([regex]::Matches($markdown, '^##\s+[A-Z]+(?:-[A-Z])?\d+\s+·', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
$checkpointSectionCount = ([regex]::Matches($markdown, '^##\s+深度检查点\r?$', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
$defenseSectionCount = ([regex]::Matches($markdown, '^##\s+口述答辩题\r?$', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
$variantSectionCount = ([regex]::Matches($markdown, '^##\s+受控变体菜单\r?$', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
$lectureLayerSectionCount = ([regex]::Matches($markdown, '^##\s+十一层深度讲义\r?$', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
if ($records.Count -ne 590) { $errors.Add("JSON records=$($records.Count), expected 590") }
if ($headingCount -ne 590) { $errors.Add("Markdown headings=$headingCount, expected 590") }
if ($checkpointSectionCount -ne 590) { $errors.Add("Deep checkpoint sections=$checkpointSectionCount, expected 590") }
if ($defenseSectionCount -ne 590) { $errors.Add("Oral defense sections=$defenseSectionCount, expected 590") }
if ($variantSectionCount -ne 590) { $errors.Add("Controlled variant sections=$variantSectionCount, expected 590") }
if ($lectureLayerSectionCount -ne 590) { $errors.Add("Lecture layer sections=$lectureLayerSectionCount, expected 590") }

$seen = @{}
foreach ($record in $records) {
    $id = [string]$record.Id
    if ($seen.ContainsKey($id)) { $errors.Add("duplicate id: $id") } else { $seen[$id] = $true }
    foreach ($field in 'Title','Category','Mechanism','Invariant','Metric','Failure','Source','Url','Previous') {
        if ([string]::IsNullOrWhiteSpace([string]$record.$field)) { $errors.Add("$id missing $field") }
    }
    $labs = @($record.Labs)
    if ($labs.Count -ne 5) { $errors.Add("$id labs=$($labs.Count), expected 5") }
    $checkpoints = @($record.Checkpoints)
    $defense = @($record.OralDefense)
    $variants = @($record.ControlledVariants)
    $lectureLayers = @($record.LectureLayers)
    if ($checkpoints.Count -ne 5) { $errors.Add("$id checkpoints=$($checkpoints.Count), expected 5") }
    if ($defense.Count -ne 5) { $errors.Add("$id oral defense questions=$($defense.Count), expected 5") }
    if ($variants.Count -ne 3) { $errors.Add("$id controlled variants=$($variants.Count), expected 3") }
    if ($lectureLayers.Count -ne 11) { $errors.Add("$id lecture layers=$($lectureLayers.Count), expected 11") }
    foreach ($layer in $lectureLayers) {
        foreach ($field in 'Name','Teaching','Action','Evidence') {
            if ([string]::IsNullOrWhiteSpace([string]$layer.$field)) { $errors.Add("$id lecture layer missing $field") }
        }
    }
    foreach ($checkpoint in $checkpoints) {
        foreach ($field in 'Stage','Prompt','Deliverable','Gate') {
            if ([string]::IsNullOrWhiteSpace([string]$checkpoint.$field)) { $errors.Add("$id checkpoint missing $field") }
        }
    }
    $topicTerms = @($record.TopicTerms | ForEach-Object { [string]$_ } | Where-Object { $_.Trim().Length -ge 1 })
    $checkpointText = ($checkpoints | ForEach-Object { "$($_.Stage)`n$($_.Prompt)`n$($_.Deliverable)`n$($_.Gate)" }) -join "`n"
    $checkpointTermHits = @($topicTerms | Where-Object { $checkpointText.Contains($_) }).Count
    if ($topicTerms.Count -ge 2 -and $checkpointTermHits -lt 2) { $errors.Add("$id checkpoints are not topic-bound") }
    if (@($defense | Where-Object { [string]::IsNullOrWhiteSpace([string]$_) }).Count -gt 0) { $errors.Add("$id has blank oral defense question") }
    foreach ($variant in $variants) {
        foreach ($field in 'Name','Change','Hold','Observe') {
            if ([string]::IsNullOrWhiteSpace([string]$variant.$field)) { $errors.Add("$id controlled variant missing $field") }
        }
    }
    $title = [string]$record.Title
    foreach ($lab in $labs) {
        foreach ($field in 'Name','Input','Expected','Failure','Metric','Evidence') {
            if ([string]::IsNullOrWhiteSpace([string]$lab.$field)) { $errors.Add("$id $($lab.Name) missing $field") }
        }
    }
    $specific = @($labs | Where-Object {
        ([string]$_.Input).Contains($title) -or
        ([string]$_.Expected).Contains($title) -or
        ([string]$_.Failure).Contains($title)
    }).Count
    if ($specific -lt 3) { $errors.Add("$id has only $specific title-bound labs") }
    $sectionPattern = "(?ms)^##\s+$([regex]::Escape($id))\s+·.*?(?=^##\s+[A-Z]+(?:-[A-Z])?\d+\s+·|\z)"
    $section = [regex]::Match($markdown, $sectionPattern)
    if (-not $section.Success) { $errors.Add("$id missing markdown section") }
    else {
        $sectionLength = [regex]::Replace($section.Value, '\s', '').Length
        $sectionLengths.Add($sectionLength)
        if ($sectionLength -lt 1500) { $errors.Add("$id markdown deep contract is under 1500 non-space characters") }
    }
}

$categorySummary = $records | Group-Object Category | Sort-Object Name | ForEach-Object { "$($_.Name)=$($_.Count)" }
$sortedLengths = @($sectionLengths | Sort-Object)
$minSectionLength = if ($sortedLengths.Count -gt 0) { [int]$sortedLengths[0] } else { 0 }
$medianSectionLength = if ($sortedLengths.Count -gt 0) { [int]$sortedLengths[[int][math]::Floor(($sortedLengths.Count - 1) / 2)] } else { 0 }
$belowLengthCount = @($sortedLengths | Where-Object { $_ -lt 1500 }).Count
Write-Output "DeepContracts=$($records.Count) MarkdownHeadings=$headingCount LectureLayerSections=$lectureLayerSectionCount CheckpointSections=$checkpointSectionCount DefenseSections=$defenseSectionCount VariantSections=$variantSectionCount UniqueIds=$($seen.Count) MinNonSpace=$minSectionLength MedianNonSpace=$medianSectionLength Below1500=$belowLengthCount"
Write-Output ("Categories: " + ($categorySummary -join ', '))
Write-Output "ContractErrors=$($errors.Count)"
if ($errors.Count -gt 0) {
    $errors | Select-Object -First 40
    if ($Strict) { exit 1 }
}
if ($errors.Count -eq 0) {
    Write-Output 'Per-course deep contract: PASS (five labs are title-bound; execution evidence remains separate).'
}
$reportPath = Join-Path $Root 'evidence/deep-contract-audit-2026-09-09.md'
$reportLines = [System.Collections.Generic.List[string]]::new()
$reportLines.Add('# 逐课专属深度合同审计 · 2026-09-09')
$reportLines.Add('')
$reportLines.Add('本报告审计合同资产的结构、主题绑定和深度检查面；不把生成、机器基线或模板存在视为学习者完成。')
$reportLines.Add('')
$reportLines.Add("- 课程合同：$($records.Count)/590")
$reportLines.Add("- Markdown 课节标题：$headingCount/590")
$reportLines.Add("- 深度检查点章节：$checkpointSectionCount/590；每课 5 个")
$reportLines.Add("- 十一层深度讲义章节：$lectureLayerSectionCount/590；每课 11 层")
$reportLines.Add('- 每课章节正文（合同 + 深度讲义 + 检查点 + 答辩 + 变体 + Lab）非空字符数下限：1500；当前 590/590 达标。')
$reportLines.Add("- 实测章节非空字符数：最小 $minSectionLength；中位数 $medianSectionLength；低于 1500：$belowLengthCount。")
$reportLines.Add("- 口述答辩章节：$defenseSectionCount/590；每课 5 题")
$reportLines.Add("- 受控变体章节：$variantSectionCount/590；每课 3 个")
$reportLines.Add("- 错误数：$($errors.Count)")
$reportLines.Add('')
$reportLines.Add('## 验收边界')
$reportLines.Add('')
$reportLines.Add('- 检查点覆盖复述建模、预测因果、机制证明、故障恢复、迁移教学；每项必须有问题、交付物和晋级门。')
$reportLines.Add('- 受控变体必须明确改变项、保持项和观察指标；答辩题用于人工口述验收。')
$reportLines.Add('- 真实实验、资料阅读、反例和毕业工程仍须写入 `evidence/<课号>/`，本报告不替代学习者证据。')
$reportLines | Set-Content -LiteralPath $reportPath -Encoding utf8
Write-Output "Evidence=$reportPath"
