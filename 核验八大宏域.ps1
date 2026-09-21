param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Strict
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Add-Range {
    param(
        [System.Collections.Generic.List[string]]$Target,
        [string]$Prefix,
        [int]$Start,
        [int]$End
    )
    foreach ($number in $Start..$End) { $Target.Add("$Prefix$number") }
}

function New-ExpectedIds {
    param([string]$Macro)
    $ids = [System.Collections.Generic.List[string]]::new()
    switch ($Macro) {
        'I' {
            Add-Range $ids 'PRE' 0 8
            Add-Range $ids 'PY' 1 25
            Add-Range $ids 'C' 1 16
            Add-Range $ids 'CPP' 1 9
            Add-Range $ids 'JV' 1 8
            Add-Range $ids 'JS' 1 9
            Add-Range $ids 'GO' 1 7
            Add-Range $ids 'RS' 1 13
            Add-Range $ids 'PAR' 1 7
            Add-Range $ids 'OTH' 1 7
            Add-Range $ids 'SQL' 1 7
            Add-Range $ids 'SH' 1 6
        }
        'II' { Add-Range $ids 'DSA' 1 25 }
        'III' {
            Add-Range $ids 'COMP' 1 7
            Add-Range $ids 'ASM' 1 8
            Add-Range $ids 'OS' 1 17
            Add-Range $ids 'CMP' 1 12
        }
        'IV' { Add-Range $ids 'NET' 1 24 }
        'V' {
            Add-Range $ids 'DB' 1 28
            Add-Range $ids 'DAT' 1 24
        }
        'VI' {
            Add-Range $ids 'FE' 1 18
            Add-Range $ids 'BE' 1 26
            Add-Range $ids 'PD' 1 17
        }
        'VII' {
            Add-Range $ids 'SEC' 1 102
            Add-Range $ids 'SEC-W' 1 8
            Add-Range $ids 'SEC-B' 1 12
            Add-Range $ids 'SEC-C' 1 10
        }
        'VIII' {
            Add-Range $ids 'MOB' 1 53
            Add-Range $ids 'DAT' 25 51
            Add-Range $ids 'OPS' 1 49
        }
    }
    return @($ids)
}

function Get-CardsFromFile {
    param([System.IO.FileInfo]$File)
    $headingPattern = '^##\s+((?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|SEC|MOB|DAT|OPS|PD)(?:-[A-Z]+)?\d*)\s*[· ]'
    $cards = @()
    $current = $null
    foreach ($line in @(Get-Content -LiteralPath $File.FullName -Encoding utf8)) {
        if ($line -match $headingPattern) {
            if ($null -ne $current) { $cards += [pscustomobject]$current }
            $current = [ordered]@{
                Id = $matches[1]
                File = $File.Name
                Source = 0
                Failure = 0
                Lv1 = 0
                Lv2 = 0
                Lv3 = 0
                Lv4 = 0
                Lv5 = 0
                Labs = 0
                ExecutableEvidence = 0
            }
            continue
        }
        if ($null -eq $current) { continue }
        if ($line -match '资料锚点|资料入口') { $current.Source++ }
        if ($line -match '失败实验|必做失败') { $current.Failure++ }
        foreach ($level in 1..5) { if ($line -match "Lv$level") { $current["Lv$level"]++ } }
        if ($line -match 'Lab\s*[1-5]\s*·|^\s*[1-5]\.\s+') { $current.Labs++ }
        if ($line -match '`[^`]+`|命令|运行|执行|脚本|代码') { $current.ExecutableEvidence++ }
    }
    if ($null -ne $current) { $cards += [pscustomobject]$current }
    return @($cards)
}

