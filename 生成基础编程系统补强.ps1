param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest

function Read-Courses([string]$path, [string]$kind) {
    $pattern = switch ($kind) {
        'PRE' { '^#{1,3}\s+(PRE\d+)\s*[· ]+(.+)$' }
        'LANG' { '^#{1,3}\s+((?:PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH)\d+)\s*[· ]+(.+)$' }
        'DSA' { '^#{1,3}\s+(DSA\d+)\s*[· ]+(.+)$' }
        'SYS' { '^#{1,3}\s+((?:COMP|ASM|OS|CMP)\d+)\s*[· ]+(.+)$' }
    }
    $result = @()
    foreach ($line in (Get-Content -LiteralPath $path)) {
        if ($line -match $pattern) { $result += [pscustomobject]@{Id=$matches[1];Title=$matches[2].Trim()} }
    }
    return $result
}

function Track([string]$kind, [string]$id, [string]$title, [string]$sourceFile) {
    if ($kind -eq 'PRE') { return '预备与环境' }
    if ($kind -eq 'DSA') { return '算法与数学' }
    if ($kind -eq 'SYS') { return '计算机系统' }
    if ($sourceFile -match '方向1a_编程Python') { return 'Python 与通用编程' }
    if ($id -match '^RS') { return 'Rust 与内存安全' }
    if ($id -match '^CPP') { return 'C++ 与零成本抽象' }
    if ($id -match '^C\d+') { return 'C 与系统接口' }
    if ($id -match '^JV') { return 'Java 与虚拟机' }
    if ($id -match '^JS') { return 'JavaScript 与运行时' }
    if ($id -match '^GO') { return 'Go 与并发服务' }
    if ($id -match '^(SQL|SH)') { return 'SQL 与自动化脚本' }
    if ($id -match '^PAR') { return '编程范式与抽象' }
    if ($title -match 'Rust|所有权|借用|生命周期|trait|async|unsafe|宏') { return 'Rust 与内存安全' }
    if ($title -match 'C\+\+|模板|STL|智能指针|移动语义') { return 'C++ 与零成本抽象' }
    if ($title -match '^C |C 入门|指针|内存|数组|结构体|预处理|malloc|文件 I/O|位运算|函数指针|未定义|汇编|构建|防御') { return 'C 与系统接口' }
    if ($title -match 'Java|JVM|GC|Maven|Gradle|集合|并发 JUC') { return 'Java 与虚拟机' }
    if ($title -match 'JavaScript|JS|DOM|Promise|原型|Node|事件循环|TypeScript|模块') { return 'JavaScript 与运行时' }
    if ($title -match 'Go|goroutine|channel|接口|net/http|go mod') { return 'Go 与并发服务' }
    if ($title -match 'SQL|Shell|Bash|PowerShell|正则|管道|重定向') { return 'SQL 与自动化脚本' }
    if ($title -match '范式|命令式|面向对象|函数式|泛型|响应式|Actor|CSP') { return '编程范式与抽象' }
    return 'Python 与通用编程'
}

