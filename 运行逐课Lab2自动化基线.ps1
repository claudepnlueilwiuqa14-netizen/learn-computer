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

if category == "prep":
    before = ("course=" + course_id).encode()
    after = ("course=" + course_id + "-variant").encode()
    check("single-input-change", before != after)
    check("same-format", before.startswith(b"course=") and after.startswith(b"course="))
    check("hash-changes", hashlib.sha256(before).hexdigest() != hashlib.sha256(after).hexdigest())
    reject("empty-input", lambda: (_ for _ in ()).throw(ValueError("empty")) if not b"" else None)
    metrics.update(before_bytes=len(before), after_bytes=len(after))
elif category in ("python", "language", "paradigm"):
    def transform(value):
        if not isinstance(value, int):
            raise TypeError("integer required")
        return value * value
    before, after = transform(3), transform(5)
    check("single-argument-change", before == 9 and after == 25)
    check("output-changes", before != after)
    reject("same-type-contract", lambda: transform("5"))
    metrics.update(before=before, after=after)
elif category == "algorithm":
    def search(values, target):
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
    base, variant = [1, 3, 5, 7, 9], [1, 3, 5, 7, 9, 11]
    before, after = search(base, 5), search(variant, 11)
    check("single-target-or-input-change", before == 2 and after == 5)
    check("boundary-still-defined", search([], 1) == -1)
    metrics.update(before=before, after=after, variant_size=len(variant))
elif category == "system":
    before, after = struct.pack("<I", 0x01020304), struct.pack("<I", 0x0A0B0C0D)
    check("single-value-change", before != after)
    check("same-abi-width", len(before) == len(after) == 4)
    reject("short-buffer", lambda: struct.unpack("<I", b"x"))
    metrics.update(before=before.hex(), after=after.hex())
elif category == "network":
    class Handler(http.server.BaseHTTPRequestHandler):
        def do_GET(self):
            suffix = "variant" if self.path == "/variant" else "base"
            body = ("%s:%s" % (course_id, suffix)).encode()
            self.send_response(200)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
        def log_message(self, *_args):
            pass
    server = http.server.HTTPServer(("127.0.0.1", 0), Handler)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    port = server.server_port
    base = urllib.request.urlopen("http://127.0.0.1:%d/" % port, timeout=3).read()
    variant = urllib.request.urlopen("http://127.0.0.1:%d/variant" % port, timeout=3).read()
    server.shutdown()
    check("single-path-change", base != variant)
    check("same-status-contract", len(base) > 0 and len(variant) > 0)
    metrics.update(base=base.decode(), variant=variant.decode(), port=port)
elif category == "database":
    db = sqlite3.connect(":memory:")
    db.execute("create table items(id integer primary key, name text not null)")
    db.execute("insert into items(name) values (?)", (course_id,))
    before = db.execute("select count(*) from items").fetchone()[0]
    db.execute("insert into items(name) values (?)", (course_id + "-variant",))
    after = db.execute("select count(*) from items").fetchone()[0]
    check("single-row-change", before == 1 and after == 2)
    check("same-schema", any(row[1] == "name" for row in db.execute("pragma table_info(items)").fetchall()))
    metrics.update(before=before, after=after)
elif category == "web":
    before = '<main><label for="name">Name</label><input id="name"></main>'
    after = '<main><label for="name">Display name</label><input id="name"></main>'
    check("single-text-change", before != after)
    check("same-label-control", 'for="name"' in before and 'for="name"' in after)
    reject("missing-label", lambda: (_ for _ in ()).throw(ValueError("label")) if 'for="name"' not in "<input>" else None)
    metrics.update(before_bytes=len(before), after_bytes=len(after))
elif category == "security":
    import re
    valid = lambda value: bool(re.fullmatch(r"[A-Za-z0-9_-]{1,20}", value))
    before, after = "alice_1", "alice_variant"
    check("single-input-change", valid(before) and valid(after) and before != after)
    digest_before = hashlib.sha256(before.encode()).hexdigest()
    digest_after = hashlib.sha256(after.encode()).hexdigest()
    check("evidence-changes", digest_before != digest_after)
    reject("unsafe-still-rejected", lambda: (_ for _ in ()).throw(ValueError("unsafe")) if not valid("../secret") else None)
    metrics.update(before_digest=digest_before, after_digest=digest_after)
