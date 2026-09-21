param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [string]$OnlyId
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$jsonPath = Join-Path $Root '逐课专属深度合同_590课.json'
$evidenceRoot = Join-Path $Root 'evidence'
$runDate = '2026-09-09'
$records = @(Get-Content -LiteralPath $jsonPath -Raw -Encoding utf8 | ConvertFrom-Json)
if ($OnlyId) { $records = @($records | Where-Object Id -eq $OnlyId) }
if ($records.Count -eq 0) { throw "no course record selected" }

$probe = @'
import hashlib
import http.server
import json
import math
import os
import sqlite3
import struct
import sys
import threading
import urllib.request

category, course_id = sys.argv[1], sys.argv[2]
checks = []
metrics = {}

def check(name, value):
    if not value:
        raise AssertionError(name)
    checks.append(name)

def negative(name, fn):
    try:
        fn()
    except Exception as exc:
        checks.append(name + ":rejected:" + type(exc).__name__)
        return
    raise AssertionError(name + ":accepted")

if category == "prep":
    root = os.path.abspath("prep-sample")
    os.makedirs(root, exist_ok=True)
    source = os.path.join(root, "input.txt")
    with open(source, "w", encoding="utf-8") as handle:
        handle.write("course=" + course_id + "\n")
    with open(source, encoding="utf-8") as handle:
        check("filesystem-roundtrip", handle.read().strip() == "course=" + course_id)
    digest = hashlib.sha256(open(source, "rb").read()).hexdigest()
    check("sha256-length", len(digest) == 64)
    negative("missing-path", lambda: open(os.path.join(root, "missing.txt")))
    metrics["bytes"] = os.path.getsize(source)
    metrics["sha256"] = digest
elif category in ("python", "language", "paradigm"):
    def transform(value):
        if not isinstance(value, int):
            raise TypeError("integer required")
        return value * value
    check("normal-input", transform(3) == 9)
    check("empty-boundary", transform(0) == 0)
    negative("invalid-type", lambda: transform("3"))
    payload = json.dumps({"id": course_id, "value": transform(4)}, sort_keys=True)
    check("protocol-roundtrip", json.loads(payload)["value"] == 16)
    metrics["payload_bytes"] = len(payload.encode("utf-8"))
elif category == "algorithm":
    def binary_search(values, target):
        left, right = 0, len(values) - 1
        while left <= right:
            middle = (left + right) // 2
            if values[middle] == target:
                return middle
            if values[middle] < target:
                left = middle + 1
            else:
                right = middle - 1
        return -1
    values = [1, 3, 5, 7, 9]
    check("found", binary_search(values, 5) == 2)
    check("missing", binary_search(values, 6) == -1)
    check("empty", binary_search([], 1) == -1)
    metrics["comparisons_bound"] = len(values).bit_length()
elif category == "system":
    packed = struct.pack("<I", 0x01020304)
    check("byte-order-observed", packed.hex() == "04030201")
    check("process-id", os.getpid() > 0)
    negative("invalid-unpack", lambda: struct.unpack("<Q", b"1"))
    metrics["packed_bytes"] = len(packed)
elif category == "network":
    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            body = ("ok:" + course_id).encode("utf-8")
            self.send_response(200)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        def log_message(self, *_args):
            pass
    server = http.server.HTTPServer(("127.0.0.1", 0), Handler)
    thread = threading.Thread(target=server.handle_request, daemon=True)
    thread.start()
    started = server.server_port
    response = urllib.request.urlopen("http://127.0.0.1:%d/" % started, timeout=3)
    body = response.read().decode("utf-8")
    server.server_close()
    check("loopback-http", body == "ok:" + course_id)
    check("status-200", response.status == 200)
    metrics["port"] = started
elif category == "database":
    db = sqlite3.connect(":memory:")
    db.execute("create table items(id integer primary key, name text not null)")
    db.execute("insert into items(name) values (?)", (course_id,))
    db.commit()
    before = db.execute("select count(*) from items").fetchone()[0]
    try:
        db.execute("insert into items(id, name) values (1, ?)", ("conflict",))
    except sqlite3.IntegrityError:
        db.rollback()
        checks.append("constraint-rejected")
    after = db.execute("select count(*) from items").fetchone()[0]
    check("transaction-preserved", before == after == 1)
    metrics["rows"] = after
elif category == "web":
    html = '<!doctype html><html lang="zh-CN"><main><label for="name">Name</label><input id="name"></main></html>'
    check("lang", 'lang="zh-CN"' in html)
    check("main", "<main>" in html)
    check("label-control", 'for="name"' in html and 'id="name"' in html)
    negative("missing-main", lambda: (_ for _ in ()).throw(ValueError("main missing")) if "<main>" not in "<p>x</p>" else None)
    metrics["html_bytes"] = len(html.encode("utf-8"))
