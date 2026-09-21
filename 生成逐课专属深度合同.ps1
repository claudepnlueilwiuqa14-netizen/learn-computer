param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-Category([string]$id) {
    if ($id -match '^PRE') { return 'prep' }
    if ($id -match '^PY') { return 'python' }
    if ($id -eq 'PAR7' -or $id -match '^(C\d|CPP|JV|JS|GO)') { return 'language' }
    if ($id -match '^(RS|PAR|OTH|SQL|SH)') { return 'paradigm' }
    if ($id -match '^DSA') { return 'algorithm' }
    if ($id -match '^(COMP|ASM|OS|CMP)') { return 'system' }
    if ($id -match '^NET') { return 'network' }
    if ($id -match '^DB') { return 'database' }
    if ($id -match '^(FE|BE)') { return 'web' }
    if ($id -match '^SEC') { return 'security' }
    if ($id -match '^MOB') { return 'mobile' }
    if ($id -match '^DAT') { return 'ai' }
    if ($id -match '^OPS') { return 'ops' }
    if ($id -match '^PD') { return 'product' }
    throw "unknown course id: $id"
}

$profiles = @{
    prep = @{
        Mechanism = '输入设备/文件系统/进程/解释器之间的可观察事件链'
        Invariant = '每一步都有可观察输入、输出、错误边界和可恢复清理动作'
        Metric = '步骤耗时、失败恢复时间、命令退出码、文件哈希'
        Failure = '路径不存在、权限拒绝、编码变化或进程中断'
        Source = 'Microsoft Learn Windows 基础与无障碍；Python 3 Tutorial'
        Url = 'https://learn.microsoft.com/powershell/ ; https://docs.python.org/3/tutorial/'
        Complexity = '把生活类比拆成状态、事件、数据和边界，不能只复述操作步骤'
    }
    python = @{
        Mechanism = 'Python 数据模型、调用栈、异常传播、模块导入和标准库组合'
        Invariant = '输入契约、异常类型、资源生命周期和重复运行幂等性明确'
        Metric = 'P50/P95 执行时间、峰值内存、测试覆盖的边界类别、错误率'
        Failure = '空值/非法类型/Unicode/只读路径/部分写入'
        Source = 'Python Language Reference：数据模型、执行模型、导入系统'
        Url = 'https://docs.python.org/3/reference/'
        Complexity = '同时解释语义、运行时对象和工程可复现性，不把语法熟练当成掌握'
    }
    language = @{
        Mechanism = '类型系统、内存/所有权模型、错误模型、构建器与运行时之间的契约'
        Invariant = '警告不被静默、资源有唯一责任、跨语言协议的字节和错误语义一致'
        Metric = '编译诊断数量、P50/P95、峰值内存、二进制/包体哈希、竞态或 sanitizer 结果'
        Failure = '最小非法程序、边界字节、并发竞态、ABI/版本不匹配'
        Source = '对应语言的官方规范、教程和工具链文档'
        Url = 'https://isocpp.github.io/CppCoreGuidelines/ ; https://doc.rust-lang.org/book/ ; https://go.dev/ref/mem ; https://dev.java/learn/ ; https://developer.mozilla.org/en-US/docs/Web/JavaScript'
        Complexity = '用两个语言实现同一协议，并把差异归因到语义而非表面语法'
    }
    paradigm = @{
        Mechanism = '范式约束、组合子、不可变数据、声明式查询或 Shell 管道的数据流'
        Invariant = '组合前后保持类型/数据不变量，副作用边界和失败传播可定位'
        Metric = '组合深度、分配次数、查询/管道耗时、失败定位时间、重复运行差异'
        Failure = '空管道、短路、部分失败、非终止输入或副作用重复'
        Source = 'Rust Reference、Python Language Reference、PostgreSQL 与 GNU Bash 官方文档'
        Url = 'https://doc.rust-lang.org/reference/ ; https://www.postgresql.org/docs/current/ ; https://www.gnu.org/software/bash/manual/'
        Complexity = '从等价变换、求值策略和副作用追到运行时，而不止写出一段风格化代码'
    }
    algorithm = @{
        Mechanism = '抽象数据结构、状态转移、循环不变量、复杂度和输入分布'
        Invariant = '每次更新保持数据结构不变量，证明前提与反例边界写在一起'
        Metric = '操作计数、P50/P95、峰值内存、规模增长曲线、性质测试反例大小'
        Failure = '空/重复/极值/最坏分布、错误指针或被破坏的不变量'
        Source = 'MIT 6.006 Introduction to Algorithms；MIT Mathematics for Computer Science'
        Url = 'https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/ ; https://courses.csail.mit.edu/6.042/spring18/'
        Complexity = '同时交实现、证明、反例和基准，禁止用一次跑分替代渐进分析'
    }
    system = @{
        Mechanism = '源码、ABI、汇编、链接、装载、系统调用、调度和持久化的跨层链路'
        Invariant = '调用约定、内存所有权、并发顺序或崩溃后持久化不变量可被观测'
        Metric = '指令数、系统调用数、上下文切换、缺页、吞吐、尾延迟、RPO/RTO'
        Failure = '链接/ABI 错误、竞态、越界、缺页压力、进程崩溃或写入中断'
        Source = 'OSTEP；Nand2Tetris；xv6；RISC-V ISA Specifications'
        Url = 'https://pages.cs.wisc.edu/~remzi/OSTEP/ ; https://www.nand2tetris.org/ ; https://pdos.csail.mit.edu/6.1810/ ; https://riscv.org/technical/specifications/'
        Complexity = '至少跨越两个层次解释同一个现象，并把测量事实与推断分开'
    }
    network = @{
        Mechanism = '协议状态机、报文字段、超时/重传、缓存和故障域'
        Invariant = '请求关联到正确响应，状态转换、序列/版本和超时语义不被猜测替代'
        Metric = 'P50/P95/P99、吞吐、重传/错误率、连接数、恢复时间和抓包帧证据'
        Failure = '超时、端口关闭、重复请求、乱序/丢包、错误证书或 DNS 缓存'
        Source = 'IETF RFC、Wireshark User Guide 和对应协议官方文档'
        Url = 'https://www.rfc-editor.org/rfc/rfc9293 ; https://www.rfc-editor.org/rfc/rfc9000 ; https://www.rfc-editor.org/rfc/rfc8446 ; https://www.wireshark.org/docs/wsug_html/'
        Complexity = '从应用日志回到报文字段和规范条款，所有网络实验只绑定 127.0.0.1 或授权靶场'
    }
    database = @{
        Mechanism = '数据模型、执行器、索引、事务隔离、锁/MVCC、WAL 和恢复'
        Invariant = '约束、事务原子性、快照可见性、备份校验和迁移回滚保持一致'
        Metric = '查询计划、P50/P95、锁等待、冲突率、吞吐、备份大小、RPO/RTO'
        Failure = '约束冲突、死锁/锁超时、进程中断、损坏备份或迁移半途失败'
        Source = 'PostgreSQL Documentation；SQLite Documentation；CMU 15-445/645'
        Url = 'https://www.postgresql.org/docs/current/ ; https://www.sqlite.org/docs.html ; https://15445.courses.cs.cmu.edu/'
        Complexity = '把 SQL 表面行为连接到执行计划、并发控制和恢复日志，不只完成 CRUD'
    }
    web = @{
        Mechanism = '浏览器文档树、事件循环、HTTP 缓存、API 契约和用户任务状态'
        Invariant = '语义/焦点/权限/缓存/幂等契约在正常、错误和慢网条件下仍成立'
        Metric = 'LCP/INP/CLS、API P50/P95、错误率、键盘成功率、响应大小和缓存命中率'
        Failure = '键盘焦点丢失、错误 JSON、重复提交、缓存泄漏、超时或依赖不可用'
        Source = 'MDN Web Docs；W3C WCAG 2.2；OWASP ASVS'
        Url = 'https://developer.mozilla.org/en-US/docs/Web ; https://www.w3.org/TR/WCAG22/ ; https://owasp.org/www-project-application-security-verification-standard/'
        Complexity = '把用户目标、浏览器机制、服务端安全和可观测指标放进同一个可回滚闭环'
    }
    security = @{
        Mechanism = '资产/信任边界、输入验证、身份权限、检测证据和修复回归'
        Invariant = '测试只触达自有或授权目标，证据可哈希，拒绝路径不泄露敏感数据'
        Metric = '误报/漏报、检测延迟、修复回归通过率、证据完整性和残余风险'
        Failure = '越界输入、弱配置、伪造事件、日志缺失或修复造成兼容回归'
        Source = 'OWASP ASVS/Top 10/WSTG；NIST NICE 与 SP 800-61；CWE/CVSS'
        Url = 'https://owasp.org/www-project-application-security-verification-standard/ ; https://owasp.org/www-project-top-ten/ ; https://csrc.nist.gov/pubs/sp/800/61/r2/final ; https://cwe.mitre.org/'
        Complexity = '报告根因、可复现证据、修复和回滚，绝不把越权操作当成学习成果'
    }
    mobile = @{
        Mechanism = '平台生命周期、权限/沙箱、渲染帧、离线状态、功耗和发布签名'
        Invariant = '非法生命周期跃迁被拒绝，权限最小，离线和崩溃后数据可恢复'
        Metric = '冷/热启动、帧率、CPU/内存、离线成功率、崩溃恢复、功耗代理指标'
        Failure = '权限撤销、旋转/窗口变化、进程被杀、网络断开、签名或版本不匹配'
        Source = 'Android Developers；Apple Developer Documentation；Zephyr Project docs'
        Url = 'https://developer.android.com/ ; https://developer.apple.com/documentation/ ; https://docs.zephyrproject.org/'
        Complexity = '明确平台差异和未验证环节，不能把单一模拟器行为外推到所有设备'
    }
    ai = @{
        Mechanism = '数据契约、切分/泄漏、特征与模型、评估、漂移、推理服务和治理'
        Invariant = '数据/模型/代码/环境可追溯，评估集隔离，输入异常触发拒绝或降级'
        Metric = '质量指标与置信区间、P50/P95、峰值内存、漂移、校准、成本代理值'
        Failure = '标签错位、缺失/异常、分布漂移、评估污染、模型不可收敛或资源耗尽'
        Source = 'PyTorch Tutorials；NIST AI RMF 1.0 与 Generative AI Profile'
        Url = 'https://pytorch.org/tutorials/ ; https://www.nist.gov/itl/ai-risk-management-framework'
        Complexity = '每个结论必须同时有数据版本、模型配置、评估方法、反例和停止条件'
    }
    ops = @{
        Mechanism = '声明式资源、进程/容器、三信号观测、SLO/错误预算、供应链和灾备'
        Invariant = '配置幂等，健康检查先于流量，变更可回滚，观测数据不含敏感内容'
        Metric = '可用性、错误率、P95/P99、恢复时间、资源利用率、错误预算消耗和成本'
        Failure = '依赖关闭、配置错误、进程退出、资源上限、单节点不可用或制品不可信'
        Source = 'Kubernetes Concepts/Security；OpenTelemetry；Google SRE Books；Docker Docs'
        Url = 'https://kubernetes.io/docs/concepts/ ; https://opentelemetry.io/docs/ ; https://sre.google/books/ ; https://docs.docker.com/'
        Complexity = '以时间线和证据解释影响、恢复和长期修复，不能用“部署成功”替代可靠性'
    }
    product = @{
        Mechanism = '用户任务、信息架构、交互状态、研究证据、设计系统和交付协作'
        Invariant = '任务目标可观察，错误可恢复，组件状态一致，隐私和可访问性约束不被遗漏'
        Metric = '任务成功率、完成时间、错误率、可访问性检查通过率、转化/留存假设'
        Failure = '空状态、慢网、误操作、文案歧义、对比度/焦点回归或需求冲突'
        Source = 'W3C WCAG 2.2；NN/g 10 Usability Heuristics；Material Design'
        Url = 'https://www.w3.org/TR/WCAG22/ ; https://www.nngroup.com/articles/ten-usability-heuristics/ ; https://m3.material.io/'
        Complexity = '把用户研究、规格、实现约束、指标和停止/转向决策串成证据链'
    }
}

