param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$path = Join-Path $Root '逐课真实实验蓝图_590课.md'
if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "missing blueprint: $path" }
$text = Get-Content -LiteralPath $path -Raw -Encoding utf8
$cards = ([regex]::Matches($text, '^## (?:SEC(?:-[WBC])?|PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|MOB|DAT|OPS|PD)\d+', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
$labs1 = ([regex]::Matches($text, '^### Lab 1', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
$labs2 = ([regex]::Matches($text, '^### Lab 2', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
$labs3 = ([regex]::Matches($text, '^### Lab 3', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
$labs4 = ([regex]::Matches($text, '^### Lab 4', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
$labs5 = ([regex]::Matches($text, '^### Lab 5', [Text.RegularExpressions.RegexOptions]::Multiline)).Count
Write-Output "BlueprintCards=$cards Lab1=$labs1 Lab2=$labs2 Lab3=$labs3 Lab4=$labs4 Lab5=$labs5"
if ($cards -ne 590 -or @($labs1,$labs2,$labs3,$labs4,$labs5 | Where-Object { $_ -ne 590 }).Count -gt 0) { exit 1 }
Write-Output 'Real experiment blueprint: PASS (content contract verified; execution evidence remains separate).'
