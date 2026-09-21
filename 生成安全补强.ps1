param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [string]$Output = (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) '方向7_安全攻防_闯关与实战补强.md')
)
Set-StrictMode -Version Latest
$files = @(
    (Join-Path $Root '教案_方向7a_安全基础_Web安全.md'),
    (Join-Path $Root '教案_方向7b_二进制_漏洞利用_Hook.md'),
    (Join-Path $Root '教案_方向7c_恶意代码_渗透红队_CTFCERT_AIOT.md')
)
$pattern = '^#{1,3}\s+((?:SEC|SEC-W|SEC-B|SEC-C)(?:\d+|-[A-Z]\d+))\s*[· ]+(.+)$'
$courses = @()
foreach ($file in $files) {
    foreach ($line in (Get-Content -LiteralPath $file)) {
        if ($line -match $pattern) { $courses += [pscustomobject]@{Id=$matches[1];Title=$matches[2].Trim();File=(Split-Path $file -Leaf)} }
    }
}

function Get-Track([string]$id, [string]$title) {
    if ($id -match '^SEC-W') { return 'Web 应用与身份安全' }
    if ($id -match '^SEC-B') { return '二进制与内存安全' }
    if ($id -match '^SEC-C') { return '授权实战与检测工程' }
    if ($id -match '^SEC([1-9]|1[0-9]|2[0-2])') { return '安全基础与 Web 防御' }
    if ($id -match '^SEC(2[3-9]|[3-4][0-9]|5[0-5])') { return '二进制与逆向基础' }
    return '威胁检测与安全运营'
}

function Get-Focus([string]$track, [string]$title) {
    switch ($track) {
        'Web 应用与身份安全' { return @(
            "信任边界：$title 中不可信输入、身份、授权和危险汇点如何连接？",
            '防御证据：如何在本地自建应用或授权靶场复现低风险问题、修复并做回归？',
            '工程取舍：安全控制对可用性、性能、隐私、开发体验和运营成本的影响是什么？') }
        '安全基础与 Web 防御' { return @(
            "威胁模型：$title 保护的资产、攻击面、信任边界和滥用案例是什么？",
            '验证方法：哪些单元、集成、动态或配置测试能证明控制有效？',
            '治理闭环：发现、分级、修复、回归、披露和复盘如何留证？') }
        '二进制与内存安全' { return @(
            "跨层链路：$title 如何从 C/C++ 源码、ABI、内存布局反映到机器码和崩溃？",
            '安全实验：只对自己编译的教学二进制做静态/动态分析，如何用 Sanitizer、模糊测试和补丁验证修复？',
            '边界：哪些细节会形成现实系统攻击能力，如何在隔离、最小样本和防御目标下停止？') }
        '授权实战与检测工程' { return @(
            "授权边界：$title 的目标、时间窗、允许技术、停止条件和报告对象如何书面化？",
            '证据链：如何保存请求、日志、时间线、哈希、规则命中和修复回归而不泄露真实数据？',
            '运营价值：如何把一次练习转成检测、缓解、恢复、培训和度量？') }
        default { return @(
            "检测视角：$title 的行为假设、可观察信号、误报/漏报和响应动作是什么？",
            '安全实验：只使用合成样本、自有容器/虚拟机和授权靶场，如何验证规则与修复？',
            '复盘视角：风险、影响、根因、控制缺口、补救和长期预防如何被不同读者理解？') }
    }
}

function Get-Labs([string]$track, [string]$title) {
    switch ($track) {
        'Web 应用与身份安全' { return @(
            "Lab 1 · 自有最小样例：在本地故意写出与 [$title] 对应的安全缺陷，保存范围、版本和复现请求。",
            'Lab 2 · 修复回归：加入参数化/输出编码/授权校验/安全 cookie/CSRF 或速率限制中的正确控制，测试正反路径。',
            'Lab 3 · 工具交叉验证：对自己的服务运行 SAST、依赖扫描和动态测试，人工复核一个结果并记录误报。',
            'Lab 4 · 检测工程：为合成日志设计 Sigma/查询/告警，测量覆盖、误报和响应时间。',
            'Lab 5 · 宗师报告：提交威胁模型、修复前后 diff、回归证据、残余风险和面向开发者/管理者的双版本报告。') }
        '安全基础与 Web 防御' { return @(
            "Lab 1 · 资产清单：为 [$title] 的自有小应用列出资产、数据分类、入口、信任边界和责任人。",
            'Lab 2 · 控制验证：写单元/集成测试证明允许路径成功、拒绝路径失败且错误不泄露敏感信息。',
            'Lab 3 · 配置审计：检查密钥、权限、依赖、日志、备份和默认配置，提交风险排序。',
            'Lab 4 · 修复演练：将一个高风险项从发现、修复、回归到发布完整走一遍。',
            'Lab 5 · 研究笔记：把结果映射 OWASP ASVS/Top 10 或 NIST NICE 能力条目，写明未覆盖范围。') }
        '二进制与内存安全' { return @(
            "Lab 1 · 教学二进制：只编译自己的最小 C/C++ 程序，使用 gdb/Rizin/objdump 解释函数、栈和 ABI。",
            'Lab 2 · 安全编译：开启 ASan/UBSan/栈保护/PIE/RELRO 等防护，比较崩溃信息与二进制属性。',
            'Lab 3 · 有界模糊测试：对本地解析器使用合成输入和时间/内存上限，分类崩溃并最小化样本。',
            'Lab 4 · 修复验证：修复自有教学缺陷，重新编译、回归、对比覆盖率；不制作针对真实软件的利用链。',
            'Lab 5 · 防御报告：解释根因、可观察信号、编译/语言迁移建议、残余风险和安全披露边界。') }
        '授权实战与检测工程' { return @(
            "Lab 1 · 范围确认：为 [$title] 写授权单、资产列表、时间窗、禁止动作、停止条件和联系人。",
            'Lab 2 · 隔离验证：只对本地靶场/CTF/自有容器运行低风险验证，保存请求、响应和时间线。',
            'Lab 3 · 检测回放：用合成日志/pcap 回放行为，验证规则、告警去重和响应手册。',
            'Lab 4 · 修复闭环：让开发者修复一个问题，再独立复测并确认没有旁路回归。',
            'Lab 5 · 复盘教学：提交证据链、风险评级、业务影响、缓解、恢复、限制和下一次演练计划。') }
        default { return @(
            "Lab 1 · 合成样本：创建与 [$title] 相关的无害日志/配置/教学样本，记录生成过程和哈希。",
            'Lab 2 · 分析路径：用静态/动态/时间线工具提取行为、IOC、上下文和不确定性。',
            'Lab 3 · 检测规则：写一条规则或查询，测试命中、误报、漏报和性能。',
            'Lab 4 · 处置演练：在自有隔离环境执行隔离、清理、恢复和回滚，保存每一步证据。',
            'Lab 5 · 宗师报告：按技术读者和管理者分别说明根因、影响、控制缺口、指标和后续投资。') }
    }
}