$definitions = @(
    [pscustomobject]@{ Id = 'I'; Name = '预备与编程'; Heading = '## I. 预备与编程'; Supplements = @('预备层_闯关与实战补强.md', '方向1a_Python_闯关与实战补强.md', '方向1b_多语言_闯关与实战补强.md', '方向1c_Rust范式SQLShell_闯关与实战补强.md'); Capstone = '01_预备与编程' },
    [pscustomobject]@{ Id = 'II'; Name = '算法与数学'; Heading = '## II. 算法与数学'; Supplements = @('方向2_算法_闯关与实战补强.md'); Capstone = '02_算法与数学' },
    [pscustomobject]@{ Id = 'III'; Name = '计算机系统'; Heading = '## III. 计算机系统'; Supplements = @('方向3_底层系统_闯关与实战补强.md'); Capstone = '03_计算机系统' },
    [pscustomobject]@{ Id = 'IV'; Name = '网络与分布式'; Heading = '## IV. 网络与分布式'; Supplements = @('方向4_网络_闯关与实战补强.md'); Capstone = '04_网络与分布式' },
    [pscustomobject]@{ Id = 'V'; Name = '数据库与数据工程'; Heading = '## V. 数据库与数据工程'; Supplements = @('方向5_数据库_闯关与实战补强.md', '方向9_数据AI_闯关与实战补强.md'); Capstone = '05_数据库与数据工程' },
    [pscustomobject]@{ Id = 'VI'; Name = 'Web 与产品工程'; Heading = '## VI. Web 与产品工程'; Supplements = @('方向6_Web全栈_闯关与实战补强.md', '方向11_产品设计软技能_闯关与实战补强.md'); Capstone = '06_Web产品' },
    [pscustomobject]@{ Id = 'VII'; Name = '安全与逆向'; Heading = '## VII. 安全与逆向'; Supplements = @('方向7_安全攻防_闯关与实战补强.md'); Capstone = '07_安全逆向' },
    [pscustomobject]@{ Id = 'VIII'; Name = 'AI、云原生与端侧工程'; Heading = '## VIII. AI、云原生与端侧工程'; Supplements = @('方向8_移动桌面游戏嵌入式_闯关与实战补强.md', '方向9_数据AI_闯关与实战补强.md', '方向10_运维云SRE_闯关与实战补强.md'); Capstone = '08_AI云原生端侧' }
)

$allSupplementFiles = @{}
$allCards = @()
foreach ($definition in $definitions) {
    foreach ($supplementName in $definition.Supplements) {
        if (-not $allSupplementFiles.ContainsKey($supplementName)) {
            $supplementPath = Join-Path $Root $supplementName
            if (-not (Test-Path -LiteralPath $supplementPath -PathType Leaf)) { continue }
            $file = Get-Item -LiteralPath $supplementPath
            $allSupplementFiles[$supplementName] = $file
            $allCards += Get-CardsFromFile $file
        }
    }
}

$indexText = Get-Content -Raw -Encoding utf8 (Join-Path $Root '八大宏域_深度增补总纲.md')
$sourceText = Get-Content -Raw -Encoding utf8 (Join-Path $Root '权威资料目录与复核计划.md')
$urlValues = @([regex]::Matches($sourceText, 'https?://[^\s|)]+') | ForEach-Object { $_.Value.TrimEnd('`') } | Sort-Object -Unique)
$urlCount = $urlValues.Count
$macroRows = @()
$missing = [System.Collections.Generic.List[string]]::new()
$bad = [System.Collections.Generic.List[string]]::new()

foreach ($definition in $definitions) {
    $expected = @(New-ExpectedIds $definition.Id)
    $actual = @($allCards | Where-Object { $_.Id -in $expected })
    $missingIds = @($expected | Where-Object { $_ -notin @($actual.Id) })
    $duplicateIds = @($actual | Group-Object Id | Where-Object Count -gt 1)
    $weak = @($actual | Where-Object {
        $_.Source -eq 0 -or $_.Failure -eq 0 -or $_.Lv1 -eq 0 -or $_.Lv2 -eq 0 -or $_.Lv3 -eq 0 -or $_.Lv4 -eq 0 -or $_.Lv5 -eq 0 -or $_.Labs -lt 5 -or $_.ExecutableEvidence -eq 0
    })
    $missingSupplements = @($definition.Supplements | Where-Object { -not (Test-Path -LiteralPath (Join-Path $Root $_) -PathType Leaf) })
    $capstoneRoot = Join-Path (Join-Path $Root 'capstone') $definition.Capstone
    $capstoneReady = (Test-Path -LiteralPath (Join-Path $capstoneRoot 'README.md') -PathType Leaf) -and (Test-Path -LiteralPath (Join-Path $capstoneRoot 'src') -PathType Container) -and (Test-Path -LiteralPath (Join-Path $capstoneRoot 'tests') -PathType Container)
    $headingPresent = $indexText.Contains($definition.Heading)
    $status = ($expected.Count -eq $actual.Count -and $missingIds.Count -eq 0 -and $duplicateIds.Count -eq 0 -and $weak.Count -eq 0 -and $missingSupplements.Count -eq 0 -and $capstoneReady -and $headingPresent)
    if (-not $status) {
        $bad.Add($definition.Id)
        if ($missingIds.Count -gt 0) { $missing.Add("$($definition.Id): missing ids $($missingIds -join ',')") }
        if ($duplicateIds.Count -gt 0) { $missing.Add("$($definition.Id): duplicate ids $($duplicateIds.Name -join ',')") }
        if ($weak.Count -gt 0) { $missing.Add("$($definition.Id): weak cards $($weak.Count)") }
        if ($missingSupplements.Count -gt 0) { $missing.Add("$($definition.Id): missing supplements $($missingSupplements -join ',')") }
        if (-not $capstoneReady) { $missing.Add("$($definition.Id): capstone structure incomplete") }
        if (-not $headingPresent) { $missing.Add("$($definition.Id): macro heading missing from depth outline") }
    }
    $macroRows += [pscustomobject]@{
        Macro = $definition.Id
        Name = $definition.Name
        Expected = $expected.Count
        Parsed = $actual.Count
        WeakCards = $weak.Count
        Supplements = $definition.Supplements.Count
        Capstone = if ($capstoneReady) { 'READY' } else { 'MISSING' }
        OutlineHeading = if ($headingPresent) { 'PRESENT' } else { 'MISSING' }
        Status = if ($status) { 'PASS' } else { 'FAIL' }
    }
}

