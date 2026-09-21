param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [string]$Output = (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) '逐课补强卡_590课.md')
)

Set-StrictMode -Version Latest
$pattern = '^#{1,3}\s+((?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|SEC|MOB|DAT|OPS|PD)(?:-[A-Z]+)?\d*)\s*[· ]+(.+)$'
$records = @()
$fileOrder = @(
    '教案_预备层.md',
    '教案_方向1a_编程Python.md',
    '教案_方向1b_多语言_C_CPP_Java_JS_Go.md',
    '教案_方向1c_Rust_范式_SQL_Shell.md',
    '教案_方向2_算法与数据结构.md',
    '教案_方向3_底层系统.md',
    '教案_方向4_网络.md',
    '教案_方向5_数据库.md',
    '教案_方向6_Web全栈.md',
    '教案_方向7a_安全基础_Web安全.md',
    '教案_方向7b_二进制_漏洞利用_Hook.md',
    '教案_方向7c_恶意代码_渗透红队_CTFCERT_AIOT.md',
    '教案_方向8_移动桌面游戏嵌入式.md',
    '教案_方向9_数据AI.md',
    '教案_方向10_运维云SRE.md',
    '教案_方向11_产品设计软技能.md'
)
$files = foreach ($name in $fileOrder) {
    Get-Item -LiteralPath (Join-Path $Root $name) -ErrorAction SilentlyContinue
}

foreach ($file in $files) {
    foreach ($line in (Get-Content -LiteralPath $file.FullName)) {
        if ($line -match $pattern) {
            $records += [pscustomobject]@{
                Id = $matches[1].Trim()
                Title = $matches[2].Trim()
                File = $file.Name
            }
        }
    }
}

function Get-Family([string]$id) {
    if ($id -match '^SEC-W') { return '安全-Web专题' }
    if ($id -match '^SEC-B') { return '安全-二进制专题' }
    if ($id -match '^SEC-C') { return '安全-实战专题' }
    if ($id -match '^SEC') { return '安全与逆向' }
    if ($id -match '^PRE') { return '预备与环境' }
    if ($id -match '^(PY\d+|C\d+|CPP\d+|JV\d+|JS\d+|GO\d+|RS\d+|PAR\d+|OTH\d+|SQL\d+|SH\d+)$') { return '编程与语言' }
    if ($id -match '^(DSA)') { return '算法与数学' }
    if ($id -match '^(COMP|ASM|OS|CMP)') { return '计算机系统' }
    if ($id -match '^NET') { return '网络与分布式' }
    if ($id -match '^DB') { return '数据库与数据工程' }
    if ($id -match '^(FE|BE)') { return 'Web与产品工程' }
    if ($id -match '^MOB') { return '端侧与平台' }
    if ($id -match '^DAT') { return 'AI与数据科学' }
    if ($id -match '^OPS') { return '云原生与SRE' }
    if ($id -match '^PD') { return '产品与设计' }
    return '待分类'
}

