param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Strict
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$jsonPath = Join-Path $Root '逐课专属深度合同_590课.json'
$evidenceRoot = Join-Path $Root 'evidence'
$records = @(Get-Content -LiteralPath $jsonPath -Raw -Encoding utf8 | ConvertFrom-Json)
$missing = [System.Collections.Generic.List[string]]::new()
$badStatus = [System.Collections.Generic.List[string]]::new()
foreach ($record in $records) {
    $id = [string]$record.Id
    $dir = Join-Path $evidenceRoot (Join-Path $id 'labs\lab1\automation-baseline')
    foreach ($name in @('RESULT.md','commands.txt','environment.txt','probe-output.json')) {
        if (-not (Test-Path -LiteralPath (Join-Path $dir $name) -PathType Leaf)) { $missing.Add("$id/$name") }
    }
    $resultPath = Join-Path $dir 'RESULT.md'
    if (Test-Path -LiteralPath $resultPath) {
        $text = Get-Content -LiteralPath $resultPath -Raw -Encoding utf8
        if ($text -notmatch '- Status: PASS') { $badStatus.Add($id) }
        if ($text -notmatch 'not learner completion') { $badStatus.Add("$id learner-boundary") }
    }
}
$resultFile = Join-Path $Root '抽样运行_2026-09-09\lab1-automation-results.json'
$results = if (Test-Path -LiteralPath $resultFile) { @(Get-Content -LiteralPath $resultFile -Raw -Encoding utf8 | ConvertFrom-Json) } else { @() }
$pass = @($results | Where-Object Status -eq 'PASS').Count
$fail = @($results | Where-Object Status -eq 'FAIL').Count
Write-Output "Courses=$($records.Count) EvidenceMissing=$($missing.Count) BadStatus=$($badStatus.Count) Results=$($results.Count) Pass=$pass Fail=$fail"
if ($missing.Count -gt 0) { $missing | Select-Object -First 20 }
if ($badStatus.Count -gt 0) { $badStatus | Select-Object -First 20 }
if ($Strict -and ($missing.Count -gt 0 -or $badStatus.Count -gt 0 -or $results.Count -ne $records.Count -or $fail -gt 0)) { exit 1 }
if ($missing.Count -eq 0 -and $badStatus.Count -eq 0 -and $results.Count -eq $records.Count -and $fail -eq 0) {
    Write-Output 'Lab 1 automated baseline: PASS (machine baseline only; learner completion remains separate).'
}
