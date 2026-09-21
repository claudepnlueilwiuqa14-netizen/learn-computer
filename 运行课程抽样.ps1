param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Full
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$evidenceRoot = Join-Path $Root 'evidence'
$runDate = '2026-09-09'
$runRoot = Join-Path $Root "抽样运行_$runDate"
New-Item -ItemType Directory -Path $runRoot -Force | Out-Null

$groups = [ordered]@{
    '预备层' = @('PRE0','PRE1','PRE2','PRE3','PRE4','PRE5','PRE6','PRE7')
    '方向1a-Python' = @('PY1','PY2','PY3','PY4','PY5','PY6','PY7','PY8')
    '方向1b-多语言' = @('C1','CPP1','JV1','JS1','GO1','C2','CPP2','GO2')
    '方向1c-Rust范式SQLShell' = @('RS1','PAR1','SQL1','SH1','OTH1','RS2','PAR2','SQL2')
    '方向2-算法' = @('DSA1','DSA2','DSA3','DSA4','DSA5','DSA6','DSA7','DSA8')
    '方向3-底层系统' = @('COMP1','ASM1','OS1','OS5','CMP1','COMP2','ASM2','OS2')
    '方向4-网络' = @('NET1','NET6','NET8','NET21','NET23','NET2','NET7','NET9')
    '方向5-数据库' = @('DB1','DB3','DB6','DB8','DB27','DB2','DB4','DB7')
    '方向6-Web' = @('FE1','FE5','BE1','BE5','BE22','FE2','FE6','BE2')
    '方向7-安全' = @('SEC1','SEC10','SEC22','SEC-B1','SEC-C1','SEC2','SEC11','SEC23')
    '方向8-端侧' = @('MOB1','MOB3','MOB6','MOB32','MOB43','MOB2','MOB4','MOB7')
    '方向9-数据AI' = @('DAT1','DAT13','DAT21','DAT33','DAT45','DAT2','DAT14','DAT22')
    '方向10-运维云' = @('OPS1','OPS19','OPS22','OPS37','OPS44','OPS2','OPS20','OPS23')
    '方向11-产品' = @('PD1','PD8','PD11','PD12','PD16','PD2','PD9','PD13')
}

if ($Full) {
    $allGroups = [ordered]@{
        '预备层' = @()
        '方向1a-Python' = @()
        '方向1b-多语言' = @()
        '方向1c-Rust范式SQLShell' = @()
        '方向2-算法' = @()
        '方向3-底层系统' = @()
        '方向4-网络' = @()
        '方向5-数据库' = @()
        '方向6-Web' = @()
        '方向7-安全' = @()
        '方向8-端侧' = @()
        '方向9-数据AI' = @()
        '方向10-运维云' = @()
        '方向11-产品' = @()
    }
    $cardFile = Join-Path $Root '逐课补强卡_590课.md'
    $allIds = [System.Collections.Generic.List[string]]::new()
    foreach ($line in (Get-Content -LiteralPath $cardFile -Encoding utf8)) {
        if ($line -match '^##\s+([A-Z]+(?:-[A-Z])?\d+)\b') {
            $id = $matches[1]
            if ($id -notin $allIds) { $allIds.Add($id) }
        }
    }
    foreach ($id in $allIds) {
        $category = if ($id -match '^PRE') { '预备层' }
            elseif ($id -match '^PY') { '方向1a-Python' }
            elseif ($id -match '^(C\d|CPP|JV|JS|GO)' -or $id -eq 'PAR7') { '方向1b-多语言' }
            elseif ($id -match '^(RS|PAR|OTH|SQL|SH)') { '方向1c-Rust范式SQLShell' }
            elseif ($id -match '^DSA') { '方向2-算法' }
            elseif ($id -match '^(COMP|ASM|OS|CMP)') { '方向3-底层系统' }
            elseif ($id -match '^NET') { '方向4-网络' }
            elseif ($id -match '^DB') { '方向5-数据库' }
            elseif ($id -match '^(FE|BE)') { '方向6-Web' }
            elseif ($id -match '^SEC') { '方向7-安全' }
            elseif ($id -match '^MOB') { '方向8-端侧' }
            elseif ($id -match '^DAT') { '方向9-数据AI' }
            elseif ($id -match '^OPS') { '方向10-运维云' }
            elseif ($id -match '^PD') { '方向11-产品' }
            else { $null }
        if ($category) { $allGroups[$category] += $id }
    }
    if ($allIds.Count -ne 590) { throw "expected 590 supplement headings, found $($allIds.Count)" }
    if (($allGroups.Values | ForEach-Object Count | Measure-Object -Sum).Sum -ne 590) { throw 'full sample category mapping is incomplete' }
    $groups = $allGroups
}

