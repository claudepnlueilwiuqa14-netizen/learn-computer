param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest

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
$sourceFiles = foreach ($name in $fileOrder) {
    Get-Item -LiteralPath (Join-Path $Root $name) -ErrorAction SilentlyContinue
}
$pattern = '^#{1,3}\s+((?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|SEC|MOB|DAT|OPS|PD)(?:-[A-Z]+)?\d*)\s*[· ]+(.+)$'
$records = @()
foreach ($file in $sourceFiles) {
    foreach ($line in (Get-Content -LiteralPath $file.FullName -Encoding utf8)) {
        if ($line -match $pattern) {
            $records += [pscustomobject]@{ Id=$matches[1]; Title=$matches[2].Trim(); File=$file.Name }
        }
    }
}

function Macro([string]$id) {
    if ($id -match '^(PRE\d+|PY\d+|C\d+|CPP\d+|JV\d+|JS\d+|GO\d+|RS\d+|PAR\d+|OTH\d+|SQL\d+|SH\d+)$') { return 'I · 预备与编程' }
    if ($id -match '^DSA') { return 'II · 算法与数学' }
    if ($id -match '^(COMP|ASM|OS|CMP)') { return 'III · 计算机系统' }
    if ($id -match '^NET') { return 'IV · 网络与分布式' }
    if ($id -match '^DB') { return 'V · 数据库与数据工程' }
    if ($id -match '^DAT(\d+)$' -and [int]$matches[1] -le 24) { return 'V · 数据库与数据工程' }
    if ($id -match '^(FE|BE|PD)') { return 'VI · Web、产品与人机工程' }
    if ($id -match '^SEC') { return 'VII · 安全、逆向与可信工程' }
    return 'VIII · AI、云原生与端侧工程'
}

function Supplement([string]$id) {
    switch -Regex ($id) {
        '^PRE' { return '预备层_闯关与实战补强.md' }
        '^PY' { return '方向1a_Python_闯关与实战补强.md' }
        '^(C\d+|CPP\d+|JV\d+|JS\d+|GO\d+|PAR7)$' { return '方向1b_多语言_闯关与实战补强.md' }
        '^(RS\d+|PAR[1-6]|OTH\d+|SQL\d+|SH\d+)$' { return '方向1c_Rust范式SQLShell_闯关与实战补强.md' }
        '^DSA' { return '方向2_算法_闯关与实战补强.md' }
        '^(COMP|ASM|OS|CMP)' { return '方向3_底层系统_闯关与实战补强.md' }
        '^NET' { return '方向4_网络_闯关与实战补强.md' }
        '^DB' { return '方向5_数据库_闯关与实战补强.md' }
        '^(FE|BE)' { return '方向6_Web全栈_闯关与实战补强.md' }
        '^SEC' { return '方向7_安全攻防_闯关与实战补强.md' }
        '^MOB' { return '方向8_移动桌面游戏嵌入式_闯关与实战补强.md' }
        '^DAT' { return '方向9_数据AI_闯关与实战补强.md' }
        '^OPS' { return '方向10_运维云SRE_闯关与实战补强.md' }
        '^PD' { return '方向11_产品设计软技能_闯关与实战补强.md' }
        default { return '未映射' }
    }
}

