param(
    [string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path),
    [switch]$RefreshUnstartedContracts
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$jsonPath = Join-Path $Root '逐课专属深度合同_590课.json'
$evidenceRoot = Join-Path $Root 'evidence'
if (-not (Test-Path -LiteralPath $jsonPath -PathType Leaf)) { throw "missing contract json: $jsonPath" }
$records = @(Get-Content -LiteralPath $jsonPath -Raw -Encoding utf8 | ConvertFrom-Json)
$createdDirs = 0
$createdFiles = 0
$refreshedContracts = 0
foreach ($record in $records) {
    $id = [string]$record.Id
    $labs = @($record.Labs)
    for ($i = 0; $i -lt 5; $i++) {
        $labNo = $i + 1
        $lab = $labs[$i]
        $dir = Join-Path $evidenceRoot (Join-Path $id "labs\lab$labNo")
        if (-not (Test-Path -LiteralPath $dir -PathType Container)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
            $createdDirs++
        }
        $readme = Join-Path $dir 'README.md'
        if (-not (Test-Path -LiteralPath $readme -PathType Leaf)) {
            @"
# $id · $($record.Title) · $($lab.Name)

状态：⬜ 未执行。此文件由生成器预填合同，不代表 Lab、Lv1–Lv5 或课程完成。

## 本课绑定

- 核心机制：$($record.Mechanism)
- 必守不变量：$($record.Invariant)
- 前置锚点：$($record.Previous)
- 资料锚点：$($record.Source)
- 资料入口：$($record.Url)
- 深度检查点/口述答辩/受控变体：见 `逐课专属深度合同_590课.md` 中的 $id 章节

## 执行合同

- 输入与操作：$($lab.Input)
- 预期与验收：$($lab.Expected)
- 失败分支：$($lab.Failure)
- 指标：$($lab.Metric)
- 证据路径：evidence/$id/labs/lab$labNo/

## 实际执行记录（学习者填写）

- 日期/时区：
- 操作系统/架构：
- 工具及版本：
- 实际命令：
- 退出码：
- 原始输出/日志：
- 结果：⬜ 未执行 / 🔄 进行中 / ✅ 通过 / ⚠️ 阻塞 / ❌ 失败
- 证明了什么：
- 没有证明什么：
- 清理与凭据撤销：
- 未验证项与下一步：
"@ | Set-Content -LiteralPath $readme -Encoding utf8
            $createdFiles++
        } elseif ($RefreshUnstartedContracts) {
            $existing = Get-Content -LiteralPath $readme -Raw -Encoding utf8
            if ($existing -match '(?m)^状态：⬜ 未执行。') {
                $contractBlock = @"
## 本课绑定

- 核心机制：$($record.Mechanism)
- 必守不变量：$($record.Invariant)
- 前置锚点：$($record.Previous)
- 资料锚点：$($record.Source)
- 资料入口：$($record.Url)
- 深度检查点/口述答辩/受控变体：见 `逐课专属深度合同_590课.md` 中的 $id 章节

## 执行合同

- 输入与操作：$($lab.Input)
- 预期与验收：$($lab.Expected)
- 失败分支：$($lab.Failure)
- 指标：$($lab.Metric)
- 证据路径：evidence/$id/labs/lab$labNo/
"@
                $pattern = '(?s)## 本课绑定\r?\n.*?(?=\r?\n## 实际执行记录（学习者填写）)'
                $updated = [regex]::Replace($existing, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $contractBlock }, 1)
                if ($updated -ne $existing) {
                    $updated | Set-Content -LiteralPath $readme -Encoding utf8
                    $refreshedContracts++
                }
            }
        }
        $commands = Join-Path $dir 'commands.txt'
        if (-not (Test-Path -LiteralPath $commands -PathType Leaf)) {
            @("# $id lab$labNo",'# 逐行追加实际命令、开始/结束时间、退出码；禁止写入真实密钥或 Cookie。') | Set-Content -LiteralPath $commands -Encoding utf8
            $createdFiles++
        }
        $notes = Join-Path $dir 'notes.md'
        if (-not (Test-Path -LiteralPath $notes -PathType Leaf)) {
            @("# $id lab$labNo",'','记录假设、反例、指标、资料章节、取舍、失败原因、清理和下一步。') | Set-Content -LiteralPath $notes -Encoding utf8
            $createdFiles++
        }
        $tests = Join-Path $dir 'tests'
        $artifacts = Join-Path $dir 'artifacts'
        New-Item -ItemType Directory -Path $tests -Force | Out-Null
        New-Item -ItemType Directory -Path $artifacts -Force | Out-Null
        foreach ($sub in @($tests,$artifacts)) {
            $keep = Join-Path $sub '.gitkeep'
            if (-not (Test-Path -LiteralPath $keep -PathType Leaf)) {
                '' | Set-Content -LiteralPath $keep -Encoding utf8
                $createdFiles++
            }
        }
    }
}
Write-Output "Courses=$($records.Count) LabDirs=$($records.Count * 5) CreatedDirs=$createdDirs CreatedFiles=$createdFiles RefreshedContracts=$refreshedContracts"