function Focus([string]$track, [string]$title) {
    switch ($track) {
        '预备与环境' { return @("操作链路：$title 如何从用户动作、操作系统事件、文件/进程到可观察结果？", '边界实验：路径错误、权限不足、版本差异、输入疲劳和恢复失败时如何继续？', '迁移目标：把本课能力连接到后续编程、网络和安全课，留下可复现证据。') }
        '算法与数学' { return @("模型与证明：$title 的输入、状态、不变量、正确性和复杂度如何写成可检验命题？", '反例实验：最坏输入、重复值、空输入、溢出、随机性、缓存和规模变化会怎样？', '工程取舍：时间、空间、常数、可读性、并行性和实现风险如何测量？') }
        '计算机系统' { return @("跨层链路：$title 如何从源码、编译/链接、指令、系统调用到硬件/内核事件？", '故障实验：竞态、崩溃、缺页、ABI 不一致、缓存未命中或持久化中断如何取证？', '工程取舍：性能、正确性、可移植性、安全、可调试性和恢复成本如何权衡？') }
        'Rust 与内存安全' { return @("不变量：$title 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？", '边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？', '工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？') }
        'C++ 与零成本抽象' { return @("对象模型：$title 如何落到布局、构造析构、vtable、模板实例化和移动语义？", '边界实验：悬空引用、异常安全、ODR、ABI、并发和未定义行为如何暴露？', '工程取舍：抽象、性能、编译时间、二进制兼容和团队可维护性如何权衡？') }
        'C 与系统接口' { return @("内存/ABI：$title 如何映射到指针、对齐、调用约定、系统调用和文件描述符？", '边界实验：越界、整数溢出、资源泄漏、未定义行为和错误码如何被测试发现？', '工程取舍：可控性、性能、可移植性、安全加固和维护成本如何量化？') }
        'Java 与虚拟机' { return @("运行时链路：$title 如何经过字节码、类加载、栈帧、GC、线程和 JIT？", '边界实验：堆压力、锁竞争、异常路径、类路径冲突和版本不兼容如何诊断？', '工程取舍：吞吐、延迟、内存、可观测性、兼容性和开发效率如何权衡？') }
        'JavaScript 与运行时' { return @("事件链路：$title 如何经过词法作用域、任务队列、DOM/Node、Promise 和 I/O？", '边界实验：竞态、微任务饥饿、原型污染、类型边界、内存泄漏和模块冲突如何发现？', '工程取舍：交互、并发、兼容性、类型安全、包体和供应链如何量化？') }
        'Go 与并发服务' { return @("调度链路：$title 如何经过 goroutine、GMP、channel、接口、net/http 和运行时？", '边界实验：竞态、泄漏、阻塞、取消、背压、错误传播和版本兼容如何处理？', '工程取舍：简单性、吞吐、尾延迟、部署、可观测性和生态如何权衡？') }
        'SQL 与自动化脚本' { return @("解释链路：$title 如何由声明/命令、解析、管道、执行器和副作用形成结果？", '边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？', '工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？') }
        '编程范式与抽象' { return @("抽象链路：$title 如何改变状态、数据流、副作用、并发和可测试性？", '反例实验：抽象泄漏、性能退化、调试困难、共享状态和错误传播如何暴露？', '工程取舍：表达力、学习成本、性能、可组合性和团队协作如何权衡？') }
        default { return @("程序链路：$title 如何由输入、状态、控制流、数据结构、函数和 I/O 形成结果？", '边界实验：空值、错误、规模、编码、路径、资源耗尽和重复执行如何处理？', '工程取舍：正确性、可读性、测试、性能、安全和维护成本如何量化？') }
    }
}