$out = [System.Collections.Generic.List[string]]::new()
$out.Add('# 方向 7 · 安全攻防与逆向：SEC1–SEC102 + W/B/C 专题补强')
$out.Add('')
$out.Add('> 这是白帽课程的逐课增补层。所有操作只针对自有代码、自己的虚拟机/容器、明确授权靶场或 CTF。严禁扫描/登录/抓取他人系统，严禁处理真实凭据，严禁部署恶意代码或编写可直接危害他人的成品。')
$out.Add('> 每课都要保存授权范围、实验时间窗、资产清单、命令/请求、日志或 pcap、文件哈希、修复回归、清理步骤和未验证项。')
$out.Add('> 资料锚点：OWASP Top 10、OWASP ASVS、NIST NICE、MITRE ATT&CK（仅作防御映射）、CWE、CVE/CVSS、各语言/平台安全文档。')
$out.Add('')
$out.Add('## 五级完成定义')
$out.Add('- Lv1：在隔离自有环境跑通无害最小样例。')
$out.Add('- Lv2：改变一个输入/配置，解释差异并保留证据。')
$out.Add('- Lv3：跨代码、日志、网络或配置完成综合验证。')
$out.Add('- Lv4：做修复、审计、检测或安全编译，并有指标和回归。')
$out.Add('- Lv5：完成授权范围内的原创研究/架构/教学/报告，说明边界与残余风险。')
$out.Add('')

foreach ($course in $courses) {
    $tick = [char]96
    $track = Get-Track $course.Id $course.Title
    $focus = Get-Focus $track $course.Title
    $labs = Get-Labs $track $course.Title
    $out.Add("## $($course.Id) · $($course.Title)")
    $out.Add('')
    $out.Add("- 原课文件：${tick}$($course.File)${tick}")
    $out.Add("- 轨道：$track")
    $out.Add('- 深挖问题：')
    foreach ($q in $focus) { $out.Add("  - $q") }
    $out.Add('- 闯关交付：')
    $out.Add("  - Lv1：${tick}$($course.Id)/lv1${tick} 最小样例、范围和输出。")
    $out.Add("  - Lv2：${tick}$($course.Id)/lv2${tick} 单变量变体、差异、失败解释。")
    $out.Add("  - Lv3：${tick}$($course.Id)/lv3${tick} 综合测试、日志/pcap、时间线和设计图。")
    $out.Add("  - Lv4：${tick}$($course.Id)/lv4${tick} 修复/检测/安全编译/审计报告，含基线和回归。")
    $out.Add("  - Lv5：${tick}$($course.Id)/lv5${tick} 研究或教学交付，含威胁模型、限制、残余风险和授权证明。")
    $out.Add('- 五个 Lab：')
    foreach ($lab in $labs) { $out.Add("  - $lab") }
    $out.Add('- 安全验收：未授权目标、真实凭据、真实个人数据和可直接危害他人的利用成品一律不得进入证据目录；实验结束撤销密钥、关闭服务、删除样本并保留最小必要日志。')
    $out.Add('')
}

$out.Add('## 方向 7 毕业工程')
$out.Add('')
$out.Add('建立一个完全隔离的防御实验室：本地 Web 应用、教学二进制、合成日志/pcap、规则仓库、漏洞修复分支和事件 Runbook。演示资产盘点、威胁建模、低风险复现、修复回归、检测告警、隔离恢复、报告披露和证据销毁；不连接真实目标、不使用真实凭据、不部署恶意持久化。')
$out.Add('')
$out.Add('## 权威资料锚点')
$out.Add('- [OWASP Top 10](https://owasp.org/www-project-top-ten/)')
$out.Add('- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)')
$out.Add('- [NIST NICE](https://www.nist.gov/itl/applied-cybersecurity/nice)')
$out.Add('- [MITRE ATT&CK](https://attack.mitre.org/)')
$out.Add('- [CWE](https://cwe.mitre.org/)')
$out.Add('- [CVE Program](https://www.cve.org/)')

$out | Set-Content -LiteralPath $Output -Encoding UTF8
Write-Output "Generated $($courses.Count) security cards -> $Output"
