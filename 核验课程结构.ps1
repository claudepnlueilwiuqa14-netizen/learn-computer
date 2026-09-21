param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Strict
)

$files = Get-ChildItem -LiteralPath $Root -File -Filter '教案_*.md' |
    Where-Object { $_.Name -notmatch '总索引|旧版|闯关与实战补强' }
$supplementFiles = Get-ChildItem -LiteralPath $Root -File -Filter '*补强.md'
$rows = @()
$ids = @()

foreach ($file in $files) {
    $lines = Get-Content -LiteralPath $file.FullName
    $current = $null
    foreach ($line in $lines) {
        if ($line -match '^#{1,3}\s+((?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|SEC|MOB|DAT|OPS|PD)(?:-[A-Z]+)?\d*)\s*[· ]') {
            if ($current) { $rows += [pscustomobject]$current }
            $current = [ordered]@{
                Id = $matches[1]
                File = $file.Name
                Goal = 0
                Prereq = 0
                Principle = 0
                Shallow = 0
                HandsOn = 0
                Deep = 0
                Top = 0
                Safety = 0
                Accept = 0
                Pitfalls = 0
                Next = 0
                Labs = 0
                Lv1 = 0
                Lv2 = 0
                Lv3 = 0
                Lv4 = 0
                Lv5 = 0
            }
            $ids += [pscustomobject]@{ Id = $matches[1]; File = $file.Name }
            continue
        }
        if (-not $current) { continue }
        if ($line -match '🎯|目标') { $current.Goal++ }
        if ($line -match '📋|前置') { $current.Prereq++ }
        if ($line -match '🟢|最浅层') { $current.Shallow++ }
        if ($line -match '🟡|动手层') { $current.HandsOn++ }
        if ($line -match '🔵|原理层') { $current.Principle++ }
        if ($line -match '🟣|深挖层') { $current.Deep++ }
        if ($line -match '🔴|顶级视角') { $current.Top++ }
        if ($line -match '🟠|安全|合规') { $current.Safety++ }
        if ($line -match '✅|验收') { $current.Accept++ }
        if ($line -match '⚠️|常见坑') { $current.Pitfalls++ }
        if ($line -match '➡️|下一步') { $current.Next++ }
        if ($line -match '实战\s*Lab|Lab\s*[0-9A-Za-z-]+') { $current.Labs++ }
        foreach ($n in 1..5) { if ($line -match "Lv$n") { $current["Lv$n"]++ } }
    }
    if ($current) { $rows += [pscustomobject]$current }
}

$duplicates = $ids | Group-Object Id | Where-Object Count -gt 1

# 补强层采用独立文件承载五关和 Lab。按课号解析，避免把统一说明误算成每课完成。
$suppRows = @()
foreach ($file in $supplementFiles) {
    $currentSupplement = $null
    foreach ($line in (Get-Content -LiteralPath $file.FullName -Encoding utf8)) {
        if ($line -match '^##\s+((?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|SEC|MOB|DAT|OPS|PD)(?:-[A-Z]+)?\d*)\s*[· ]') {
            if ($currentSupplement) { $suppRows += [pscustomobject]$currentSupplement }
            $currentSupplement = [ordered]@{
                Id = $matches[1]
                File = $file.Name
                Labs = 0
                Lv1 = 0
                Lv2 = 0
                Lv3 = 0
                Lv4 = 0
                Lv5 = 0
            }
            continue
        }
        if (-not $currentSupplement) { continue }
        if ($line -match 'Lab\s*[1-5]\s*·|^\s*[1-5]\.\s+') { $currentSupplement.Labs++ }
        foreach ($n in 1..5) { if ($line -match "Lv$n") { $currentSupplement["Lv$n"]++ } }
    }
    if ($currentSupplement) { $suppRows += [pscustomobject]$currentSupplement }
}
$suppById = @{}
foreach ($supp in $suppRows) { $suppById[$supp.Id] = $supp }

