[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [Parameter(Mandatory = $true)]
    [string]$CourseId,
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-H][1-5]$')]
    [string]$ChallengeId
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($CourseId -notmatch '^(?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|SEC|MOB|DAT|OPS|PD)(?:-[A-Z]+)?\d+$') {
    throw "CourseId 格式不受支持：$CourseId"
}

$evidenceRoot = Join-Path $Root 'evidence'
$courseRoot = Join-Path $evidenceRoot $CourseId
$templatePath = Join-Path $evidenceRoot '_templates\boss挑战_README.md'
$progressPath = Join-Path $evidenceRoot 'boss\PROGRESS.md'
if (-not (Test-Path -LiteralPath $courseRoot -PathType Container)) { throw "找不到课号证据目录：$courseRoot" }
if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) { throw "找不到 Boss 模板：$templatePath" }
if (-not (Test-Path -LiteralPath $progressPath -PathType Leaf)) { throw "找不到 Boss 进度板：$progressPath" }

$progress = Get-Content -Raw -Encoding utf8 $progressPath
if (-not [regex]::IsMatch($progress, "\|\s+$ChallengeId\s+")) { throw "进度板中没有挑战编号：$ChallengeId" }

$bossRoot = Join-Path $courseRoot 'boss'
$target = Join-Path $bossRoot $ChallengeId
if (Test-Path -LiteralPath $target) { throw "目标已存在，为避免覆盖历史证据而停止：$target" }

if ($PSCmdlet.ShouldProcess($target, '创建 Boss Lab 证据入口')) {
    New-Item -ItemType Directory -Path (Join-Path $target 'tests') -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $target 'artifacts') -Force | Out-Null
    Copy-Item -LiteralPath $templatePath -Destination (Join-Path $target 'README.md')
    Set-Content -LiteralPath (Join-Path $target 'commands.txt') -Encoding utf8 -Value @(
        "# $CourseId / $ChallengeId · 创建于 $(Get-Date -Format 'yyyy-MM-dd')",
        '# 先填写环境、版本、随机种子和授权边界，再粘贴可复制命令。',
        '# 不要把机器基线输出当作学习者完成证据。'
    )
    Set-Content -LiteralPath (Join-Path $target 'notes.md') -Encoding utf8 -Value @(
        '# 资料、反例与复盘',
        '',
        '- 资料页面/章节/版本/访问日期：',
        '- 已验证命题：',
        '- 未验证项、反例和下一步：'
    )
    Write-Output "Created=$target"
    Write-Output 'Status=⬜ 未开始（仅创建提交入口，未执行挑战）'
}
