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
import http.server
import json
import math
import os
import re
import sqlite3
import sys
import threading
import time
import urllib.error
import urllib.request

category, course_id = sys.argv[1], sys.argv[2]
timeline, checks, metrics = [], [], {}
started = time.perf_counter()

def mark(event):
    timeline.append({"event": event, "ms": round((time.perf_counter() - started) * 1000, 3)})

def check(name, value):
    if not value:
        raise AssertionError(name)
    checks.append(name)

def expect_failure(name, fn):
    try:
        fn()
    except Exception as exc:
        mark(name + ":observed:" + type(exc).__name__)
        checks.append(name + ":recovered")
        return
    raise AssertionError(name + ":failure-not-observed")

mark("start")
if category == "prep":
    target = os.path.join("failure-work", "missing.txt")
    expect_failure("missing-path", lambda: open(target))
    os.makedirs("failure-work", exist_ok=True)
    with open(target, "w", encoding="utf-8") as handle:
        handle.write(course_id)
    check("recovery-file", open(target, encoding="utf-8").read() == course_id)
    os.remove(target)
    metrics["cleanup"] = not os.path.exists(target)
elif category in ("python", "language", "paradigm"):
    def transform(value):
        if not isinstance(value, int):
            raise TypeError("integer required")
        return value * value
    expect_failure("invalid-type", lambda: transform("bad"))
    check("recovery-normal-input", transform(6) == 36)
    metrics["recovery_value"] = 36
elif category == "algorithm":
    def search(values, target):
        if values != sorted(values):
            raise ValueError("sorted precondition")
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
    expect_failure("unsorted-input", lambda: search([3, 1], 1))
    check("recovery-sorted-input", search([1, 3], 3) == 1)
    metrics["recovery_size"] = 2
elif category == "system":
    def decode(data):
        if len(data) != 4:
            raise ValueError("four bytes required")
        return int.from_bytes(data, "little")
    expect_failure("short-buffer", lambda: decode(b"x"))
    check("recovery-valid-buffer", decode(b"\x04\x03\x02\x01") == 0x01020304)
    metrics["recovery_value"] = 0x01020304
elif category == "network":
    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            body = ("ok:" + course_id).encode()
            self.send_response(200)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        def log_message(self, *_args):
            pass
    first = http.server.HTTPServer(("127.0.0.1", 0), Handler)
    port = first.server_port
    first.server_close()
    expect_failure("closed-port", lambda: urllib.request.urlopen("http://127.0.0.1:%d/" % port, timeout=1))
    second = http.server.HTTPServer(("127.0.0.1", 0), Handler)
    thread = threading.Thread(target=second.handle_request, daemon=True)
    thread.start()
    response = urllib.request.urlopen("http://127.0.0.1:%d/" % second.server_port, timeout=3)
    check("recovery-loopback", response.read().decode() == "ok:" + course_id)
    second.server_close()
    metrics["recovery_status"] = response.status
elif category == "database":
    db = sqlite3.connect(":memory:")
    db.execute("create table items(id integer primary key, name text not null)")
    db.execute("insert into items(name) values (?)", (course_id,))
    db.commit()
    expect_failure("constraint-conflict", lambda: (db.execute("begin"), db.execute("insert into items(id,name) values (1,'bad')"), db.commit()))
    db.rollback()
    db.execute("insert into items(name) values (?)", (course_id + "-recovered",))
    db.commit()
    check("recovery-rows", db.execute("select count(*) from items").fetchone()[0] == 2)
    metrics["recovery_rows"] = 2
elif category == "web":
    def validate(payload):
        if "name" not in payload or not payload["name"]:
            raise ValueError("name required")
        return {"status": 200, "name": payload["name"]}
    expect_failure("missing-field", lambda: validate({}))
    check("recovery-valid-request", validate({"name": course_id})["status"] == 200)
    metrics["recovery_status"] = 200
elif category == "security":
    valid = lambda value: bool(re.fullmatch(r"[A-Za-z0-9_-]{1,20}", value))
    expect_failure("unsafe-input", lambda: (_ for _ in ()).throw(ValueError("rejected")) if not valid("../secret") else None)
    check("recovery-safe-input", valid("alice_1"))
    metrics["unsafe_target"] = "self-owned-synthetic-input"