$summary = [ordered]@{
    Files = $files.Count
    Titles = $rows.Count
    SupplementFiles = $supplementFiles.Count
    SupplementLessons = @($supplementFiles | ForEach-Object { Select-String -LiteralPath $_.FullName -Pattern '^## (?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|MOB|DAT|OPS|PD)\d+|^## SEC(?:\d+|-[WBC]\d+)' }).Count
    SupplementLabs = @($supplementFiles | ForEach-Object { Select-String -LiteralPath $_.FullName -Pattern 'Lab [1-5] ·|^[ ]*[1-5]\. ' }).Count
    DuplicateIds = $duplicates.Count
    GoalsMissing = @($rows | Where-Object Goal -eq 0).Count
    PrereqMissing = @($rows | Where-Object Prereq -eq 0).Count
    PrincipleMissing = @($rows | Where-Object Principle -eq 0).Count
    AcceptMissing = @($rows | Where-Object Accept -eq 0).Count
    ElevenPartIncomplete = @($rows | Where-Object { $_.Goal -eq 0 -or $_.Prereq -eq 0 -or $_.Shallow -eq 0 -or $_.HandsOn -eq 0 -or $_.Principle -eq 0 -or $_.Deep -eq 0 -or $_.Top -eq 0 -or $_.Safety -eq 0 -or $_.Accept -eq 0 -or $_.Pitfalls -eq 0 -or $_.Next -eq 0 }).Count
    # These two fields describe the historical raw-course baseline. The effective fields below include supplements.
    RawCourseFiveGateIncomplete = @($rows | Where-Object { $_.Lv1 -eq 0 -or $_.Lv2 -eq 0 -or $_.Lv3 -eq 0 -or $_.Lv4 -eq 0 -or $_.Lv5 -eq 0 }).Count
    RawCourseFewerThanFiveLabs = @($rows | Where-Object Labs -lt 5).Count
    SupplementCardsParsed = $suppRows.Count
    SupplementFullyGated = @($suppRows | Where-Object { $_.Lv1 -gt 0 -and $_.Lv2 -gt 0 -and $_.Lv3 -gt 0 -and $_.Lv4 -gt 0 -and $_.Lv5 -gt 0 -and $_.Labs -ge 5 }).Count
    SupplementFiveGateIncomplete = @($suppRows | Where-Object { $_.Lv1 -eq 0 -or $_.Lv2 -eq 0 -or $_.Lv3 -eq 0 -or $_.Lv4 -eq 0 -or $_.Lv5 -eq 0 }).Count
    SupplementLabsIncomplete = @($suppRows | Where-Object Labs -lt 5).Count
    EffectiveFiveGateIncomplete = @($rows | Where-Object {
        $s = $suppById[$_.Id]
        $null -eq $s -or $s.Lv1 -eq 0 -or $s.Lv2 -eq 0 -or $s.Lv3 -eq 0 -or $s.Lv4 -eq 0 -or $s.Lv5 -eq 0
    }).Count
    EffectiveLabsIncomplete = @($rows | Where-Object {
        $s = $suppById[$_.Id]
        $null -eq $s -or $s.Labs -lt 5
    }).Count
}

"=== 课程结构核验 ==="
$summary.GetEnumerator() | ForEach-Object { '{0}: {1}' -f $_.Key, $_.Value }
""
if ($duplicates) {
    '重复标题：'
    $duplicates | ForEach-Object { "- $($_.Name): $($_.Group.File -join ', ')" }
}
""
'原课正文直接扫描不满足五关或 Lab 数量的课（前 40 条；补强层覆盖前的历史基线）：'
$rows | Where-Object { $_.Lv1 -eq 0 -or $_.Lv2 -eq 0 -or $_.Lv3 -eq 0 -or $_.Lv4 -eq 0 -or $_.Lv5 -eq 0 -or $_.Labs -lt 5 } |
    Select-Object -First 40 Id,File,Labs,Lv1,Lv2,Lv3,Lv4,Lv5 | Format-Table -AutoSize

'11 段标题不完整的课：'
$rows | Where-Object { $_.Goal -eq 0 -or $_.Prereq -eq 0 -or $_.Shallow -eq 0 -or $_.HandsOn -eq 0 -or $_.Principle -eq 0 -or $_.Deep -eq 0 -or $_.Top -eq 0 -or $_.Safety -eq 0 -or $_.Accept -eq 0 -or $_.Pitfalls -eq 0 -or $_.Next -eq 0 } |
    Select-Object Id,File,Goal,Prereq,Shallow,HandsOn,Principle,Deep,Top,Safety,Accept,Pitfalls,Next | Format-Table -AutoSize

if ($Strict -and ($summary.DuplicateIds -gt 0 -or $summary.ElevenPartIncomplete -gt 0 -or $summary.EffectiveFiveGateIncomplete -gt 0 -or $summary.EffectiveLabsIncomplete -gt 0)) {
    exit 2
}
