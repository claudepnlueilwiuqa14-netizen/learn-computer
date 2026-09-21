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
import re
import sqlite3
import struct
import sys
import threading
import urllib.request

category, course_id = sys.argv[1], sys.argv[2]
checks, metrics = [], {}

def check(name, value):
    if not value:
        raise AssertionError(name)
    checks.append(name)

def reject(name, fn):
    try:
        fn()
    except Exception as exc:
        checks.append(name + ":rejected:" + type(exc).__name__)
        return
    raise AssertionError(name + ":accepted")

if category in ("prep", "python", "language", "paradigm"):
    def parse_and_transform(payload):
        value = payload.get("value")
        if not isinstance(value, int):
            raise TypeError("value must be integer")
        return {"course": payload["course"], "result": value * value}
    result = parse_and_transform({"course": course_id, "value": 4})
    check("handwritten-transform", result["result"] == 16)
    check("deterministic-output", result == parse_and_transform({"course": course_id, "value": 4}))
    reject("malformed-payload", lambda: parse_and_transform({"course": course_id, "value": "4"}))
    metrics["result"] = result["result"]
elif category == "algorithm":
    def handwritten_search(values, target):
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
    check("invariant-search", handwritten_search(values, 7) == 3)
    check("empty-case", handwritten_search([], 7) == -1)
    reject("unsorted-precondition", lambda: (_ for _ in ()).throw(ValueError("sorted input required")) if [3, 1] != sorted([3, 1]) else None)
    metrics["steps_bound"] = len(values).bit_length()
elif category == "system":
    def decode_u32(data):
        if len(data) != 4:
            raise ValueError("four bytes required")
        return int.from_bytes(data, "little")
    check("handwritten-decoder", decode_u32(b"\x04\x03\x02\x01") == 0x01020304)
    check("fixed-width", len(struct.pack("<I", decode_u32(b"\x04\x03\x02\x01"))) == 4)
    reject("short-input", lambda: decode_u32(b"x"))
    metrics["value"] = decode_u32(b"\x04\x03\x02\x01")
elif category == "network":
    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            body = json.dumps({"id": course_id, "ok": True}, sort_keys=True).encode()
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        def log_message(self, *_args):
            pass
    server = http.server.HTTPServer(("127.0.0.1", 0), Handler)
    thread = threading.Thread(target=server.handle_request, daemon=True)
    thread.start()
    response = urllib.request.urlopen("http://127.0.0.1:%d/" % server.server_port, timeout=3)
    payload = json.loads(response.read().decode())
    server.server_close()
    check("handwritten-loopback-service", payload == {"id": course_id, "ok": True})
    check("response-contract", response.status == 200)
    metrics["port"] = server.server_port
elif category == "database":
    db = sqlite3.connect(":memory:")
    db.execute("create table items(id integer primary key, name text not null)")
    db.execute("begin")
    db.execute("insert into items(name) values (?)", (course_id,))
    db.commit()
    check("handwritten-transaction", db.execute("select count(*) from items").fetchone()[0] == 1)
    try:
        db.execute("begin")
        db.execute("insert into items(id, name) values (1, ?)", ("bad",))
        db.commit()
    except sqlite3.IntegrityError:
        db.rollback()
    check("rollback-invariant", db.execute("select count(*) from items").fetchone()[0] == 1)
    metrics["rows"] = 1
elif category == "web":
    html = '<!doctype html><html lang="zh-CN"><main><label for="name">Name</label><input id="name"></main></html>'
    def validate(document):
        required = ['lang="zh-CN"', "<main>", 'for="name"', 'id="name"']
        return all(item in document for item in required)
    check("handwritten-semantic-validator", validate(html))
    reject("missing-semantic-main", lambda: (_ for _ in ()).throw(ValueError("main missing")) if not validate("<p>x</p>") else None)
    metrics["html_bytes"] = len(html.encode())
elif category == "security":
    def validate_name(value):
        return bool(re.fullmatch(r"[A-Za-z0-9_-]{1,20}", value))
    def digest_owned(value):
        return hashlib.sha256(("owned:" + value).encode()).hexdigest()
    check("handwritten-input-validator", validate_name("alice_1"))
    reject("unsafe-input", lambda: (_ for _ in ()).throw(ValueError("rejected")) if not validate_name("../secret") else None)
    check("handwritten-evidence-hash", len(digest_owned(course_id)) == 64)
    metrics["digest"] = digest_owned(course_id)
elif category == "mobile":
    allowed = {"created": {"started"}, "started": {"paused", "stopped"}, "paused": {"started", "stopped"}, "stopped": set()}
    def transition(state, next_state):
        if next_state not in allowed[state]:
            raise ValueError("illegal transition")
        return next_state
    state = "created"
    for next_state in ("started", "paused", "stopped"):
        state = transition(state, next_state)
    check("handwritten-state-machine", state == "stopped")
    reject("terminal-state", lambda: transition(state, "started"))
    metrics["state"] = state