elif category == "mobile":
    allowed = {"created": {"started"}, "started": {"paused", "stopped"}, "paused": {"started", "stopped"}, "stopped": set()}
    def transition(state, next_state):
        if next_state not in allowed[state]:
            raise ValueError("illegal transition")
        return next_state
    expect_failure("illegal-transition", lambda: transition("stopped", "started"))
    check("recovery-valid-transition", transition("created", "started") == "started")
    metrics["recovery_state"] = "started"
elif category == "ai":
    def fit(xs, ys):
        if not xs or len(xs) != len(ys) or any(not math.isfinite(float(v)) for v in xs + ys):
            raise ValueError("invalid training data")
        return sum(x * y for x, y in zip(xs, ys)) / sum(x * x for x in xs)
    expect_failure("nonfinite-input", lambda: fit([0, float("nan")], [0, 1]))
    check("recovery-valid-fit", math.isclose(fit([0, 1, 2], [0, 2, 4]), 2.0))
    metrics["recovery_slope"] = 2.0
elif category == "ops":
    def health(checks_input):
        return "ok" if all(checks_input.values()) else "fail"
    check("failure-observed", health({"process": True, "dependency": False}) == "fail")
    check("recovery-health", health({"process": True, "dependency": True}) == "ok")
    metrics["recovery_status"] = "ok"
elif category == "product":
    def task_contract(document):
        if 'for="name"' not in document or 'id="name"' not in document:
            raise ValueError("task contract incomplete")
        return True
    expect_failure("missing-control", lambda: task_contract("<input>"))
    check("recovery-complete-task", task_contract('<label for="name">Name</label><input id="name">'))
    metrics["recovery_controls"] = 1
else:
    raise ValueError("unsupported category: " + category)

mark("recovered")
metrics["recovery_ms"] = round((time.perf_counter() - started) * 1000, 3)
print(json.dumps({"course": course_id, "category": category, "checks": checks, "timeline": timeline, "metrics": metrics}, ensure_ascii=False, sort_keys=True))
'@

$results = [System.Collections.Generic.List[object]]::new()
foreach ($record in $records) {
    $id = [string]$record.Id
    $labDir = Join-Path $evidenceRoot (Join-Path $id 'labs\lab4')
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
        "failure=controlled local failure followed by recovery"
        "started=$started"
        "ended=$ended"
        "status=$status"
        "contract=evidence/$id/labs/lab4/README.md"
        "baseline=evidence/$id/labs/lab4/automation-baseline/"
        "cleanup=remove or archive automation-baseline/work after review; no credentials are created"
    ) | Set-Content -LiteralPath (Join-Path $baseDir 'commands.txt') -Encoding utf8
    @(
        "# $id Lab 4 automated baseline"
        ""
        "- Status: $status"
        "- Category: $($record.Category)"
        "- Started: $started"
        "- Ended: $ended"
        "- Evidence: automation-baseline/"
        "- Failure/recovery: a bounded local failure was observed, then a valid path was restored."
        "- This is a local automated baseline, not learner completion of Lab 4 or Lv1-Lv5."
        "- The learner must write the root cause, evidence chain, recovery limit, cleanup and unverified items."
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
$results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runRoot 'lab4-automation-results.json') -Encoding utf8
$summary = $results | Group-Object Status | Sort-Object Name
@(
    "# Lab 4 自动化基线汇总 · $runDate"
    ""
    "范围：$($results.Count) 个课号，各运行一次受控故障注入与恢复基线。"
    "自动化基线不代表学习者完成；Lab 5、Lv1–Lv5 和毕业工程仍独立验收。"
    ""
    ($summary | ForEach-Object { "- $($_.Name)：$($_.Count)" })
    ""
    "| 课号 | 轨道 | 状态 | 错误 |"
    "|---|---|---|---|"
    ($results | ForEach-Object { "| $($_.Id) | $($_.Category) | $($_.Status) | $($_.Error -replace '\|','/') |" })
) | Set-Content -LiteralPath (Join-Path $runRoot 'LAB4-AUTOMATION-SUMMARY.md') -Encoding utf8
$pass = @($results | Where-Object Status -eq 'PASS').Count
$fail = @($results | Where-Object Status -eq 'FAIL').Count
Write-Output "Courses=$($results.Count) Lab4BaselinePass=$pass Lab4BaselineFail=$fail Summary=$(Join-Path $runRoot 'LAB4-AUTOMATION-SUMMARY.md')"
if ($fail -gt 0) { exit 1 }