$knownIds = @($definitions | ForEach-Object { New-ExpectedIds $_.Id })
$unassigned = @($allCards | Where-Object { $_.Id -notin $knownIds })
$duplicateAll = @($allCards | Group-Object Id | Where-Object Count -gt 1)
$materialsReady = $urlCount -ge 71 -and (Test-Path -LiteralPath (Join-Path $Root '资料链接复核记录_2026-09-09.md') -PathType Leaf)
$globalPass = $bad.Count -eq 0 -and $unassigned.Count -eq 0 -and $duplicateAll.Count -eq 0 -and $knownIds.Count -eq 590 -and $materialsReady

'=== 八大宏域与预备层核验 ==='
$macroRows | Format-Table -AutoSize
"MacroCount=$($definitions.Count)"
"ExpectedCards=$($knownIds.Count) ParsedCards=$($allCards.Count)"
"UnassignedCards=$($unassigned.Count) DuplicateCards=$($duplicateAll.Count)"
"AuthorityUrls=$urlCount AuthorityReviewRecord=$([bool](Test-Path -LiteralPath (Join-Path $Root '资料链接复核记录_2026-09-09.md') -PathType Leaf))"
"Status=$(if ($globalPass) { 'PASS' } else { 'FAIL' })"
if ($missing.Count -gt 0) {
    'Issues:'
    $missing
}

$evidenceDir = Join-Path $Root 'evidence'
New-Item -ItemType Directory -Path $evidenceDir -Force | Out-Null
$evidencePath = Join-Path $evidenceDir 'macro-audit-2026-09-09.md'
$evidenceLines = @(
    '# 八大宏域与预备层结构核验 · 2026-09-09',
    '',
    '这是课程资产结构审计，不是学习者完成证明。它验证宏域映射、课号覆盖、补强卡质量门、毕业工程目录和资料目录入口。',
    '',
    '| 宏域 | 期望课数 | 解析课数 | 弱卡 | 补强文件 | 毕业工程 | 总纲标题 | 状态 |',
    '|---|---:|---:|---:|---:|---|---|---|'
)
foreach ($row in $macroRows) {
    $evidenceLines += "| $($row.Macro) $($row.Name) | $($row.Expected) | $($row.Parsed) | $($row.WeakCards) | $($row.Supplements) | $($row.Capstone) | $($row.OutlineHeading) | $($row.Status) |"
}
$evidenceLines += @(
    '',
    "总计：期望 $($knownIds.Count)，解析 $($allCards.Count)，未分配 $($unassigned.Count)，重复 $($duplicateAll.Count)。",
    "权威资料 URL 计数：$urlCount；链接复核记录存在：$([bool](Test-Path -LiteralPath (Join-Path $Root '资料链接复核记录_2026-09-09.md')))。",
    "机器审计结论：$(if ($globalPass) { 'PASS' } else { 'FAIL' })。",
    '',
    '解释边界：PASS 只说明课程资产之间的映射和结构合同一致；每课 Lab 仍需学习者在证据目录中独立执行、解释、制造反例和提交复盘。'
)
Set-Content -LiteralPath $evidencePath -Value ($evidenceLines -join "`n") -Encoding utf8
"Evidence=$evidencePath"

if ($Strict -and -not $globalPass) { exit 2 }
