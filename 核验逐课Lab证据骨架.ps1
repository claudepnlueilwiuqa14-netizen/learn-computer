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
$placeholderMissing = [System.Collections.Generic.List[string]]::new()
foreach ($record in $records) {
    $id = [string]$record.Id
    for ($labNo = 1; $labNo -le 5; $labNo++) {
        $dir = Join-Path $evidenceRoot (Join-Path $id "labs\lab$labNo")
        foreach ($name in @('README.md','commands.txt','notes.md','tests','.gitkeep','artifacts','artifacts\.gitkeep')) {
            $target = if ($name -in @('tests','artifacts')) { Join-Path $dir $name } elseif ($name -eq '.gitkeep') { Join-Path $dir "tests\.gitkeep" } elseif ($name -eq 'artifacts\.gitkeep') { Join-Path $dir $name } else { Join-Path $dir $name }
            if (-not (Test-Path -LiteralPath $target)) { $missing.Add("$id/lab$labNo/$name") }
        }
        $readme = Join-Path $dir 'README.md'
        if (Test-Path -LiteralPath $readme) {
            $text = Get-Content -LiteralPath $readme -Raw -Encoding utf8
            if ($text -notmatch '状态：⬜ 未执行') { $placeholderMissing.Add("$id/lab$labNo status marker missing") }
            if ($text -notmatch [regex]::Escape([string]$record.Title)) { $placeholderMissing.Add("$id/lab$labNo title binding missing") }
        }
    }
}
Write-Output "Courses=$($records.Count) ExpectedLabDirs=$($records.Count * 5) Missing=$($missing.Count) PlaceholderIssues=$($placeholderMissing.Count)"
if ($missing.Count -gt 0) { $missing | Select-Object -First 30 }
if ($placeholderMissing.Count -gt 0) { $placeholderMissing | Select-Object -First 30 }
if ($Strict -and ($missing.Count -gt 0 -or $placeholderMissing.Count -gt 0)) { exit 1 }
if ($missing.Count -eq 0 -and $placeholderMissing.Count -eq 0) { Write-Output 'Lab evidence skeleton: PASS (all placeholders remain explicitly incomplete).' }