$out = [System.Collections.Generic.List[string]]::new()
$out.Add('# 全领域宗师级超级完整版 · 总览索引')
$out.Add('')
$out.Add('> 这是 590 个课/专题的可导航总览，不替代原教案正文或逐课补强卡。学习顺序：先读原课 11 段，再读对应补强文件中的 Lv1–Lv5 与 5 个 Lab，最后把证据写入 `evidence/<课号>/`。')
$out.Add('> 当前质量状态（2026-09-09）：590/590 编号无重复；原课 11 段 590/590；补强层资料锚点/失败实验/五关/至少 5 Lab 均为 590/590；干净环境运行验证仍为 0/590，不能把结构生成当作毕业。')
$out.Add('')
$out.Add('## 八大宏域地图')
$out.Add('- I 预备与编程：PRE + 方向1，环境、表示、内存、控制流、语言、测试、构建和解释器。')
$out.Add('- II 算法与数学：方向2，建模、证明、复杂度、数据结构、随机化、性质测试和性能。')
$out.Add('- III 计算机系统：方向3，数字逻辑、ISA、编译链接、OS、并发、内存、文件系统和调试。')
$out.Add('- IV 网络与分布式：方向4，协议、路由、TLS、服务发现、共识、故障和容量。')
$out.Add('- V 数据库与数据工程：方向5，关系模型、执行器、事务、WAL、复制、分片、治理和恢复。')
$out.Add('- VI Web、产品与人机工程：方向6 + 方向11，浏览器、后端、可访问性、研究、设计、交付和协作。')
$out.Add('- VII 安全、逆向与可信工程：方向7，威胁建模、修复、检测、取证、授权靶场和负责任披露。')
$out.Add('- VIII AI、云原生与端侧工程：方向8 + 方向9 + 方向10，移动/嵌入式、数据/模型、容器、SRE、供应链和成本。')
$out.Add('')
$out.Add('## 通用闯关合同')
$out.Add('- Lv1：最小闭环，能运行且留下输出、版本和清理步骤。')
$out.Add('- Lv2：只改一个变量，提交前后对比和失败解释。')
$out.Add('- Lv3：跨两节知识完成综合任务，提交自动化测试、日志和设计图。')
$out.Add('- Lv4：手写机制或完成性能/安全/可靠性审计，提交基线、指标、根因和回归。')
$out.Add('- Lv5：开放研究、教学或架构决策，提交 ADR/证明/反例/复现/限制。')
$out.Add('- 白帽边界：网络与安全练习只对自有代码、隔离虚拟机、明确授权靶场或 CTF。')
$out.Add('')
$out.Add('## 逐课目录')
$macroOrder = @(
    'I · 预备与编程',
    'II · 算法与数学',
    'III · 计算机系统',
    'IV · 网络与分布式',
    'V · 数据库与数据工程',
    'VI · Web、产品与人机工程',
    'VII · 安全、逆向与可信工程',
    'VIII · AI、云原生与端侧工程'
)
foreach ($macro in $macroOrder) {
    $group = @($records | Where-Object { (Macro $_.Id) -eq $macro })
    $out.Add('')
    $out.Add("### $macro")
    foreach ($record in $group) {
        $supp = Supplement $record.Id
        $out.Add(("- **{0}** · {1}  | 原课：{2}  | 补强：{3}  | 证据：evidence/{0}/" -f $record.Id,$record.Title,$record.File,$supp))
    }
}
$out.Add('')
$out.Add('## 权威资料入口')
$out.Add('- 完整资料目录与章节映射：`权威资料目录与复核计划.md`；本次 URL 可达性记录：`资料链接复核记录_2026-09-09.md`。')
$out.Add('- 计算机基础与算法：MIT 6.006、OSTEP、Nand2Tetris。')
$out.Add('- 语言与工具链：Python、Rust、Java、Go、MDN JavaScript/HTML/CSS 官方文档。')
$out.Add('- 网络与数据：RFC、Wireshark、PostgreSQL、SQLite 官方文档。')
$out.Add('- 安全与治理：OWASP Top 10/ASVS、NIST NICE、CWE/CVE/CVSS、MITRE ATT&CK（防御映射）。')
$out.Add('- 平台与可靠性：Kubernetes、OpenTelemetry、Docker、云厂商官方架构文档。')
$out.Add('- AI 与人机工程：PyTorch、Hugging Face、NN/g、WCAG。')
$out.Add('')
$out.Add('## 毕业证据')
$out.Add('每课至少提交 `README.md`、`commands.txt`、`tests/`、`artifacts/`、`notes.md`；模板见 `evidence/_templates/课次证据_README.md`，590 个骨架见 `evidence/INDEX.md`。八大宏域作品和跨域综合演练的详细指标见 `八大宏域毕业工程与验收合同.md`。')
$out.Add('')
$out.Add('## 台前进度')
$out.Add('当前源文件：`台前任务列表_课程重构.md`；结构核验命令：`pwsh -NoProfile -File 核验课程结构.ps1`。')
$out | Set-Content -LiteralPath (Join-Path $Root '全领域宗师级超级完整版.md') -Encoding utf8
Write-Output "Generated $($records.Count) course index entries."