function Labs([string]$track, [string]$title) {
    switch ($track) {
        '预备与环境' { return @('最小操作：按原课完成一次环境/文件/终端任务，保存截图或语音说明。','受控变体：改变路径、输入方式、窗口/权限条件，记录差异和恢复方法。','综合任务：把本课与一个前置能力连接，完成可重复的小流程并写检查表。','排障演练：故意制造一个非破坏性错误，按“现象→假设→证据→修复”记录。','开放研究：写一页学习环境/护手/备份/安全改进建议，并让他人按步骤复现。') }
        '算法与数学' { return @('最小实现：手写本课结构/算法，含空输入、边界和复杂度注释。','性质测试：用随机/生成输入验证不变量、排序、可达性或代价上界。','综合任务：连接一个前置结构或算法，比较两种方案和最坏输入。','基准实验：改变规模和分布，测时间、空间、分配、缓存或并行影响。','开放研究：写证明/反例/实验报告，提出一个优化假设并验证。') }
        '计算机系统' { return @('最小链路：编译/运行本课示例，保存源码、编译参数、符号和输出。','受控故障：制造安全的崩溃/竞态/缺页/文件中断，保存 gdb/系统工具证据。','跨层实验：把源码、汇编、系统调用、内存或文件系统串成一张图。','性能/恢复：用 profiler/基准/故障注入测一个指标并修复回归。','开放研究：实现简化子系统或写内核/编译器/分配器设计 ADR，包含限制。') }
        'Rust 与内存安全' { return @('最小实现：用 cargo 跑通本课 API，并写单元测试。','边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。','综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。','性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。','开放研究：写安全不变量、替代设计、生态限制和迁移建议。') }
        'C++ 与零成本抽象' { return @('最小实现：完成类/模板/容器/智能指针示例，开启警告和调试符号。','边界变体：改变值类别、异常、生命周期、并发或 ABI，保存编译器/运行时证据。','综合任务：用 RAII、移动、模板和测试构建一个小组件。','性能/安全审计：比较拷贝/移动、分配、UBSan/ASan 和二进制大小。','开放研究：写对象模型/ABI/团队规范 ADR，说明何时不用复杂抽象。') }
        'C 与系统接口' { return @('最小实现：用 gcc/clang 编译带 `-Wall -Wextra -g` 的示例。','边界变体：测试空指针、越界、错误码、资源泄漏和整数边界，保存 sanitizer 结果。','综合任务：连接文件 I/O、进程/线程、网络或内存映射中的两个主题。','性能/加固：比较优化级别、缓存/分配器和 canary/PIE/RELRO 等防护。','开放研究：写 C API 设计、所有权约定、兼容性和迁移到 Rust 的建议。') }
        'Java 与虚拟机' { return @('最小实现：用 JDK 编译/运行/测试本课示例，保存版本和字节码。','边界变体：制造堆压力、异常、锁竞争或类路径冲突，记录 jstack/jmap/日志。','综合任务：连接集合、线程池、JUC、I/O 和数据库中的两个主题。','性能审计：做 JMH/基准，比较 GC、延迟、吞吐和内存。','开放研究：写 JVM 参数、可观测性、升级和兼容 ADR。') }
        'JavaScript 与运行时' { return @('最小实现：在浏览器或 Node 运行本课示例，保存 console/Network/版本。','边界变体：制造微任务饥饿、竞态、类型边界、原型/模块冲突或泄漏。','综合任务：把 DOM/API/状态/测试或 Node I/O 连接成完整流程。','性能/安全审计：用 DevTools、TypeScript、依赖扫描和性能记录修复一项问题。','开放研究：写事件循环/包边界/浏览器安全和替代方案笔记。') }
        'Go 与并发服务' { return @('最小实现：`go test` 跑通本课服务/包并保存输出。','边界变体：用 `-race`、超时、取消、慢消费者和重启测试失败路径。','综合任务：连接 goroutine/channel、HTTP、上下文、日志和指标。','性能审计：做 benchmark/pprof，比较分配、吞吐、P95 和 goroutine 数。','开放研究：写协议/错误/部署/兼容 ADR，说明何时不用并发。') }
        'SQL 与自动化脚本' { return @('最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。','边界变体：空值、空格/引号、失败管道、重复执行和权限错误。','综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。','安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。','开放研究：写可移植、可回滚、可观测的自动化 Runbook。') }
        '编程范式与抽象' { return @('最小实现：用两种范式写同一小问题，保存代码和测试。','受控变体：改变状态共享、数据规模或错误模型，比较可读性和结果。','综合任务：把纯函数/对象/事件/泛型/actor 中两种组合起来。','性能审计：测分配、调用、并发和调试成本，找出抽象泄漏。','开放研究：写“何时用哪种范式”的决策矩阵和教学例子。') }
        default { return @('最小实现：按原课写一个可运行程序，带输入、输出和测试。','边界变体：加入错误、空值、规模、编码、路径或重复执行。','综合任务：连接数据结构、文件、网络、并发或测试中的两个主题。','性能/安全审计：测一个瓶颈，检查输入、资源、依赖和日志。','开放研究：写设计决策、反例、复现步骤和下一步实验。') }
    }
}

function Source([string]$track) {
    switch ($track) {
        '预备与环境' { return 'Microsoft Learn Windows 基础/无障碍：https://learn.microsoft.com/windows/；Git Documentation：https://git-scm.com/doc' }
        'Python 与通用编程' { return 'Python Tutorial：https://docs.python.org/3/tutorial/；Python Language Reference：https://docs.python.org/3/reference/' }
        'C 与系统接口' { return 'GCC/Clang 官方文档：https://gcc.gnu.org/onlinedocs/；https://clang.llvm.org/docs/' }
        'C++ 与零成本抽象' { return 'cppreference：https://en.cppreference.com/w/；C++ Core Guidelines：https://isocpp.github.io/CppCoreGuidelines/' }
        'Java 与虚拟机' { return 'Dev.java Learn：https://dev.java/learn/；JVM Specification：https://docs.oracle.com/javase/specs/' }
        'JavaScript 与运行时' { return 'MDN Web Docs：https://developer.mozilla.org/en-US/docs/Web；Node.js Docs：https://nodejs.org/docs/latest/api/' }
        'Go 与并发服务' { return 'A Tour of Go：https://go.dev/tour/；Go Memory Model：https://go.dev/ref/mem' }
        'Rust 与内存安全' { return 'The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/' }
        'SQL 与自动化脚本' { return 'PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/' }
        '编程范式与抽象' { return 'Python Language Reference：https://docs.python.org/3/reference/；Rust Book：https://doc.rust-lang.org/book/；Go/JS 官方语言规范' }
        '算法与数学' { return 'MIT 6.006：https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/；MIT 6.042：https://courses.csail.mit.edu/6.042/' }
        '计算机系统' { return 'OSTEP：https://pages.cs.wisc.edu/~remzi/OSTEP/；Nand2Tetris：https://www.nand2tetris.org/；xv6：https://pdos.csail.mit.edu/6.1810/' }
        default { return '使用该主题的一手官方文档，记录页面标题、章节、版本、访问日期和未验证项。' }
    }
}