function Get-CommandSet([string]$family) {
    switch -Regex ($family) {
        '^预备' { return @('Get-ChildItem -Force', 'python --version', 'code .', '保存截图与语音/文字说明') }
        '^编程' { return @('python -m pytest -q', 'git diff --check', 'gcc -Wall -Wextra -g', 'cargo test', 'go test ./...') }
        '^算法' { return @('python benchmark.py --n 1000', 'python -m pytest -q', 'git diff --check', '保存 CSV/JSON 基准结果', '绘制规模-时间曲线') }
        '^计算机系统' { return @('gcc -g -O0 lab.c -o lab', 'gdb ./lab', 'objdump -d ./lab', '保存寄存器/调用栈/日志', '记录故障注入与恢复') }
        '^网络' { return @('ipconfig /all', 'ping 127.0.0.1', 'curl -v http://127.0.0.1:8000', 'tshark -r capture.pcapng', '保存 pcapng 与过滤器') }
        '^数据库' { return @('sqlite3 lab.db', 'EXPLAIN QUERY PLAN ...', 'python -m pytest -q', '保存事务时间线', '记录备份/恢复校验和') }
        '^Web' { return @('npm test', 'curl -i http://127.0.0.1:8000', 'python -m pytest -q', '保存 Lighthouse/axe/压测结果', '记录部署与回滚命令') }
        '^安全' { return @('docker compose up -d', 'pytest -q', '保存请求/日志/时间线', '仅对本地授权靶场复现', '提交修复前后回归结果') }
        '^端侧' { return @('adb devices', 'adb logcat -d', '保存模拟器截图与崩溃日志', '记录权限/功耗测量', '记录签名与回滚步骤') }
        '^AI' { return @('python train.py --seed 42', 'python evaluate.py --split test', '保存 metrics.json', '记录模型/数据版本', '绘制误差与漂移曲线') }
        '^云原生' { return @('docker compose up -d', 'kubectl get pods', 'kubectl describe pod <pod>', 'curl http://127.0.0.1:PORT/health', '保存 trace/metric/log 与复盘') }
        '^产品' { return @('记录用户任务与假设', '提交原型链接或截图', '运行可访问性检查', '记录 5 位测试者反馈', '提交指标、决策与迭代日志') }
        default { return @('记录输入与输出', '保存最小复现', '运行自动化测试', '记录失败分支', '提交复盘') }
    }
}

function Get-SourceAnchors([string]$family, [string]$title) {
    if ($family -match '^AI') { return 'PyTorch Documentation；Hugging Face Course；NIST AI RMF；论文须记录版本与章节' }
    if ($family -match '^数据库') { return 'PostgreSQL Documentation；SQLite Documentation；CMU 15-445 Database Systems 课程资料' }
    if ($family -match '^网络') { return 'RFC 体系（TCP/IP/TLS/DNS/HTTP）；Wireshark User Guide；Computer Networking: A Top-Down Approach' }
    if ($family -match '^安全') { return 'OWASP ASVS/Top 10；NIST NICE；CWE/CVE/CVSS；MITRE ATT&CK（仅防御映射）' }
    if ($family -match '^计算机系统') { return 'OSTEP；Nand2Tetris；Intel/AMD Architecture Manuals 或 RISC-V ISA Specification' }
    if ($family -match '^算法') { return 'MIT 6.006 Introduction to Algorithms；CLRS 相关章节；USENIX/ACM 论文作为扩展阅读' }
    if ($family -match '^Web') { return 'MDN Web Docs；OWASP ASVS/Top 10；W3C/WCAG；OpenTelemetry Documentation' }
    if ($family -match '^云原生') { return 'Kubernetes Documentation；Docker Documentation；OpenTelemetry；Google SRE Book' }
    if ($family -match '^端侧') { return 'Android Developers / Apple Developer / Microsoft Learn；各平台安全与发布官方指南' }
    if ($family -match '^产品') { return 'W3C WCAG；Nielsen Norman Group；Material Design / Apple HIG；ISO 9241 相关原则' }
    if ($family -match '^预备') { return 'Microsoft Learn Windows 基础与无障碍文档；Git Documentation（版本控制基础）' }
    if ($family -match '^编程') { return 'Python/C++/Rust/Java/JavaScript/Go 官方语言文档；ISO/ECMA 标准或实现规范（按本课语言选择）' }
    if ($title -match 'Python|解释器|包|虚拟环境|asyncio') { return 'Python 3 Tutorial（官方，数据结构/模块/异步章节）；Python Language Reference（语义与数据模型）' }
    if ($title -match 'Rust|所有权|借用|生命周期|trait|async') { return 'The Rust Programming Language（官方，Ownership/Traits/Async）；Rust Reference（语言语义）' }
    if ($title -match 'C\+\+|模板|STL|智能指针|移动语义') { return 'cppreference（语言与标准库）；C++ Core Guidelines（资源与并发）' }
    if ($title -match 'Java|JVM|GC|JUC|字节码') { return 'Dev.java Learn（官方）；Java Virtual Machine Specification（类文件/运行时）' }
    if ($title -match 'JavaScript|DOM|Promise|Node|事件循环|TypeScript') { return 'MDN Web Docs（JavaScript/DOM/网络）；Node.js Documentation（运行时）' }
    if ($title -match 'Go|goroutine|channel|net/http') { return 'A Tour of Go（官方）；Go Memory Model 与标准库文档' }
    if ($title -match 'SQL|Shell|Bash|PowerShell|正则|管道') { return 'PostgreSQL Documentation 或 SQLite Documentation；GNU Bash Reference / Microsoft Learn PowerShell' }
    return '优先使用该主题的一手官方文档；记录页面标题、版本、访问日期和未验证项'
}

