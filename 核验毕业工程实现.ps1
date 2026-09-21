param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$capstoneRoot = Join-Path $Root 'capstone'
$projects = @(
    '01_预备与编程','02_算法与数学','03_计算机系统','04_网络与分布式',
    '05_数据库与数据工程','06_Web产品','07_安全逆向','08_AI云原生端侧'
)
$missing = [System.Collections.Generic.List[string]]::new()
foreach ($project in $projects) {
    $dir = Join-Path $capstoneRoot $project
    $source = @(Get-ChildItem -LiteralPath (Join-Path $dir 'src') -File | Where-Object Name -notmatch '^README\.md$')
    $tests = @(Get-ChildItem -LiteralPath (Join-Path $dir 'tests') -File | Where-Object Name -notmatch '^README\.md$')
    $smoke = Join-Path $dir 'evidence\smoke-2026-09-09.txt'
    if ($source.Count -eq 0) { $missing.Add("$project/src implementation") }
    if ($tests.Count -eq 0) { $missing.Add("$project/tests implementation") }
    if (-not (Test-Path -LiteralPath $smoke -PathType Leaf)) { $missing.Add("$project/evidence smoke") }
}
Write-Output "ExpectedProjects=$($projects.Count) Implemented=$($projects.Count - $missing.Count) Missing=$($missing.Count)"
if ($missing.Count -gt 0) { $missing | ForEach-Object { Write-Output "MISSING $_" }; exit 1 }
Write-Output 'Capstone implementation smoke structure: PASS (graduation contract still requires deeper evidence).'