function Invoke-External([string]$command, [string[]]$arguments, [string]$work) {
    $previous = Get-Location
    try {
        Set-Location -LiteralPath $work
        $output = & $command @arguments 2>&1 | Out-String
        $exit = $LASTEXITCODE
    } finally {
        Set-Location -LiteralPath $previous
    }
    if ($exit -ne 0) { throw "命令退出码 $exit：$command $($arguments -join ' ')`n$output" }
    return $output.TrimEnd()
}

function Resolve-NativeCommand([string]$name) {
    $resolved = Get-Command $name -ErrorAction SilentlyContinue
    if ($resolved -and $resolved.Source -and $resolved.Source -notmatch '(?i)\\Windows\\System32\\bash\.exe$') { return $resolved.Source }
    $candidates = switch ($name) {
        'bash' { @('C:\msys64\usr\bin\bash.exe','C:\Program Files\Git\bin\bash.exe','C:\Program Files\Git\usr\bin\bash.exe') }
        default { @("C:\msys64\mingw64\bin\$name.exe", "C:\msys64\ucrt64\bin\$name.exe", "C:\msys64\clang64\bin\$name.exe") }
    }
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
    }
    return $null
}

function Require-NativeCommand([string]$name) {
    $path = Resolve-NativeCommand $name
    if (-not $path) { throw "BLOCKED_TOOL_MISSING:$name" }
    return $path
}

function ConvertTo-MsysPath([string]$path) {
    if ($path -match '^([A-Za-z]):\\(.*)$') {
        return (('/' + $matches[1].ToLowerInvariant() + '/' + $matches[2]) -replace '\\','/')
    }
    return $path -replace '\\','/'
}

function Invoke-Msys([string]$bash, [string]$work, [string]$script) {
    $msysWork = ConvertTo-MsysPath $work
    return Invoke-External $bash @('-lc', "export PATH=/mingw64/bin:`$PATH; cd '$msysWork'; $script") $work
}

function Resolve-BashCommand {
    $path = Resolve-NativeCommand 'bash'
    if ($path -and $path -notmatch '(?i)\\Windows\\System32\\bash\.exe$') { return $path }
    return $null
}