function Failure([string]$track) {
    switch ($track) {
        '预备与环境' { return '在自己的学习目录制造路径不存在、权限不足或版本差异，记录“现象→假设→证据→修复→清理”。' }
        '算法与数学' { return '构造空输入、重复值、最坏规模、溢出或随机性反例，保存失败用例、性质测试输出和修复。' }
        '计算机系统' { return '在隔离程序中制造可恢复的错误码、竞态、缺页、崩溃或 ABI 差异，用调试器/系统工具留证。' }
        'Rust 与内存安全' { return '在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。' }
        'C++ 与零成本抽象' { return '在自有示例中制造悬空引用、异常路径、ODR/ABI 差异或竞态，使用 ASan/UBSan 和回归测试。' }
        'C 与系统接口' { return '在隔离程序中测试空指针、越界、整数边界、资源泄漏和错误码，保存 sanitizer 输出并清理。' }
        'Java 与虚拟机' { return '在本地程序制造堆压力、锁竞争、异常路径或类路径冲突，保存 jstack/日志和恢复步骤。' }
        'JavaScript 与运行时' { return '在自己的浏览器/Node 项目制造竞态、微任务饥饿、类型边界、模块冲突或泄漏，保存 DevTools 证据。' }
        'Go 与并发服务' { return '在本地服务制造竞态、阻塞、取消、背压或慢消费者，使用 -race/pprof 记录并恢复。' }
        'SQL 与自动化脚本' { return '在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。' }
        '编程范式与抽象' { return '改变状态共享、错误模型或数据规模，记录抽象泄漏、性能退化和调试成本。' }
        default { return '改变一个输入或环境条件制造可恢复失败，记录“现象→假设→证据→修复→回归→清理”。' }
    }
}

function Commands([string]$track) {
    switch ($track) {
        '预备与环境' { return @('Get-ChildItem -Force','python --version','code .') }
        'Python 与通用编程' { return @('python -m pytest -q','python -m compileall .','git diff --check') }
        'C 与系统接口' { return @('gcc -Wall -Wextra -g lab.c -o lab','./lab','gdb ./lab') }
        'C++ 与零成本抽象' { return @('c++ -std=c++20 -Wall -Wextra -g lab.cpp -o lab','./lab','ASAN_OPTIONS=detect_leaks=1 ./lab') }
        'Java 与虚拟机' { return @('javac --release 21 Main.java','java Main','jcmd <pid> VM.flags') }
        'JavaScript 与运行时' { return @('node --version','node --test','npm audit --omit=dev') }
        'Go 与并发服务' { return @('go test ./...','go test -race ./...','go test -bench . ./...') }
        'Rust 与内存安全' { return @('cargo test','cargo clippy -- -D warnings','cargo miri test') }
        'SQL 与自动化脚本' { return @('sqlite3 lab.db','EXPLAIN QUERY PLAN ...','bash -n script.sh') }
        '编程范式与抽象' { return @('python -m pytest -q','cargo test','go test ./...') }
        '算法与数学' { return @('python benchmark.py --n 1000','python -m pytest -q','保存 JSON/CSV 基准') }
        '计算机系统' { return @('gcc -g -O0 lab.c -o lab','gdb ./lab','objdump -d ./lab') }
        default { return @('记录输入与输出','运行自动化测试','保存失败复现') }
    }
}