function Get-TopicPatch([string]$id, [string]$category, [string]$title) {
    $patch = @{}
    if ($category -eq 'language') {
        if ($title -match '(?i)函数式|不可变|高阶|范畴') { $patch['Mechanism']='代数数据类型/高阶函数、不可变状态、函子/单子式组合与副作用边界'; $patch['Invariant']='纯函数等价变换保持结果，副作用只在显式边界发生，惰性求值不会改变终止语义'; $patch['Metric']='分配次数、组合深度、短路/惰性触发次数、P50/P95'; $patch['Failure']='非终止流、空值、共享可变状态或副作用重复'; $patch['Source']='Python/Rust/Go/JavaScript 官方语言参考与函数式编程资料'; $patch['Url']='https://docs.python.org/3/reference/ ; https://doc.rust-lang.org/reference/ ; https://developer.mozilla.org/en-US/docs/Web/JavaScript' }
    }
    elseif ($category -eq 'network') {
        if ($title -match '(?i)TCP|传输') { $patch['Mechanism']='TCP 连接状态机、序列空间、确认/重传与拥塞控制边界'; $patch['Invariant']='同一连接的序列空间和确认推进满足规范，超时不会制造重复副作用'; $patch['Metric']='SYN/ACK/重传帧数、RTT、P95、cwnd 代理值'; $patch['Failure']='本地延迟、丢包模拟、半开连接或重复提交'; $patch['Source']='RFC 9293 TCP：状态机、段处理、规范性 MUST/SHOULD'; $patch['Url']='https://www.rfc-editor.org/rfc/rfc9293' }
        elseif ($title -match '(?i)DNS') { $patch['Mechanism']='DNS 委派、递归/权威角色、TTL 缓存和失败回答'; $patch['Invariant']='名称、类型、TTL 和缓存作用域一致，NXDOMAIN 与 SERVFAIL 不混淆'; $patch['Metric']='查询延迟、命中率、TTL 剩余时间、失败类别'; $patch['Failure']='本地假域名、TTL 变化、权威不可达或缓存污染样例'; $patch['Source']='RFC 1034/1035：域名空间、查询和响应'; $patch['Url']='https://www.rfc-editor.org/rfc/rfc1035' }
        elseif ($title -match '(?i)QUIC') { $patch['Mechanism']='QUIC 连接 ID、加密握手、独立流和迁移'; $patch['Invariant']='单流丢失不阻塞其他流，连接迁移不泄露未授权状态'; $patch['Metric']='握手 RTT、流级尾延迟、重传、迁移成功率'; $patch['Failure']='本地网络切换、单流延迟、握手失败'; $patch['Source']='RFC 9000：连接、流、错误和迁移'; $patch['Url']='https://www.rfc-editor.org/rfc/rfc9000' }
        elseif ($title -match '(?i)TLS|HTTPS') { $patch['Mechanism']='TLS 1.3 握手、密钥调度、证书验证和告警'; $patch['Invariant']='证书/主机名/版本验证失败必须阻断，密钥材料不进入日志'; $patch['Metric']='握手耗时、协议版本、证书链结果、失败告警'; $patch['Failure']='本地自签名证书、过期证书、错误主机名'; $patch['Source']='RFC 8446 TLS 1.3：握手和密钥调度'; $patch['Url']='https://www.rfc-editor.org/rfc/rfc8446' }
        elseif ($title -match '(?i)BGP|路由') { $patch['Mechanism']='路径向量、策略选择、收敛和 RPKI 可信边界'; $patch['Invariant']='未授权前缀不进入模拟路由表，撤销后收敛时间可测'; $patch['Metric']='收敛时间、前缀数量、拒绝率、路径变化次数'; $patch['Failure']='本地模拟邻居断开、错误前缀或撤销'; $patch['Source']='IETF 路由安全资料与授权仿真环境'; $patch['Url']='https://www.rfc-editor.org/' }
        elseif ($title -match '(?i)抓包|Wireshark|tcpdump') { $patch['Mechanism']='pcap 时间戳、链路层/网络层/传输层字段和过滤语义'; $patch['Invariant']='每个结论能回指帧号/字段，pcap 只含自有回环流量'; $patch['Metric']='帧数、RTT、重传率、过滤命中数'; $patch['Failure']='过滤器写错、时间戳偏移或抓包不完整'; $patch['Source']='Wireshark User Guide：捕获、显示过滤器和统计'; $patch['Url']='https://www.wireshark.org/docs/wsug_html/' }
    }
    elseif ($category -eq 'database') {
        if ($title -match '(?i)事务|ACID|隔离') { $patch['Mechanism']='事务边界、快照可见性、隔离级别和序列化失败'; $patch['Invariant']='提交/回滚原子性成立，异常不会留下半成品'; $patch['Metric']='锁等待、冲突率、提交延迟、RPO/RTO'; $patch['Failure']='两个本地连接制造冲突、超时和进程中断'; $patch['Source']='PostgreSQL 18 Chapter 13：Concurrency Control 与 Transaction Isolation'; $patch['Url']='https://www.postgresql.org/docs/current/mvcc.html' }
        elseif ($title -match '(?i)索引|执行计划|优化') { $patch['Mechanism']='访问路径、选择性、统计信息、排序和代价估计'; $patch['Invariant']='优化前后结果集完全一致，计划变化有可重复输入'; $patch['Metric']='计划节点、实际行数、P50/P95、缓存命中'; $patch['Failure']='低选择性索引、统计信息过期或参数变化'; $patch['Source']='PostgreSQL Documentation：Indexes、Using EXPLAIN'; $patch['Url']='https://www.postgresql.org/docs/current/performance-tips.html' }
        elseif ($title -match '(?i)WAL|备份|恢复|复制') { $patch['Mechanism']='日志顺序、检查点、备份链、复制延迟和恢复目标'; $patch['Invariant']='恢复后约束和已提交数据一致，备份哈希与演练记录匹配'; $patch['Metric']='备份大小、复制延迟、RPO/RTO、恢复校验时间'; $patch['Failure']='备份截断、进程中断、延迟副本或错误恢复点'; $patch['Source']='PostgreSQL Documentation：WAL、Backup and Recovery、Replication'; $patch['Url']='https://www.postgresql.org/docs/current/backup.html' }
        elseif ($title -match '(?i)JOIN|窗口|SQL|范式|模型') { $patch['Mechanism']='关系代数、基数估计、函数依赖或窗口分区排序'; $patch['Invariant']='重写查询/规范化不改变语义，NULL 和重复行有明确定义'; $patch['Metric']='结果校验哈希、计划节点、行数、耗时'; $patch['Failure']='NULL、重复键、笛卡尔积或空分区'; $patch['Source']='PostgreSQL Documentation：SQL Language 与 Query Planning'; $patch['Url']='https://www.postgresql.org/docs/current/sql.html' }
    }
    elseif ($category -eq 'web') {
        if ($title -match '(?i)缓存|Cache') { $patch['Mechanism']='私有/共享缓存、fresh/stale、Vary、验证和请求合并'; $patch['Invariant']='个性化响应不会泄露到共享缓存，验证器命中时实体一致'; $patch['Metric']='命中率、Age、304 比例、响应大小、P95'; $patch['Failure']='错误 Vary、过期响应、重复请求或个性化数据缓存'; $patch['Source']='MDN HTTP caching：Types、Fresh and stale、Vary、Validation'; $patch['Url']='https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Caching' }
        elseif ($title -match '(?i)可访问|a11y|WCAG|语义|HTML') { $patch['Mechanism']='语义树、标签关联、焦点顺序、键盘操作和辅助技术接口'; $patch['Invariant']='不依赖颜色/鼠标也能完成任务，错误与焦点可定位'; $patch['Metric']='键盘成功率、焦点路径、对比度、自动检查和人工检查差异'; $patch['Failure']='缺 label、焦点陷阱、窄屏溢出或动态内容未播报'; $patch['Source']='W3C WCAG 2.2：Perceivable、Operable、Understandable、Robust'; $patch['Url']='https://www.w3.org/TR/WCAG22/' }
        elseif ($title -match '(?i)认证|授权|会话|API|后端|安全') { $patch['Mechanism']='身份、会话、授权、输入校验、幂等键和错误契约'; $patch['Invariant']='每次副作用都绑定授权和幂等语义，错误响应不泄露内部细节'; $patch['Metric']='4xx/5xx、重复副作用数、P95、审计事件完整率'; $patch['Failure']='过期会话、重复请求、非法 JSON、依赖超时'; $patch['Source']='OWASP ASVS：Authentication、Session、Validation、API'; $patch['Url']='https://owasp.org/www-project-application-security-verification-standard/' }
        elseif ($title -match '(?i)性能|浏览器|事件循环|JavaScript') { $patch['Mechanism']='任务队列、渲染关键路径、资源优先级和长任务'; $patch['Invariant']='用户输入不会被无限长任务饿死，错误路径不阻塞渲染'; $patch['Metric']='LCP/INP/CLS、长任务数、资源大小和 P95'; $patch['Failure']='慢网、长任务、超长文本或第三方资源不可用'; $patch['Source']='MDN Web Docs 与 web.dev Performance（受限时以 MDN 为替代）'; $patch['Url']='https://developer.mozilla.org/en-US/docs/Web/Performance' }
    }
    elseif ($category -eq 'ai') {
        if ($title -match '(?i)数据|ETL|特征|治理|血缘') { $patch['Mechanism']='schema、数据血缘、切分、质量规则和版本哈希'; $patch['Invariant']='训练/验证/测试隔离，无标签泄漏，坏数据阻断流水线'; $patch['Metric']='缺失率、重复率、漂移 PSI/分布差异、处理吞吐'; $patch['Failure']='标签错位、重复、缺失、时间穿越或污染评估集'; $patch['Source']='NIST AI RMF：Govern、Map、Measure、Manage；数据卡实践'; $patch['Url']='https://www.nist.gov/itl/ai-risk-management-framework' }
        elseif ($title -match '(?i)回归|分类|聚类|树|ML|机器学习') { $patch['Mechanism']='损失函数、梯度/分裂准则、正则化、校准和数据分布'; $patch['Invariant']='固定种子和配置可复现，指标与基线比较而非孤立报数'; $patch['Metric']='训练/验证曲线、置信区间、P50/P95 推理延迟、MSE/F1 等'; $patch['Failure']='不收敛、类别不平衡、过拟合或分布外输入'; $patch['Source']='PyTorch Tutorials 与统计学习教材；指标需写明适用前提'; $patch['Url']='https://pytorch.org/tutorials/beginner/basics/intro.html' }
        elseif ($title -match '(?i)Transformer|LLM|生成|提示|RAG|Agent|文本') { $patch['Mechanism']='token 化、注意力/上下文、检索证据、工具边界和评估集'; $patch['Invariant']='输出可追溯到输入/版本，工具调用最小权限，提示注入进入拒绝路径'; $patch['Metric']='忠实度/召回、拒答率、token 数、P95、成本代理值'; $patch['Failure']='上下文截断、检索为空、提示注入或工具超时'; $patch['Source']='NIST AI RMF Generative AI Profile；Hugging Face Course（超时时以官方仓库/文档替代）'; $patch['Url']='https://www.nist.gov/itl/ai-risk-management-framework ; https://huggingface.co/learn/nlp-course' }
        elseif ($title -match '(?i)SHAP|解释|公平|漂移|MLOps|部署') { $patch['Mechanism']='解释归因、漂移告警、模型/数据/代码制品和回滚'; $patch['Invariant']='解释范围与模型版本一致，漂移触发可审计动作而非静默'; $patch['Metric']='归因稳定性、漂移阈值、模型版本、恢复时间和成本'; $patch['Failure']='特征缺失、版本不匹配、漂移误报或模型不可用'; $patch['Source']='NIST AI RMF 与 PyTorch 保存/加载、评估文档'; $patch['Url']='https://www.nist.gov/itl/ai-risk-management-framework ; https://pytorch.org/tutorials/' }
    }
    elseif ($category -eq 'ops') {
        if ($title -match '(?i)Kubernetes|K8s|Pod|调度|存储|网络策略') { $patch['Mechanism']='声明式对象、控制器收敛、Pod/Service、调度、策略和存储生命周期'; $patch['Invariant']='期望状态与实际状态差异可解释，探针通过前才接收流量'; $patch['Metric']='收敛时间、重启数、P95、资源利用率、策略拒绝数'; $patch['Failure']='镜像错误、探针失败、节点不可用、权限拒绝或卷挂载失败'; $patch['Source']='Kubernetes Concepts/Security：Workloads、Networking、Storage、Policies'; $patch['Url']='https://kubernetes.io/docs/concepts/' }
        elseif ($title -match '(?i)观测|OpenTelemetry|日志|指标|Tracing|追踪') { $patch['Mechanism']='traces、metrics、logs 的关联、语义约定、采样和 Collector 管道'; $patch['Invariant']='correlation id 跨边界不丢失，观测数据不含敏感值'; $patch['Metric']='端到端 trace 延迟、采样率、丢失率、告警准确率'; $patch['Failure']='采集器不可用、时钟偏移、采样过度或敏感字段进入日志'; $patch['Source']='OpenTelemetry Documentation：Observability primer、semantic conventions、Collector'; $patch['Url']='https://opentelemetry.io/docs/' }
        elseif ($title -match '(?i)SLO|SRE|事故|故障|灾备|容量') { $patch['Mechanism']='SLO/SLI、错误预算、故障域、时间线、恢复和容量模型'; $patch['Invariant']='告警对应用户影响，恢复动作可回滚，复盘区分事实与假设'; $patch['Metric']='可用性、错误预算消耗、MTTD/MTTR、P95/P99、RPO/RTO'; $patch['Failure']='依赖降级、单节点故障、资源耗尽或错误告警'; $patch['Source']='Google SRE Books：SLO、Error Budget、Incident Response、Capacity'; $patch['Url']='https://sre.google/books/' }
        elseif ($title -match '(?i)Docker|容器|镜像|CI|CD|供应链|Terraform|IaC') { $patch['Mechanism']='制品不可变性、构建缓存、签名/SBOM、声明式变更和回滚'; $patch['Invariant']='同一输入得到可校验制品，未签名/不匹配版本不得发布'; $patch['Metric']='构建时间、镜像大小、漏洞/策略命中数、部署和回滚耗时'; $patch['Failure']='依赖不可达、层缓存污染、签名失败或半成品发布'; $patch['Source']='Docker Docs、Kubernetes Security 与供应链实践'; $patch['Url']='https://docs.docker.com/ ; https://kubernetes.io/docs/concepts/security/' }
    }
    elseif ($category -eq 'security') {
        if ($title -match '(?i)Web|XSS|SQLi|SSRF|CSRF|注入|OWASP') { $patch['Mechanism']='输入到解释器/浏览器/网络请求的信任边界、编码和授权上下文'; $patch['Invariant']='恶意样例只在自有靶场拒绝，修复后正常输入不回归'; $patch['Metric']='检测延迟、误报/漏报、修复回归、响应状态和日志完整性'; $patch['Failure']='编码绕过、空值、重复参数、重定向或依赖不可用'; $patch['Source']='OWASP WSTG/ASVS/Top 10：风险、验证和修复'; $patch['Url']='https://owasp.org/www-project-web-security-testing-guide/ ; https://owasp.org/www-project-application-security-verification-standard/' }
        elseif ($title -match '(?i)二进制|汇编|逆向|漏洞|内存|Hook') { $patch['Mechanism']='调用约定、内存布局、控制流、符号/调试信息和安全缓解'; $patch['Invariant']='只分析自有或授权样本，输入边界触发后进程可控退出'; $patch['Metric']='崩溃复现率、覆盖路径、栈/寄存器证据、修复回归'; $patch['Failure']='越界、格式异常、栈破坏或符号缺失'; $patch['Source']='自有样本 + DWARF、xv6/Nand2Tetris、CWE 条目'; $patch['Url']='https://dwarfstd.org/ ; https://cwe.mitre.org/' }
        elseif ($title -match '(?i)取证|响应|SOC|检测|威胁|恶意') { $patch['Mechanism']='资产清单、事件时间线、证据哈希、检测规则和响应决策'; $patch['Invariant']='证据链可验证且脱敏，未授权目标触发停止条件'; $patch['Metric']='时间线完整率、检测延迟、误报/漏报、恢复时间'; $patch['Failure']='日志缺口、时钟偏移、伪造事件或凭据样例误入证据'; $patch['Source']='NIST SP 800-61、NIST NICE、MITRE ATT&CK（检测映射）'; $patch['Url']='https://csrc.nist.gov/pubs/sp/800/61/r2/final ; https://www.nist.gov/itl/applied-cybersecurity/nice ; https://attack.mitre.org/' }
        elseif ($title -match '(?i)密码|身份|认证|密钥|加密') { $patch['Mechanism']='随机数、哈希/MAC/AEAD、密钥生命周期、身份和最小权限'; $patch['Invariant']='密钥不进日志/仓库，验证失败默认拒绝且重放不可成功'; $patch['Metric']='验证耗时、失败率、密钥轮换时间、重放拒绝率'; $patch['Failure']='弱随机、过期密钥、错误上下文或重放样例'; $patch['Source']='NIST/Crypto 官方规范与 OWASP ASVS Authentication/Cryptography'; $patch['Url']='https://owasp.org/www-project-application-security-verification-standard/' }
    }
    elseif ($category -eq 'system') {
        if ($title -match '(?i)编译|链接|汇编|指令|ISA|CPU') { $patch['Mechanism']='词法/语法到 IR、寄存器/栈、ABI、目标文件和链接重定位'; $patch['Invariant']='调用约定与符号解析一致，优化前后可观察语义不变'; $patch['Metric']='指令数、目标文件段、重定位数、编译/链接时间'; $patch['Failure']='未定义符号、ABI 不匹配、非法指令或优化改变调试假设'; $patch['Source']='Nand2Tetris、RISC-V ISA、DWARF 和编译器官方文档'; $patch['Url']='https://www.nand2tetris.org/ ; https://riscv.org/technical/specifications/ ; https://dwarfstd.org/' }
        elseif ($title -match '(?i)进程|线程|并发|调度|锁|内存|页|文件系统|持久化') { $patch['Mechanism']='地址空间、调度/同步、缓存/页表、文件系统日志和崩溃恢复'; $patch['Invariant']='并发顺序/所有权成立，崩溃后只暴露已提交状态'; $patch['Metric']='上下文切换、锁等待、缺页、吞吐、尾延迟、RPO/RTO'; $patch['Failure']='竞态、死锁、资源耗尽、断电/进程中断或损坏输入'; $patch['Source']='OSTEP、xv6 book/source、Nand2Tetris'; $patch['Url']='https://pages.cs.wisc.edu/~remzi/OSTEP/ ; https://pdos.csail.mit.edu/6.1810/' }
    }
    elseif ($category -eq 'algorithm') {
        if ($title -match '(?i)图|最短|流|并查|拓扑|网络') { $patch['Mechanism']='图表示、松弛/连通不变量、队列/堆和负权边界'; $patch['Invariant']='每次松弛或合并保持已知最优/连通性质，非法图被显式拒绝'; $patch['Metric']='边/点规模、松弛次数、P50/P95、峰值内存和反例规模'; $patch['Failure']='空图、重复边、负环、断开图或极端权重'; $patch['Source']='MIT 6.006 图算法讲义与作业'; $patch['Url']='https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/' }
        elseif ($title -match '(?i)排序|查找|哈希|树|堆|队列|栈') { $patch['Mechanism']='数据结构不变量、比较/哈希契约、分治和摊还成本'; $patch['Invariant']='操作前后结构合法，等价输入得到等价输出，哈希冲突不丢数据'; $patch['Metric']='比较/访问次数、P50/P95、峰值内存、冲突率'; $patch['Failure']='空/重复/极值键、最坏顺序或容量边界'; $patch['Source']='MIT 6.006 与 CP-Algorithms（实现对照）'; $patch['Url']='https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/ ; https://cp-algorithms.com/' }
        elseif ($title -match '(?i)动态|贪心|递归|复杂度|概率|证明|线性代数') { $patch['Mechanism']='状态转移/选择性质、递归树、概率模型或证明前提'; $patch['Invariant']='递推与基例覆盖定义域，证明前提和失效反例明确'; $patch['Metric']='状态数、递归深度、误差/置信区间、规模增长曲线'; $patch['Failure']='基例缺失、贪心反例、数值不稳定或概率假设不成立'; $patch['Source']='MIT Mathematics for Computer Science 与 MIT 6.006'; $patch['Url']='https://courses.csail.mit.edu/6.042/spring18/' }
    }
    elseif ($category -eq 'mobile') {
        if ($title -match '(?i)游戏|渲染|图形|帧') { $patch['Mechanism']='游戏循环、输入/更新/渲染时序、资源生命周期和碰撞状态'; $patch['Invariant']='固定时间步不因帧率改变，暂停/恢复不会重复副作用'; $patch['Metric']='FPS、帧时间 P95、内存、加载时间和崩溃恢复'; $patch['Failure']='低帧率、资源缺失、窗口切换或输入队列堆积'; $patch['Source']='平台图形/游戏官方文档；本地模拟器和自有资产'; $patch['Url']='https://developer.android.com/ ; https://developer.apple.com/documentation/' }
        elseif ($title -match '(?i)嵌入式|RTOS|传感|设备树|低功耗') { $patch['Mechanism']='中断/任务、设备树、驱动边界、采样和功耗状态'; $patch['Invariant']='中断处理短且可重入，设备断开时系统安全降级'; $patch['Metric']='响应延迟、采样丢失、CPU/内存、功耗代理、看门狗恢复'; $patch['Failure']='传感器缺失、总线错误、看门狗超时或睡眠唤醒失败'; $patch['Source']='Zephyr Project docs：RTOS、设备树、驱动和低功耗'; $patch['Url']='https://docs.zephyrproject.org/' }
        elseif ($title -match '(?i)权限|签名|OTA|发布|离线|崩溃') { $patch['Mechanism']='权限状态、沙箱存储、签名制品、版本迁移和离线队列'; $patch['Invariant']='权限默认拒绝，签名/版本不匹配阻断，离线重放幂等'; $patch['Metric']='启动/恢复时间、离线成功率、崩溃率、回滚时间'; $patch['Failure']='权限撤销、签名错误、迁移失败、网络断开或进程被杀'; $patch['Source']='Android Developers/Apple Developer 官方生命周期、签名和发布文档'; $patch['Url']='https://developer.android.com/ ; https://developer.apple.com/documentation/' }
    }
    elseif ($category -eq 'product') {
        if ($title -match '(?i)研究|访谈|指标|实验|需求') { $patch['Mechanism']='问题假设、任务脚本、观察记录、指标和决策闭环'; $patch['Invariant']='观察事实与解释分离，样本脱敏，停止/转向条件预先写出'; $patch['Metric']='任务成功率、完成时间、错误率、样本量和置信度'; $patch['Failure']='样本不足、诱导问题、指标冲突或需求不可实现'; $patch['Source']='NN/g 10 Usability Heuristics 与产品研究方法'; $patch['Url']='https://www.nngroup.com/articles/ten-usability-heuristics/' }
        elseif ($title -match '(?i)设计系统|组件|视觉|交互|可访问|原型') { $patch['Mechanism']='Token、组件状态、响应式布局、焦点和错误恢复'; $patch['Invariant']='状态不依赖颜色单独表达，组件在窄屏/键盘/错误条件保持一致'; $patch['Metric']='对比度、焦点路径、任务时间、组件复用率、缺陷数'; $patch['Failure']='空/加载/错误状态缺失、断点溢出或文案歧义'; $patch['Source']='W3C WCAG 2.2、Material Design、NN/g'; $patch['Url']='https://www.w3.org/TR/WCAG22/ ; https://m3.material.io/' }
    }
    if ($patch.Count -eq 0) {
        $fallback = $null
        if ($category -eq 'language') {
            if ($id -match '^C1$') { $fallback=@{Mechanism='C translation unit、main 入口、标准输出流与宿主 ABI 的最小闭环'; Invariant='main 返回码与 stdout 字节可预测，编译警告不被忽略'; Metric='预处理后行数、目标文件符号、退出码、stdout 字节数'; Failure='缺少 main、错误格式串、非零退出或链接器未定义符号'; Source='ISO C 语义参考与 GCC 文档：翻译阶段、main、标准 I/O'; Url='https://gcc.gnu.org/onlinedocs/'} }
            elseif ($id -match '^C2$') { $fallback=@{Mechanism='C 整数/浮点类型、对象表示、整数提升、对齐和别名规则'; Invariant='sizeof/alignof 与表示范围被实测，转换不静默截断或溢出'; Metric='sizeof/alignof、范围边界、编译诊断、序列化字节'; Failure='有符号溢出、窄化转换、未对齐访问或字节序误读'; Source='C 标准类型与对象表示；C23 cppreference 类型章节'; Url='https://en.cppreference.com/w/c/language/types'} }
            elseif ($id -match '^C3$') { $fallback=@{Mechanism='指针值、对象生命周期、间接访问、指针算术和有效性边界'; Invariant='每次解引用都指向存活对象且在边界内，释放后指针不再使用'; Metric='地址差、对齐、ASan 诊断、分配/释放计数'; Failure='空/悬空/越界指针、二次释放或严格别名冲突'; Source='C 指针、对象生命周期与 undefined behavior 参考'; Url='https://en.cppreference.com/w/c/language/pointer'} }
            elseif ($id -match '^C4$') { $fallback=@{Mechanism='数组到指针衰变、连续元素、NUL 终止字符串和边界复制'; Invariant='长度、容量和终止符一致，复制不会越过目标对象'; Metric='长度/容量、拷贝字节数、ASan 结果、缓存访问次数'; Failure='缺 NUL、截断、重叠 memcpy 或越界扫描'; Source='C 数组与字符串库规范；CERT STR 规则'; Url='https://en.cppreference.com/w/c/string/byte'} }
            elseif ($id -match '^C5$') { $fallback=@{Mechanism='结构体字段偏移、填充对齐、联合体共享存储和序列化布局'; Invariant='offsetof/sizeof 与 ABI 约定一致，联合体读取符合活动成员规则'; Metric='字段偏移、填充字节、结构体大小、序列化哈希'; Failure='跨编译器布局差异、未初始化填充或错误联合体解释'; Source='C object representation、struct/union 与 ABI 文档'; Url='https://en.cppreference.com/w/c/language/struct'} }
            elseif ($id -match '^C6$') { $fallback=@{Mechanism='预处理 token 流、宏展开、条件编译和 include 依赖图'; Invariant='宏参数只求值一次的约束被显式处理，展开结果可审计'; Metric='预处理输出行数、宏展开次数、依赖文件数、构建时间'; Failure='宏副作用、名称捕获、缺少括号或条件分支漂移'; Source='GCC Preprocessor 文档与 C translation phases'; Url='https://gcc.gnu.org/onlinedocs/cpp/'} }
            elseif ($id -match '^C7$') { $fallback=@{Mechanism='malloc 分配器元数据、对齐、生命周期、realloc 搬迁和所有权转移'; Invariant='每次成功分配恰好一次释放，失败路径不泄漏且旧指针仍有效或已替换'; Metric='分配/释放计数、峰值堆、碎片率、ASan/LSan 结果'; Failure='泄漏、UAF、double free、realloc 丢失原指针或整数溢出'; Source='C malloc/free 契约与 AddressSanitizer 文档'; Url='https://clang.llvm.org/docs/AddressSanitizer.html'} }
            elseif ($id -match '^C8$') { $fallback=@{Mechanism='FILE 流、文件描述符、缓冲区、偏移、短读写和错误码'; Invariant='打开的句柄最终关闭，返回字节数与文件偏移一致，部分写入可恢复'; Metric='read/write 次数、缓冲大小、偏移、fsync 耗时、错误码'; Failure='路径权限、短读写、文本/二进制模式差异或中断写入'; Source='C stdio 与 POSIX read/write 文档'; Url='https://pubs.opengroup.org/onlinepubs/9699919799/'} }
            elseif ($id -match '^C9$') { $fallback=@{Mechanism='位掩码、移位、补码、整数提升和寄存器级标志传播'; Invariant='掩码只修改目标位，移位计数与类型范围合法，结果可由位级断言复核'; Metric='位操作次数、分支数、指令数、边界输入通过率'; Failure='负数移位、移位越界、符号扩展或掩码优先级错误'; Source='C bitwise operators 与整数表示参考'; Url='https://en.cppreference.com/w/c/language/operator_arithmetic'} }
            elseif ($id -match '^C10$') { $fallback=@{Mechanism='函数指针类型、调用约定、回调表、闭包数据指针和间接分支'; Invariant='函数签名、调用约定和用户数据一致，空回调有明确策略'; Metric='间接调用次数、分支预测、回调延迟、崩溃率'; Failure='错误原型、悬空回调、竞态注销或间接调用到非代码地址'; Source='C function pointer 与 ABI calling convention 文档'; Url='https://en.cppreference.com/w/c/language/pointer'} }
            elseif ($id -match '^C11$') { $fallback=@{Mechanism='未定义行为的触发前提、可观察后果、编译器假设和 sanitizer 证据'; Invariant='实验只用自有最小样例，UB 与实现定义/未指定行为分开记录'; Metric='优化级别差异、UBSan/ASan 告警、输出分歧、最小反例长度'; Failure='有符号溢出、越界、UAF、数据竞争或错误格式串'; Source='C undefined behavior、SEI CERT 与 UBSan 文档'; Url='https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html'} }
            elseif ($id -match '^C12$') { $fallback=@{Mechanism='inline asm 约束、寄存器分配、clobber、volatile 和编译器内存模型'; Invariant='输入/输出约束与实际指令一致，clobber 完整且不破坏栈/ABI'; Metric='汇编指令数、寄存器分配、屏障前后重排、执行周期'; Failure='约束写错、缺 clobber、非便携指令或优化后语义改变'; Source='GCC Extended Asm 约束与 volatile 文档'; Url='https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html'} }
            elseif ($id -match '^C13$') { $fallback=@{Mechanism='预处理→编译→汇编→链接的构建图、依赖时间戳和可复现制品'; Invariant='增量构建只重建受影响节点，干净构建与增量构建产物可解释'; Metric='节点数、缓存命中、构建耗时、二进制哈希、依赖闭包'; Failure='隐式依赖、循环依赖、ABI 不匹配或脏构建假成功'; Source='GNU Make、CMake 和 reproducible builds 文档'; Url='https://cmake.org/cmake/help/latest/'} }
            elseif ($id -match '^C14$') { $fallback=@{Mechanism='边界检查、整数溢出防护、错误传播、资源清理和纵深防御'; Invariant='不可信输入先验证，失败默认拒绝，资源在所有路径释放'; Metric='拒绝率、覆盖边界数、静态告警、回归通过率'; Failure='检查遗漏、TOCTOU、错误码丢失或修复引入兼容回归'; Source='SEI CERT C Coding Standard 与 OWASP 输入验证'; Url='https://wiki.sei.cmu.edu/confluence/display/c'} }
            elseif ($id -match '^C15$') { $fallback=@{Mechanism='结构体布局、cache line、访问步长、预取和伪共享'; Invariant='布局变更不改变 ABI/语义，线程独占字段不跨 cache line 争用'; Metric='cache miss、吞吐、P95、结构体大小和 false-sharing 计数'; Failure='未对齐、跨行字段、错误 padding 或基准噪声误判'; Source='Linux perf cache-misses 与 C object layout 文档'; Url='https://perf.wiki.kernel.org/'} }
            elseif ($id -match '^C16$') { $fallback=@{Mechanism='静态/动态库符号表、重定位、导出可见性、加载路径和 ABI 版本'; Invariant='链接到预期符号版本，运行时库路径可追踪且不加载未授权制品'; Metric='符号数、重定位数、加载耗时、依赖闭包、制品哈希'; Failure='未定义符号、RPATH 污染、版本冲突或 PIC 缺失'; Source='ELF shared libraries、ld.so 和 GNU ld 文档'; Url='https://sourceware.org/binutils/docs/'} }
            elseif ($id -match '^CPP') { $fallback=@{Mechanism="C++ 资源/类型/模板语义中的「$($title)」：对象生命周期、异常安全、编译期实例化或并发内存序"; Invariant='RAII/所有权、异常安全级别、模板约束和内存序在边界路径保持明确'; Metric='编译时间、模板实例数、分配次数、sanitizer/TSAN 结果'; Failure='悬空引用、切片、异常泄漏、模板歧义或数据竞争'; Source='C++ Core Guidelines 与 cppreference 对应章节'; Url='https://isocpp.github.io/CppCoreGuidelines/'} }
            elseif ($id -match '^JV') { $fallback=@{Mechanism="JVM 字节码/对象/集合/并发语义中的「$($title)」：类加载、堆代、内存模型和构建制品"; Invariant='类型擦除/泛型约束、happens-before、异常传播和资源关闭可观测'; Metric='GC 暂停、堆峰值、线程数、JFR 事件、构建哈希'; Failure='类路径冲突、内存泄漏、死锁、未捕获异常或构建不可复现'; Source='Dev.java、Java Language Specification 与 JVM Specification'; Url='https://dev.java/learn/'} }
            elseif ($id -match '^JS') { $fallback=@{Mechanism="JavaScript 词法环境、原型、模块或事件循环中的「$($title)」：任务队列、微任务与对象引用"; Invariant='闭包捕获、Promise 状态、模块边界和 DOM 副作用顺序明确'; Metric='长任务数、微任务队列长度、内存快照、P95 延迟、bundle 哈希'; Failure='this 绑定、未处理拒绝、竞态更新、循环依赖或原型污染'; Source='ECMAScript 规范与 MDN JavaScript Guide'; Url='https://developer.mozilla.org/en-US/docs/Web/JavaScript'} }
            elseif ($id -match '^GO') { $fallback=@{Mechanism="Go 类型/接口/goroutine/runtime 语义中的「$($title)」：调度、channel 所有权与错误包装"; Invariant='goroutine 可退出，channel 关闭方向明确，错误链可判别，模块构建可复现'; Metric='goroutine 数、阻塞时间、竞态检测、基准 P95、二进制哈希'; Failure='泄漏、死锁、nil interface、竞态或模块版本漂移'; Source='Go Tour、Go Memory Model 与官方工具链文档'; Url='https://go.dev/ref/mem'} }
        }
        elseif ($category -eq 'paradigm') {
            if ($id -match '^RS') { $fallback=@{Mechanism="Rust 所有权/借用/trait/async/unsafe 语义中的「$($title)」：编译器证明与运行时边界"; Invariant='借用规则、Send/Sync、Pin/生命周期和 unsafe 前置条件可被编译器或测试验证'; Metric='编译诊断、分配次数、任务延迟、Miri/ASan/TSAN 结果'; Failure='悬空引用、数据竞争、Send/Sync 误判、取消不安全或 FFI ABI 错配'; Source='The Rust Programming Language、Rust Reference 与 Nomicon'; Url='https://doc.rust-lang.org/reference/'} }
            elseif ($id -match '^SQL') { $fallback=@{Mechanism="SQL 关系代数/优化器/事务语义中的「$($title)」：NULL、重复、快照和执行计划"; Invariant='重写不改变结果集，事务边界与 NULL/重复行语义显式'; Metric='计划节点、行数估计误差、锁等待、P95、结果哈希'; Failure='笛卡尔积、NULL 三值逻辑、死锁、N+1 或索引失效'; Source='PostgreSQL SQL、EXPLAIN 与 transaction 文档'; Url='https://www.postgresql.org/docs/current/'} }
            elseif ($id -match '^SH') { $fallback=@{Mechanism="Shell 进程/管道/退出码语义中的「$($title)」：字节流、引用、陷阱与幂等脚本"; Invariant='每个命令退出码被处理，管道错误不丢失，临时资源最终清理'; Metric='进程树、管道吞吐、退出码、重跑差异、脚本耗时'; Failure='未引用空格、set -e 陷阱、SIGPIPE、临时文件泄漏或 glob 误匹配'; Source='GNU Bash Reference 与 ShellCheck 规则'; Url='https://www.gnu.org/software/bash/manual/'} }
            elseif ($id -match '^PAR') { $fallback=@{Mechanism="编程范式的约束/组合/副作用语义中的「$($title)」：用等价程序和反例验证设计取舍"; Invariant='组合前后保持值/类型不变量，副作用边界与求值顺序显式'; Metric='组合深度、分配、失败传播时间、重复运行差异'; Failure='共享可变状态、短路改变语义、非终止或重复副作用'; Source='对应语言规范与 SICP/范式研究资料'; Url='https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book.html'} }
            elseif ($id -match '^OTH') { $fallback=@{Mechanism="跨语言运行时/类型/构建语义中的「$($title)」：把同一协议实现并比较内存、错误和工具链"; Invariant='协议字节、错误分类和资源所有权跨实现一致'; Metric='编译/解释耗时、包体哈希、峰值内存、错误率'; Failure='ABI/版本不匹配、编码差异、资源泄漏或工具链缺失'; Source='该语言官方规范与包管理文档'; Url='https://www.ecma-international.org/publications-and-standards/standards/'} }
        }
        elseif ($category -eq 'algorithm') {
            if ($id -match '^DSA1$') { $fallback=@{Mechanism='渐进复杂度、摊还分析、递推和主定理的假设'; Invariant='计数模型、输入规模和最坏/平均分布先定义再比较'; Metric='基本操作计数、规模曲线、拟合误差、峰值栈深'; Failure='忽略常数、平均冒充最坏、递推基例缺失或输入分布错配'; Source='MIT 6.006 Lecture 1–3 与 6.042 证明基础'; Url='https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/'} }
            elseif ($id -match '^DSA(2|3|4|5|6|7|8|9|25)$') { $fallback=@{Mechanism="数据结构「$($title)」的表示、操作不变量、摊还成本和缓存行为"; Invariant='插入/删除/查询前后结构合法，等价输入结果一致，容量边界有定义'; Metric='比较/访问/旋转次数、P50/P95、峰值内存、反例规模'; Failure='空/重复/极值键、最坏顺序、容量耗尽或指针断链'; Source='MIT 6.006 数据结构讲义与 CP-Algorithms 实现对照'; Url='https://cp-algorithms.com/'} }
            elseif ($id -match '^DSA(10|11|12|13|20)$') { $fallback=@{Mechanism="图算法「$($title)」的图表示、队列/堆、松弛或连通性不变量"; Invariant='访问/合并/松弛不破坏已知最优或连通性质，负权/环边界显式'; Metric='点边数、松弛次数、队列峰值、P95、反例规模'; Failure='断开图、重复边、负环、溢出或拓扑环'; Source='MIT 6.006 Graph Algorithms 与作业'; Url='https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/'} }
            elseif ($id -match '^DSA(14|15|16|17|18|19|21|22|23|24)$') { $fallback=@{Mechanism="算法「$($title)」的状态空间/递推、证明前提、复杂度和最小反例"; Invariant='基例与状态转移覆盖定义域，证明前提和失效边界写入测试'; Metric='状态/比较次数、递归深度、误差/置信区间、规模曲线'; Failure='基例缺失、贪心反例、数值不稳定、剪枝错误或边界溢出'; Source='MIT 6.006、MIT 6.042 与性质测试资料'; Url='https://courses.csail.mit.edu/6.042/spring18/'} }
        }
        elseif ($category -eq 'prep') {
            $fallback=@{Mechanism="预备课「$($title)」的可观察人机事件链：动作、焦点、对象、权限、错误和恢复"; Invariant='每一步可复述、可观察、可撤销，资料和账号不被破坏'; Metric='步骤耗时、错误恢复时间、退出码、文件哈希、复述正确率'; Failure='路径不存在、权限拒绝、版本差异、编码或误操作'; Source='Microsoft Learn Windows/Python Tutorial 对应章节'; Url='https://learn.microsoft.com/'}
        }
        elseif ($category -eq 'web') {
            $fallback=@{Mechanism="Web 主题「$($title)」的浏览器/HTTP/用户任务闭环：状态、事件、契约、缓存和可访问性"; Invariant='语义、焦点、幂等、权限和错误状态在慢网/窄屏仍成立'; Metric='任务成功率、LCP/INP/CLS、API P95、错误率、焦点路径'; Failure='空/加载/错误状态遗漏、重复提交、焦点丢失、缓存泄漏或超时'; Source='MDN Web Docs、W3C WCAG 2.2 与 OWASP ASVS 对应章节'; Url='https://developer.mozilla.org/en-US/docs/Web'}
        }
        elseif ($category -eq 'network') {
            $fallback=@{Mechanism="网络主题「$($title)」的协议状态机、报文字段、计时器和故障域"; Invariant='请求与响应关联、序列/版本和超时语义可回指规范；重试不重复副作用'; Metric='RTT/P95/P99、字段/帧数、重传率、连接数、恢复时间'; Failure='超时、丢包、乱序、端口关闭、错误证书或 DNS 缓存'; Source='IETF RFC、Wireshark User Guide 与协议官方文档对应章节'; Url='https://www.rfc-editor.org/'}
        }
        elseif ($category -eq 'database') {
            $fallback=@{Mechanism="数据库主题「$($title)」的数据模型、执行器、并发控制、索引/日志和恢复闭环"; Invariant='约束、快照可见性、结果集和恢复后的已提交状态一致'; Metric='计划节点、行数估计、锁等待、P95、吞吐、RPO/RTO'; Failure='NULL/重复、锁超时、死锁、坏备份、迁移半途或 N+1'; Source='PostgreSQL、SQLite 和 CMU 15-445 对应章节'; Url='https://www.postgresql.org/docs/current/'}
        }
        elseif ($category -eq 'system') {
            $fallback=@{Mechanism="系统主题「$($title)」的源码→指令/系统调用→调度/内存/持久化跨层链路"; Invariant='ABI、所有权、并发顺序或崩溃后提交边界可观测且不被优化静默改变'; Metric='指令/系统调用、上下文切换、缺页、吞吐、尾延迟、RPO/RTO'; Failure='ABI/链接错误、竞态、越界、缺页压力、系统调用失败或写入中断'; Source='OSTEP、xv6、Nand2Tetris、RISC-V ISA 对应章节'; Url='https://pages.cs.wisc.edu/~remzi/OSTEP/'}
        }
        elseif ($category -eq 'security') {
            $fallback=@{Mechanism="安全主题「$($title)」的资产、信任边界、输入/权限路径、检测证据和修复回归"; Invariant='仅限自有/授权范围，拒绝路径默认安全，证据可哈希脱敏且修复不回归'; Metric='误报/漏报、检测延迟、拒绝率、修复通过率、证据完整性'; Failure='越界输入、弱配置、伪造事件、日志缺失或授权范围不清'; Source='OWASP WSTG/ASVS、NIST、MITRE ATT&CK、CWE 对应条目'; Url='https://owasp.org/www-project-web-security-testing-guide/'}
        }
        elseif ($category -eq 'mobile') {
            $fallback=@{Mechanism="端侧主题「$($title)」的平台生命周期、权限/沙箱、渲染/设备状态和发布制品"; Invariant='非法生命周期/权限跃迁被拒绝，离线/崩溃/版本迁移可恢复且签名可验证'; Metric='冷/热启动、帧时间 P95、CPU/内存、离线成功率、崩溃恢复'; Failure='权限撤销、旋转、进程被杀、网络断开、签名或版本不匹配'; Source='Android Developers、Apple Developer、Zephyr 对应章节'; Url='https://developer.android.com/'}
        }
        elseif ($category -eq 'ai') {
            $fallback=@{Mechanism="数据/AI 主题「$($title)」的 schema、切分、特征/模型、评估、推理和治理闭环"; Invariant='数据/模型/代码/环境可追溯，评估隔离，异常输入触发拒绝或降级'; Metric='质量指标置信区间、P50/P95、峰值内存、漂移、校准和成本'; Failure='标签错位、泄漏、漂移、不可收敛、评估污染或资源耗尽'; Source='PyTorch Tutorials、NIST AI RMF、Hugging Face 对应章节'; Url='https://pytorch.org/tutorials/'}
        }
        elseif ($category -eq 'ops') {
            $fallback=@{Mechanism="运维主题「$($title)」的配置/制品→进程/控制器→健康与三信号→SLO/回滚/成本"; Invariant='配置幂等、健康先于流量、变更可回滚、观测不含敏感值'; Metric='收敛时间、可用性、错误率、P95/P99、资源利用率、MTTD/MTTR'; Failure='依赖关闭、配置错误、资源上限、单节点不可用或不可信制品'; Source='Kubernetes、OpenTelemetry、Google SRE、Docker 对应章节'; Url='https://kubernetes.io/docs/concepts/'}
        }
        elseif ($category -eq 'product') {
            $fallback=@{Mechanism="产品主题「$($title)」的用户任务、交互状态、研究证据、设计系统和交付决策闭环"; Invariant='目标可观察，错误可恢复，状态一致，隐私/可访问性约束不遗漏'; Metric='任务成功率、完成时间、错误率、对比度/键盘通过率、样本量'; Failure='空/加载/错误状态缺失、文案歧义、焦点/对比度回归或需求冲突'; Source='W3C WCAG 2.2、NN/g 启发式、Material Design 对应章节'; Url='https://www.w3.org/TR/WCAG22/'}
        }
        if ($null -ne $fallback) { foreach ($key in $fallback.Keys) { $patch[$key] = [string]$fallback[$key] } }
    }
    return $patch
}

