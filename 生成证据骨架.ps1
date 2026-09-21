param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest

$evidenceRoot = Join-Path $Root 'evidence'
New-Item -ItemType Directory -Path $evidenceRoot -Force | Out-Null
$pattern = '^#{1,3}\s+((?:PRE|PY|C|CPP|JV|JS|GO|RS|PAR|OTH|SQL|SH|DSA|COMP|ASM|OS|CMP|NET|DB|FE|BE|SEC|MOB|DAT|OPS|PD)(?:-[A-Z]+)?\d*)\s*[· ]+(.+)$'
$fileOrder = @(
    '教案_预备层.md','教案_方向1a_编程Python.md','教案_方向1b_多语言_C_CPP_Java_JS_Go.md','教案_方向1c_Rust_范式_SQL_Shell.md',
    '教案_方向2_算法与数据结构.md','教案_方向3_底层系统.md','教案_方向4_网络.md','教案_方向5_数据库.md','教案_方向6_Web全栈.md',
    '教案_方向7a_安全基础_Web安全.md','教案_方向7b_二进制_漏洞利用_Hook.md','教案_方向7c_恶意代码_渗透红队_CTFCERT_AIOT.md',
    '教案_方向8_移动桌面游戏嵌入式.md','教案_方向9_数据AI.md','教案_方向10_运维云SRE.md','教案_方向11_产品设计软技能.md'
)
$records = @()
foreach ($name in $fileOrder) {
    $path = Join-Path $Root $name
    if (-not (Test-Path -LiteralPath $path)) { continue }
    foreach ($line in (Get-Content -LiteralPath $path -Encoding utf8)) {
        if ($line -match $pattern) { $records += [pscustomobject]@{ Id=$matches[1]; Title=$matches[2].Trim(); File=$name } }
    }
}

$readmeTemplate = Join-Path $evidenceRoot '_templates\课次证据_README.md'
$created = 0
foreach ($record in $records) {
    $dir = Join-Path $evidenceRoot $record.Id
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $readme = Join-Path $dir 'README.md'
    if (-not (Test-Path -LiteralPath $readme)) {
        @"
# $($record.Id) · $($record.Title) 证据

> 状态：⬜ 未开始。此骨架由生成器创建，不代表任何关卡或 Lab 已完成。

## 来源

- 原课文件：$($record.File)
- 补强卡：请填写对应 `*闯关与实战补强.md`
- 资料页面/章节/版本/访问日期：

## 环境

- 日期：
- 操作系统/架构：
- 工具和版本：
- 输入/合成数据说明：

## 安全与清理

- 资产所有者/授权来源：
- 允许的目标、时间窗和动作：
- 禁止动作与停止条件：
- 脱敏方法：
- 清理/凭据撤销：

## 关卡与 Lab

- Lv1：⬜ 证据路径：
- Lv2：⬜ 证据路径：
- Lv3：⬜ 证据路径：
- Lv4：⬜ 证据路径：
- Lv5：⬜ 证据路径：
- Lab 1–5：⬜ 证据路径：

## 必做失败实验

- 现象：
- 假设：
- 最小复现：
- 证据：
- 根因：
- 修复与回归：
- 清理：

## 结论

- 已验证命题：
- 指标与基线：
- 未验证项/限制：
- 下一步课号与依赖原因：
"@ | Set-Content -LiteralPath $readme -Encoding utf8
        $created++
    }
    foreach ($name in @('commands.txt','notes.md')) {
        $file = Join-Path $dir $name
        if (-not (Test-Path -LiteralPath $file)) {
            if ($name -eq 'commands.txt') { '# 逐行记录实际命令、退出码和时间；不要写真实密钥。' | Set-Content -LiteralPath $file -Encoding utf8 }
            else { '# 记录假设、资料章节、反例、指标、取舍、失败结果和下一步。' | Set-Content -LiteralPath $file -Encoding utf8 }
        }
    }
    foreach ($name in @('tests','.gitkeep')) {
        if ($name -eq '.gitkeep') { continue }
        $sub = Join-Path $dir $name
        New-Item -ItemType Directory -Path $sub -Force | Out-Null
        $keep = Join-Path $sub '.gitkeep'
        if (-not (Test-Path -LiteralPath $keep)) { '' | Set-Content -LiteralPath $keep -Encoding utf8 }
    }
    $artifacts = Join-Path $dir 'artifacts'
    New-Item -ItemType Directory -Path $artifacts -Force | Out-Null
    $keep = Join-Path $artifacts '.gitkeep'
    if (-not (Test-Path -LiteralPath $keep)) { '' | Set-Content -LiteralPath $keep -Encoding utf8 }
}
$index = Join-Path $evidenceRoot 'INDEX.md'
$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('# 590 课证据索引')
$lines.Add('')
$lines.Add('每行对应一个课号证据目录。`⬜` 只表示骨架已创建，不表示学习完成；完成状态必须写入该课 README 并附真实证据。')
$lines.Add('')
foreach ($record in $records) { $lines.Add(("- [ ] **{0}** · {1} · {0}/README.md" -f $record.Id,$record.Title)) }
$lines | Set-Content -LiteralPath $index -Encoding utf8
Write-Output "CourseRecords=$($records.Count) NewReadmes=$created EvidenceRoot=$evidenceRoot"
