param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest
$path = Join-Path $Root '方向5_数据库_闯关与实战补强.md'
$text = Get-Content -LiteralPath $path -Raw -Encoding utf8
$gate = @"
**五关交付**：Lv1 跑通本课最小 schema/查询/事务并保存 SQL、输出和版本；Lv2 只改变一个数据量、索引、隔离级别或故障参数并提交前后对比；Lv3 与前置课组成可自动化的综合管道并记录失败分支；Lv4 手写最小机制或完成执行计划、性能、恢复与安全审计并交基线和根因；Lv5 完成开放研究或架构决策，交 ADR/论文式笔记、反例、复现实验、限制和教学材料。

"@
$pattern = '(?m)^(\*\*深挖\*\*[:：][^\r\n]*\r?\n)'
$updated = [regex]::Replace($text, $pattern, ('$1' + $gate))
if ($updated -eq $text) { throw '未找到数据库课卡的深挖段，未写入任何内容。' }
$updated | Set-Content -LiteralPath $path -Encoding utf8
Write-Output "Updated: $path"