function Get-TopicTerms([string]$id, [string]$category, [string]$title) {
    $stop = @(
        '入门','基础','深入','概论','原理','实战','实践','教程','全景','精选','基础','与','和','及','含',
        '仅','分析','不实践','合法边界','白帽','视角','收官','方法论','学习','高效习得','站在巨人肩膀上'
    )
    $normalized = $title -replace '[\(\)（）【】\[\]、/·—–:：,，。；;→=]+', ' '
    $normalized = $normalized -replace '(?i)入门与|基础与|深入与|原理与|概论与', ' '
    $normalized = $normalized -replace '(?i)详解', ' '
    $parts = $normalized -split '\s+' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    $terms = [System.Collections.Generic.List[string]]::new()
    foreach ($part in $parts) {
        $term = $part.Trim()
        if ($term.Length -eq 0 -or $stop -contains $term) { continue }
        if ($term -match '^(?i:Lv|Lab)\d+$') { continue }
        if ($term.Length -lt 2 -and $term -notmatch '^(?i:C|C\+\+|Go|JS|TS|SQL|UI|UX|AI|ML|JVM|JIT|IR|AST|ELF|PE|TLS|TCP|UDP|DNS|HTTP|HTTPS|QUIC|RAG|LLM|K8s|OTA|NDK|JNI|API|RPC|WAL|MVCC|SLO|SRE|CI|CD)$') { continue }
        if (-not $terms.Contains($term)) { $terms.Add($term) }
    }
    if ($terms.Count -eq 0) { $terms.Add(($title -replace '[\(\)（）]', '').Trim()) }
    $contextTerm = switch -Regex ($id) {
        '^PRE' { '计算机操作'; break }
        '^PY' { 'Python'; break }
        '^C\d' { 'C语言'; break }
        '^CPP' { 'C++'; break }
        '^JV' { 'Java/JVM'; break }
        '^JS' { 'JavaScript'; break }
        '^GO' { 'Go语言'; break }
        '^RS' { 'Rust'; break }
        '^PAR' { '编程范式'; break }
        '^OTH' { '语言运行时'; break }
        '^SQL' { 'SQL'; break }
        '^SH' { 'Shell'; break }
        '^DSA' { '算法证明'; break }
        '^COMP' { '计算机体系结构'; break }
        '^ASM' { '汇编与ABI'; break }
        '^OS' { '操作系统'; break }
        '^CMP' { '编译器'; break }
        '^NET' { '网络协议'; break }
        '^DB' { '数据库系统'; break }
        '^FE' { '浏览器前端'; break }
        '^BE' { '后端服务'; break }
        '^SEC' { '安全验证'; break }
        '^MOB' { '端侧平台'; break }
        '^DAT' { '数据与模型'; break }
        '^OPS' { '运维系统'; break }
        '^PD' { '用户任务'; break }
        default { "$category 轨道" }
    }
    if ($terms.Count -lt 2 -and -not $terms.Contains($contextTerm)) { $terms.Add($contextTerm) }
    return @($terms | Select-Object -First 6)
}

