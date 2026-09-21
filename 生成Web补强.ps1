param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [string]$Output = (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) '方向6_Web全栈_闯关与实战补强.md')
)
Set-StrictMode -Version Latest
$source = Join-Path $Root '教案_方向6_Web全栈.md'
$pattern = '^#{1,3}\s+((?:FE|BE)\d+)\s*[· ]+(.+)$'
$courses = @()
foreach ($line in (Get-Content -LiteralPath $source)) {
    if ($line -match $pattern) { $courses += [pscustomobject]@{Id=$matches[1];Title=$matches[2].Trim()} }
}

function Get-Track([string]$id, [string]$title) {
    if ($id -match '^FE') { return '前端与浏览器' }
    if ($title -match '认证|密码|安全|上传|支付') { return '后端安全与信任' }
    if ($title -match '部署|Nginx|Docker|K8s|Serverless|微服务') { return '交付与云原生' }
    if ($title -match '日志|监控|链路|测试|性能|系统设计|毕业') { return '可靠性与产品交付' }
    return '后端与 API'
}

function Get-Focus([string]$track, [string]$title) {
    switch ($track) {
        '前端与浏览器' { return @(
            "浏览器链路：$title 要改变 DOM、样式、事件、网络或存储的哪一部分？",
            '边界实验：慢网、窄屏、键盘操作、禁用 JavaScript、重复提交和错误响应时是否仍可用？',
            '工程取舍：体验、可访问性、性能、隐私、供应链和维护成本如何量化？') }
        '后端安全与信任' { return @(
            "信任边界：$title 中哪些输入来自不可信客户端，验证、授权、审计和回滚分别在哪里？",
            '失败实验：重放、超时、并发、权限变化、恶意文件或第三方回调失败时会发生什么？',
            '证据要求：用测试、日志、trace 和最小权限证明修复有效，而不是只展示成功请求。') }
        '交付与云原生' { return @(
            "运行模型：$title 如何被构建、配置、调度、观测、扩容、升级和回滚？",
            '故障实验：依赖不可用、资源不足、实例重启、证书过期和版本不兼容如何恢复？',
            '工程取舍：可用性、成本、部署速度、隔离、数据持久性和供应链风险如何权衡？') }
        default { return @(
            "系统边界：$title 的 API、数据、队列、缓存和外部依赖如何协作？",
            '失败实验：重复请求、慢查询、消息重投、部分成功和降级如何被发现与修复？',
            '交付证据：用指标、容量模型、测试和 ADR 解释一个架构选择。') }
    }
}

function Get-Labs([string]$track, [string]$id, [string]$title) {
    if ($track -eq '前端与浏览器') {
        return @(
            "Lab 1 · 最小页面：在本地实现 [$title] 的最小可运行例子，保存源码、浏览器版本和截图。",
            'Lab 2 · 受控变体：切换窄屏/键盘/慢网/禁用脚本之一，保存前后行为与解释。',
            'Lab 3 · 综合交互：连接表单、API、错误状态和加载状态，使用 Playwright 或等价测试覆盖成功与失败。',
            'Lab 4 · 审计优化：用 DevTools/Lighthouse/axe 检查性能、a11y、隐私或供应链，提交指标和一项修复。',
            'Lab 5 · 开放研究：提出一个可证伪 UX/性能假设，做对照实验并写 ADR、限制和复现步骤。')
    }
    if ($track -eq '后端安全与信任') {
        return @(
            "Lab 1 · 最小 API：在本地实现 [$title] 的健康路径，给出请求、响应、状态码和数据模型。",
            'Lab 2 · 失败变体：测试空值、超长值、重复请求、过期凭据、并发和第三方超时，记录安全失败。',
            'Lab 3 · 综合链路：接入数据库/队列/缓存中的一个，加入幂等键、事务边界和结构化日志。',
            'Lab 4 · 防御审计：对自有服务做参数化、权限、密钥、上传、回调或依赖审计，提交修复回归。',
            'Lab 5 · 架构研究：写威胁模型、数据流图、SLO、回滚和一次事故复盘；不使用真实个人数据。')
    }
    if ($track -eq '交付与云原生') {
        return @(
            "Lab 1 · 本地交付：把 [$title] 打包为可重复启动的 Docker Compose/本地服务。",
            'Lab 2 · 配置变体：改变副本、资源、超时或版本，记录行为、日志和成本影响。',
            'Lab 3 · 故障注入：模拟依赖失败、探针失败、重启、证书/配置错误，验证自动恢复或安全降级。',
            'Lab 4 · 观测审计：加入 metrics、logs、traces、健康检查、最小权限和供应链锁定，提交证据。',
            'Lab 5 · 运维研究：写容量模型、SLO/错误预算、升级/回滚和灾备演练报告。')
    }
    return @(
        "Lab 1 · 最小服务：在本地实现 [$title] 的单体闭环，保存 API、数据表、测试和运行命令。",
        'Lab 2 · 受控变体：改变并发、数据量、超时或失败比例，比较 P50/P95/P99、错误率和资源。',
        'Lab 3 · 综合架构：连接两个前置能力（如 API+数据库、缓存+队列），加入重试、幂等和回滚。',
        'Lab 4 · 根因分析：用 profiler、EXPLAIN、日志或 trace 定位一个瓶颈，提交优化前后证据。',
        'Lab 5 · 开放决策：写 ADR、容量/成本估算、威胁模型、测试策略和已知限制，并让他人复现。')
}