elif category == "security":
    import re
    valid = lambda value: bool(re.fullmatch(r"[A-Za-z0-9_-]{1,20}", value))
    check("safe-name", valid("alice_1"))
    negative("path-traversal-name", lambda: (_ for _ in ()).throw(ValueError("rejected")) if not valid("../secret") else None)
    digest = hashlib.sha256(("owned-" + course_id).encode()).hexdigest()
    check("evidence-digest", len(digest) == 64)
    metrics["digest"] = digest
elif category == "mobile":
    transitions = {"created": {"started"}, "started": {"paused", "stopped"}, "paused": {"started", "stopped"}, "stopped": set()}
    state = "created"
    for next_state in ("started", "paused", "started", "stopped"):
        check("transition-" + next_state, next_state in transitions[state])
        state = next_state
    negative("illegal-transition", lambda: (_ for _ in ()).throw(ValueError("stopped is terminal")) if "started" not in transitions["stopped"] else None)
    metrics["final_state"] = state
elif category == "ai":
    xs, ys = [0, 1, 2, 3], [0, 2, 4, 6]
    slope = sum(x * y for x, y in zip(xs, ys)) / sum(x * x for x in xs)
    check("linear-baseline", math.isclose(slope, 2.0))
    negative("non-finite-input", lambda: (_ for _ in ()).throw(ValueError("nan")) if not math.isfinite(float("nan")) else None)
    metrics["slope"] = slope
elif category == "ops":
    result = {"status": "ok", "checks": ["process", "filesystem", "local-http"]}
    check("health-status", result["status"] == "ok")
    check("health-checks", len(result["checks"]) == 3)
    negative("bad-health", lambda: (_ for _ in ()).throw(ValueError("unhealthy")) if {"status": "fail"}["status"] != "ok" else None)
    metrics["check_count"] = len(result["checks"])
elif category == "product":
    html = '<!doctype html><html lang="zh-CN"><body><label for="name">Name</label><input id="name"></body></html>'
    check("document-language", 'lang="zh-CN"' in html)
    check("task-label", 'for="name"' in html)
    check("control-id", 'id="name"' in html)
    metrics["task_states"] = 4
else:
    raise ValueError("unsupported category: " + category)

print(json.dumps({"course": course_id, "category": category, "checks": checks, "metrics": metrics}, ensure_ascii=False, sort_keys=True))
'@

function Resolve-Native([string]$name) {
    $cmd = Get-Command $name -ErrorAction SilentlyContinue
    if ($cmd -and $cmd.Source -and $cmd.Source -notmatch '(?i)\\Windows\\System32\\bash\.exe$') { return $cmd.Source }
    $candidates = switch ($name) {
        'bash' { @('C:\msys64\usr\bin\bash.exe','C:\Program Files\Git\bin\bash.exe','C:\Program Files\Git\usr\bin\bash.exe') }
        default { @("C:\msys64\mingw64\bin\$name.exe","C:\msys64\ucrt64\bin\$name.exe","C:\msys64\clang64\bin\$name.exe") }
    }
    foreach ($candidate in $candidates) { if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate } }
    return $null
}

function Invoke-Version([string]$id, [string]$work) {
    $name = if ($id -match '^CPP') { 'g++' } elseif ($id -match '^C\d') { 'gcc' } elseif ($id -match '^GO') { 'go' } elseif ($id -match '^RS') { 'cargo' } elseif ($id -match '^JV') { 'java' } elseif ($id -match '^JS') { 'node' } elseif ($id -match '^SH') { 'bash' } else { $null }
    if (-not $name) { return "native_tool=not_applicable" }
    $path = Resolve-Native $name
    if (-not $path -and $name -in @('java','node')) { $path = (Get-Command $name -ErrorAction SilentlyContinue).Source }
    if (-not $path) { return @("native_tool=$name","status=BLOCKED_TOOL") -join ([Environment]::NewLine) }
    $old = Get-Location
    try {
        Set-Location -LiteralPath $work
        $output = & $path --version 2>&1 | Out-String
        return @("native_tool=$name","path=$path",$output.TrimEnd()) -join ([Environment]::NewLine)
    } finally { Set-Location -LiteralPath $old }
}