function Get-FailureCase([string]$family, [string]$title) {
    if ($title -match 'TCP|UDP|QUIC|HTTP|TLS|DNS|路由|网络') { return '失败实验：仅在本机/隔离网络制造超时、端口关闭、DNS 错误或丢包，绑定命令输出/pcap 与恢复步骤。' }
    if ($title -match '数据库|SQL|事务|索引|WAL|复制|分片') { return '失败实验：仅在本地数据库制造约束冲突、锁等待、崩溃恢复或统计信息偏差，保存时间线、日志和回滚证据。' }
    if ($title -match '安全|漏洞|认证|授权|注入|逆向|恶意') { return '失败实验：只在自有代码或授权靶场制造一个无害拒绝路径，记录授权范围、请求/日志、修复和回归，不保存真实凭据。' }
    if ($title -match 'AI|模型|神经|训练|数据') { return '失败实验：用合成数据制造过拟合、数据泄漏、漂移或评估集污染，保存随机种子、指标、模型/数据版本和修复对照。' }
    if ($title -match '进程|线程|内存|编译|汇编|CPU|缓存|内核|文件系统') { return '失败实验：在隔离程序中制造可恢复的错误码、竞态、缺页、崩溃或 ABI 差异，使用调试器/系统工具留证并清理。' }
    if ($family -match '^产品') { return '失败实验：用合成用户和原型制造空状态、慢响应、键盘操作或低对比度问题，记录可访问性/任务成功率变化。' }
    return '失败实验：改变一个输入或环境条件制造可恢复失败，记录“现象→假设→证据→修复→回归→清理”。'
}

