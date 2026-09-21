param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$Strict
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$jsonPath = Join-Path $Root '逐课专属深度合同_590课.json'
if (-not (Test-Path -LiteralPath $jsonPath -PathType Leaf)) { throw "missing contract json: $jsonPath" }
$records = @(Get-Content -LiteralPath $jsonPath -Raw -Encoding utf8 | ConvertFrom-Json)
$errors = [System.Collections.Generic.List[string]]::new()
$rows = [System.Collections.Generic.List[object]]::new()
$fieldNames = @('TopicMechanism','TopicInvariant','TopicMetric','TopicFailure','SourceChapter','TopicLabInput','ResearchQuestion')
$genericPatterns = @(
    '输入设备/文件系统/进程/解释器之间的可观察事件链',
    'Python 数据模型、调用栈、异常传播、模块导入和标准库组合',
    '类型系统、内存/所有权模型、错误模型、构建器与运行时之间的契约',
    '范式约束、组合子、不可变数据、声明式查询或 Shell 管道的数据流',
    '抽象数据结构、状态转移、循环不变量、复杂度和输入分布',
    '源码、ABI、汇编、链接、装载、系统调用、调度和持久化的跨层链路',
    '协议状态机、报文字段、超时/重传、缓存和故障域',
    '数据模型、执行器、索引、事务隔离、锁/MVCC、WAL 和恢复',
    '浏览器文档树、事件循环、HTTP 缓存、API 契约和用户任务状态',
    '资产/信任边界、输入验证、身份权限、检测证据和修复回归',
    '平台生命周期、权限/沙箱、渲染帧、离线状态、功耗和发布签名',
    '数据契约、切分/泄漏、特征与模型、评估、漂移、推理服务和治理',
    '声明式资源、进程/容器、三信号观测、SLO/错误预算、供应链和灾备',
    '用户任务、信息架构、交互状态、研究证据、设计系统和交付协作'
)
foreach ($record in $records) {
    $id = [string]$record.Id
    if ([string]::IsNullOrWhiteSpace([string]$record.ProfileKind) -or [string]$record.ProfileKind -ne 'topic-semantic-v1') { $errors.Add("$id missing topic profile version") }
    $terms = @($record.TopicTerms | ForEach-Object { [string]$_ } | Where-Object { $_.Trim().Length -ge 1 -and $_ -notin @('与','及','和','或','的') })
    if ($terms.Count -lt 2) { $errors.Add("$id has fewer than 2 topic terms") }
    $fieldText = ($fieldNames | ForEach-Object { [string]$record.$_ }) -join "`n"
    $covered = 0
    foreach ($term in $terms) {
        if ($fieldText.Contains($term)) { $covered++ } else { $errors.Add("$id topic term not present in semantic fields: $term") }
    }
    $semanticFieldCount = @($fieldNames | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$record.$_) -and [string]$record.$_ -notmatch '^对应语言的官方规范|^与「|^本课语言规范' }).Count
    $genericHits = @($genericPatterns | Where-Object { [string]$record.Mechanism -eq $_ -or [string]$record.Invariant -eq $_ -or [string]$record.Metric -eq $_ -or [string]$record.Failure -eq $_ }).Count
    if ($genericHits -gt 0) { $errors.Add("$id retains a bare generic contract field") }
    if ([string]$record.Category -eq 'python' -and [string]$record.Mechanism -match '^Python 数据模型、调用栈、异常传播、模块导入和标准库组合') {
        $errors.Add("$id starts Mechanism with the shared Python baseline instead of the lesson-specific mechanism")
    }
    $labs = @($record.Labs)
    $labText = ($labs | ForEach-Object { "$($_.Input)`n$($_.Expected)`n$($_.Failure)`n$($_.Metric)" }) -join "`n"
    $labHits = @($terms | Where-Object { $labText.Contains($_) }).Count
    if ($labHits -lt 2) { $errors.Add("$id only $labHits topic terms appear across labs") }
    $coreText = @([string]$record.Mechanism,[string]$record.Invariant,[string]$record.Metric,[string]$record.Failure) -join "`n"
    $coreHits = @($terms | Where-Object { $coreText.Contains($_) }).Count
    if ($coreHits -ne $terms.Count) {
        $missingCore = @($terms | Where-Object { -not $coreText.Contains($_) }) -join '|'
        $errors.Add("$id topic terms missing from core contract fields: $missingCore")
    }
    $labSlotHits = [System.Collections.Generic.List[int]]::new()
    if ($labs.Count -ne 5) { $errors.Add("$id has $($labs.Count) labs; expected exactly 5") }
    for ($labIndex = 0; $labIndex -lt 5; $labIndex++) {
        if ($labIndex -ge $labs.Count) {
            $labSlotHits.Add(0)
            continue
        }
        $lab = $labs[$labIndex]
        $slotText = "$($lab.Input)`n$($lab.Expected)`n$($lab.Failure)`n$($lab.Metric)"
        $slotHits = @($terms | Where-Object { $slotText.Contains($_) }).Count
        $labSlotHits.Add($slotHits)
        if ($slotHits -lt 1) { $errors.Add("$id Lab $($labIndex + 1) has no topic-term binding") }
    }
    $labSlotsBound = @($labSlotHits | Where-Object { $_ -ge 1 }).Count
    $rows.Add([pscustomobject]@{
        Id=$id; Category=[string]$record.Category; Terms=$terms.Count; TermsCovered=$covered
        SemanticFields=$semanticFieldCount; CoreTermsCovered=$coreHits; LabTermsCovered=$labHits; LabSlotsBound=$labSlotsBound
        LabSlotHits=($labSlotHits -join ','); GenericBareFields=$genericHits
    })
}
$all = @($rows)
$expectedLabSlots = $records.Count * 5
$boundLabSlots = [int](($all | Measure-Object -Property LabSlotsBound -Sum).Sum)
$coreFieldBound = @($all | Where-Object { $_.CoreTermsCovered -eq $_.Terms }).Count
$fullyBound = @($all | Where-Object { $_.Terms -ge 2 -and $_.TermsCovered -eq $_.Terms -and $_.LabTermsCovered -ge 2 -and $_.LabSlotsBound -eq 5 -and $_.GenericBareFields -eq 0 }).Count
$summary = $all | Group-Object Category | Sort-Object Name | ForEach-Object {
    $bound = @($_.Group | Where-Object { $_.TermsCovered -eq $_.Terms -and $_.LabTermsCovered -ge 2 -and $_.LabSlotsBound -eq 5 -and $_.GenericBareFields -eq 0 }).Count
    "$($_.Name)=$bound/$($_.Count)"
}
Write-Output "TopicRecords=$($records.Count)"
Write-Output "FullyTopicBound=$fullyBound/$($records.Count)"
Write-Output "CoreFieldBindings=$coreFieldBound/$($records.Count)"
Write-Output "LabSlotBindings=$boundLabSlots/$expectedLabSlots"
Write-Output ("CategoryTopicBound: " + ($summary -join ', '))
Write-Output "TopicSpecificityErrors=$($errors.Count)"
if ($errors.Count -gt 0) {
    $errors | Select-Object -First 60
    if ($Strict) { exit 1 }
}
if ($errors.Count -eq 0) { Write-Output 'Per-course topic specificity: PASS (terms, semantic fields, labs, and generic-field guard passed).' }
$reportPath = Join-Path $Root 'evidence/topic-specificity-audit-2026-09-09.md'
$reportLines = [System.Collections.Generic.List[string]]::new()
$reportLines.Add('# 逐课主题特异性审计 · 2026-09-09')
$reportLines.Add('')
$reportLines.Add('本报告只审计合同资产是否真正绑定到课题，不把合同存在或机器基线误算作学习者完成。')
$reportLines.Add('')
$reportLines.Add("- 课数：$($records.Count)")
$reportLines.Add("- 完整主题绑定：$fullyBound/$($records.Count)")
$reportLines.Add("- 核心字段主题绑定：$coreFieldBound/$($records.Count)")
$reportLines.Add("- Lab 1–5 槽位主题绑定：$boundLabSlots/$expectedLabSlots")
$reportLines.Add("- 错误数：$($errors.Count)")
$reportLines.Add('- 每课要求：至少 2 个主题词；主题词出现在语义字段和 Mechanism/Invariant/Metric/Failure 核心字段；至少 2 个主题词进入 Lab；Lab 1–5 每个槽位至少命中 1 个主题词；通用字段不能裸留。')
$reportLines.Add('')
$reportLines.Add('## 分宏域')
$reportLines.Add('')
foreach ($line in $summary) { $reportLines.Add("- $line") }
$reportLines.Add('')
$reportLines.Add('## 证据边界')
$reportLines.Add('')
$reportLines.Add('- 通过表示生成器产物具备可审计的课题特异字段，不表示学习者已阅读资料或完成 Lab。')
$reportLines.Add('- 资料章节仍需在 `evidence/<课号>/notes.md` 记录页面标题、版本、访问日期、已验证命题和未验证项。')
$reportLines | Set-Content -LiteralPath $reportPath -Encoding utf8
Write-Output "Evidence=$reportPath"