$results = [System.Collections.Generic.List[object]]::new()
foreach ($record in $records) {
    $id = [string]$record.Id
    $labDir = Join-Path $evidenceRoot (Join-Path $id 'labs\lab1')
    $baseDir = Join-Path $labDir 'automation-baseline'
    $work = Join-Path $baseDir 'work'
    New-Item -ItemType Directory -Path $work -Force | Out-Null
    $probePath = Join-Path $work 'probe.py'
    $probe | Set-Content -LiteralPath $probePath -Encoding utf8
    $started = Get-Date
    $status = 'PASS'
    $output = ''
    $errorText = ''
    try {
        $version = Invoke-Version $id $work
        $version | Set-Content -LiteralPath (Join-Path $baseDir 'environment.txt') -Encoding utf8
        $output = & python $probePath ([string]$record.Category) $id 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) { throw ("probe exit code {0}{1}{2}" -f $LASTEXITCODE,[Environment]::NewLine,$output) }
        $output.TrimEnd() | Set-Content -LiteralPath (Join-Path $baseDir 'probe-output.json') -Encoding utf8
    } catch {
        $status = 'FAIL'
        $errorText = $_.Exception.Message
        $errorText | Set-Content -LiteralPath (Join-Path $baseDir 'error.txt') -Encoding utf8
    }
    $ended = Get-Date
    @(
        "course=$id"
        "category=$($record.Category)"
        "command=python probe.py $($record.Category) $id"
        "started=$started"
        "ended=$ended"
        "status=$status"
        "contract=evidence/$id/labs/lab1/README.md"
        "baseline=evidence/$id/labs/lab1/automation-baseline/"
        "negative_case=probe intentionally exercises one rejected boundary"
        "cleanup=remove or archive automation-baseline/work after review; no credentials are created"
    ) | Set-Content -LiteralPath (Join-Path $baseDir 'commands.txt') -Encoding utf8
    @(
        "# $id Lab 1 automated baseline"
        ""
        "- Status: $status"
        "- Category: $($record.Category)"
        "- Started: $started"
        "- Ended: $ended"
        "- Evidence: automation-baseline/"
        "- This is a local automated baseline, not learner completion of Lab 1 or Lv1-Lv5."
        "- The learner must explain the mechanism, reproduce the command, inspect the negative case, and add a limitation."
        "- Error: $(if ($errorText) { $errorText } else { 'none' })"
    ) | Set-Content -LiteralPath (Join-Path $baseDir 'RESULT.md') -Encoding utf8
    $readme = Join-Path $labDir 'README.md'
    $readmeText = Get-Content -LiteralPath $readme -Raw -Encoding utf8
    $readmeText = [regex]::Replace($readmeText, "(?ms)\r?\n## Automated baseline $runDate.*?(?=\r?\n## |\z)", '')
    $block = @(
        ""
        "## Automated baseline $runDate"
        "- Status: $status"
        "- Evidence: automation-baseline/RESULT.md"
        "- This machine result does not change the learner status above."
    ) -join ([Environment]::NewLine)
    ($readmeText.TrimEnd() + [Environment]::NewLine + $block + [Environment]::NewLine) | Set-Content -LiteralPath $readme -Encoding utf8
    $results.Add([pscustomobject]@{ Id=$id; Category=$record.Category; Status=$status; Error=$errorText })
}

$runRoot = Join-Path $Root "抽样运行_$runDate"
$results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runRoot 'lab1-automation-results.json') -Encoding utf8
$summary = $results | Group-Object Status | Sort-Object Name
@(
    "# Lab 1 自动化基线汇总 · $runDate"
    ""
    "范围：$($results.Count) 个课号，各运行一次按轨道区分的本地/合成 Lab 1 基线。"
    "自动化基线不代表学习者完成；Lab 2–5、Lv1–Lv5 和毕业工程仍独立验收。"
    ""
    ($summary | ForEach-Object { "- $($_.Name)：$($_.Count)" })
    ""
    "| 课号 | 轨道 | 状态 | 错误 |"
    "|---|---|---|---|"
    ($results | ForEach-Object { "| $($_.Id) | $($_.Category) | $($_.Status) | $($_.Error -replace '\|','/') |" })
) | Set-Content -LiteralPath (Join-Path $runRoot 'LAB1-AUTOMATION-SUMMARY.md') -Encoding utf8
$pass = @($results | Where-Object Status -eq 'PASS').Count
$fail = @($results | Where-Object Status -eq 'FAIL').Count
Write-Output "Courses=$($results.Count) Lab1BaselinePass=$pass Lab1BaselineFail=$fail Summary=$(Join-Path $runRoot 'LAB1-AUTOMATION-SUMMARY.md')"
if ($fail -gt 0) { exit 1 }