function Get-TopicSemantic([string]$id, [string]$category, [string]$title) {
    $terms = @(Get-TopicTerms $id $category $title)
    $focus = ($terms -join '、')
    $primary = [string]$terms[0]
    $secondary = if ($terms.Count -gt 1) { [string]$terms[1] } else { '边界条件' }
    $mechanism = switch ($category) {
        'prep' { "围绕`“$($focus)`”建立事件链：用户动作/设备输入 → 界面或命令 → 文件/进程对象 → 返回码与可恢复状态；用实际观察区分类比和事实。" }
        'python' { "围绕`“$($focus)`”追踪 Python 对象模型与控制流：绑定/求值 → 栈帧、迭代器或模块 → 异常与资源边界；用测试、trace 或 dis 把语义落到证据。" }
        'language' { "围绕`“$($focus)`”追踪源代码 → 词法/类型检查 → ABI 与对象布局 → 运行时；比较警告、错误模型、构建产物和调试信息的具体差异。" }
        'paradigm' { "围绕`“$($focus)`”把程序画成状态/值流图，标出求值策略、副作用边界、组合律和失败传播；用等价变换验证而非只展示代码风格。" }
        'algorithm' { "围绕`“$($focus)`”定义输入域与抽象状态，写出循环或递推不变量、复杂度上界和最小反例；用性质测试检验证明的前提。" }
        'system' { "围绕`“$($focus)`”跨越源码、指令/系统调用、内存或持久化层；每个结论都绑定到寄存器、段、页、线程、系统调用或日志观察点。" }
        'network' { "围绕`“$($focus)`”建立协议状态机与字段表，从回环应用日志回指报文、超时、重传和故障域；所有流量限定在 127.0.0.1 或授权靶场。" }
        'database' { "围绕`“$($focus)`”建立关系/日志/执行器模型，把 SQL 结果回指执行计划、锁/MVCC、索引、WAL 或恢复点，而不是停在 CRUD 表面。" }
        'web' { "围绕`“$($focus)`”连接 DOM/事件循环、HTTP、缓存、API 契约和用户任务；正常、错误、慢网及键盘路径都要留下可复核证据。" }
        'security' { "围绕`“$($focus)`”画资产与信任边界，追踪输入到解析器/权限/检测证据的路径；仅使用自有代码、合成输入或明确授权靶场，并保留修复回归。" }
        'mobile' { "围绕`“$($focus)`”建模平台生命周期、权限/沙箱、渲染或设备状态；比较冷启动、进程被杀、离线和版本迁移时的不同行为。" }
        'ai' { "围绕`“$($focus)`”串起数据 schema、切分、特征/模型、评估、推理和治理；每个结论绑定数据版本、配置、随机种子与反例。" }
        'ops' { "围绕`“$($focus)`”追踪配置/制品 → 控制器或进程 → 健康与三信号 → SLO、回滚和成本；实验只在本地进程、容器或模拟集群运行。" }
        'product' { "围绕`“$($focus)`”把用户任务拆成状态、反馈、研究证据和交付决策；空、加载、错误、键盘和隐私边界都要可观察、可恢复。" }
        default { "围绕`“$($focus)`”定义输入、状态、输出、错误边界和验收证据，并把每个结论绑定到可重复实验。" }
    }
    $invariant = switch ($category) {
        'prep' { "「$($focus)」每一步都有可观察输入/输出、权限边界、失败码和清理动作；重跑不破坏原始资料。" }
        'python' { "「$($focus)」的输入契约、对象身份/值语义、异常类型和资源生命周期明确；重复运行不产生隐藏副作用。" }
        'language' { "「$($focus)」的类型/布局/调用约定和错误语义在边界输入下仍一致；编译器警告、sanitizer 或运行时错误不能静默。" }
        'paradigm' { "「$($focus)」的组合前后保持值/类型不变量，副作用只在显式边界发生，短路或惰性不会改变终止语义。" }
        'algorithm' { "每次处理「$($focus)」的状态更新都保持不变量，结果与参考定义等价；空、重复、极值和最坏输入有明确结论。" }
        'system' { "「$($focus)」的所有权、顺序、地址转换或崩溃后提交边界可观测；优化、调度和故障不能制造未声明状态。" }
        'network' { "「$($focus)」的状态转换、序列/版本、请求关联和超时语义满足协议；重试不会制造重复副作用。" }
        'database' { "「$($focus)」的约束、可见性、计划结果和恢复状态一致；提交/回滚、备份校验和迁移回滚都有明确边界。" }
        'web' { "「$($focus)」在语义、焦点、权限、缓存、幂等和慢网条件下仍可完成用户任务；错误响应不泄露内部细节。" }
        'security' { "「$($focus)」的拒绝路径默认安全、证据可哈希且脱敏，修复后正常输入不回归；越过授权范围立即停止。" }
        'mobile' { "「$($focus)」的非法生命周期/权限跃迁被拒绝，离线重放幂等，进程被杀或旋转后数据与 UI 状态可恢复。" }
        'ai' { "「$($focus)」的数据/模型/代码/环境可追溯，评估集隔离；异常输入触发拒绝或降级而非静默给出高置信结论。" }
        'ops' { "「$($focus)」的期望与实际状态差异可解释，健康检查先于流量，变更可回滚，观测数据不含敏感值。" }
        'product' { "「$($focus)」的任务目标可观察，错误可恢复，组件状态一致；隐私、可访问性与停止/转向条件不会被遗漏。" }
        default { "「$($focus)」的输入、状态、输出和失败边界可复现，结论不超出实验实际证明范围。" }
    }
    $metric = switch ($category) {
        'prep' { "以「$($primary)」为主变量：步骤耗时、失败恢复时间、命令退出码、文件哈希和重跑差异。" }
        'python' { "以「$($primary)」为主变量：P50/P95、峰值内存、边界测试类别、异常率、对象/调用次数。" }
        'language' { "以「$($primary)」为主变量：编译诊断数、二进制/包体哈希、P50/P95、峰值内存、sanitizer/竞态结果。" }
        'paradigm' { "以「$($primary)」为主变量：组合深度、分配次数、查询/管道耗时、失败定位时间和重复运行差异。" }
        'algorithm' { "以「$($primary)」为主变量：操作/松弛次数、P50/P95、峰值内存、规模增长曲线、反例最小规模。" }
        'system' { "以「$($primary)」为主变量：指令/系统调用数、上下文切换、缺页、吞吐、尾延迟、RPO/RTO。" }
        'network' { "以「$($primary)」为主变量：字段/帧数、RTT、P50/P95/P99、重传/错误率、连接数和恢复时间。" }
        'database' { "以「$($primary)」为主变量：计划节点、实际行数、P50/P95、锁等待/冲突率、吞吐、备份大小和 RPO/RTO。" }
        'web' { "以「$($primary)」为主变量：LCP/INP/CLS、API P50/P95、键盘成功率、响应大小、缓存命中率和错误率。" }
        'security' { "以「$($primary)」为主变量：误报/漏报、检测延迟、拒绝率、修复回归通过率、证据完整性和残余风险。" }
        'mobile' { "以「$($primary)」为主变量：冷/热启动、帧时间 P95、CPU/内存、离线成功率、崩溃恢复和功耗代理。" }
        'ai' { "以「$($primary)」为主变量：质量指标与置信区间、P50/P95、峰值内存、漂移/校准、token 数和成本代理。" }
        'ops' { "以「$($primary)」为主变量：收敛时间、可用性、错误率、P95/P99、资源利用率、MTTD/MTTR 和回滚耗时。" }
        'product' { "以「$($primary)」为主变量：任务成功率、完成时间、错误率、键盘/可访问性通过率、样本量和决策置信度。" }
        default { "以「$($primary)」为主变量：正确率、耗时、资源占用、失败率和恢复时间。" }
    }
    $failure = switch ($category) {
        'prep' { "保持其他条件不变，故意破坏「$($primary)」的前置条件（路径、权限、编码或进程中断），记录现象、返回码、恢复和清理。" }
        'python' { "保持其他输入不变，注入「$($primary)」的空值、非法类型、Unicode、只读路径或部分写入，保存最小反例和异常栈。" }
        'language' { "保持协议和工具版本不变，制造「$($primary)」的非法程序、边界字节、ABI/版本不匹配或并发竞态，保存诊断与回归。" }
        'paradigm' { "保持数据集不变，破坏「$($primary)」的组合律、短路、惰性或副作用边界，比较等价实现并记录非终止/重复副作用。" }
        'algorithm' { "保持算法和随机种子不变，注入「$($primary)」的空、重复、极值、最坏分布或失效证明前提，缩减到最小反例。" }
        'system' { "在自有最小程序中注入「$($primary)」的竞态、越界、缺页压力、系统调用失败或写入中断，记录跨层时间线并恢复。" }
        'network' { "只对回环服务注入「$($primary)」的超时、丢包、乱序、重复请求、错误证书或 DNS 缓存，保留抓包/日志和回滚。" }
        'database' { "在合成库中注入「$($primary)」的约束冲突、锁超时、死锁、进程中断、坏备份或半途迁移，校验恢复后的行集。" }
        'web' { "在本地页面/API 注入「$($primary)」的键盘焦点丢失、错误 JSON、重复提交、缓存泄漏、慢网或依赖超时，完成回归。" }
        'security' { "在自有或授权靶场对「$($primary)」注入越界输入、弱配置、伪造事件或日志缺失；保留哈希、授权范围、修复 diff 和清理。" }
        'mobile' { "在本地模拟器或状态机注入「$($primary)」的权限撤销、旋转、进程被杀、网络断开、签名/版本不匹配，验证安全降级。" }
        'ai' { "用合成数据注入「$($primary)」的标签错位、缺失/异常、分布漂移、评估污染、不可收敛或资源耗尽，记录停止条件。" }
        'ops' { "在本地进程/容器/模拟集群注入「$($primary)」的依赖关闭、配置错误、资源上限、单节点不可用或不可信制品，执行回滚。" }
        'product' { "在本地原型注入「$($primary)」的空状态、慢网、误操作、文案歧义、对比度/焦点回归或需求冲突，记录观察与决策。" }
        default { "只在隔离环境改变「$($primary)」的一个前置条件，记录可恢复失败、证据、修复、回归和清理。" }
    }
    # 高密度主题覆盖：这些课的验收必须落到标题对应的真实协议/算法/运行时机制。
    $sourceChapter = $null
    $labInput = $null
    if ($category -eq 'network') {
        if ($title -match '(?i)TLS|HTTPS') {
            $mechanism = 'TLS 1.3 ClientHello/ServerHello、密钥调度、证书链/主机名验证与告警处理。'
            $invariant = '证书、主机名、协议版本和 ALPN 验证失败必须阻断；密钥材料不进入日志。'
            $metric = '握手 RTT、协议版本、证书链结果、ALPN、失败告警和重试率。'
            $failure = '本地自签名/过期证书、错误主机名、版本降级或私钥权限错误；只用回环服务。'
            $sourceChapter = 'RFC 8446 TLS 1.3：握手、密钥调度、认证与告警章节。'
            $labInput = '在 127.0.0.1 运行 TLS 服务，分别使用有效、过期、自签名和错误主机名证书，保存握手版本、ALPN、验证错误和清理记录。'
        } elseif ($title -match '(?i)QUIC') {
            $mechanism = 'QUIC Connection ID、加密握手、独立流、流控、丢包恢复与连接迁移。'
            $invariant = '单流丢失不阻塞其他流，连接迁移不泄露未授权状态，握手失败不降级为明文。'
            $metric = '握手 RTT、流级 P95、重传、连接迁移成功率和拥塞窗口代理值。'
            $failure = '回环延迟/丢包、单流阻塞、迁移失败或握手版本不匹配；只用本地仿真。'
            $sourceChapter = 'RFC 9000 QUIC：连接、流、流控、错误和迁移章节。'
            $labInput = '在本地 QUIC 仿真或授权回环服务中并发发送多流，注入单流丢包和迁移，保存流 ID、时序和恢复证据。'
        } elseif ($title -match '(?i)HTTP/3|HTTP3') {
            $mechanism = 'HTTP/3 请求/响应语义映射到 QUIC 流、QPACK 头压缩、流重置与连接迁移。'
            $invariant = 'HTTP 方法/状态码和流 ID 关联一致，单流故障不阻塞其他请求，QPACK 状态可恢复。'
            $metric = '首字节时间、流级 P95、QPACK 表大小、重置率和迁移成功率。'
            $failure = 'QPACK 解码错误、流重置、慢客户端或连接迁移；仅在回环服务注入。'
            $sourceChapter = 'RFC 9114 HTTP/3 与 RFC 9204 QPACK：流、头字段和错误章节。'
            $labInput = '在 127.0.0.1 HTTP/3 仿真中并发发送请求，记录 QUIC 流/头字段、重置和迁移时序。'
        } elseif ($title -match '(?i)HTTP') {
            $mechanism = 'HTTP 方法/状态码/头字段、连接复用、HTTP/2 多路复用与 HTTP/3 映射到 QUIC 流的请求生命周期。'
            $invariant = '方法、状态码、Content-Length/Transfer-Encoding、流 ID 和幂等性一致；协议降级不泄露数据。'
            $metric = '首字节时间、P50/P95、复用连接数、头字段大小、流级错误率和重试重复率。'
            $failure = '分块边界错误、半关闭、慢客户端、重复 POST、H2 流重置或 H3 连接迁移；仅在回环服务注入。'
            $sourceChapter = 'RFC 9110 HTTP Semantics、RFC 9113 HTTP/2、RFC 9114 HTTP/3：方法、字段、流和错误章节。'
            $labInput = '启动 127.0.0.1 HTTP 服务，分别发送 GET/POST、分块响应、并发请求和故障请求，保存响应头、连接/流 ID 与时序。'
        } elseif ($title -match '(?i)DHCP') {
            $mechanism = 'DHCP Discover/Offer/Request/ACK 状态机、事务 xid、租约时间和 option 字段。'
            $invariant = 'xid、客户端标识、地址池和租约期限在四步握手中一致；续租/拒绝不会分配重复地址。'
            $metric = 'DORA RTT、租约命中率、地址池利用率、续租失败率和 option 解析错误数。'
            $failure = '服务器不可达、地址池耗尽、xid 不匹配、续租超时或错误网关；仅在合成 DHCP 状态机测试。'
            $sourceChapter = 'RFC 2131/2132：DHCP 状态机、租约和选项字段章节。'
            $labInput = '用合成报文驱动 DHCP 状态机，记录四步字段、租约计时、续租与拒绝路径，不向真实网络发送广播。'
        } elseif ($title -match '(?i)UDP') {
            $mechanism = 'UDP 数据报边界、端口复用、校验和与应用层顺序/重传责任。'
            $invariant = '每个数据报边界和校验状态可区分；丢失/乱序不被错误地宣称为传输层可靠。'
            $metric = '数据报丢失率、乱序率、校验失败数、应用重传 P95 和吞吐。'
            $failure = '本地丢包、乱序、重复、零长度数据报或端口关闭；用回环 socket 和合成网络故障。'
            $sourceChapter = 'RFC 768 UDP：用户数据报格式、校验和与无连接语义章节。'
            $labInput = '用 127.0.0.1 UDP 客户端/服务端发送带序号数据报，注入丢包/乱序，比较裸 UDP 与应用层重传。'
        } elseif ($title -match '(?i)代理|反向代理|NAT') {
            $mechanism = '正向/反向代理与 NAT 的地址映射、连接跟踪、Host/X-Forwarded-* 信任边界和超时。'
            $invariant = '映射表、源地址语义和授权头字段可追溯；代理不会把未验证的转发头当成身份。'
            $metric = '映射条目、连接复用率、P95、超时/回收数和真实客户端识别准确率。'
            $failure = '映射过期、半开连接、错误转发头、端口耗尽或后端不可达；仅用本地双节点。'
            $sourceChapter = 'RFC 9110 Forwarded、RFC 7857 NAT 行为资料与反向代理官方文档对应章节。'
            $labInput = '启动本地前后端和代理，记录连接跟踪、Host/转发头、超时与回收，验证伪造头被拒绝。'
        } elseif ($title -match '(?i)负载均衡') {
            $mechanism = '四层/七层负载均衡、健康检查、连接粘性、加权选择和故障转移。'
            $invariant = '不健康节点不接收新流量，重试遵守幂等性，粘性会话不越过授权边界。'
            $metric = '各节点流量方差、健康收敛时间、P95/P99、失败转移率和重试放大倍数。'
            $failure = '单节点退出、探针误判、连接长尾、权重变化或重复副作用；仅在本地多进程。'
            $sourceChapter = 'Envoy/HAProxy/Nginx 官方负载均衡、健康检查和连接池章节。'
            $labInput = '运行两个回环后端与本地均衡器，改变权重并停止节点，保存路由决策、探针和恢复时间线。'
        }
    } elseif ($category -eq 'database') {
        if ($title -match '(?i)范式|关系模型') {
            $mechanism = '函数依赖、候选键、1NF/2NF/3NF/BCNF 分解与无损连接/依赖保持。'
            $invariant = '分解无损且约束可维护，规范化前后业务事实和 NULL/重复语义可证明。'
            $metric = '依赖覆盖率、连接重复倍数、查询 P95、表数量和更新异常数。'
            $failure = '有损分解、隐藏传递依赖、更新/删除异常或为规范化过度牺牲可用查询。'
            $sourceChapter = 'Database System Concepts：Functional Dependencies/Normalization 与 PostgreSQL constraints。'
            $labInput = '给定合成订单表列出依赖并分解到 BCNF，构造反例验证无损连接和更新异常。'
        } elseif ($title -match '(?i)概论|数据模型|ER') {
            $mechanism = '实体/属性/关系到关系表、主键/外键和约束的建模映射。'
            $invariant = '每个业务事实只有一个权威来源，键与基数约束可由数据库拒绝非法状态。'
            $metric = '函数依赖数量、约束覆盖率、重复事实数、迁移回滚时间和查询基线。'
            $failure = '多对多误建模、空值语义不清、孤儿行、重复事实或迁移半途。'
            $sourceChapter = 'CMU 15-445 Database Design 与 PostgreSQL Constraints/DDL 章节。'
            $labInput = '为合成订单域画 ER 图并落地 schema，插入正常/孤儿/重复/NULL 用例，保存约束错误和迁移回滚。'
        } elseif ($title -match '(?i)JOIN|联结') {
            $mechanism = '关系代数连接、连接算法（NLJ/Hash/Merge）、基数估计和外连接 NULL 扩展。'
            $invariant = '连接谓词、重复行和 NULL 扩展语义明确；优化计划结果集与参考实现一致。'
            $metric = '输入/输出基数、连接节点、内存峰值、P95 和估计误差。'
            $failure = '笛卡尔积、错误谓词、NULL 过滤、倾斜键或 Hash 表溢出。'
            $sourceChapter = 'PostgreSQL Queries/Joins 与 EXPLAIN 章节；记录实际行数与计划估计。'
            $labInput = '生成有重复键、NULL、空表和倾斜分布的合成表，比较三种连接写法、结果哈希和 EXPLAIN。'
        } elseif ($title -match '(?i)索引|执行计划|优化') {
            $mechanism = 'B+Tree/哈希访问路径、选择性、统计信息、代价估计、回表和覆盖索引。'
            $invariant = '优化只改变访问路径不改变结果集；统计信息和参数变化能解释计划切换。'
            $metric = '计划节点、估计/实际行数比、缓存命中、P50/P95 和索引维护成本。'
            $failure = '低选择性索引、函数包列、统计过期、参数嗅探或索引导致写放大。'
            $sourceChapter = 'PostgreSQL Indexes、Using EXPLAIN、Planner Statistics 与 Performance Tips。'
            $labInput = '对同一合成表做有/无索引和不同选择性对照，保存 EXPLAIN ANALYZE、结果哈希与写入成本。'
        } elseif ($title -match '(?i)Elasticsearch|搜索引擎') {
            $mechanism = '倒排索引、分析器/tokenizer、BM25 相关性、段合并、刷新与副本分片。'
            $invariant = '文档版本、分析器和查询 DSL 可追溯，刷新前后可见性明确，副本结果与主分片一致。'
            $metric = 'Recall@k、MRR/BM25、索引段数、刷新延迟、查询 P95 和磁盘放大。'
            $failure = '分词器错配、相关性漂移、段合并压力、分片不可用或查询超时；只用合成文档。'
            $sourceChapter = 'Elasticsearch Reference：Text analysis、Inverted index、Query DSL、Shards/Replicas。'
            $labInput = '用合成多语言文档建立倒排索引，比较 analyzer/BM25 与刷新/段合并，注入分片不可用并校验结果。'
        } elseif ($title -match '(?i)图数据库|属性图|Cypher') {
            $mechanism = '属性图节点/边、标签与属性索引、Cypher 模式匹配和路径遍历。'
            $invariant = '边方向、路径去重和事务可见性明确，查询结果能回指图版本和索引状态。'
            $metric = '遍历扩展数、路径长度、结果基数、P95、索引命中率和写入冲突。'
            $failure = '环路爆炸、重复路径、缺失方向、笛卡尔模式或半途事务；只用合成图。'
            $sourceChapter = 'Neo4j Cypher Manual：Property Graph、MATCH、路径和索引章节。'
            $labInput = '建立合成属性图，运行有向/无向/可变长度 MATCH，构造环路与重复路径并记录计划和结果哈希。'
        } elseif ($title -match '(?i)分布式事务|共识|2PC|Raft|Paxos') {
            $mechanism = '2PC prepare/commit、Raft 任期/日志复制/多数派提交与 Paxos 提案编号。'
            $invariant = '未达多数派的日志不能提交，任期/提案号单调，重试和领导切换不产生双重提交。'
            $metric = '提交延迟、复制 lag、选举次数、消息/日志条数、可用性窗口和恢复时间。'
            $failure = '协调者崩溃、网络分区、重复提案、旧领导写入或磁盘写入中断；只用本地多进程仿真。'
            $sourceChapter = 'Raft extended paper、Paxos Made Simple 与 PostgreSQL 事务/两阶段提交资料。'
            $labInput = '用本地多进程或状态机仿真 2PC/Raft/Paxos，注入协调者崩溃、分区和旧任期消息，保存日志与恢复矩阵。'
        } elseif ($title -match '(?i)Redis') {
            $mechanism = 'Redis 单线程事件循环、数据结构、过期、持久化 RDB/AOF、流水线和缓存击穿。'
            $invariant = 'TTL/淘汰不会返回已过期敏感值，重放命令幂等，AOF/RDB 恢复不丢已承诺数据。'
            $metric = '命令 P95、命中率、内存碎片、AOF fsync 延迟、恢复时间和击穿放大倍数。'
            $failure = '热 key、雪崩、AOF 截断、内存上限、主从延迟或重复消费。'
            $sourceChapter = 'Redis Documentation：Data Types、Persistence、Expiration、Eviction 与 Pipelining。'
            $labInput = '在本地 Redis 或仿真器中构造热 key/过期/故障重启，保存命中率、AOF/RDB 校验和回滚证据。'
        } elseif ($title -match '(?i)事务|ACID|隔离') {
            $mechanism = '事务原子性、快照可见性、锁/MVCC、隔离级别和序列化失败。'
            $invariant = '提交/回滚原子性成立，读取遵守选定隔离级别，异常不留下半成品。'
            $metric = '锁等待、冲突率、提交 P95、序列化失败数、吞吐和恢复点。'
            $failure = '两个本地连接制造脏读/不可重复读/幻读、死锁、超时或进程中断。'
            $sourceChapter = 'PostgreSQL Chapter 13 Concurrency Control 与 Transaction Isolation。'
            $labInput = '用两条本地连接执行交错事务，逐隔离级别记录可见行集、锁等待、回滚和序列化失败。'
        }
    } elseif ($category -eq 'ai') {
        if ($title -match '(?i)RAGAS|忠实|相关') {
            $mechanism = 'RAGAS/生成式评估中的 faithfulness、answer relevancy、context precision/recall 与评估集构造。'
            $invariant = '评估问题、参考答案、检索上下文和生成回答版本可追溯，指标定义不被提示模板暗中改变。'
            $metric = 'faithfulness、answer relevancy、context precision/recall、人工一致性和评估成本。'
            $failure = '引用缺失、上下文污染、评估集泄漏、指标与人工判断反向或模型评审偏差；只用合成语料。'
            $sourceChapter = 'Ragas 官方文档与 NIST AI RMF：生成式 AI 评估、忠实性和相关性章节。'
            $labInput = '用合成问答/检索包计算 RAGAS 指标，构造无引用、错误上下文和提示污染反例，比较自动分数与人工盲评。'
        } elseif ($title -match '(?i)向量数据库|近似检索|ANN') {
            $mechanism = '向量嵌入、距离度量、HNSW/IVF 近似最近邻索引、召回/精度与索引更新。'
            $invariant = '向量版本/维度/度量一致，索引结果可回指数据版本，删除和更新不会返回已撤销文档。'
            $metric = 'Recall@k、查询 P95、索引构建时间、内存/磁盘、更新延迟和过滤后召回。'
            $failure = '维度错配、度量错用、索引陈旧、过滤条件泄漏或高维资源耗尽；只用合成向量。'
            $sourceChapter = 'FAISS/HNSW 官方文档与向量数据库索引、过滤和一致性章节。'
            $labInput = '生成固定种子向量，比较精确检索与 HNSW/IVF，改变 ef/nprobe 与过滤条件，记录召回、延迟和版本回滚。'
        } elseif ($title -match '(?i)Transformer|注意力') {
            $mechanism = 'Q/K/V 投影、缩放点积注意力、mask、多头拼接、位置编码和 O(n²) 上下文成本。'
            $invariant = 'mask 不允许越权看未来/填充，位置编码与 token 顺序一致，注意力权重按行归一。'
            $metric = '序列长度、注意力矩阵内存、token/s、P95、困惑度/任务指标和 mask 错误率。'
            $failure = '上下文截断、因果 mask 反转、位置外推、长序列资源耗尽或 padding 泄漏。'
            $sourceChapter = 'Attention Is All You Need、PyTorch Transformer 教程与 Hugging Face Attention 章节。'
            $labInput = '用小矩阵手算并实现单头 Q/K/V 注意力，加入 causal/padding mask 和位置编码，保存权重矩阵与复杂度测量。'
        } elseif ($title -match '(?i)Tokenizer|Token') {
            $mechanism = 'Unicode 规范化、BPE/WordPiece 合并、词表 ID、特殊 token 和 token budget。'
            $invariant = '编码后可按词表解码，特殊 token 边界不被合并，未知/超长输入有明确截断策略。'
            $metric = '压缩率、token 数、OOV/UNK 率、编码耗时、截断率和字节偏差。'
            $failure = 'Unicode 组合字符、混合语言、特殊 token 注入、超长上下文或训练/推理词表不一致。'
            $sourceChapter = 'Hugging Face Tokenizers/Course 与模型官方 tokenizer 配置章节。'
            $labInput = '在合成多语言语料上比较字符/词/BPE 分词，保存词表哈希、token 序列、解码一致性和截断反例。'
        } elseif ($title -match '(?i)RAG|检索') {
            $mechanism = '文档切分、embedding、向量召回、重排、上下文拼接和引用可追溯链。'
            $invariant = '回答证据来自检索文档版本，空召回触发拒答，提示注入不会改变检索权限。'
            $metric = 'Recall@k、MRR、忠实度、引用覆盖率、token 成本和 P95。'
            $failure = '切分跨越语义边界、召回为空、相似但错误文档、上下文超长或提示注入。'
            $sourceChapter = 'NIST AI RMF Generative AI Profile 与 Hugging Face Retrieval/RAG 官方资料。'
            $labInput = '用合成文档建立版本化 RAG，比较 chunk 大小/overlap/k，注入空召回和提示注入并保留引用证据。'
        } elseif ($title -match '(?i)LoRA|QLoRA|微调') {
            $mechanism = '低秩 ΔW=BA、冻结基座、量化误差、适配器合并和训练/推理显存。'
            $invariant = '基座权重不可变，适配器版本可追溯，合并前后 tokenizer/config 与评估集一致。'
            $metric = '可训练参数比例、显存、吞吐、验证指标、量化误差和适配器大小。'
            $failure = 'rank 过小/过大、数据泄漏、量化溢出、适配器错配或合并后回归。'
            $sourceChapter = 'Hugging Face PEFT/QLoRA 官方文档与 PyTorch AMP/quantization 章节。'
            $labInput = '在小型合成任务上固定基座，对比全量微调与 LoRA/QLoRA，保存参数量、显存、指标和回滚制品。'
        }
    } elseif ($category -eq 'ops') {
        if ($title -match '(?i)CNI|CSI') {
            $mechanism = 'Kubernetes CNI 网络命名空间/Service 路径与 CSI 控制器、节点插件、挂载/卷生命周期。'
            $invariant = '网络和卷对象与 Pod UID 关联，挂载/卸载幂等，未就绪网络或卷不接流量。'
            $metric = 'Pod 网络就绪、DNS/Service RTT、挂载耗时、卷错误率、重连时间和资源占用。'
            $failure = 'CNI 配置错误、网络策略拒绝、CSI attach/mount 失败、节点隔离或卷泄漏；只用本地集群。'
            $sourceChapter = 'Kubernetes Networking/Cluster Architecture 与 Container Storage Interface 官方规范章节。'
            $labInput = '在 kind/minikube 或 JSON 仿真中创建 Pod、Service 和 PVC，注入 CNI/CSI 失败，记录事件、路径、挂载和清理。'
        } elseif ($title -match '(?i)RBAC|最小权限') {
            $mechanism = 'Kubernetes Subject/Role/RoleBinding、资源动词、ServiceAccount 和 admission 授权决策。'
            $invariant = '默认拒绝、权限最小且按命名空间隔离，审计事件能回指主体和授权规则。'
            $metric = '允许/拒绝率、规则覆盖、越权用例数、审计延迟和权限变更回滚时间。'
            $failure = 'ClusterRole 过宽、绑定错命名空间、ServiceAccount 泄漏或规则更新未生效；只用本地集群。'
            $sourceChapter = 'Kubernetes Security：RBAC、Authorization 与 ServiceAccount 官方章节。'
            $labInput = '在本地集群创建最小 Role/Binding，执行允许与拒绝请求，注入过宽规则后回滚并保存审计事件。'
        } elseif ($title -match '(?i)排障|诊断|事件') {
            $mechanism = 'Pod/Node/Controller 事件、日志、探针、状态条件与 kubectl 调查路径的因果关联。'
            $invariant = '每个症状都能回指时间线和资源 UID，诊断命令只读优先，修复后状态收敛并可回滚。'
            $metric = 'MTTD/MTTR、事件到根因链长度、误诊率、探针恢复时间和命令覆盖。'
            $failure = '镜像拉取失败、CrashLoopBackOff、探针误判、资源不足或事件丢失；只用本地集群。'
            $sourceChapter = 'Kubernetes Debugging Applications/Clusters 与 Events 官方章节。'
            $labInput = '在本地集群注入镜像、探针、资源和依赖故障，按只读→假设→修复→回归顺序保存事件/日志/状态时间线。'
        } elseif ($title -match '(?i)ArgoCD|GitOps|声明式交付') {
            $mechanism = 'Git desired state、ArgoCD 应用同步、差异检测、健康状态和回滚/漂移修复。'
            $invariant = '提交哈希与集群状态可追溯，漂移可检测，未审查变更不自动越过环境闸门。'
            $metric = '同步延迟、漂移检测时间、失败率、回滚耗时、制品哈希和审计完整率。'
            $failure = '清单冲突、凭据泄漏、自动同步误删、依赖不可达或回滚版本不一致；只用本地 Git/集群。'
            $sourceChapter = 'Argo CD User Guide：Application、Sync、Drift Detection 与 Rollback。'
            $labInput = '在本地 Git 仓库与模拟集群建立声明式应用，注入清单漂移/失败同步，保存提交、差异、回滚和清理证据。'
        } elseif ($title -match '(?i)PromQL|指标查询') {
            $mechanism = 'Prometheus 时间序列标签、PromQL 聚合/窗口、录制规则和告警表达式。'
            $invariant = '标签基数受控，聚合维度不丢失用户影响，告警表达式与 SLO 时间窗口一致。'
            $metric = '查询 P95、样本量、标签基数、采集丢失率、告警延迟和存储成本。'
            $failure = '高基数标签、缺失样本、窗口错配、时钟偏移或告警风暴；只用本地指标。'
            $sourceChapter = 'Prometheus Documentation：Data model、PromQL、Recording Rules 与 Alerting。'
            $labInput = '运行本地指标端点，生成正常/缺失/高基数序列，比较 PromQL 聚合与告警窗口并保存查询结果。'
        } elseif ($title -match '(?i)ELK|EFK|集中分析') {
            $mechanism = '日志采集/解析/索引/查询链路、字段映射、保留策略和敏感字段脱敏。'
            $invariant = '每条日志可回指服务/时间/请求 ID，解析失败不静默丢弃，敏感字段不进入索引。'
            $metric = '采集丢失率、解析成功率、查询 P95、索引增长、保留成本和脱敏命中率。'
            $failure = '解析格式漂移、索引爆炸、collector 不可用、时钟偏移或敏感字段泄漏；只用合成日志。'
            $sourceChapter = 'Elastic/Fluentd/Fluent Bit 官方文档：采集、解析、索引和生命周期管理。'
            $labInput = '用合成结构化/非结构化日志运行本地采集与索引链路，注入格式漂移和高基数，验证脱敏、查询和清理。'
        } elseif ($title -match '(?i)Kubernetes|K8s|控制面|数据面') {
            $mechanism = 'API server/etcd/scheduler/controller-manager 与 kubelet/CNI/Service 数据面的期望状态收敛。'
            $invariant = '对象版本/期望状态可追踪，控制器幂等，readiness 通过前不接流量，RBAC 最小。'
            $metric = 'reconcile 延迟、watch 事件、Pod 重启、就绪收敛时间、P95 和资源利用率。'
            $failure = '控制器重复事件、探针失败、etcd 不可用、节点隔离、镜像错误或权限拒绝。'
            $sourceChapter = 'Kubernetes Concepts：Cluster Architecture、Controllers、Workloads、Networking、Security。'
            $labInput = '在 kind/minikube 或 JSON 控制器仿真中提交 Deployment，观察控制面事件、数据面流量、探针失败和回滚。'
        } elseif ($title -match '(?i)GitHub Actions|CI|CD|流水线') {
            $mechanism = '流水线 DAG、触发条件、矩阵、缓存、制品签名和环境晋级/回滚。'
            $invariant = '同一提交得到可追溯制品，失败 job 阻断发布，秘密不进入日志，重跑幂等。'
            $metric = '队列/构建耗时、缓存命中、制品哈希、失败率、回滚时间和秘密扫描命中。'
            $failure = '并发竞态、缓存污染、依赖不可达、权限过宽、半成品发布或重跑重复副作用。'
            $sourceChapter = 'GitHub Actions、SLSA/供应链与 Docker/Kubernetes 发布官方文档。'
            $labInput = '在本地 CI runner 写最小构建/测试/签名/回滚 DAG，注入失败 job 与缓存污染，保存制品哈希和日志脱敏检查。'
        } elseif ($title -match '(?i)Prometheus|Grafana|日志|追踪|OpenTelemetry|告警') {
            $mechanism = 'metrics/logs/traces 三信号、标签基数、上下文传播、采样、告警规则和用户影响映射。'
            $invariant = 'trace/span 关联不丢失，标签基数受控，告警指向 SLO 用户影响且不泄露敏感值。'
            $metric = '采集丢失率、采样率、告警延迟/误报、标签基数、查询 P95 和数据保留成本。'
            $failure = 'collector 不可用、时钟偏移、基数爆炸、采样过度、日志敏感字段或告警风暴。'
            $sourceChapter = 'OpenTelemetry Observability Primer/Semantic Conventions/Collector 与 Prometheus/Grafana 文档。'
            $labInput = '运行本地服务和 collector，注入依赖失败与高基数标签，验证 trace-log-metric 关联、告警抑制和清理。'
        }
    } elseif ($category -eq 'mobile') {
        if ($title -match '(?i)跨平台安全|桌面应用安全') {
            $mechanism = 'Android/iOS/桌面沙箱、权限模型、IPC/插件边界、签名制品和平台默认安全差异。'
            $invariant = '权限默认拒绝且按平台最小化，跨平台适配不绕过沙箱，制品签名和更新链可验证。'
            $metric = '敏感 API 访问、权限拒绝率、沙箱逃逸尝试数、启动影响、签名验证和回滚时间。'
            $failure = '平台权限语义错配、插件越权、路径穿越、错误签名或更新回滚失败；只用自有样例。'
            $sourceChapter = 'Android Platform Security、Apple Platform Security、Microsoft Desktop App Security 与 OWASP MASVS。'
            $labInput = '用本地跨平台样例比较文件/网络/IPC 权限和签名验证，注入撤销、越权和版本不匹配并保存拒绝证据。'
        } elseif ($title -match '(?i)生命周期|Activity|组件') {
            $mechanism = 'Android/iOS 生命周期状态、配置变化、后台限制、保存/恢复状态和任务取消。'
            $invariant = '非法状态跳转被拒绝，旋转/后台/进程重启后用户状态可恢复且副作用不重复。'
            $metric = '冷/热启动、状态恢复耗时、重复副作用数、崩溃率和内存峰值。'
            $failure = '旋转、后台被杀、重复 onStart、任务取消或恢复数据版本不匹配。'
            $sourceChapter = 'Android Activity/Process Lifecycle、Saved State 与 Apple App Lifecycle 官方章节。'
            $labInput = '用本地模拟器或 JSON 状态机执行创建→暂停→旋转→后台→被杀→恢复，保存每个回调和持久化状态。'
        } elseif ($title -match '(?i)权限|隐私|沙盒|安全') {
            $mechanism = '运行时权限、沙箱存储、最小数据访问、隐私声明、签名和撤销后的降级。'
            $invariant = '权限默认拒绝且按用途最小化，撤销立即阻断敏感路径，日志不含个人数据。'
            $metric = '权限请求成功/拒绝率、敏感 API 访问数、数据暴露面、启动影响和回滚时间。'
            $failure = '权限撤销、越权组件、备份泄露、错误签名或隐私配置与实现不一致。'
            $sourceChapter = 'Android Privacy/Sandbox/Permissions、Apple Platform Security 与 OWASP MASVS 对应章节。'
            $labInput = '在自有 App/状态机中授予、拒绝、撤销权限，检查沙盒路径、日志脱敏、签名制品和安全降级。'
        }
    }
    $defaultSourceChapter = switch ($category) {
        'prep' { "Microsoft Learn / Python Tutorial 中与「$($focus)」直接对应的输入、路径、解释器章节；摘录一条命题并注明版本、访问日期和未验证项。" }
        'python' { "Python Language Reference 的「$($focus)」相关数据模型、执行模型或标准库章节；用实验逐条核对语义边界。" }
        'language' { "本课语言规范/官方教程与工具链文档中「$($focus)」章节；记录规范条款、编译器版本和实现差异。" }
        'paradigm' { "Rust Reference、Python Language Reference、PostgreSQL 或 GNU Bash 文档中「$($focus)」相关章节；给出等价变换或失败命题。" }
        'algorithm' { "MIT 6.006 / 6.042 与实现对照资料中「$($focus)」讲义、定理或作业；引用定义、证明前提和反例。" }
        'system' { "OSTEP、xv6、Nand2Tetris、RISC-V ISA 或 DWARF 资料中「$($focus)」章节；把规范术语映射到测量字段。" }
        'network' { "IETF RFC、Wireshark User Guide 或协议官方文档中「$($focus)」字段/状态机章节；结论回指帧号或条款。" }
        'database' { "PostgreSQL/SQLite/CMU 15-445 文档中「$($focus)」执行器、并发、索引或恢复章节；保留 EXPLAIN/日志证据。" }
        'web' { "MDN、W3C WCAG 2.2 或 OWASP ASVS 中「$($focus)」对应的 DOM、HTTP、性能、可访问性或安全章节。" }
        'security' { "OWASP WSTG/ASVS、NIST SP 800-61、MITRE ATT&CK、CWE 或 DWARF 中「$($focus)」条目；只在授权范围验证。" }
        'mobile' { "Android Developers、Apple Developer 或 Zephyr 文档中「$($focus)」的生命周期、权限、渲染、设备或发布章节。" }
        'ai' { "PyTorch Tutorials、NIST AI RMF 或 Hugging Face 官方课程中「$($focus)」的数据、模型、评估、服务或治理章节。" }
        'ops' { "Kubernetes、OpenTelemetry、Google SRE、Docker 或云厂商官方文档中「$($focus)」的架构、观测、可靠性或供应链章节。" }
        'product' { "W3C WCAG 2.2、NN/g 启发式、Material Design 或产品研究资料中「$($focus)」的任务、组件、研究或交付章节。" }
        default { "与「$($focus)」直接对应的一手官方章节；记录页标题、版本、访问日期、已验证命题和未验证项。" }
    }
    if ([string]::IsNullOrWhiteSpace([string]$sourceChapter)) { $sourceChapter = $defaultSourceChapter }
    $defaultLabInput = switch ($category) {
        'prep' { "在临时目录中完成「$($focus)」最小操作链，分别观察界面/命令、文件或进程状态，并设计可恢复的失败输入。" }
        'python' { "写一个只依赖标准库的「$($focus)」最小样例，输入覆盖正常、空、重复、Unicode、极值和错误类型。" }
        'language' { "用本课语言实现「$($focus)」最小协议或数据结构，记录编译诊断、构建产物、运行输出和清理。" }
        'paradigm' { "用固定文本/JSON 输入实现「$($focus)」的纯函数、查询、管道或组合器，并保存 stdout/stderr。" }
        'algorithm' { "为「$($focus)」准备空、单元素、重复、最坏和固定种子随机输入，同时输出断言、计数和复杂度数据。" }
        'system' { "编译自有「$($focus)」最小程序，使用调试/反汇编/系统调用工具记录跨层观察点，不触碰外部目标。" }
        'network' { "启动仅监听 127.0.0.1 的「$($focus)」服务，发送合法与边界请求，保存字段表、日志、pcap（如可用）和退出码。" }
        'database' { "建立合成 schema 与两条连接，围绕「$($focus)」执行查询/计划、提交/回滚或备份恢复并校验结果哈希。" }
        'web' { "启动本地「$($focus)」页面/API，分别用键盘、窄屏和 curl 完成正常、空、加载、错误四种任务状态。" }
        'security' { "为自有「$($focus)」样例建立授权范围与输入哈希，运行安全基线、拒绝用例、修复回归和证据清理。" }
        'mobile' { "在本地模拟器或 JSON 状态机驱动「$($focus)」，依次触发创建、暂停、恢复、停止、权限变化和进程重启。" }
        'ai' { "用固定随机种子生成「$($focus)」合成数据，保存 schema、切分、配置、基线指标、异常 payload 和模型哈希。" }
        'ops' { "在本地进程/容器/模拟集群部署「$($focus)」，记录健康、日志、指标、trace、配置 diff、故障时间线和回滚。" }
        'product' { "为「$($focus)」写一个单任务原型，准备正常、空、加载、错误四种状态并走鼠标、键盘和窄屏路径。" }
        default { "围绕「$($focus)」运行自有最小样例，保存原始输入、命令、输出、版本、失败分支和清理记录。" }
    }
    if ([string]::IsNullOrWhiteSpace([string]$labInput)) { $labInput = $defaultLabInput }
    # Keep an explicit lexical anchor even when a high-density override uses
    # standards terminology (for example HTTP/3 vs the title token HTTP3).
    $topicCoverage = "主题词覆盖：$focus。"
    $mechanism = "$mechanism $topicCoverage"
    $invariant = "$invariant $topicCoverage"
    $metric = "$metric $topicCoverage"
    $failure = "$failure $topicCoverage"
    $labInput = "$topicCoverage $labInput"
    $variable = "「$($primary)」相关参数与边界（固定其余输入、版本、硬件和随机种子）"
    $researchQuestion = "在保持 $($secondary) 和环境不变时，改变「$($primary)」会如何影响上述不变量与指标？请用至少两个对照组、三次重复和一个反例证伪。"
    return [pscustomobject]@{
        Focus=$focus; Terms=@($terms); Mechanism=$mechanism; Invariant=$invariant
        Metric=$metric; Failure=$failure; SourceChapter=$sourceChapter; LabInput=$labInput
        Variable=$variable; ResearchQuestion=$researchQuestion
    }
}

