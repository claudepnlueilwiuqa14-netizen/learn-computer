param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$capstoneRoot = Join-Path $Root 'capstone'
$expected = @(
    '01_预备与编程','02_算法与数学','03_计算机系统','04_网络与分布式',
    '05_数据库与数据工程','06_Web产品','07_安全逆向','08_AI云原生端侧'
)
$files = @('README.md','runbook.md','threat-model.md','postmortem.md','docs/adr/ADR-0001.md','src/README.md','tests/README.md','evidence/README.md')
$missing = [System.Collections.Generic.List[string]]::new()
foreach ($name in $expected) {
    $dir = Join-Path $capstoneRoot $name
    if (-not (Test-Path -LiteralPath $dir -PathType Container)) { $missing.Add("$name/") ; continue }
    foreach ($file in $files) {
        if (-not (Test-Path -LiteralPath (Join-Path $dir $file) -PathType Leaf)) { $missing.Add("$name/$file") }
    }
}
$allowedRootDirs = @('evidence','cross_domain') # unified summaries and cross-domain drill live here
$extra = @(Get-ChildItem -LiteralPath $capstoneRoot -Directory -ErrorAction SilentlyContinue | Where-Object { $_.Name -notin $expected -and $_.Name -notin $allowedRootDirs })
Write-Output "ExpectedProjects=$($expected.Count) Missing=$($missing.Count) Extra=$($extra.Count)"
if ($missing.Count -gt 0) { $missing | ForEach-Object { Write-Output "MISSING $_" }; exit 1 }
if ($extra.Count -gt 0) { $extra | ForEach-Object { Write-Output "EXTRA $($_.Name)" } }
Write-Output 'Capstone skeleton structure: PASS (implementation and graduation evidence are not implied).'
