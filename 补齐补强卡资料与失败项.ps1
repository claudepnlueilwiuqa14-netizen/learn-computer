param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest

function Get-Source([string]$id) {
    if ($id -match '^PRE') { return 'Microsoft Learn Windows 基础/无障碍：https://learn.microsoft.com/windows/；Git Documentation：https://git-scm.com/doc' }
    if ($id -match '^PY') { return 'Python Tutorial：https://docs.python.org/3/tutorial/；Python Language Reference：https://docs.python.org/3/reference/' }
    if ($id -match '^C\d+') { return 'C 标准库与编译器文档；GCC：https://gcc.gnu.org/onlinedocs/；Clang：https://clang.llvm.org/docs/' }
    if ($id -match '^CPP') { return 'cppreference：https://en.cppreference.com/w/；C++ Core Guidelines：https://isocpp.github.io/CppCoreGuidelines/' }
    if ($id -match '^JV') { return 'Dev.java Learn：https://dev.java/learn/；JVM Specification：https://docs.oracle.com/javase/specs/' }
    if ($id -match '^JS') { return 'MDN Web Docs：https://developer.mozilla.org/en-US/docs/Web；Node.js Docs：https://nodejs.org/docs/latest/api/' }
    if ($id -match '^GO') { return 'A Tour of Go：https://go.dev/tour/；Go Memory Model：https://go.dev/ref/mem' }
    if ($id -match '^RS') { return 'The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/' }
    if ($id -match '^(PAR|OTH|SQL|SH)') { return 'GNU Bash Reference：https://www.gnu.org/software/bash/manual/；PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/ / https://www.sqlite.org/docs.html' }
    if ($id -match '^DSA') { return 'MIT 6.006：https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/；MIT 6.042：https://courses.csail.mit.edu/6.042/' }
    if ($id -match '^(COMP|ASM|OS|CMP)') { return 'OSTEP：https://pages.cs.wisc.edu/~remzi/OSTEP/；Nand2Tetris：https://www.nand2tetris.org/；xv6：https://pdos.csail.mit.edu/6.1810/' }
    if ($id -match '^NET') { return 'RFC Editor：https://www.rfc-editor.org/；Wireshark User Guide：https://www.wireshark.org/docs/wsug_html/' }
    if ($id -match '^DB') { return 'PostgreSQL Documentation：https://www.postgresql.org/docs/current/；CMU 15-445：https://15445.courses.cs.cmu.edu/' }
    if ($id -match '^(FE|BE)') { return 'MDN Web Docs：https://developer.mozilla.org/en-US/docs/Web；W3C WCAG：https://www.w3.org/TR/WCAG22/；OWASP ASVS：https://owasp.org/www-project-application-security-verification-standard/' }
    if ($id -match '^SEC') { return 'OWASP ASVS/Top 10：https://owasp.org/；NIST NICE：https://www.nist.gov/itl/applied-cybersecurity/nice；CWE：https://cwe.mitre.org/' }
    if ($id -match '^MOB') { return 'Android Developers：https://developer.android.com/；Apple Developer：https://developer.apple.com/documentation/；Microsoft Learn：https://learn.microsoft.com/' }
    if ($id -match '^DAT') { return 'PyTorch Tutorials：https://pytorch.org/tutorials/；Hugging Face Course：https://huggingface.co/learn/nlp-course；NIST AI RMF：https://www.nist.gov/itl/ai-risk-management-framework' }
    if ($id -match '^OPS') { return 'Kubernetes Concepts：https://kubernetes.io/docs/concepts/；Docker Docs：https://docs.docker.com/；Google SRE Books：https://sre.google/books/' }
    if ($id -match '^PD') { return 'W3C WCAG：https://www.w3.org/TR/WCAG22/；NN/g Heuristics：https://www.nngroup.com/articles/ten-usability-heuristics/；Material Design：https://m3.material.io/' }
    return '使用该主题的一手官方文档；记录页面标题、章节、版本、访问日期和未验证项。'
}