function Get-DeepQuestions([string]$family, [string]$title) {
    $q1 = "机制：$title 的状态、数据结构或调用链是什么？"
    $q2 = "边界：在什么输入、规模、版本或故障下，直觉会失效？"
    $q3 = "取舍：正确性、性能、安全、可维护性和成本之间如何权衡？"
    if ($family -match '^网络') {
        return @('协议字段：一次请求如何封装、传输、确认、重试或结束？','故障：丢包、乱序、超时、缓存或中间盒改变结果时如何定位？',$q3)
    }
    if ($family -match '^数据库') {
        return @('执行路径：解析、优化、算子、锁/MVCC、日志和存储如何串起来？','故障：崩溃、死锁、热点、统计信息错误或副本延迟时会怎样？',$q3)
    }
    if ($family -match '^安全') {
        return @('信任边界：输入如何到达危险汇点，控制措施在哪一层生效？','证据：如何在自有代码/授权靶场中复现、修复并做回归？',$q3)
    }
    if ($family -match '^AI') {
        return @('数学与数据：目标函数、梯度、数据切分和评估指标如何决定结果？','失效：分布漂移、泄漏、过拟合、提示注入或成本约束如何暴露？',$q3)
    }
    if ($family -match '^计算机系统') {
        return @('跨层链路：源代码如何变成指令、系统调用、内核路径和硬件事件？','故障：竞态、缺页、崩溃、缓存未命中或 ABI 不一致时如何取证？',$q3)
    }
    if ($family -match '^算法') {
        return @('模型与证明：输入、状态、不变量、正确性和复杂度如何写成可检验命题？','反例：最坏输入、重复值、空输入、溢出、随机性或规模变化会怎样？',$q3)
    }
    if ($family -match '^Web') {
        return @('浏览器/服务链路：请求如何经过 DOM、缓存、认证、业务、数据库和观测系统？','失效：慢网、窄屏、重复提交、权限错误、依赖故障或回滚时如何保证可用？',$q3)
    }
    if ($family -match '^产品') {
        return @('用户证据：问题、任务、约束和成功指标如何被观察与验证？','失效：错误状态、无障碍、隐私、认知负担或反馈偏差如何影响决策？',$q3)
    }
    if ($family -match '^预备') {
        return @('操作链路：用户动作如何经过界面、输入设备、操作系统事件和可观察结果？','恢复边界：路径错误、权限不足、版本差异、输入疲劳和备份失败时如何继续？',$q3)
    }
    if ($family -match '^编程') {
        return @('运行时链路：源码如何经过词法/语法、类型、运行时、内存和 I/O 形成结果？','边界：空值、编码、异常、资源耗尽、并发和版本/ABI 差异如何被测试发现？',$q3)
    }
    if ($family -match '^云原生') {
        return @('交付链路：代码如何经过构建、镜像、调度、网络、存储、观测和回滚？','故障：资源耗尽、配置漂移、依赖不可用、分区或部署半成品时如何恢复？',$q3)
    }
    if ($family -match '^端侧') {
        return @('平台链路：应用如何经过生命周期、沙箱、权限、设备 I/O、能耗和发布渠道？','边界：离线、低电量、崩溃、签名失效、升级中断和设备碎片化如何处理？',$q3)
    }
    switch -Regex ($title) {
        'TCP|UDP|QUIC|HTTP|TLS|DNS|路由|抓包|BGP' { $q1 = "协议字段：一次请求如何封装、传输、确认、重试或结束？"; $q2 = "故障：丢包、乱序、超时、缓存或中间盒改变结果时如何定位？" }
        '数据库|SQL|事务|索引|WAL|复制|分片|缓存' { $q1 = "执行路径：解析、优化、算子、锁/MVCC、日志和存储如何串起来？"; $q2 = "故障：崩溃、死锁、热点、统计信息错误或副本延迟时会怎样？" }
        'XSS|注入|认证|授权|JWT|OAuth|漏洞|逆向|渗透|恶意|取证' { $q1 = "信任边界：输入如何到达危险汇点，控制措施在哪一层生效？"; $q2 = "证据：如何在自有代码/授权靶场中复现、修复并做回归？" }
        'AI|模型|神经|Transformer|学习|特征' { $q1 = "数学与数据：目标函数、梯度、数据切分和评估指标如何决定结果？"; $q2 = "失效：分布漂移、泄漏、过拟合、提示注入或成本约束如何暴露？" }
        '进程|线程|内存|文件系统|编译|汇编|CPU|缓存|内核' { $q1 = "跨层链路：源代码如何变成指令、系统调用、内核路径和硬件事件？"; $q2 = "故障：竞态、缺页、崩溃、缓存未命中或 ABI 不一致时如何取证？" }
        '产品|设计|用户|交互|需求|项目' { $q1 = "用户证据：问题、任务、约束和成功指标如何被观察与验证？"; $q2 = "失效：错误状态、无障碍、隐私、认知负担或反馈偏差如何影响决策？" }
    }
    return @($q1, $q2, $q3)
}

function Get-Labs([string]$family, [string]$title, [string[]]$commands) {
    $tick = [char]96
    $c0 = $commands[0]
    $c1 = $commands[1]
    $c2 = $commands[2]
    return @(
        "Lab A · 最小闭环：围绕 [$title] 运行一个最小例子；命令骨架：${tick}$c0${tick}；保存原始输出、环境版本和清理步骤。验收：结果可重复。",
        "Lab B · 受控变体：只改变一个输入、参数或版本，运行 ${tick}$c1${tick}；写出变更前后差异和一个解释。验收：变体测试通过。",
        "Lab C · 跨课综合：把本课与一个前置课连接，运行 ${tick}$c2${tick}；加入失败分支、日志和自动化测试。验收：失败会被测试捕获。",
        "Lab D · 造轮子/审计：不调用目标框架的核心黑盒功能，手写最小机制或审计自有样例；记录至少一个性能、安全或可靠性指标。验收：报告包含基线、方法、结果、限制。",
        "Lab E · 开放研究：提出一个可证伪假设，设计对照实验，保存数据/代码/版本/随机种子；用 200–500 字解释反例和下一步。验收：他人按 README 能复现。"
    )
}