$out = [System.Collections.Generic.List[string]]::new()
$out.Add('# 方向 6 · Web 全栈：FE1–FE18 / BE1–BE26 闯关与实战补强')
$out.Add('')
$out.Add('> 本文件补充 `教案_方向6_Web全栈.md`。所有服务只在本机、隔离容器或明确授权环境运行；认证、支付、上传和安全实验不使用真实凭据或个人数据。')
$out.Add('> 资料锚点：MDN Web、OWASP ASVS/Top 10、PostgreSQL、OpenTelemetry、Kubernetes Concepts、NN/g 十项启发式。')
$out.Add('')
$out.Add('## 统一五关')
$out.Add('- Lv1：最小闭环能运行，交命令、源码、输出和环境。')
$out.Add('- Lv2：只改一个参数/输入/设备条件，交差异和解释。')
$out.Add('- Lv3：跨前置课完成综合路径，交自动化测试、错误状态和日志。')
$out.Add('- Lv4：性能/安全/可访问性/可靠性审计或手写核心机制，交指标和根因。')
$out.Add('- Lv5：产品或架构开放题，交 ADR、威胁模型、SLO、回滚、研究笔记和教学材料。')
$out.Add('')

foreach ($course in $courses) {
    $tick = [char]96
    $track = Get-Track $course.Id $course.Title
    $focus = Get-Focus $track $course.Title
    $labs = Get-Labs $track $course.Id $course.Title
    $out.Add("## $($course.Id) · $($course.Title)")
    $out.Add('')
    $out.Add("- 轨道：$track")
    $out.Add('- 深挖问题：')
    foreach ($q in $focus) { $out.Add("  - $q") }
    $out.Add('- 闯关交付：')
    $out.Add("  - Lv1：提交 ${tick}$($course.Id)/lv1${tick} 最小运行证据。")
    $out.Add("  - Lv2：提交 ${tick}$($course.Id)/lv2${tick} 变体、对比和失败解释。")
    $out.Add("  - Lv3：提交 ${tick}$($course.Id)/lv3${tick} 综合测试、日志和设计图。")
    $out.Add("  - Lv4：提交 ${tick}$($course.Id)/lv4${tick} 基线、指标、审计/优化和限制。")
    $out.Add("  - Lv5：提交 ${tick}$($course.Id)/lv5${tick} ADR/研究/威胁模型/复盘，并教会他人复现。")
    $out.Add('- 五个 Lab：')
    foreach ($lab in $labs) { $out.Add("  - $lab") }
    $out.Add('- 验收：至少 4/5 Lab 在干净环境可复现；成功、失败、权限、超时和清理路径均有证据；不把“页面能打开”或“接口返回 200”当作毕业。')
    $out.Add('')
}

$out.Add('## 闪电号卡毕业工程映射')
$out.Add('')
$out.Add('1. FE1–FE4：语义页面、响应式、错误/加载状态、a11y 和性能预算。')
$out.Add('2. FE5–FE18：交互、状态、组件、构建、类型、浏览器安全、微前端边界和端到端测试。')
$out.Add('3. BE1–BE9：API、认证授权、数据模型、事务、幂等、分页、迁移和契约测试。')
$out.Add('4. BE10–BE20：GraphQL/gRPC、上传、缓存、队列、限流、微服务、实时和支付回调。')
$out.Add('5. BE21–BE26：观测、测试、容器/K8s/HTTPS、性能、系统设计、灾备和最终演示。')
$out.Add('6. 毕业验收：正常下单、重复提交、库存不足、回调延迟、数据库恢复、依赖故障、安全审计和回滚全部可演示。')

$out | Set-Content -LiteralPath $Output -Encoding UTF8
Write-Output "Generated $($courses.Count) Web cards -> $Output"