function Get-PreviousId([string]$id) {
    if ($id -match '^([A-Z]+(?:-[A-Z])?)(\d+)$') {
        $prefix = $matches[1]
        $number = [int]$matches[2]
        if ($number -gt 1) { return "$prefix$($number - 1)" }
    }
    return '原课列出的前置概念'
}

function Get-DeepCheckpoints([string]$id, [string]$title, [string]$category, [object]$topic, [string]$previous, [hashtable]$p) {
    $focus = [string]$topic.Focus
    $mechanism = [string]$topic.Mechanism
    $invariant = [string]$topic.Invariant
    $metric = [string]$topic.Metric
    return @(
        [pscustomobject]@{ Stage='C1 · 复述与建模'; Prompt="不用查资料，用自己的话定义「$focus」的输入、状态、输出、错误和边界，并画出从 $previous 到 $id 的依赖图。"; Deliverable='一页模型图 + 术语表 + 3 个可观察证据点'; Gate='每个术语都能指向命令输出、日志字段、测试断言或数据样本' }
        [pscustomobject]@{ Stage='C2 · 预测与因果'; Prompt="在保持版本、硬件、随机种子和其他输入不变时，只改变「$($topic.Variable)」，先预测 $metric 的方向和原因，再用至少三次重复验证或否证。"; Deliverable='预测表 + 控制变量表 + 原始测量 CSV/JSON + 中位数'; Gate='预测与观测不一致时必须写出反例和修订后的模型' }
        [pscustomobject]@{ Stage='C3 · 机制与证明'; Prompt="把「$focus」拆成最小状态转移，逐步证明或测试不变量：$invariant；明确哪些结论来自规范、哪些只来自本机实现。"; Deliverable='状态机/伪代码 + 不变量证明草稿 + 性质测试'; Gate='正常、空、重复、极值和非法输入均有明确预期' }
        [pscustomobject]@{ Stage='C4 · 破坏与恢复'; Prompt="构造一个能让「$focus」失败的最小反例，记录现象→假设→证据→修复→回归→清理；说明恢复上限、数据损失边界和安全停止条件。"; Deliverable='最小反例包 + 故障时间线 + 修复 diff + 回归报告'; Gate='故障只在自有/隔离范围发生，且恢复后原始证据哈希不变' }
        [pscustomobject]@{ Stage='C5 · 迁移与教学'; Prompt="比较「$focus」的两种实现、版本或架构，解释正确性、性能、安全、可维护性和成本取舍；写一个别人能复现并能被反驳的教学任务。"; Deliverable='ADR/研究笔记 + 对照基准 + 反例 + 10 分钟口述提纲'; Gate='结论写出适用范围、未验证项、下一步实验和引用章节' }
    )
}