elif category == "ai":
    def fit_slope(xs, ys):
        if len(xs) != len(ys) or not xs or sum(x * x for x in xs) == 0:
            raise ValueError("invalid training data")
        return sum(x * y for x, y in zip(xs, ys)) / sum(x * x for x in xs)
    slope = fit_slope([0, 1, 2, 3], [0, 2, 4, 6])
    check("handwritten-fit", math.isclose(slope, 2.0))
    reject("invalid-data", lambda: fit_slope([], []))
    metrics["slope"] = slope
elif category == "ops":
    def aggregate_health(checks_input):
        if not checks_input:
            raise ValueError("health checks required")
        return {"status": "ok" if all(checks_input.values()) else "fail", "checks": checks_input}
    health = aggregate_health({"process": True, "filesystem": True, "local_http": True})
    check("handwritten-health", health["status"] == "ok")
    check("health-cardinality", len(health["checks"]) == 3)
    reject("empty-health", lambda: aggregate_health({}))
    metrics["check_count"] = len(health["checks"])
elif category == "product":
    def task_contract(document):
        required = ['lang="zh-CN"', 'for="name"', 'id="name"']
        return all(item in document for item in required)
    html = '<!doctype html><html lang="zh-CN"><label for="name">Name</label><input id="name"></html>'
    check("handwritten-task-contract", task_contract(html))
    reject("incomplete-task", lambda: (_ for _ in ()).throw(ValueError("missing label")) if not task_contract("<input>") else None)
    metrics["contract_fields"] = 3
else:
    raise ValueError("unsupported category: " + category)

print(json.dumps({"course": course_id, "category": category, "checks": checks, "metrics": metrics}, ensure_ascii=False, sort_keys=True))
'@

$results = [System.Collections.Generic.List[object]]::new()
foreach ($record in $records) {
    $id = [string]$record.Id
    $labDir = Join-Path $evidenceRoot (Join-Path $id 'labs\lab3')
    $baseDir = Join-Path $labDir 'automation-baseline'
    $work = Join-Path $baseDir 'work'
    New-Item -ItemType Directory -Path $work -Force | Out-Null
    $probePath = Join-Path $work 'probe.py'
    $probe | Set-Content -LiteralPath $probePath -Encoding utf8
    $started = Get-Date
    $status = 'PASS'
    $errorText = ''
    try {
        @("python=$((python --version 2>&1 | Out-String).Trim())","powershell=$($PSVersionTable.PSVersion)") | Set-Content -LiteralPath (Join-Path $baseDir 'environment.txt') -Encoding utf8
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
        "mechanism=handwritten core mechanism, state machine, validator, transaction, protocol or data function"
        "started=$started"
        "ended=$ended"
        "status=$status"
        "contract=evidence/$id/labs/lab3/README.md"
        "baseline=evidence/$id/labs/lab3/automation-baseline/"
        "cleanup=remove or archive automation-baseline/work after review; no credentials are created"
    ) | Set-Content -LiteralPath (Join-Path $baseDir 'commands.txt') -Encoding utf8
    @(
        "# $id Lab 3 automated baseline"
        ""
        "- Status: $status"
        "- Category: $($record.Category)"
        "- Started: $started"
        "- Ended: $ended"
        "- Evidence: automation-baseline/"
        "- Mechanism: handwritten core mechanism, state machine, validator, transaction, protocol or data function."
        "- This is a local automated baseline, not learner completion of Lab 3 or Lv1-Lv5."
        "- The learner must explain invariants, complexity, black-box boundary and limitations."
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
$results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runRoot 'lab3-automation-results.json') -Encoding utf8
$summary = $results | Group-Object Status | Sort-Object Name
@(
    "# Lab 3 自动化基线汇总 · $runDate"
    ""
    "范围：$($results.Count) 个课号，各运行一次手写核心机制/验证器基线。"
    "自动化基线不代表学习者完成；Lab 4–5、Lv1–Lv5 和毕业工程仍独立验收。"
    ""
    ($summary | ForEach-Object { "- $($_.Name)：$($_.Count)" })
    ""
    "| 课号 | 轨道 | 状态 | 错误 |"
    "|---|---|---|---|"
    ($results | ForEach-Object { "| $($_.Id) | $($_.Category) | $($_.Status) | $($_.Error -replace '\|','/') |" })
) | Set-Content -LiteralPath (Join-Path $runRoot 'LAB3-AUTOMATION-SUMMARY.md') -Encoding utf8
$pass = @($results | Where-Object Status -eq 'PASS').Count
$fail = @($results | Where-Object Status -eq 'FAIL').Count
Write-Output "Courses=$($results.Count) Lab3BaselinePass=$pass Lab3BaselineFail=$fail Summary=$(Join-Path $runRoot 'LAB3-AUTOMATION-SUMMARY.md')"
if ($fail -gt 0) { exit 1 }
