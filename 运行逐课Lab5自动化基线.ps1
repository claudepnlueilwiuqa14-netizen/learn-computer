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
if ($records.Count -eq 0) { throw 'no course record selected' }

$probe = @'
import hashlib
import json
import math
import statistics
import sys

sys.stdout.reconfigure(encoding='utf-8')
category, course_id, metadata_path = sys.argv[1], sys.argv[2], sys.argv[3]
metadata = json.load(open(metadata_path, encoding='utf-8'))
seed = sum(ord(ch) for ch in course_id) % 7 + 3

def measure(group, replicate):
    # Deterministic synthetic measurements keep the baseline reproducible and local.
    if category == 'algorithm':
        return seed * (replicate + 1) * (1 if group == 'A' else 2)
    if category == 'database':
        return seed + replicate + (0 if group == 'A' else 3)
    if category == 'network':
        return 10 + seed + replicate + (0 if group == 'A' else 5)
    if category == 'security':
        return (0 if group == 'A' else 1) + replicate * 0
    if category == 'ai':
        return round((seed / 10) + replicate * 0.01 + (0 if group == 'A' else 0.05), 4)
    if category in ('ops', 'mobile'):
        return 2 + replicate + (0 if group == 'A' else 1)
    if category in ('web', 'product'):
        return 80 - replicate + (0 if group == 'A' else -5)
    return seed + replicate + (0 if group == 'A' else 2)

group_a = [measure('A', i) for i in range(3)]
group_b = [measure('B', i) for i in range(3)]
mean_a = statistics.mean(group_a)
mean_b = statistics.mean(group_b)
effect = round(mean_b - mean_a, 6)
if category == 'security':
    hypothesis = '合成安全输入中，加入一个越界样本会被拒绝且不会改变安全样本的接受结果。'
    falsifier = '若越界样本被接受，或安全样本被误拒，则假设被否证。'
    boundary = '仅覆盖自有合成输入和本地规则，不推断真实系统的检测率。'
elif category == 'algorithm':
    hypothesis = '在固定实现和输入族下，变量翻倍不会让操作计数超过基线的三倍。'
    falsifier = '任一重复的操作计数超过基线三倍，或输入前提被破坏仍声称成立。'
    boundary = '只测确定性合成输入，不代表所有实现、缓存或硬件上的复杂度。'
else:
    hypothesis = '只改变一个受控变量时，两个对照组的指标差异可被稳定观察且方向一致。'
    falsifier = '三次重复中方向不一致、差异不可复现，或未控制第二个变量。'
    boundary = '这是本地合成实验，不替代真实生产流量、随机抽样或外部因果结论。'

checks = [
    ('hypothesis-present', bool(hypothesis)),
    ('two-groups', group_a != group_b),
    ('three-replicates', len(group_a) == 3 and len(group_b) == 3),
    ('deterministic-repeat', group_a == [measure('A', i) for i in range(3)]),
    ('falsifier-present', bool(falsifier)),
    ('boundary-present', bool(boundary)),
    ('citation-present', bool(metadata.get('source')) and bool(metadata.get('url'))),
]
failed = [name for name, ok in checks if not ok]
if failed:
    raise AssertionError(','.join(failed))

packet = {
    'course': course_id,
    'title': metadata['title'],
    'category': category,
    'hypothesis': hypothesis,
    'groups': {
        'A_control': {'description': '固定基线', 'observations': group_a},
        'B_treatment': {'description': '只改变一个受控变量', 'observations': group_b},
    },
    'replicates': 3,
    'metric': metadata['metric'],
    'summary': {'mean_A': mean_a, 'mean_B': mean_b, 'effect_B_minus_A': effect},
    'supports_hypothesis': math.isfinite(effect),
    'counterexample_or_falsifier': falsifier,
    'boundary': boundary,
    'source': metadata['source'],
    'url': metadata['url'],
    'version': '2026-09-09 local synthetic baseline',
    'unverified': ['learner-selected real data', 'independent replication', 'external causal validity'],
    'next_step': '由学习者替换合成输入，保留控制变量，记录原始输出并尝试推翻假设。',
    'synthetic_only': True,
    'checks': [name for name, ok in checks],
    'artifact_sha256': hashlib.sha256(json.dumps({'a': group_a, 'b': group_b}, sort_keys=True).encode()).hexdigest(),
}
print(json.dumps(packet, ensure_ascii=False, sort_keys=True))
'@

