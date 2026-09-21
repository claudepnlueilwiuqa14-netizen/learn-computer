param(
    [int]$Port = 8765,
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$OpenBrowser
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$page = Join-Path $Root '课堂模式.html'
if (-not (Test-Path -LiteralPath $page -PathType Leaf)) { throw "找不到课堂模式页面：$page" }
$homePage = Join-Path $Root '学习主页.html'
if (-not (Test-Path -LiteralPath $homePage -PathType Leaf)) { throw "找不到学习主页：$homePage" }
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) { throw '找不到 Python，无法启动本地课堂页面' }
$existing = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
if ($existing) { Write-Output "课堂服务器已在端口 $Port 运行" }
else {
    $server = Join-Path $Root 'serve_classroom.py'
    Start-Process -FilePath $python.Source -ArgumentList @($server,'--port',$Port.ToString(),'--root',$Root) -WindowStyle Hidden
    Start-Sleep -Milliseconds 500
}
$healthUrl = "http://127.0.0.1:$Port/api/health"
$ready = [bool]$existing
1..20 | ForEach-Object {
    if ($ready) { return }
    try {
        $health = Invoke-RestMethod -Uri $healthUrl -TimeoutSec 1
        if ($health.ok) { $ready = $true }
    } catch { Start-Sleep -Milliseconds 250 }
}
if (-not $ready) { throw "本地课堂服务未能在端口 $Port 就绪，请检查 Python 或端口占用情况" }
Write-Output "课堂模式：http://127.0.0.1:$Port/课堂模式.html"
Write-Output "学习主页：http://127.0.0.1:$Port/学习主页.html"
if ($OpenBrowser) {
    Start-Process "http://127.0.0.1:$Port/学习主页.html"
}