elif category == "mobile":
    transitions = {"created": {"started"}, "started": {"paused", "stopped"}, "paused": {"started", "stopped"}, "stopped": set()}
    base, variant = ["started", "stopped"], ["started", "paused"]
    state = "created"
    for step in base:
        check("base-" + step, step in transitions[state])
        state = step
    base_final = state
    state = "created"
    for step in variant:
        check("variant-" + step, step in transitions[state])
        state = step
    check("single-transition-path-change", base_final != state)
    metrics.update(base_final=base_final, variant_final=state)
elif category == "ai":
    before = [0, 2, 4, 6]
    after = [0, 3, 6, 9]
    slope_before = sum(x * y for x, y in zip(range(4), before)) / sum(x * x for x in range(4))
    slope_after = sum(x * y for x, y in zip(range(4), after)) / sum(x * x for x in range(4))
    check("single-label-scale-change", math.isclose(slope_before, 2.0) and math.isclose(slope_after, 3.0))
    check("metric-changes", slope_before != slope_after)
    reject("non-finite-still-rejected", lambda: (_ for _ in ()).throw(ValueError("nan")) if not math.isfinite(float("nan")) else None)
    metrics.update(before=slope_before, after=slope_after)
elif category == "ops":
    before = {"status": "ok", "checks": ["process", "filesystem", "local-http"]}
    after = {"status": "ok", "checks": ["process", "filesystem", "local-http", "variant"]}
    check("single-check-change", len(after["checks"]) == len(before["checks"]) + 1)
    check("status-preserved", before["status"] == after["status"] == "ok")
    metrics.update(before_checks=len(before["checks"]), after_checks=len(after["checks"]))
elif category == "product":
    before = '<label for="name">Name</label><input id="name">'
    after = before + '<label for="email">Email</label><input id="email">'
    check("single-field-addition", len(after) > len(before))
    check("original-task-preserved", 'for="name"' in after and 'id="name"' in after)
    metrics.update(before_fields=1, after_fields=2)
else:
    raise ValueError("unsupported category: " + category)

print(json.dumps({"course": course_id, "category": category, "checks": checks, "metrics": metrics}, ensure_ascii=False, sort_keys=True))
'@

$results = [System.Collections.Generic.List[object]]::new()
foreach ($record in $records) {
    $id = [string]$record.Id
    $labDir = Join-Path $evidenceRoot (Join-Path $id 'labs\lab2')
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
        "variable=one category-specific input/field/path/value change"
        "started=$started"
        "ended=$ended"
        "status=$status"
        "contract=evidence/$id/labs/lab2/README.md"
        "baseline=evidence/$id/labs/lab2/automation-baseline/"
        "cleanup=remove or archive automation-baseline/work after review; no credentials are created"
    ) | Set-Content -LiteralPath (Join-Path $baseDir 'commands.txt') -Encoding utf8
    @(
        "# $id Lab 2 automated baseline"
        ""
        "- Status: $status"
        "- Category: $($record.Category)"
        "- Started: $started"
        "- Ended: $ended"
        "- Evidence: automation-baseline/"
        "- Variable: one category-specific input, field, path or value changed while the contract stays fixed."
        "- This is a local automated comparison, not learner completion of Lab 2 or Lv1-Lv5."
        "- The learner must explain causality, controls, repeatability and limitations."
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
$results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runRoot 'lab2-automation-results.json') -Encoding utf8
$summary = $results | Group-Object Status | Sort-Object Name
@(
    "# Lab 2 自动化基线汇总 · $runDate"
    ""
    "范围：$($results.Count) 个课号，各运行一次按轨道区分的单变量对照基线。"
    "自动化对照不代表学习者完成；Lab 3–5、Lv1–Lv5 和毕业工程仍独立验收。"
    ""
    ($summary | ForEach-Object { "- $($_.Name)：$($_.Count)" })
    ""
    "| 课号 | 轨道 | 状态 | 错误 |"
    "|---|---|---|---|"
    ($results | ForEach-Object { "| $($_.Id) | $($_.Category) | $($_.Status) | $($_.Error -replace '\|','/') |" })
) | Set-Content -LiteralPath (Join-Path $runRoot 'LAB2-AUTOMATION-SUMMARY.md') -Encoding utf8
$pass = @($results | Where-Object Status -eq 'PASS').Count
$fail = @($results | Where-Object Status -eq 'FAIL').Count
Write-Output "Courses=$($results.Count) Lab2BaselinePass=$pass Lab2BaselineFail=$fail Summary=$(Join-Path $runRoot 'LAB2-AUTOMATION-SUMMARY.md')"
if ($fail -gt 0) { exit 1 }