$out = [System.Collections.Generic.List[string]]::new()
$out.Add('# 逐课补强卡（590 个可识别课/专题标题）')
$out.Add('')
$out.Add('> 生成时间：2026-09-09。来源：16 份当前教案文件；旧版归档、总索引、总纲和本文件自身不参与扫描。')
$out.Add('> 用法：先读原课的 11 段正文，再完成本卡的深挖问题、Lv1–Lv5 和 5 个 Lab。命令是骨架，须在自己的项目/隔离环境中替换路径和端口。')
$out.Add('> 安全：涉及网络、安全、逆向、恶意代码的实验只允许自有代码、自己的虚拟机、明确授权靶场或 CTF；不扫描、不登录、不抓取、不处理真实凭据。')
$out.Add('')
$out.Add('## 质量门')
$out.Add('每张卡必须留下 `evidence/<课号>/README.md`、`commands.txt`、`tests/`、`artifacts/`、`notes.md`；README 写环境、日期、版本、已知限制和清理方式。Lv5 不是“看完”，而是可复现的设计、研究、教学或审计交付。')
$out.Add('')

foreach ($record in $records) {
    $tick = [char]96
    $family = Get-Family $record.Id
    $commands = Get-CommandSet $family
    $questions = Get-DeepQuestions $family $record.Title
    $labs = Get-Labs $family $record.Title $commands
    $sources = Get-SourceAnchors $family $record.Title
    $failure = Get-FailureCase $family $record.Title
    $out.Add("## $($record.Id) · $($record.Title)")
    $out.Add('')
    $out.Add("- 原课文件：${tick}$($record.File)${tick}")
    $out.Add("- 归属宏域：$family")
    $out.Add("- 资料锚点：$sources")
    $out.Add('- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项；一手官方文档优先，论文只作为可复现实验的补充。')
    $out.Add('- 深挖问题：')
    foreach ($q in $questions) { $out.Add("  - $q") }
    $out.Add('- 闯关路线：')
    $out.Add("  - Lv1 新手村：按原课动手层跑通最小闭环；交 ${tick}$($record.Id)/lv1${tick} 的输出、截图或测试。")
    $out.Add("  - Lv2 熟练工：修改一个参数/输入/需求并解释差异；交 ${tick}$($record.Id)/lv2${tick} 的变体和对比。")
    $out.Add("  - Lv3 进阶者：连接一个前置课完成综合任务；交 ${tick}$($record.Id)/lv3${tick} 的自动化测试、日志和设计图。")
    $out.Add("  - Lv4 高手：手写核心机制或完成基准/审计；交 ${tick}$($record.Id)/lv4${tick} 的基线、指标、根因和限制。")
    $out.Add("  - Lv5 宗师：提出开放问题并教会别人；交 ${tick}$($record.Id)/lv5${tick} 的论文式笔记、ADR、复现实验或授权靶场报告。")
    $out.Add('- 实战 Lab：')
    foreach ($lab in $labs) { $out.Add("  - $lab") }
    $out.Add("- 必做失败实验：$failure")
    $out.Add("- 推荐命令骨架：$tick$($commands -join "${tick}、${tick}")$tick")
    $out.Add('- 安全与验收：确认资产属于自己或已获书面授权；实验结束关闭服务、删除临时凭据、保存证据链。通过条件是 5 关均有证据、至少 5 个 Lab 中 4 个可复现、未验证项已明确记录。')
    $out.Add('')
}

$out | Set-Content -LiteralPath $Output -Encoding UTF8
Write-Output "Generated $($records.Count) cards -> $Output"
