param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Strict
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projects = @(
    '01_预备与编程','02_算法与数学','03_计算机系统','04_网络与分布式',
    '05_数据库与数据工程','06_Web产品','07_安全逆向','08_AI云原生端侧'
)
$missing = [System.Collections.Generic.List[string]]::new()
$bad = [System.Collections.Generic.List[string]]::new()
$date = '2026-09-09'
foreach ($project in $projects) {
    $path = Join-Path $Root (Join-Path "capstone\$project\evidence" "deep-baseline-$date.json")
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { $missing.Add("$project/evidence/deep-baseline-$date.json"); continue }
    try {
        $record = Get-Content -LiteralPath $path -Raw -Encoding utf8 | ConvertFrom-Json
        if ($record.status -ne 'BASELINE_PASS') { $bad.Add("$project/status") }
        foreach ($field in @('tests','metrics','fault_injection','rollback','threat_model','gaps','graduation_decision')) {
            if (-not $record.PSObject.Properties.Name.Contains($field)) { $bad.Add("$project/$field") }
        }
        if ($record.graduation_decision -ne 'NOT_READY') { $bad.Add("$project/graduation-boundary") }
        if (-not $record.tests.passed) { $bad.Add("$project/tests") }
        if ($record.threat_model.authorization -notmatch 'self-owned') { $bad.Add("$project/authorization") }
        $faults = @($record.fault_injection)
        if ($faults.Count -lt 1) { $bad.Add("$project/fault-missing") }
        if (@($faults | Where-Object observed -eq $true).Count -lt 1) { $bad.Add("$project/fault-not-observed") }
        if (@($faults | Where-Object recovered -eq $true).Count -lt 1) { $bad.Add("$project/fault-not-recovered") }
        if ($record.rollback.executed -ne $true) { $bad.Add("$project/rollback-not-executed") }
        if (@($record.gaps).Count -lt 1) { $bad.Add("$project/gaps-missing") }
    } catch { $bad.Add("$project/invalid-json") }
}
$summary = Join-Path $Root "capstone\evidence\DEEP-SUMMARY-$date.md"
$summaryOk = Test-Path -LiteralPath $summary -PathType Leaf
Write-Output "Projects=$($projects.Count) Missing=$($missing.Count) Bad=$($bad.Count) SummaryPresent=$summaryOk"
if ($missing.Count -gt 0) { $missing | Select-Object -First 20 }
if ($bad.Count -gt 0) { $bad | Select-Object -First 20 }
if ($Strict -and ($missing.Count -gt 0 -or $bad.Count -gt 0 -or -not $summaryOk)) { exit 1 }
if ($missing.Count -eq 0 -and $bad.Count -eq 0 -and $summaryOk) {
    Write-Output 'Capstone deep baseline: PASS (machine evidence only; graduation remains NOT_READY).'
}