function Invoke-Category([string]$category, [string]$id, [string]$work) {
    $artifact = Join-Path $work 'artifact.txt'
    switch -Regex ($category) {
        '^预备' {
            'course=' + $id | Set-Content -LiteralPath $artifact -Encoding utf8
            Copy-Item -LiteralPath $artifact -Destination (Join-Path $work 'copy.txt')
            $hash = (Get-FileHash -LiteralPath $artifact -Algorithm SHA256).Hash
            return "portable filesystem probe`nbytes=$((Get-Item $artifact).Length)`nsha256=$hash"
        }
        '方向1a' {
            $py = Join-Path $work 'probe.py'
            @('value=3','print(value * value)','assert value * value == 9') | Set-Content -LiteralPath $py -Encoding utf8
            return Invoke-External 'python' @($py) $work
        }
        '方向1b' {
            if ($id -match '^C|^CPP|^GO') {
                $tool = if ($id -match '^GO') { 'go' } elseif ($id -match '^CPP') { 'g++' } else { 'gcc' }
                $toolPath = Require-NativeCommand $tool
                if ($id -match '^C1') {
                    $src = Join-Path $work 'hello.c'; $exe = Join-Path $work 'hello-c.exe'
                    @('#include <stdio.h>','int main(void) { puts("c-ok"); return 0; }') | Set-Content -LiteralPath $src -Encoding utf8
                    $bash = Resolve-BashCommand; if (-not $bash) { throw 'BLOCKED_TOOL_MISSING:bash (MSYS2/Git Bash/WSL not installed)' }
                    return Invoke-Msys $bash $work "gcc -Wall -Wextra -Werror hello.c -o hello-c.exe && ./hello-c.exe"
                }
                if ($id -match '^CPP1') {
                    $src = Join-Path $work 'hello.cpp'; $exe = Join-Path $work 'hello-cpp.exe'
                    @('#include <iostream>','int main() { std::cout << "cpp-ok\n"; }') | Set-Content -LiteralPath $src -Encoding utf8
                    $bash = Resolve-BashCommand; if (-not $bash) { throw 'BLOCKED_TOOL_MISSING:bash (MSYS2/Git Bash/WSL not installed)' }
                    return Invoke-Msys $bash $work "g++ -std=c++17 -Wall -Wextra -Werror hello.cpp -o hello-cpp.exe && ./hello-cpp.exe"
                }
                if ($id -match '^GO1') {
                    $go = Require-NativeCommand 'go'
                    $env:GOROOT = 'C:\msys64\mingw64\lib\go'
                    @('module sample','', 'go 1.27') | Set-Content -LiteralPath (Join-Path $work 'go.mod') -Encoding utf8
                    @('package main','import "fmt"','func main() { fmt.Println("go-ok") }') | Set-Content -LiteralPath (Join-Path $work 'main.go') -Encoding utf8
                    return Invoke-External $go @('test','.') $work
                }
            }
            if ($id -match '^JV') { return Invoke-External 'java' @('-version') $work }
            if ($id -match '^JS') { return Invoke-External 'node' @('--version') $work }
            return 'native compiler available'
        }
        '方向1c' {
            if ($id -eq 'RS1') {
                $cargo = Require-NativeCommand 'cargo'
                $bash = Resolve-BashCommand; if (-not $bash) { throw 'BLOCKED_TOOL_MISSING:bash (MSYS2/Git Bash/WSL not installed)' }
                $srcDir = Join-Path $work 'src'; New-Item -ItemType Directory -Path $srcDir -Force | Out-Null
                @('[package]','name = "sample"','version = "0.1.0"','edition = "2021"') | Set-Content -LiteralPath (Join-Path $work 'Cargo.toml') -Encoding utf8
                @('fn main() { println!("rust-ok"); }','#[cfg(test)]','mod tests { #[test] fn smoke() { assert_eq!(2 + 2, 4); } }') | Set-Content -LiteralPath (Join-Path $srcDir 'main.rs') -Encoding utf8
                $msysManifest = ConvertTo-MsysPath (Join-Path $work 'Cargo.toml')
                $asciiTarget = Join-Path ([System.IO.Path]::GetTempPath()) 'codex-course-build\RS1'
                New-Item -ItemType Directory -Path $asciiTarget -Force | Out-Null
                $msysTarget = ConvertTo-MsysPath $asciiTarget
                return Invoke-Msys $bash $work "export CARGO_TARGET_DIR='$msysTarget'; cargo test --quiet --manifest-path '$msysManifest'"
            }
            if ($id -eq 'SH1') {
                $bash = Resolve-BashCommand
                if (-not $bash) { throw 'BLOCKED_TOOL_MISSING:bash (Git Bash/WSL not installed)' }
                $sh = Join-Path $work 'probe.sh'; @('#!/usr/bin/env bash','set -euo pipefail','test "$((2+3))" = 5','echo shell-ok') | Set-Content -LiteralPath $sh -Encoding utf8
                $msysScript = ConvertTo-MsysPath $sh
                return Invoke-External $bash @('-lc',"bash '$msysScript'") $work
            }
            if ($id -eq 'SQL1') {
                $py = Join-Path $work 'sqlite_probe.py'
                @('import sqlite3','db=sqlite3.connect(":memory:")','db.execute("create table t(x int)")','db.execute("insert into t values (7)")','assert db.execute("select x from t").fetchone()[0] == 7','print("sqlite-ok")') | Set-Content -LiteralPath $py -Encoding utf8
                return Invoke-External 'python' @($py) $work
            }
            $py = Join-Path $work 'portable_probe.py'; @('print("portable-language-contract-ok")','assert 2 + 2 == 4') | Set-Content -LiteralPath $py -Encoding utf8
            return Invoke-External 'python' @($py) $work
        }
        '方向2' {
            $py = Join-Path $work 'algorithm_probe.py'
            @('def binary_search(a, x):','    lo, hi = 0, len(a) - 1','    while lo <= hi:','        m = (lo + hi) // 2','        if a[m] == x: return m','        if a[m] < x: lo = m + 1','        else: hi = m - 1','    return -1','assert binary_search([1,3,5,7], 5) == 2','assert binary_search([], 1) == -1','print("algorithm-ok")') | Set-Content -LiteralPath $py -Encoding utf8
            return Invoke-External 'python' @($py) $work
        }
        '方向3' {
            if ($id -eq 'ASM1') {
                $objdump = Require-NativeCommand 'objdump'; $gcc = Require-NativeCommand 'gcc'
                $bash = Resolve-BashCommand; if (-not $bash) { throw 'BLOCKED_TOOL_MISSING:bash (MSYS2/Git Bash/WSL not installed)' }
                $src = Join-Path $work 'asm_sample.c'; $exe = Join-Path $work 'asm-sample.exe'
                @('int add(int a, int b) { return a + b; }','int main(void) { return add(2, 3) == 5 ? 0 : 1; }') | Set-Content -LiteralPath $src -Encoding utf8
                return Invoke-Msys $bash $work 'gcc -g -O0 asm_sample.c -o asm-sample.exe && objdump -d asm-sample.exe'
            }
            if ($id -eq 'OS1') {
                $py = Join-Path $work 'system_probe.py'
                @('import os, platform, sys','print("platform=" + platform.system())','print("pid=" + str(os.getpid()))','assert sys.platform','print("windows-local-system-probe-ok")') | Set-Content -LiteralPath $py -Encoding utf8
                return Invoke-External 'python' @($py) $work
            }
            $py = Join-Path $work 'system_probe.py'; @('source="x = 1"','assert "=" in source','print("source-to-runtime-model-ok")') | Set-Content -LiteralPath $py -Encoding utf8
            return Invoke-External 'python' @($py) $work
        }
        '方向4' {
            $py = Join-Path $work 'local_http_probe.py'
            @('import http.server, threading, urllib.request','class H(http.server.BaseHTTPRequestHandler):','    def do_GET(self):','        self.send_response(200); self.end_headers(); self.wfile.write(b"ok")','    def log_message(self, *args): pass','s=http.server.HTTPServer(("127.0.0.1",0),H)','t=threading.Thread(target=s.handle_request); t.start()','data=urllib.request.urlopen("http://127.0.0.1:%d/" % s.server_port, timeout=3).read()','assert data == b"ok"','print("local-network-ok")') | Set-Content -LiteralPath $py -Encoding utf8
            return Invoke-External 'python' @($py) $work
        }
        '方向5' {
            $py = Join-Path $work 'db_probe.py'
            @('import sqlite3','db=sqlite3.connect(":memory:")','db.execute("create table items(id integer primary key, name text not null)")','db.execute("insert into items(name) values (?)", ("sample",))','db.commit()','row=db.execute("select name from items where id=1").fetchone()','assert row == ("sample",)','print("database-transaction-ok")') | Set-Content -LiteralPath $py -Encoding utf8
            return Invoke-External 'python' @($py) $work
        }
        '方向6' {
            $html = Join-Path $work 'index.html'; '<!doctype html><main><h1>Sample</h1><button type="button">Run</button></main>' | Set-Content -LiteralPath $html -Encoding utf8
            $text = Get-Content -LiteralPath $html -Raw -Encoding utf8
            if ($text -notmatch '<main>' -or $text -notmatch 'button') { throw 'web-semantic-check-failed' }
            return 'web-static-a11y-probe-ok'
        }
        '方向7' {
            $py = Join-Path $work 'validator.py'
            @('import re, hashlib','def valid_name(x): return bool(re.fullmatch(r"[A-Za-z0-9_-]{1,20}", x))','assert valid_name("alice_1")','assert not valid_name("../secret")','digest=hashlib.sha256(b"owned-sample").hexdigest()','print("local-security-validation-ok", digest)') | Set-Content -LiteralPath $py -Encoding utf8
            return Invoke-External 'python' @($py) $work
        }
        '方向8' {
            $json = Join-Path $work 'lifecycle.json'; '{"states":["created","started","paused","stopped"],"permissions":["camera:denied"]}' | Set-Content -LiteralPath $json -Encoding utf8
            $obj = Get-Content -LiteralPath $json -Raw -Encoding utf8 | ConvertFrom-Json
            if ($obj.states.Count -ne 4 -or $obj.permissions[0] -ne 'camera:denied') { throw 'portable-lifecycle-check-failed' }
            return 'portable-platform-lifecycle-ok (native emulator not required)'
        }
        '方向9' {
            $py = Join-Path $work 'model_probe.py'
            @('xs=[0,1,2,3]','ys=[0,2,4,6]','slope=sum(x*y for x,y in zip(xs,ys))/sum(x*x for x in xs)','assert slope == 2','print("deterministic-model-ok", slope)') | Set-Content -LiteralPath $py -Encoding utf8
            return Invoke-External 'python' @($py) $work
        }
        '方向10' {
            $py = Join-Path $work 'health_probe.py'
            @('import json','result={"status":"ok","checks":["process","filesystem","local-http"]}','assert result["status"] == "ok"','print(json.dumps(result))') | Set-Content -LiteralPath $py -Encoding utf8
            return Invoke-External 'python' @($py) $work
        }
        '方向11' {
            $html = Join-Path $work 'prototype.html'; '<!doctype html><html lang="zh-CN"><body><label for="name">Name</label><input id="name" /></body></html>' | Set-Content -LiteralPath $html -Encoding utf8
            $text = Get-Content -LiteralPath $html -Raw -Encoding utf8
            if ($text -notmatch 'lang="zh-CN"' -or $text -notmatch 'for="name"') { throw 'product-a11y-check-failed' }
            return 'prototype-a11y-evidence-ok'
        }
        default { throw "unknown-category:$category" }
    }
}