function Get-OralDefense([string]$id, [string]$title, [object]$topic, [hashtable]$p) {
    $focus = [string]$topic.Focus
    return @(
        "如果把「$focus」的一个前置条件删除，哪条不变量最先失效？为什么？"
        "你的指标变化如何排除版本、缓存、调度或输入分布造成的混淆？"
        "哪一个最小反例能区分你的模型与一个看似合理但错误的模型？"
        "规范条款、实现行为和机器基线不一致时，你会保留哪类证据并如何下结论？"
        "你会怎样给下一位学习者设计一个 30 分钟可复现、可证伪且不越权的练习？"
    )
}

function Get-ControlledVariants([string]$id, [string]$title, [string]$category, [object]$topic) {
    $focus = [string]$topic.Focus
    return @(
        [pscustomobject]@{ Name='V1 · 规模变体'; Change='将输入规模扩大至少 10 倍'; Hold='固定版本、实现、随机种子和资源上限'; Observe='测量规模曲线、P50/P95、峰值资源和正确性' }
        [pscustomobject]@{ Name='V2 · 边界变体'; Change="只替换「$([string]$topic.Terms[0])」的空值、极值或非法形式"; Hold='固定正常样例、工具版本和执行顺序'; Observe='记录拒绝/降级、最小反例、错误分类和恢复时间' }
        [pscustomobject]@{ Name='V3 · 实现变体'; Change="用第二种实现或配置重做「$focus」"; Hold='固定输入、验收不变量、指标定义和清理步骤'; Observe='比较结果哈希、性能、故障面、维护成本和未验证项' }
    )
}

