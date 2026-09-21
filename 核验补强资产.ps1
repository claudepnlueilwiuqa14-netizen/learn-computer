param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Strict
)
Set-StrictMode -Version Latest

$headingPattern = '^##\s+((?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|SEC|MOB|DAT|OPS|PD)(?:-[A-Z]+)?\d*)\s*[· ]'
$files = Get-ChildItem -LiteralPath $Root -File -Filter '*补强.md'
$cards = @()
foreach ($file in $files) {
    $lines = @(Get-Content -LiteralPath $file.FullName -Encoding utf8)
    $current = $null
    foreach ($line in $lines) {
        if ($line -match $headingPattern) {
            if ($current) { $cards += [pscustomobject]$current }
            $current = [ordered]@{
                Id = $matches[1]
                File = $file.Name
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
        if (-not $current) { continue }
        if ($line -match '资料锚点|资料入口') { $current.Source++ }
        if ($line -match '失败实验|必做失败') { $current.Failure++ }
        foreach ($n in 1..5) { if ($line -match "Lv$n") { $current["Lv$n"]++ } }
        if ($line -match 'Lab\s*[1-5]\s*·|^\s*[1-5]\.\s+') { $current.Labs++ }
        if ($line -match '`[^`]+`|命令|运行|执行|脚本|代码') { $current.ExecutableEvidence++ }
    }
    if ($current) { $cards += [pscustomobject]$current }
}

$missingSource = @($cards | Where-Object Source -eq 0)
$missingFailure = @($cards | Where-Object Failure -eq 0)
$missingGate = @($cards | Where-Object { $_.Lv1 -eq 0 -or $_.Lv2 -eq 0 -or $_.Lv3 -eq 0 -or $_.Lv4 -eq 0 -or $_.Lv5 -eq 0 })
$missingLabs = @($cards | Where-Object Labs -lt 5)
$missingExec = @($cards | Where-Object ExecutableEvidence -eq 0)
$duplicates = @($cards | Group-Object Id | Where-Object Count -gt 1)
$summary = [ordered]@{
    SupplementFiles = $files.Count
    Cards = $cards.Count
    DuplicateIds = $duplicates.Count
    MissingSourceAnchors = $missingSource.Count
    MissingFailureExperiments = $missingFailure.Count
    MissingFiveGates = $missingGate.Count
    MissingFiveLabs = $missingLabs.Count
    MissingExecutableEvidence = $missingExec.Count
    FullyAudited = @($cards | Where-Object {
        $_.Source -gt 0 -and $_.Failure -gt 0 -and $_.Lv1 -gt 0 -and $_.Lv2 -gt 0 -and $_.Lv3 -gt 0 -and $_.Lv4 -gt 0 -and $_.Lv5 -gt 0 -and $_.Labs -ge 5 -and $_.ExecutableEvidence -gt 0
    }).Count
}
'=== 补强资产核验 ==='
$summary.GetEnumerator() | ForEach-Object { '{0}: {1}' -f $_.Key, $_.Value }
if ($missingSource -or $missingFailure -or $missingGate -or $missingLabs -or $missingExec -or $duplicates) {
    ''
    '缺口（前 40 条）：'
    @($missingSource + $missingFailure + $missingGate + $missingLabs + $missingExec | Select-Object -Unique Id,File | Select-Object -First 40 | Format-Table -AutoSize | Out-String).TrimEnd()
}
if ($Strict -and ($summary.DuplicateIds -gt 0 -or $summary.MissingSourceAnchors -gt 0 -or $summary.MissingFailureExperiments -gt 0 -or $summary.MissingFiveGates -gt 0 -or $summary.MissingFiveLabs -gt 0 -or $summary.MissingExecutableEvidence -gt 0)) { exit 2 }