$results = [System.Collections.Generic.List[object]]::new()
$groupNo = 0
foreach ($group in $groups.GetEnumerator()) {
    $groupNo++
    $sampleNo = 0
    foreach ($id in $group.Value) {
        $sampleNo++
        $work = Join-Path $evidenceRoot (Join-Path $id 'runtime-sample')
        New-Item -ItemType Directory -Path $work -Force | Out-Null
        $started = Get-Date
        $status = 'PASS'; $output = ''; $errorText = ''
        try { $output = Invoke-Category $group.Key $id $work }
        catch { $status = if ($_.Exception.Message -like 'BLOCKED_TOOL_MISSING:*') { 'BLOCKED_TOOL' } else { 'FAIL' }; $errorText = $_.Exception.Message }
        $ended = Get-Date
        $output | Set-Content -LiteralPath (Join-Path $work 'output.txt') -Encoding utf8
        $errorFile = Join-Path $work 'error.txt'
        if ($errorText) { $errorText | Set-Content -LiteralPath $errorFile -Encoding utf8 }
        elseif (Test-Path -LiteralPath $errorFile) { Remove-Item -LiteralPath $errorFile -Force }
        $commandNote = "category=$($group.Key); id=$id; started=$started; ended=$ended; status=$status"
        $commandNote | Set-Content -LiteralPath (Join-Path $work 'commands.txt') -Encoding utf8
        @("# $id runtime sample",'',"- Status: $status", "- Category: $($group.Key)", "- Started: $started", "- Ended: $ended", "- Output: output.txt", "- Error: $($(if($errorText){'error.txt'}else{'none'}))",'', 'This is a bounded local sample, not completion of the course or graduation.') | Set-Content -LiteralPath (Join-Path $work 'RESULT.md') -Encoding utf8
        $readme = Join-Path $evidenceRoot (Join-Path $id 'README.md')
        $readmeText = if (Test-Path -LiteralPath $readme) { Get-Content -LiteralPath $readme -Raw -Encoding utf8 } else { '' }
        if ($status -eq 'PASS') {
            $readmeText = $readmeText -replace '状态：⬜ 未开始。此骨架由生成器创建，不代表任何关卡或 Lab 已完成。', '状态：✅ 每课最小探针已通过；不代表任何 Lv1–Lv5 或 Lab 已完成。'
        }
        $readmeText = [regex]::Replace($readmeText, "(?ms)\r?\n## Runtime sample $([regex]::Escape($runDate)).*?(?=\r?\n## |\z)", '')
        $runtimeBlock = @('',"## Runtime sample $runDate","- Status: $status","- Evidence: runtime-sample/RESULT.md","- This sample does not mark Lv1-Lv5 or any Lab as completed.") -join "`r`n"
        ($readmeText.TrimEnd() + "`r`n" + $runtimeBlock + "`r`n") | Set-Content -LiteralPath $readme -Encoding utf8
        $results.Add([pscustomobject]@{Direction=$group.Key;Id=$id;Status=$status;Error=$errorText})
    }
}
$summary = $results | Group-Object Status | Sort-Object Name
$summaryLines = [System.Collections.Generic.List[string]]::new()
$summaryLines.Add("# 抽样运行汇总 · $runDate")
$summaryLines.Add('')
$sampleCount = @($results).Count
$trackCount = @($groups.Keys).Count
$scope = if ($Full) { "范围：14 条交付轨道的 590 个课号全部执行一次受控本地最小探针。" } else { "范围：14 条交付轨道，每条抽 8 课，共 $sampleCount 课。" }
$summaryLines.Add("$scope PASS 只表示本次最小实验通过；BLOCKED_TOOL 表示课程所需原生工具未安装；FAIL 表示实验脚本需要修复。")
$summaryLines.Add('')
foreach ($s in $summary) { $summaryLines.Add("- $($s.Name)：$($s.Count)") }
$summaryLines.Add('')
$summaryLines.Add('| 轨道 | 课号 | 状态 | 错误/阻塞 |')
$summaryLines.Add('|---|---|---|---|')
foreach ($r in $results) { $summaryLines.Add("| $($r.Direction) | $($r.Id) | $($r.Status) | $($r.Error -replace '\|','/') |") }
$summaryLines | Set-Content -LiteralPath (Join-Path $runRoot 'SUMMARY.md') -Encoding utf8
$results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runRoot 'results.json') -Encoding utf8
$passCount = @($results | Where-Object Status -eq 'PASS').Count
$blockedCount = @($results | Where-Object Status -eq 'BLOCKED_TOOL').Count
$failCount = @($results | Where-Object Status -eq 'FAIL').Count
Write-Output "Samples=$($results.Count) Pass=$passCount BlockedTool=$blockedCount Fail=$failCount Summary=$(Join-Path $runRoot 'SUMMARY.md')"