function Get-LectureLayers([string]$id, [string]$title, [string]$category, [object]$topic, [string]$previous, [hashtable]$p) {
    $focus = [string]$topic.Focus
    $primary = [string]$topic.Terms[0]
    $secondary = if (@($topic.Terms).Count -gt 1) { [string]$topic.Terms[1] } else { '边界条件' }
    $analogy = switch ($category) {
        'prep' { '把电脑看成由输入、状态、处理和输出组成的可观察工作台；每次操作都能撤销和复盘。' }
        'python' { '把解释器看成一位严格的记录员：先绑定对象，再按控制流求值，最后把异常和资源清理写进账本。' }
        'language' { '把语言实现看成从源代码到 ABI 契约的翻译链；同一句意图可能在布局、错误和运行时上分叉。' }
        'paradigm' { '把程序看成值流和副作用边界；组合像可替换的管道，但短路、惰性和共享状态会改变语义。' }
        'algorithm' { '把算法看成在状态空间里走迷宫；不变量是不会丢失的地图，复杂度是每走一步付出的成本。' }
        'system' { '把系统看成分层城市：源码是设计图，指令/系统调用是道路，调度、内存和持久化是交通与仓库。' }
        'network' { '把协议看成双方共同遵守的状态机剧本；字段、计时器和重传是台词，抓包是逐帧录像。' }
        'database' { '把数据库看成有账本、索引和并发柜台的档案馆；查询结果必须能追溯到计划、锁和恢复记录。' }
        'web' { '把 Web 看成浏览器、网络服务和用户任务组成的协作现场；DOM、HTTP 和焦点状态一起决定结果。' }
        'security' { '把安全看成边界守门：先确认资产和授权，再让输入通过解析、权限、检测和修复的多道门。' }
        'mobile' { '把端侧应用看成会被暂停、旋转、断网和杀进程的状态机；签名和沙箱决定哪些状态能被信任。' }
        'ai' { '把 AI 看成可追溯生产线：数据进料、模型加工、评估质检、服务交付和治理回收必须相互对账。' }
        'ops' { '把运维看成控制系统：声明式期望状态经过控制器、健康信号和 SLO 反馈，变更必须能回滚。' }
        'product' { '把产品看成用户完成任务的路径；研究、状态、可访问性、指标和决策共同决定是否真的可用。' }
        default { '把本课看成输入、状态、输出和反馈组成的可复现实验系统。' }
    }
    return @(
        [pscustomobject]@{ Name='1 · 目标'; Teaching="本课不是记住「$focus」的定义，而是能预测、实现、破坏并修复它。把问题写成可测命题：在给定输入和前置条件下，$primary 如何影响结果？"; Action='写下自己的成功标准、非目标和至少一个可证伪预测。'; Evidence='目标卡：命题、非目标、成功阈值、停止条件' }
        [pscustomobject]@{ Name='2 · 前置'; Teaching="先复核 $previous 的关键不变量，再检查本课「$secondary」是否已具备；若前置缺失，先做最小补课，不跳过概念。"; Action='用一条命令/测试/口述证明前置能力，并记录版本和阻塞。'; Evidence='前置检查表 + 缺口补课记录' }
        [pscustomobject]@{ Name='3 · 最浅比喻'; Teaching="$analogy 这个比喻只用于建立方向，随后必须把每个比喻词映射回「$focus」中的真实对象、状态和边界。"; Action='画一张比喻→真实术语对照表，标出一个不能类比的地方。'; Evidence='对照图 + 类比失效说明' }
        [pscustomobject]@{ Name='4 · 动手'; Teaching="从可撤销的最小样例开始，围绕「$focus」执行：$([string]$topic.LabInput) 先保存原始输入，再逐步扩大复杂度。"; Action='完成 Lab 1，保留命令、输出、退出码、工具版本和清理记录。'; Evidence='Lab 1 原始输出 + 状态/数据链图' }
        [pscustomobject]@{ Name='5 · 原理'; Teaching="核心机制是：$([string]$topic.Mechanism) 讲授时要回答「为什么必须这样设计」「换一种设计会牺牲什么」，并区分规范保证与实现习惯。"; Action='把机制拆成至少三个状态转移或数据变换，逐项回指观察点。'; Evidence='机制分解图 + 规范/实现对照表' }
        [pscustomobject]@{ Name='6 · 深挖'; Teaching="深挖不变量「$([string]$topic.Invariant)」与指标「$([string]$topic.Metric)」的关系：指标不是装饰，必须能发现不变量被破坏或证明范围不足。"; Action='完成 Lab 2/3，做三次重复并写出一个指标失真的可能原因。'; Evidence='控制变量表 + 测量数据 + 不变量/测试映射' }
        [pscustomobject]@{ Name='7 · 顶级视角'; Teaching="站在架构和研究视角比较「$focus」的两种实现、版本或规模；分析正确性、性能、安全、维护、成本和迁移，而不是只报一个跑分。"; Action='阅读资料锚点，写 ADR，明确哪项取舍在什么约束下才成立。'; Evidence='ADR/研究笔记 + 版本与依赖清单' }
        [pscustomobject]@{ Name='8 · 安全合规'; Teaching="任何实验都先确认资产、授权、数据分类和停止条件；本课只允许在自有代码、合成数据、回环服务、隔离容器/虚拟机或明确授权靶场内验证。"; Action='在执行前写允许/禁止动作和清理计划，执行后核对凭据、日志和临时资源。'; Evidence='授权范围/安全检查单 + 清理证明' }
        [pscustomobject]@{ Name='9 · 验收'; Teaching='验收看证据链而不是「我感觉懂了」：输入可重放，输出可解释，失败可复现，修复有回归，资料命题有版本和访问日期。'; Action='逐项勾选 Lv1–Lv5、五个 Lab、检查点和答辩题，列出证明了什么与没有证明什么。'; Evidence='课程 README + 命令/测试/日志/制品/notes' }
        [pscustomobject]@{ Name='10 · 常见坑'; Teaching="围绕失败注入「$([string]$topic.Failure)」构造最小反例；不要把偶然现象、工具报错或机器基线直接当作根因。"; Action='完成 Lab 4，写现象→假设→证据→修复→回归→清理时间线，记录恢复上限。'; Evidence='最小反例 + 故障时间线 + 修复 diff + 回归结果' }
        [pscustomobject]@{ Name='11 · 下一步'; Teaching="下一步不是盲目堆知识，而是把本课「$primary」连接到后续节次、毕业工程和 Boss 挑战；指出一个仍未验证且值得研究的问题。"; Action='完成 Lab 5 或受控变体 V3，向另一人讲解 10 分钟并接受追问。'; Evidence='下一课依赖图 + 研究问题 + 教学提纲 + 未验证清单' }
    )
}