function Write-Track([string]$kind, [string]$fileName, [string]$heading, [string]$outputName) {
    $source = Join-Path $Root $fileName
    $courses = Read-Courses $source $kind
    $out = [System.Collections.Generic.List[string]]::new()
    $out.Add("# $heading")
    $out.Add('')
    $out.Add('> 这是预备、编程、算法和底层系统的主题化补强层。原课负责 11 段讲解，本文件把每课落到可运行实验、反例、测量、故障和原创交付。')
    $out.Add('> 证据目录统一为 `evidence/<课号>/README.md`、`commands.txt`、`tests/`、`artifacts/`、`notes.md`；只使用自己的机器、代码、合成数据和隔离环境。')
    $out.Add('')
    $out.Add('## 五级闯关合同')
    $out.Add('- Lv1：最小闭环可运行，交输出/截图/测试。')
    $out.Add('- Lv2：单变量变体，交前后对比和失败解释。')
    $out.Add('- Lv3：跨课综合，交自动化测试、日志、设计图和清理。')
    $out.Add('- Lv4：造轮子、性能/安全/可靠性审计，交基线、指标、根因和回归。')
    $out.Add('- Lv5：开放研究、教学或架构决策，交 ADR/证明/反例/复现和限制。')
    $out.Add('')
    foreach ($course in $courses) {
        $track = Track $kind $course.Id $course.Title $fileName
        $focus = Focus $track $course.Title
        $labs = Labs $track $course.Title
        $source = Source $track
        $failure = Failure $track
        $commands = Commands $track
        $out.Add("## $($course.Id) · $($course.Title)")
        $out.Add('')
        $out.Add(("- 原课文件：{0}" -f $fileName))
        $out.Add("- 主题轨道：$track")
        $out.Add("- 资料锚点：$source")
        $out.Add('- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。')
        $out.Add('- 深挖问题：')
        foreach ($q in $focus) { $out.Add("  - $q") }
        $out.Add('- 闯关交付：')
        $out.Add(("  - Lv1：{0}/lv1 最小运行证据。" -f $course.Id))
        $out.Add(("  - Lv2：{0}/lv2 单变量变体、对比和失败解释。" -f $course.Id))
        $out.Add(("  - Lv3：{0}/lv3 跨课测试、日志、设计图和清理。" -f $course.Id))
        $out.Add(("  - Lv4：{0}/lv4 基线、指标、审计/优化/回归。" -f $course.Id))
        $out.Add(("  - Lv5：{0}/lv5 开放研究、证明、教学或 ADR。" -f $course.Id))
        $out.Add('- 五个 Lab：')
        $n = 1
        foreach ($lab in $labs) { $out.Add("  - Lab $n · $lab"); $n++ }
        $out.Add("- 必做失败实验：$failure")
        $out.Add(("- 推荐命令骨架：{0}" -f (($commands | ForEach-Object { "``$_``" }) -join '、')))
        $out.Add('- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。')
        $out.Add('')
    }
    $out | Set-Content -LiteralPath (Join-Path $Root $outputName) -Encoding UTF8
    return $courses.Count
}

$counts = @{}
$counts.PRE = Write-Track 'PRE' '教案_预备层.md' '预备层 · PRE0–PRE8 闯关与实战补强' '预备层_闯关与实战补强.md'
$counts.LANG1 = Write-Track 'LANG' '教案_方向1a_编程Python.md' '方向 1a · Python 闯关与实战补强' '方向1a_Python_闯关与实战补强.md'
$counts.LANG2 = Write-Track 'LANG' '教案_方向1b_多语言_C_CPP_Java_JS_Go.md' '方向 1b · 多语言闯关与实战补强' '方向1b_多语言_闯关与实战补强.md'
$counts.LANG3 = Write-Track 'LANG' '教案_方向1c_Rust_范式_SQL_Shell.md' '方向 1c · Rust/范式/SQL/Shell 闯关与实战补强' '方向1c_Rust范式SQLShell_闯关与实战补强.md'
$counts.DSA = Write-Track 'DSA' '教案_方向2_算法与数据结构.md' '方向 2 · 算法与数据结构闯关与实战补强' '方向2_算法_闯关与实战补强.md'
$counts.SYS = Write-Track 'SYS' '教案_方向3_底层系统.md' '方向 3 · 底层系统闯关与实战补强' '方向3_底层系统_闯关与实战补强.md'
$counts.GetEnumerator() | ForEach-Object { Write-Output "$($_.Key): $($_.Value) cards" }
