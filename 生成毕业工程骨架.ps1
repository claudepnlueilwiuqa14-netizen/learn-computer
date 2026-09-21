param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$capstoneRoot = Join-Path $Root 'capstone'
$projects = [ordered]@{
    '01_预备与编程' = '多语言 CLI 工具箱与最小解释器前端'
    '02_算法与数学' = '算法实验室与可复现基准'
    '03_计算机系统' = 'Nand2Tetris/xv6 子系统与崩溃根因报告'
    '04_网络与分布式' = '本地多节点协议服务与故障注入'
    '05_数据库与数据工程' = '可恢复 OLTP/分析混合数据平台'
    '06_Web产品' = '闪电号卡生产化 Web 产品'
    '07_安全逆向' = '隔离靶场、检测规则与修复回归集'
    '08_AI云原生端侧' = '端到端 AI 服务与端侧演示'
}

$readme = @'
# {NAME}

状态：骨架已创建，项目实现未开始。此文件不能作为毕业完成证据。

## 目标

{GOAL}

## 当前边界

- 只使用自有代码、合成数据、本机容器/虚拟机、模拟器或明确授权靶场。
- 不放入真实凭据、Cookie、个人数据、生产配置或未授权目标信息。
- 先完成 `docs/adr/`、`threat-model.md` 和 `runbook.md`，再写实现。

## 目录

- `src/`：实现和配置（当前为空骨架）
- `tests/`：单元、集成、性质或 e2e 测试
- `evidence/`：指标、日志、trace、截图、pcap（脱敏）
- `docs/adr/`：关键取舍、假设、反例和替代方案
- `runbook.md`：启动、排障、回滚、清理
- `threat-model.md`：资产、边界、滥用案例、控制
- `postmortem.md`：故障时间线、根因、行动项

## 第一小步

1. 填写威胁模型和 ADR-0001。
2. 写出一个最小可运行测试，并把输出放入 `evidence/`。
3. 在 `runbook.md` 写清启动和清理命令。
4. 只有源码、测试、指标、故障、回滚和复盘齐全后，才能推进任务列表中的毕业工程状态。
'@

$runbook = @'
# 运行手册

状态：待实现。所有命令必须在本机、隔离容器/虚拟机或模拟器执行。

## 环境检查

记录操作系统、工具版本、工作目录和数据来源。缺少工具时标记 `BLOCKED_TOOL`，不要伪造通过。

## 启动

待实现：写出可复制的安装、构建、启动和健康检查命令。

## 排障

按“现象 -> 假设 -> 证据 -> 修复 -> 回归”记录；把日志、指标和最小复现放入 `evidence/`。

## 回滚与清理

待实现：写出停止服务、删除临时容器/卷、撤销测试密钥、恢复数据和验证清理的命令。
'@

$threat = @'
# 威胁模型

状态：待项目建模。没有资产、信任边界和授权范围，就不能开始安全实验。

## 资产

- 待填写：代码、合成数据、模型/制品、日志、测试密钥和本地服务。

## 信任边界

- 待填写：用户输入、进程/容器、网络、存储、第三方依赖和发布渠道。

## 滥用案例

- 待填写：越权、数据泄露、资源耗尽、错误配置、供应链污染或回滚失败。

## 控制与证据

- 待填写：最小权限、输入验证、审计、备份、签名、隔离、告警和修复回归。
- 授权证明、数据来源和停止条件必须放在本目录，不得使用真实凭据。
'@

$adr = @'
# ADR-0001：项目边界与最小可交付物

- 状态：草案
- 日期：2026-09-09
- 决策：先以本机/隔离环境完成一个最小闭环，再扩展到性能、故障、安全和发布。
- 原因：没有可运行基线就无法解释指标、失败和回滚。
- 未决问题：实现语言、依赖版本、数据格式、指标阈值和部署目标。
- 验证方式：补充代码、测试输出和复现命令后，将状态改为“已接受”。
'@

$postmortem = @'
# 复盘

状态：尚无项目事故；模板不能替代真实故障复盘。

| 时间 | 影响 | 现象 | 根因 | 修复 | 回滚 | 后续行动 |
|---|---|---|---|---|---|---|
| 待填写 | 待填写 | 待填写 | 待填写 | 待填写 | 待填写 | 待填写 |

要求：不责备个人；用日志、指标、测试和时间线支持每个结论。
'@

$rootReadme = @'
# 八大宏域毕业工程

这里是八个毕业工程的源码与证据入口。当前仅完成目录骨架和结构 smoke，不代表任何项目已经实现或毕业。

| 宏域 | 目录 | 当前状态 |
|---|---|---|
| I | `01_预备与编程` | 骨架已创建 |
| II | `02_算法与数学` | 骨架已创建 |
| III | `03_计算机系统` | 骨架已创建 |
| IV | `04_网络与分布式` | 骨架已创建 |
| V | `05_数据库与数据工程` | 骨架已创建 |
| VI | `06_Web产品` | 骨架已创建 |
| VII | `07_安全逆向` | 骨架已创建 |
| VIII | `08_AI云原生端侧` | 骨架已创建 |

验收合同见上级目录的 `八大宏域毕业工程与验收合同.md`。实现状态以每个项目自己的 README、测试和 evidence 为准。
'@

New-Item -ItemType Directory -Path $capstoneRoot -Force | Out-Null
if (-not (Test-Path -LiteralPath (Join-Path $capstoneRoot 'README.md'))) {
    $rootReadme | Set-Content -LiteralPath (Join-Path $capstoneRoot 'README.md') -Encoding utf8
}

foreach ($entry in $projects.GetEnumerator()) {
    $dir = Join-Path $capstoneRoot $entry.Key
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    foreach ($sub in @('src','tests','evidence','docs/adr')) {
        New-Item -ItemType Directory -Path (Join-Path $dir $sub) -Force | Out-Null
    }
    $values = @{NAME=$entry.Key;GOAL=$entry.Value}
    $contentMap = @{
        'README.md' = $readme
        'runbook.md' = $runbook
        'threat-model.md' = $threat
        'postmortem.md' = $postmortem
        'docs/adr/ADR-0001.md' = $adr
        'src/README.md' = "# 实现占位`r`n`r`n待实现；不要把此文件当成源码完成。"
        'tests/README.md' = "# 测试占位`r`n`r`n待实现；至少加入一个可重复的失败测试后再更新项目状态。"
        'evidence/README.md' = "# 证据占位`r`n`r`n保存版本、命令、输出、指标、失败、回滚和清理记录。"
    }
    foreach ($file in $contentMap.GetEnumerator()) {
        $target = Join-Path $dir $file.Key
        if (-not (Test-Path -LiteralPath $target)) {
            $text = $file.Value
            foreach ($key in $values.Keys) { $text = $text.Replace("{$key}", $values[$key]) }
            $text | Set-Content -LiteralPath $target -Encoding utf8
        } elseif ($file.Key -match '^(src|tests|evidence)/README\.md$') {
            $existing = Get-Content -LiteralPath $target -Raw -Encoding utf8
            if ($existing.Contains('`r`n')) { $file.Value | Set-Content -LiteralPath $target -Encoding utf8 }
        }
    }
}

Write-Output "CapstoneSkeletons=$($projects.Count) Root=$capstoneRoot"