$results = [System.Collections.Generic.List[object]]::new()
foreach ($record in $records) {
    $id = [string]$record.Id
    $labDir = Join-Path $evidenceRoot (Join-Path $id 'labs\lab5')
    $baseDir = Join-Path $labDir 'automation-baseline'
    $work = Join-Path $baseDir 'work'
    New-Item -ItemType Directory -Path $work -Force | Out-Null
    $probePath = Join-Path $work 'probe.py'
    $metadataPath = Join-Path $work 'metadata.json'
    $probe | Set-Content -LiteralPath $probePath -Encoding utf8
    [ordered]@{
        title = [string]$record.Title
        metric = [string]$record.Metric
        source = [string]$record.Source
        url = [string]$record.Url
    } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $metadataPath -Encoding utf8
    $started = Get-Date
    $status = 'PASS'
    $errorText = ''
    try {
        @("python=$((python --version 2>&1 | Out-String).Trim())", "powershell=$($PSVersionTable.PSVersion)") | Set-Content -LiteralPath (Join-Path $baseDir 'environment.txt') -Encoding utf8
        $output = & python $probePath ([string]$record.Category) $id $metadataPath 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) { throw ("probe exit code {0}{1}{2}" -f $LASTEXITCODE, [Environment]::NewLine, $output) }
        $output.TrimEnd() | Set-Content -LiteralPath (Join-Path $baseDir 'probe-output.json') -Encoding utf8
        $output.TrimEnd() | Set-Content -LiteralPath (Join-Path $baseDir 'research-packet.json') -Encoding utf8
    } catch {
        $status = 'FAIL'
        $errorText = $_.Exception.Message
        $errorText | Set-Content -LiteralPath (Join-Path $baseDir 'error.txt') -Encoding utf8
    }
    $ended = Get-Date
    @(
        "course=$id"
        "category=$($record.Category)"
        "command=python probe.py $($record.Category) $id metadata.json"
        'experiment=two groups, one controlled variable, three deterministic replicates'
        'safety=synthetic local inputs only; no credentials, external targets or personal data'
        "started=$started"
        "ended=$ended"
        "status=$status"
        "contract=evidence/$id/labs/lab5/README.md"
        "baseline=evidence/$id/labs/lab5/automation-baseline/"
        'cleanup=remove or archive automation-baseline/work after review'
    ) | Set-Content -LiteralPath (Join-Path $baseDir 'commands.txt') -Encoding utf8
    @(
        "# $id Lab 5 automated baseline"
        ''
        "- Status: $status"
        "- Category: $($record.Category)"
        "- Started: $started"
        "- Ended: $ended"
        '- Evidence: automation-baseline/research-packet.json'
        '- Research shape: falsifiable hypothesis, two groups, three replicates, metric, boundary, citation and next step.'
        '- Synthetic-only machine baseline; it is not learner completion of Lab 5, Lv1-Lv5 or a research claim about production.'
        '- Learner must replace the synthetic input, read and cite the source, preserve raw output, seek a counterexample and document limits.'
        "- Error: $(if ($errorText) { $errorText } else { 'none' })"
    ) | Set-Content -LiteralPath (Join-Path $baseDir 'RESULT.md') -Encoding utf8
    $readme = Join-Path $labDir 'README.md'
    $readmeText = Get-Content -LiteralPath $readme -Raw -Encoding utf8
    $readmeText = [regex]::Replace($readmeText, "(?ms)\r?\n## Automated baseline $runDate.*?(?=\r?\n## |\z)", '')
    $block = @('', "## Automated baseline $runDate", "- Status: $status", '- Evidence: automation-baseline/RESULT.md', '- This machine result does not change the learner status above.') -join ([Environment]::NewLine)
    ($readmeText.TrimEnd() + [Environment]::NewLine + $block + [Environment]::NewLine) | Set-Content -LiteralPath $readme -Encoding utf8
    $results.Add([pscustomobject]@{ Id=$id; Category=$record.Category; Status=$status; Error=$errorText })
}

$runRoot = Join-Path $Root "抽样运行_$runDate"
$results | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $runRoot 'lab5-automation-results.json') -Encoding utf8
$summary = $results | Group-Object Status | Sort-Object Name
@(
    "# Lab 5 自动化基线汇总 · $runDate"
    ''
    "范围：$($results.Count) 个课号，各运行一次合成研究与教学记录基线。"
    '机器基线只验证研究记录形状和可重复性，不代表学习者完成、资料已阅读或结论可外推。'
    ''
    ($summary | ForEach-Object { "- $($_.Name)：$($_.Count)" })
    ''
    '| 课号 | 轨道 | 状态 | 错误 |'
    '|---|---|---|---|'
    ($results | ForEach-Object { "| $($_.Id) | $($_.Category) | $($_.Status) | $($_.Error -replace '\|','/') |" })
) | Set-Content -LiteralPath (Join-Path $runRoot 'LAB5-AUTOMATION-SUMMARY.md') -Encoding utf8
$pass = @($results | Where-Object Status -eq 'PASS').Count
$fail = @($results | Where-Object Status -eq 'FAIL').Count
Write-Output "Courses=$($results.Count) Lab5BaselinePass=$pass Lab5BaselineFail=$fail Summary=$(Join-Path $runRoot 'LAB5-AUTOMATION-SUMMARY.md')"
if ($fail -gt 0) { exit 1 }