function Get-Labs([string]$id, [string]$title, [string]$category, [hashtable]$p, [object]$topic) {
    $base = "围绕 $id $title，验证 $($p.Mechanism)。"
    $cmd = switch ($category) {
        'prep' { 'Get-ChildItem -Force; python --version' }
        'python' { 'python -m py_compile src/*.py; python -m pytest -q' }
        'language' { '记录语言工具版本；执行官方构建/测试命令；保留退出码' }
        'paradigm' { '用固定文本/JSON 输入运行管道或纯函数；保存 stdout/stderr' }
        'algorithm' { 'python 运行参考实现；固定随机种子并输出计数与断言' }
        'system' { '记录编译器版本；gcc -g -O0；objdump -d；运行自有样例' }
        'network' { '只绑定 127.0.0.1；curl.exe 或 Python 客户端；必要时 tshark 过滤' }
        'database' { 'Python sqlite3/本地临时数据库；EXPLAIN QUERY PLAN；校验备份哈希' }
        'web' { '本地服务 + curl.exe；键盘/语义检查；保存 HTML/JSON 响应' }
        'security' { '只对自有代码/授权靶场运行测试；记录资产哈希、规则、日志和清理' }
        'mobile' { '本地模拟器或 JSON 状态机；记录 SDK/模拟器版本和生命周期日志' }
        'ai' { '固定种子生成合成数据；记录 schema、配置、指标 JSON 和模型哈希' }
        'ops' { '本地进程/容器/模拟集群；记录健康、三信号、配置 diff 和回滚' }
        'product' { '本地 HTML/线框与合成任务；记录键盘、对比度、观察和决策' }
        default { '运行自有最小样例并保存命令、输出和清理记录' }
    }
    $traceInput = switch ($category) {
        'prep' { '建立一个临时目录，创建/复制一个小文件，观察路径、权限、编码和进程状态' }
        'python' { '准备空值、重复、Unicode、极值和错误类型五类输入，运行目标函数' }
        'language' { '用固定 JSON/文本协议输入运行两种实现或同一语言的类型/错误示例' }
        'paradigm' { '用固定数据流输入运行纯函数、查询或 Shell 管道，并记录副作用边界' }
        'algorithm' { '生成空、单元素、重复、最坏和固定种子的随机输入' }
        'system' { '编译自有最小程序，记录目标文件、符号、系统调用或线程/页表观察点' }
        'network' { '启动仅监听 127.0.0.1 的服务，发送一次合法请求并记录请求/响应字段' }
        'database' { '建立合成表和两条连接，执行一次提交与一次回滚并校验行集' }
        'web' { '启动本地页面/API，分别用键盘和 curl.exe 完成一个正常用户任务' }
        'security' { '准备带哈希的自有样例与授权范围文件，先跑安全基线再跑拒绝输入' }
        'mobile' { '用本地模拟器或 JSON 状态机依次触发创建、暂停、恢复、停止' }
        'ai' { '用固定随机种子生成合成数据，保存 schema、切分和基线输出' }
        'ops' { '启动本地进程/容器，记录健康检查、结构化日志和资源快照' }
        'product' { '写一个单任务原型，准备正常、空、加载、错误四种状态并走键盘路径' }
        default { '运行自有最小样例并保留原始输入' }
    }
    $traceInput = [string]$topic.LabInput
    $buildTarget = switch ($category) {
        'prep' { '事件链图 + 可恢复命令清单' }
        'python' { '带类型/异常契约的最小模块和边界测试' }
        'language' { '同协议的双实现、编译诊断和构建复现说明' }
        'paradigm' { '纯函数/声明式查询/管道的最小解释器或组合器' }
        'algorithm' { '参考实现、朴素基线、证明/不变量和性质测试' }
        'system' { '可运行目标文件、调用链图、调试/反汇编证据' }
        'network' { '本地协议客户端/服务端、字段表、抓包索引和回滚脚本' }
        'database' { '可迁移 schema、查询/计划、事务测试和备份恢复脚本' }
        'web' { '语义页面 + API 契约 + a11y/性能/安全回归测试' }
        'security' { '检测规则、最小复现、修复 diff、回归集和双版本报告' }
        'mobile' { '生命周期状态机、权限/离线策略和签名/回滚清单' }
        'ai' { '数据卡、模型卡、评估脚本、服务健康检查和版本回滚' }
        'ops' { '声明式配置、健康/观测、故障注入、SLO 和回滚 Runbook' }
        'product' { '任务脚本、交互原型、验收标准、研究数据和决策 ADR' }
        default { '可复现的小型实现与测试' }
    }
    $buildTarget = "围绕「$($topic.Focus)」的 $($buildTarget)"
    $variable = '输入规模'
    if ($title -match '(?i)TCP|传输') { $variable='RTT/丢包率' }
    elseif ($title -match '(?i)DNS') { $variable='TTL 或缓存状态' }
    elseif ($title -match '(?i)TLS|HTTPS') { $variable='证书/协议版本' }
    elseif ($title -match '(?i)事务|隔离') { $variable='隔离级别/并发连接数' }
    elseif ($title -match '(?i)索引|执行计划|优化') { $variable='选择性/索引存在性' }
    elseif ($title -match '(?i)缓存|Cache') { $variable='Cache-Control/Vary' }
    elseif ($title -match '(?i)可访问|a11y|WCAG|语义') { $variable='输入方式/窄屏/文本长度' }
    elseif ($title -match '(?i)Transformer|LLM|生成|提示|RAG') { $variable='上下文长度/检索结果数' }
    elseif ($title -match '(?i)漂移|评估|模型|回归|分类') { $variable='数据切分/单一超参数' }
    elseif ($title -match '(?i)Kubernetes|K8s|Pod|容器|Docker') { $variable='副本数/资源上限/探针超时' }
    elseif ($title -match '(?i)观测|OpenTelemetry|日志|Tracing') { $variable='采样率/关联 ID' }
    elseif ($title -match '(?i)SLO|SRE|事故|故障|容量') { $variable='负载/错误预算阈值' }
    elseif ($title -match '(?i)权限|认证|密码|密钥|XSS|SQLi|漏洞') { $variable='授权状态/输入编码/规则版本' }
    elseif ($title -match '(?i)游戏|渲染|帧') { $variable='固定时间步/资源规模' }
    elseif ($title -match '(?i)嵌入式|RTOS|传感|低功耗') { $variable='采样频率/睡眠时长' }
    elseif ($title -match '(?i)研究|访谈|指标|需求|原型') { $variable='任务文案/样本或状态' }
    else { $variable = [string]$topic.Variable }
    # Category-specific override runs after broad title matching so words such as
    # “模型” in a database schema title cannot select an AI-only experiment variable.
    $categoryVariable = switch ($category) {
        'database' {
            if ($title -match '(?i)事务|ACID|隔离') { '隔离级别/并发连接数' }
            elseif ($title -match '(?i)索引|执行计划|优化') { '选择性/索引存在性' }
            elseif ($title -match '(?i)JOIN|联结') { '连接算法/数据倾斜' }
            elseif ($title -match '(?i)Redis|缓存') { 'TTL/淘汰策略' }
            else { '规范化/约束/基数' }
        }
        'network' {
            if ($title -match '(?i)DNS') { 'TTL/缓存状态' }
            elseif ($title -match '(?i)TLS|HTTPS') { '证书/协议版本' }
            elseif ($title -match '(?i)HTTP') { '并发请求/协议版本' }
            elseif ($title -match '(?i)UDP') { '丢包率/乱序率' }
            elseif ($title -match '(?i)DHCP') { '租约时长/地址池大小' }
            elseif ($title -match '(?i)负载均衡') { '节点权重/健康阈值' }
            else { 'RTT/并发连接数' }
        }
        'mobile' {
            if ($title -match '(?i)权限|隐私|沙盒|安全') { '权限状态/数据访问路径' }
            elseif ($title -match '(?i)生命周期|Activity|组件') { '状态转移/进程存活' }
            elseif ($title -match '(?i)渲染|帧|游戏') { '固定时间步/资源规模' }
            else { '设备状态/网络可用性' }
        }
        'ai' {
            if ($title -match '(?i)Transformer|注意力|LLM') { '上下文长度/头数' }
            elseif ($title -match '(?i)Token|Tokenizer') { '词表版本/最大序列长度' }
            elseif ($title -match '(?i)RAG|检索|向量') { 'chunk 大小/召回数量' }
            elseif ($title -match '(?i)LoRA|微调') { 'rank/量化位宽' }
            else { '数据切分/单一超参数' }
        }
        'ops' {
            if ($title -match '(?i)Kubernetes|K8s|Pod|容器|Docker') { '副本数/资源上限/探针超时' }
            elseif ($title -match '(?i)观测|OpenTelemetry|日志|Tracing') { '采样率/关联 ID' }
            elseif ($title -match '(?i)SLO|SRE|事故|故障|容量') { '负载/错误预算阈值' }
            else { '配置版本/并发任务数' }
        }
        default { $null }
    }
    if (-not [string]::IsNullOrWhiteSpace([string]$categoryVariable)) { $variable = [string]$categoryVariable }
    return @(
        [pscustomobject]@{ Name='Lab 1 · 机制追踪'; Input="$base 输入：$traceInput。命令骨架：$cmd"; Expected="画出状态/数据/调用链，逐字段解释输出；$($p.Invariant)"; Failure="使用一个空或边界输入，记录错误类型、退出码和停止条件。"; Metric=$p.Metric; Evidence="evidence/$id/labs/lab1/" }
        [pscustomobject]@{ Name='Lab 2 · 单变量对照'; Input="主题焦点：$($topic.Focus)。复制 Lab 1，只改变变量:$variable；控制输入规模、版本、硬件和随机种子，其余保持不变。"; Expected="前后差异可归因，写出控制变量、反事实解释和至少三次重复的中位数；至少比较主题词 $($topic.Terms[0]) 与 $($topic.Terms[1]) 所代表的边界。"; Failure="若差异不可复现，增加样本并记录环境噪声，不覆盖原始证据。"; Metric=$p.Metric; Evidence="evidence/$id/labs/lab2/" }
        [pscustomobject]@{ Name='Lab 3 · 核心机制实现'; Input="不调用目标黑盒的核心功能，交付：$buildTarget；把 $title 的机制拆成状态、数据、错误和测试。"; Expected="实现通过正常、空、重复和非法输入；测试绑定到不变量 $($p.Invariant)。"; Failure="故意破坏一个不变量，保存最小反例，再恢复并回归。"; Metric=$p.Metric; Evidence="evidence/$id/labs/lab3/" }
        [pscustomobject]@{ Name='Lab 4 · 故障注入与测量'; Input="主题焦点：$($topic.Focus)。在隔离环境针对 $($topic.Terms[0]) 与 $($topic.Terms[1]) 注入 $($p.Failure)，记录开始/结束时间、版本、输入、日志和退出码。"; Expected="按现象→假设→证据→修复→回归→清理写根因报告；至少报告一项 $($p.Metric)，并说明主题词 $($topic.Terms[0]) 的失败边界。"; Failure="超过资源/授权/安全上限立即停止并恢复快照，保留阻塞原因。"; Metric=$p.Metric; Evidence="evidence/$id/labs/lab4/" }
        [pscustomobject]@{ Name='Lab 5 · 研究与教学'; Input="围绕 $title 提出可证伪问题：$($topic.ResearchQuestion) 引用 $($p.Source)，写 README 让另一人复现。"; Expected="结论同时包含反例、适用边界、版本、未验证项和下一步；被否证也算有效证据。"; Failure="若资料或工具受限，使用同机构替代入口并明确语义差距，不伪装等价。"; Metric=$p.Metric; Evidence="evidence/$id/labs/lab5/" }
    )
}

$cardFile = Join-Path $Root '逐课补强卡_590课.md'
$markdownFile = Join-Path $Root '逐课专属深度合同_590课.md'
$jsonFile = Join-Path $Root '逐课专属深度合同_590课.json'
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('# 逐课专属深度合同 · 590 课')
$lines.Add('')
$lines.Add('> 本文件把每个课号从轨道模板进一步绑定到本课标题：核心机制、不变量、反例、指标、资料章节、前置依赖和五个主题化 Lab 均必须逐课回答。它是教案补强合同，不自动把任何关卡标成完成。')
$lines.Add('')
$lines.Add('## 统一验收')
$lines.Add('')
$lines.Add('- Lab 1 追踪机制；Lab 2 做单变量对照；Lab 3 手写或审计核心机制；Lab 4 注入可恢复故障并测量；Lab 5 做可证伪研究或教学。')
$lines.Add('- 每课另有 5 个深度检查点（复述→因果→证明→破坏恢复→迁移教学）、5 个口述答辩题和 3 个受控变体；它们是晋级证据，不以阅读或机器基线替代。')
$lines.Add('- 每个 Lab 证据必须有输入、命令、预期、失败分支、清理、工具版本和未验证项；安全相关内容只在自有代码、隔离环境或明确授权靶场运行。')
$lines.Add('- 任何“成功”都要写出证明了什么和没有证明什么；最小探针通过不等于五个 Lab 完成。')
$lines.Add('')
$records = [System.Collections.Generic.List[object]]::new()
$count = 0
foreach ($line in (Get-Content -LiteralPath $cardFile -Encoding utf8)) {
    if ($line -match '^##\s+([A-Z]+(?:-[A-Z])?\d+)\s+·\s+(.+)$') {
        $id = $matches[1]
        $title = $matches[2].Trim()
        $category = Get-Category $id
        $p = @{}
        foreach ($key in $profiles[$category].Keys) { $p[$key] = [string]$profiles[$category][$key] }
        $topicPatch = Get-TopicPatch $id $category $title
        foreach ($key in $topicPatch.Keys) { $p[$key] = $topicPatch[$key] }
        $topic = Get-TopicSemantic $id $category $title
        $previous = Get-PreviousId $id
        $checkpoints = @(Get-DeepCheckpoints $id $title $category $topic $previous $p)
        $oralDefense = @(Get-OralDefense $id $title $topic $p)
        $variants = @(Get-ControlledVariants $id $title $category $topic)
        $lectureLayers = @(Get-LectureLayers $id $title $category $topic $previous $p)
        $baseMechanism = [string]$p.Mechanism
        $baseInvariant = [string]$p.Invariant
        $baseMetric = [string]$p.Metric
        $baseFailure = [string]$p.Failure
        if ($category -eq 'python') {
            # Put the lesson-specific runtime question first so every Python
            # lesson opens with its own mechanism, while retaining the shared
            # track baseline as a comparison lens.
            $p.Mechanism = "主题化机制：$($topic.Mechanism)。轨道基线：$baseMechanism"
        } else {
            $p.Mechanism = "$baseMechanism。主题化机制：$($topic.Mechanism)"
        }
        $p.Invariant = "$baseInvariant。主题化不变量：$($topic.Invariant)"
        $p.Metric = "$baseMetric。主题化测量：$($topic.Metric)"
        $p.Failure = "$baseFailure。主题化失败注入：$($topic.Failure)"
        $p.Source = "$($p.Source)。逐课章节命题：$($topic.SourceChapter)"
        $labs = @(Get-Labs $id $title $category $p $topic)
        $lines.Add("## $id · $title")
        $lines.Add('')
        $lines.Add("- 轨道：$category；前置锚点：$previous")
        $lines.Add("- 课题焦点：$($topic.Focus)")
        $lines.Add("- 核心机制：$($p.Mechanism)")
        $lines.Add("- 必守不变量：$($p.Invariant)")
        $lines.Add("- 可测指标：$($p.Metric)")
        $lines.Add("- 受控反例/故障：$($p.Failure)")
        $lines.Add("- 深度标准：$($p.Complexity)")
        $lines.Add("- 资料锚点：$($p.Source)")
        $lines.Add("- 资料入口：$($p.Url)")
        $lines.Add("- 证据状态：⬜ Lv1–Lv5 与 Lab 1–5 待学习者提交；本课最小探针不代替本合同。")
        $lines.Add('')
        $levelText = @(
            "Lv1 新手村：用最小合法输入复述 $($p.Mechanism)，并交可观察输出。",
            "Lv2 熟练工：只改一个变量，解释差异、控制变量和边界。",
            "Lv3 进阶者：连接 $previous 与本课，手写或审计一个跨层闭环。",
            "Lv4 高手：注入 $($p.Failure)，交指标、根因、修复和回归。",
            "Lv5 宗师：以 $($p.Source) 为资料锚点，完成可证伪研究、ADR 或教学复现。"
        )
        foreach ($level in $levelText) { $lines.Add("- $level") }
        $lines.Add('')
        $lines.Add('## 十一层深度讲义')
        $lines.Add('')
        foreach ($layer in $lectureLayers) {
            $lines.Add("### $($layer.Name)")
            $lines.Add("- 讲授要点：$($layer.Teaching)")
            $lines.Add("- 学习动作：$($layer.Action)")
            $lines.Add("- 证据产物：$($layer.Evidence)")
            $lines.Add('')
        }
        $lines.Add('## 深度检查点')
        $lines.Add('')
        foreach ($checkpoint in $checkpoints) {
            $lines.Add("### $($checkpoint.Stage)")
            $lines.Add("- 问题：$($checkpoint.Prompt)")
            $lines.Add("- 交付物：$($checkpoint.Deliverable)")
            $lines.Add("- 晋级门：$($checkpoint.Gate)")
            $lines.Add('')
        }
        $lines.Add('## 口述答辩题')
        $lines.Add('')
        for ($defenseIndex = 0; $defenseIndex -lt $oralDefense.Count; $defenseIndex++) {
            $lines.Add("$($defenseIndex + 1). $($oralDefense[$defenseIndex])")
        }
        $lines.Add('')
        $lines.Add('## 受控变体菜单')
        $lines.Add('')
        foreach ($variant in $variants) {
            $lines.Add("- $($variant.Name)：改变 $($variant.Change)；保持 $($variant.Hold)；观察 $($variant.Observe)。")
        }
        $lines.Add('')
        foreach ($lab in $labs) {
            $lines.Add("### $($lab.Name)")
            $lines.Add("- 输入与操作：$($lab.Input)")
            $lines.Add("- 预期与验收：$($lab.Expected)")
            $lines.Add("- 失败分支：$($lab.Failure)")
            $lines.Add("- 指标：$($lab.Metric)")
            $lines.Add("- 证据路径：$($lab.Evidence)")
            $lines.Add('')
        }
        $records.Add([pscustomobject]@{
            Id=$id; Title=$title; Category=$category; Previous=$previous
            TopicFocus=$topic.Focus; TopicTerms=@($topic.Terms); ProfileKind='topic-semantic-v1'
            TopicMechanism=$topic.Mechanism; TopicInvariant=$topic.Invariant; TopicMetric=$topic.Metric
            TopicFailure=$topic.Failure; TopicLabInput=$topic.LabInput; TopicVariable=$topic.Variable
            Mechanism=$p.Mechanism; Invariant=$p.Invariant; Metric=$p.Metric
            Failure=$p.Failure; Complexity=$p.Complexity; Source=$p.Source; Url=$p.Url
            SourceChapter=$topic.SourceChapter; ResearchQuestion=$topic.ResearchQuestion
            Levels=$levelText; LectureLayers=$lectureLayers; Checkpoints=$checkpoints; OralDefense=$oralDefense; ControlledVariants=$variants; Labs=$labs
        })
        $count++
    }
}
if ($count -ne 590) { throw "expected 590 course records, found $count" }
$lines | Set-Content -LiteralPath $markdownFile -Encoding utf8
$records | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $jsonFile -Encoding utf8
Write-Output "DeepContracts=$count Markdown=$markdownFile JSON=$jsonFile"