function Get-Failure([string]$id) {
    if ($id -match '^SEC') { return '只在自有代码、隔离虚拟机、明确授权靶场或 CTF 制造一个无害拒绝路径；保存授权范围、请求/日志、修复回归和清理记录，不保存真实凭据。' }
    if ($id -match '^NET') { return '仅在 127.0.0.1 或自有隔离网络制造端口关闭、超时、丢包、DNS 错误或 MTU 变化；用命令/pcap 记录“现象→假设→证据→修复→回归”。' }
    if ($id -match '^DB') { return '仅在本地数据库制造约束冲突、锁等待、死锁、崩溃恢复或副本延迟；保存 SQL、时间线、日志、回滚与清理证据。' }
    if ($id -match '^DAT') { return '使用合成数据制造过拟合、泄漏、漂移或评估污染；固定随机种子，保存数据/模型版本、指标、对照和修复。' }
    if ($id -match '^OPS') { return '在本机容器或测试 VM 制造配置错误、资源耗尽、依赖不可用或部署中断；记录指标/日志/trace、恢复和回滚，不触碰生产系统。' }
    if ($id -match '^MOB') { return '在模拟器或自有设备制造离线、低电量、权限拒绝、崩溃或升级中断；保存日志、截图、签名/回滚和清理证据。' }
    if ($id -match '^PD') { return '用合成用户和原型制造空状态、慢响应、键盘操作或低对比度问题；记录任务成功率、a11y 检查和改版对照。' }
    if ($id -match '^(COMP|ASM|OS|CMP)') { return '在隔离程序中制造可恢复的错误码、竞态、缺页、崩溃或 ABI 差异；用调试器/系统工具留证并清理。' }
    if ($id -match '^DSA') { return '构造空输入、重复值、最坏规模、溢出或随机性反例；保存失败用例、性质测试输出、修复和复杂度解释。' }
    return '改变一个输入或环境条件制造可恢复失败，记录“现象→假设→证据→修复→回归→清理”。'
}

$headingPattern = '^##\s+((?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|SEC|MOB|DAT|OPS|PD)(?:-[A-Z]+)?\d*)\s*[· ]'
$files = Get-ChildItem -LiteralPath $Root -File -Filter '*补强.md'
$changed = 0
$cards = 0
foreach ($file in $files) {
    $lines = @(Get-Content -LiteralPath $file.FullName -Encoding utf8)
    $out = [System.Collections.Generic.List[string]]::new()
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -match $headingPattern) {
            $id = $matches[1]
            $end = $i + 1
            while ($end -lt $lines.Count -and $lines[$end] -notmatch '^##\s+') { $end++ }
            $section = if ($end -gt ($i + 1)) { $lines[($i + 1)..($end - 1)] } else { @() }
            $hasSource = @($section | Where-Object { $_ -match '资料锚点|资料入口' }).Count -gt 0
            $hasFailure = @($section | Where-Object { $_ -match '必做失败实验|失败实验' }).Count -gt 0
            $out.Add($line)
            if (-not $hasSource) {
                $out.Add('')
                $out.Add("**资料锚点**：$(Get-Source $id)")
                $out.Add('资料记录：使用时写明页面标题、章节、版本/提交日期、访问日期、适用范围和未验证项。')
            }
            if (-not $hasFailure) {
                $out.Add("**必做失败实验**：$(Get-Failure $id)")
            }
            $cards++
        } else {
            $out.Add($line)
        }
    }
    $newText = ($out -join [Environment]::NewLine) + [Environment]::NewLine
    $oldText = (Get-Content -LiteralPath $file.FullName -Raw -Encoding utf8)
    if ($newText -ne $oldText) {
        $newText | Set-Content -LiteralPath $file.FullName -Encoding utf8
        $changed++
    }
}
Write-Output "Cards=$cards ChangedFiles=$changed"
