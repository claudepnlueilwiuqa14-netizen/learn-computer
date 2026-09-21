param([string]$Root = (Split-Path -Parent $MyInvocation.MyCommand.Path))
Set-StrictMode -Version Latest

function Read-Courses([string]$path, [string]$kind) {
    $pattern = switch ($kind) {
        'MOB' { '^#{1,3}\s+(MOB\d+)\s*[· ]+(.+)$' }
        'DAT' { '^#{1,3}\s+(DAT\d+)\s*[· ]+(.+)$' }
        'OPS' { '^#{1,3}\s+(OPS\d+)\s*[· ]+(.+)$' }
        'PD'  { '^#{1,3}\s+(PD\d+)\s*[· ]+(.+)$' }
    }
    $result = @()
    foreach ($line in (Get-Content -LiteralPath $path)) {
        if ($line -match $pattern) { $result += [pscustomobject]@{Id=$matches[1];Title=$matches[2].Trim()} }
    }
    return $result
}

function Classify([string]$kind, [string]$title) {
    switch ($kind) {
        'MOB' {
            if ($title -match '逆向|Frida|IDA|脱壳|加固|SSL|Root|反调试|内存') { return '平台安全与合法分析' }
            if ($title -match '游戏|Unity|Unreal|Godot|图形|Shader') { return '游戏与图形' }
            if ($title -match '嵌入式|Arduino|Raspberry|RTOS|固件|物联网') { return '嵌入式与 IoT' }
            if ($title -match 'iOS|Swift|Objective|IPA|Mach-O') { return 'iOS 平台' }
            if ($title -match 'Android|Kotlin|Activity|APK|DEX|Gradle|JNI|NDK') { return 'Android 平台' }
            if ($title -match '跨平台|React Native|Flutter|Xamarin|Cordova|Capacitor|Electron|Tauri') { return '跨平台与桌面' }
            return '移动与桌面基础'
        }
        'DAT' {
            if ($title -match 'Transformer|Tokenizer|提示|RAG|向量|LoRA|Agent|多模态|LLM|模型服务|推理') { return '生成式 AI 与模型工程' }
            if ($title -match '神经|CNN|RNN|LSTM|GAN|VAE|PyTorch|训练|调参|预训练') { return '深度学习' }
            if ($title -match '回归|树|聚类|PCA|集成|评估|特征|经典 ML') { return '经典机器学习' }
            if ($title -match 'Spark|Kafka|ETL|数据管道|仓库|治理|采集|清洗|Pandas|NumPy|生命周期') { return '数据工程与治理' }
            if ($title -match 'MLflow|Airflow|注册|监控|漂移|CI/CD|特征存储|云 ML') { return 'MLOps 与生产化' }
            if ($title -match '可视化|BI|统计') { return '统计与可视化' }
            return '数据科学基础'
        }
        'OPS' {
            if ($title -match 'Kubernetes|K8s|Helm|容器|Docker') { return '容器与 Kubernetes' }
            if ($title -match 'Terraform|Ansible|IaC|GitHub Actions|GitLab|Jenkins|Argo|GitOps|制品') { return '交付与 IaC' }
            if ($title -match 'SRE|错误预算|SLI|SLO|SLA|Prometheus|Grafana|日志|链路|OTel|告警|值班|混沌|事故|容量|成本|平台工程') { return 'SRE 与可观测性' }
            if ($title -match '安全|密钥|Trivy|Snyk|Vault') { return '云安全与供应链' }
            if ($title -match 'AWS|阿里云|腾讯云|Azure|GCP|对象存储|VPC|无服务器|虚拟化|云概论') { return '云平台基础' }
            if ($title -match '性能|调优|日志|服务|进程|Linux|文件系统|权限|Shell|网络|cron|systemd') { return 'Linux 与运行时' }
            return '运维基础'
        }
        'PD' {
            if ($title -match 'UI|色彩|排版|CRAP|设计系统|Token|Figma') { return '视觉与设计系统' }
            if ($title -match 'UX|交互|可用性|可访问性|原型|线框') { return 'UX 与可访问性' }
            if ($title -match '用户研究|访谈|问卷|数据驱动|实验|指标') { return '研究与度量' }
            if ($title -match '产品|MVP|需求|PRD') { return '产品策略与规格' }
            if ($title -match '写作|文档|沟通|协作|敏捷|项目') { return '协作与交付' }
            if ($title -match '面试|简历|作品集') { return '职业表达' }
            return '学习与元认知'
        }
    }
}

function Focus([string]$track, [string]$title) {
    switch ($track) {
        '平台安全与合法分析' { return @("平台边界：$title 如何体现沙箱、签名、权限、ABI 或运行时信任？", '合法分析：只对自有 App/游戏/固件和授权样本做静态/动态分析，如何保存证据而不扩散敏感数据？', '取舍：安全控制、用户体验、性能、可调试性和发布成本如何权衡？') }
        '游戏与图形' { return @("渲染链路：$title 如何从输入、场景、资源到 CPU/GPU 帧完成？", '边界实验：不同分辨率、帧率、设备、功耗和资源缺失时如何保持可玩与可诊断？', '取舍：画质、帧时间、内存、包体、网络和可维护性如何量化？') }
        '嵌入式与 IoT' { return @("硬件链路：$title 的中断、内存、外设、功耗、固件和 OTA 如何协作？", '失效实验：断电、丢包、时钟漂移、传感器异常和更新失败如何安全恢复？', '取舍：实时性、功耗、成本、签名、可维修性和隐私如何平衡？') }
        'Android 平台' { return @("运行模型：$title 如何经过 Activity/组件、生命周期、线程、权限、APK/DEX 和系统服务？", '失效实验：旋转/杀进程/权限拒绝/离线/低内存时状态是否可恢复？', '取舍：原生、NDK、跨端、性能、隐私和发布兼容性如何量化？') }
        'iOS 平台' { return @("运行模型：$title 如何经过 Swift/Objective-C runtime、生命周期、沙盒、签名和系统框架？", '失效实验：后台挂起、权限拒绝、网络断开、版本迁移和崩溃时如何恢复？', '取舍：能耗、隐私、审核、ABI、可测试性和发布节奏如何权衡？') }
        '跨平台与桌面' { return @("边界模型：$title 哪些逻辑跨端共享，哪些必须落到原生窗口/沙箱/文件系统？", '失效实验：远程内容不可信、插件异常、自动更新失败、不同平台权限差异如何处理？', '取舍：开发效率、包体、性能、隔离、安全和维护成本如何量化？') }
        '生成式 AI 与模型工程' { return @("数学/系统链路：$title 的数据、token、模型、检索、工具、推理和评估如何连接？", '失效实验：数据泄漏、提示注入、幻觉、漂移、上下文超限、延迟和成本爆炸如何暴露？', '取舍：质量、延迟、显存、隐私、可解释性、供应链和成本如何决策？') }
        '深度学习' { return @("数学链路：$title 的张量形状、目标函数、梯度、优化器和归一化如何决定收敛？", '失效实验：过拟合、梯度消失、数据泄漏、类别不平衡、分布变化时如何诊断？', '取舍：模型容量、数据量、训练时间、显存、可解释性和部署成本如何量化？') }
        '经典机器学习' { return @("建模链路：$title 的特征、假设、损失、正则化、切分和指标如何相互影响？", '失效实验：泄漏、偏差、方差、异常值、阈值变化和类别不平衡如何改变结论？', '取舍：准确率、可解释性、稳定性、训练成本和业务风险如何权衡？') }
        '数据工程与治理' { return @("数据链路：$title 如何从采集、模式、质量、血缘、存储到消费形成闭环？", '失效实验：重复、缺失、乱序、迟到、模式变更、分区故障和隐私删除如何处理？', '取舍：新鲜度、正确性、成本、可重跑性、治理和合规如何量化？') }
        'MLOps 与生产化' { return @("生命周期：$title 如何连接代码、数据、实验、模型、特征、部署、监控和回滚？", '失效实验：漂移、依赖不可用、模型注册错版、资源不足和灰度失败如何恢复？', '取舍：自动化、审批、速度、可追溯性、SLO 和成本如何平衡？') }
        '统计与可视化' { return @("推断链路：$title 的样本、假设、估计、检验、编码和读者认知如何影响结论？", '失效实验：抽样偏差、混杂、p-hacking、误导坐标和缺失数据如何扭曲解释？', '取舍：准确、可读、可复核、隐私和认知负担如何量化？') }
        '容器与 Kubernetes' { return @("控制链路：$title 如何经过镜像、容器运行时、控制面、调度、网络、存储和策略？", '失效实验：探针失败、节点重启、资源不足、卷不可用、网络分区和版本漂移如何恢复？', '取舍：隔离、弹性、可观测性、成本、供应链和复杂度如何权衡？') }
        '交付与 IaC' { return @("交付链路：$title 如何从提交、构建、制品、计划、审批、发布到回滚保持可追溯？", '失效实验：并发部署、状态漂移、密钥泄露、半成功和依赖供应链异常如何处理？', '取舍：速度、可重复性、权限、审计、成本和开发体验如何决策？') }
        'SRE 与可观测性' { return @("可靠性链路：$title 如何连接 SLI/SLO、指标、日志、trace、告警、值班、容量和复盘？", '失效实验：高基数、告警风暴、采样丢失、依赖级联和错误预算耗尽时如何行动？', '取舍：检测覆盖、噪声、存储成本、隐私和响应速度如何量化？') }
        '云安全与供应链' { return @("信任链路：$title 如何覆盖身份、密钥、镜像、依赖、运行时、日志和恢复？", '失效实验：最小权限缺口、密钥轮换、恶意依赖、配置漂移和备份泄露如何发现？', '取舍：安全控制、交付速度、可用性、审计和成本如何权衡？') }
        '云平台基础' { return @("资源模型：$title 如何从虚拟化、网络、存储、身份和计费映射到云 API？", '失效实验：区域故障、配额耗尽、权限误配、对象误删和服务降级如何恢复？', '取舍：托管程度、可移植性、可用性、成本、锁定和合规如何决策？') }
        'Linux 与运行时' { return @("运行链路：$title 如何从进程/文件/权限/服务/网络到内核和资源限制？", '失效实验：磁盘满、FD 耗尽、僵尸、锁等待、日志爆炸和配置错误如何定位？', '取舍：性能、最小权限、可维护性、恢复速度和变更风险如何量化？') }
        '视觉与设计系统' { return @("视觉系统：$title 如何由层级、间距、颜色、字体、Token 和组件形成一致体验？", '失效实验：长文本、窄屏、低对比、深色模式、国际化和错误状态如何保持可读？', '取舍：一致性、品牌、可访问性、开发成本和演进速度如何权衡？') }
        'UX 与可访问性' { return @("交互链路：$title 如何支持目标、状态、反馈、错误预防、恢复和键盘/辅助技术？", '失效实验：新手、低视力、认知负荷、网络慢和误操作时是否仍可完成任务？', '取舍：效率、发现性、可学习性、可访问性和实现成本如何量化？') }
        '研究与度量' { return @("证据链：$title 如何从问题、假设、样本、方法、指标到决策避免自我确认？", '失效实验：样本偏差、测量误差、幸存者偏差、指标博弈和隐私风险如何暴露？', '取舍：研究深度、速度、代表性、隐私和行动成本如何平衡？') }
        '产品策略与规格' { return @("决策链：$title 如何从用户问题、约束、优先级、验收标准到迭代？", '失效实验：需求冲突、范围蔓延、失败状态、依赖延迟和指标未达成如何处理？', '取舍：价值、风险、成本、时机、质量和技术债如何量化？') }
        '协作与交付' { return @("协作链路：$title 如何让信息、责任、决策、风险、变更和反馈可追踪？", '失效实验：误解、阻塞、异步沟通、交付延期和事故沟通如何恢复？', '取舍：文档成本、同步频率、自治、透明度和速度如何权衡？') }
        '职业表达' { return @("证据链：$title 如何把真实能力、影响、限制和复盘转成可信作品？", '失效实验：简历夸大、作品不可复现、隐私泄露和面试追问时如何自洽？', '取舍：技术深度、叙事清晰、诚实边界和读者时间如何平衡？') }
        default { return @("学习链路：$title 的目标、练习、反馈、间隔、迁移和复盘如何闭环？", '失效实验：遗忘、错觉流畅、过载、动机下降和身体疲劳如何调整？', '取舍：深度、广度、节奏、健康和长期可持续性如何量化？') }
    }
}

function Labs([string]$track, [string]$title) {
    switch ($track) {
        '平台安全与合法分析' { return @('自有样本：对自己编译/签名的 App、游戏或固件建立资产与授权记录，做静态结构图。','安全配置：开启签名、沙箱、权限和混淆/加固，验证正常功能和拒绝路径。','合法动态：只在模拟器/自有设备观察日志、调用链、崩溃和网络，保存最小证据。','修复回归：修复一个自有缺陷或错误配置，做前后测试与版本比较。','研究报告：写根因、检测、缓解、残余风险和禁止越界的边界说明。') }
        '游戏与图形' { return @('最小场景：做一个可运行场景/渲染循环并记录帧时间。','受控变体：改变分辨率、对象数、材质或输入，比较 CPU/GPU/内存。','综合玩法：加入输入、资源加载、存档或网络中的两个能力并写测试。','性能优化：用 profiler 找一个帧时间瓶颈，提交基线、改动和回归。','开放研究：提出画质/帧率/功耗假设，做 A/B 测量并写设计决策。') }
        '嵌入式与 IoT' { return @('最小固件：在模拟器或自有板卡实现一个传感器/任务闭环，保存构建与串口日志。','故障变体：断电、传感器异常、丢包或时钟漂移，验证看门狗与安全默认。','综合系统：连接任务调度、通信、存储或功耗中的两个主题。','安全更新：为自有固件做签名校验、版本回滚和密钥撤销演练。','开放研究：测量功耗/实时性/可靠性，写出硬件限制和下一版方案。') }
        'Android 平台' { return @('最小 App：在模拟器完成一个界面/组件/存储/网络闭环，保存 logcat。','生命周期变体：旋转、后台、杀进程、权限拒绝和离线，验证状态恢复。','综合工程：连接 Room/Retrofit/协程/WorkManager 中至少两项并写测试。','安全审计：检查权限、导出组件、备份、网络安全配置和签名，修复并回归。','开放研究：比较原生、NDK 或跨端方案的性能、包体、隐私和维护成本。') }
        'iOS 平台' { return @('最小 App：在模拟器完成 Swift/SwiftUI/UIKit 基础闭环，保存控制台与截图。','生命周期变体：后台挂起、权限拒绝、离线、深色模式和动态字体。','综合工程：连接持久化、网络、并发或通知中的至少两项并写测试。','安全审计：检查沙盒、Keychain、ATS、签名和日志脱敏，修复并回归。','开放研究：比较 Swift/Objective-C runtime 与跨端方案，写性能和发布限制。') }
        '跨平台与桌面' { return @('最小应用：做一个跨端/桌面窗口和本地数据闭环。','平台变体：在 Windows/Linux/macOS 或不同端侧运行，记录权限和路径差异。','综合工程：加入自动更新、插件/远程内容或原生桥接的安全设计。','审计优化：测启动、内存、包体、崩溃和隔离，修复一项问题。','开放研究：提交跨平台架构 ADR、供应链锁定、签名和回滚方案。') }
        '生成式 AI 与模型工程' { return @('最小模型：用 PyTorch/本地模型完成数据→推理→评估→保存闭环，固定版本与随机种子。','受控变体：改变切分、提示、检索、量化或上下文长度，比较质量/延迟/成本。','综合应用：接入向量检索或工具调用，加入超时、权限、引用和人工兜底。','安全评估：用合成提示测试注入、泄漏、幻觉和拒答，提交修复回归。','开放研究：写模型卡、数据卡、评估集、失败案例、成本曲线和部署 ADR。') }
        '深度学习' { return @('最小训练：实现数据集、模型、loss、autograd、优化、保存/加载。','受控变体：改变学习率、batch、正则、激活或归一化，绘制收敛曲线。','综合任务：用 CNN/RNN/Transformer 中一个模型完成真实合成任务并做误差分析。','性能审计：测显存、吞吐、梯度、混合精度和推理延迟，验证一次优化。','开放研究：解释一次不收敛/过拟合，提出实验假设并保留复现配置。') }
        '经典机器学习' { return @('基线模型：从清洗、切分、训练到指标完成可重复 pipeline。','受控变体：改变特征、阈值、正则或模型，比较偏差/方差和混淆矩阵。','综合任务：至少两个模型和一个业务成本函数，做错误分层。','审计优化：检查泄漏、校准、公平性、可解释性和推理成本。','开放研究：提交模型卡、数据限制、失败样本和上线/不上线决策。') }
        '数据工程与治理' { return @('最小管道：合成数据采集→清洗→转换→加载，记录 schema 与版本。','质量变体：注入缺失、重复、迟到、乱序、范围错误和模式变更。','综合管道：加入质量门、幂等、断点续跑、血缘和回填。','可靠性审计：测新鲜度、吞吐、失败恢复、成本和隐私删除。','开放研究：写数据契约、治理 ADR、指标和一次数据事故复盘。') }
        'MLOps 与生产化' { return @('最小生命周期：训练/评估/注册/部署一个本地模型，保存元数据。','受控变体：切换模型/数据/资源/版本，验证灰度和回滚。','综合链路：加入特征、API、监控或 CI 中至少两项。','故障演练：注入漂移、模型错版、依赖失败、资源不足，测恢复。','开放研究：提交 SLO、成本、审批、血缘、模型卡和生产决策。') }
        '统计与可视化' { return @('最小分析：对合成数据做描述统计、图表和可复核 notebook。','受控变体：改变抽样、坐标、聚合或缺失处理，记录结论变化。','综合推断：写假设、检验、效应量、置信区间和限制。','误导审计：找出一张误导图并修复，加入隐私与可读性检查。','开放研究：让另一人只看图表复述结论，测量误读并迭代。') }
        '容器与 Kubernetes' { return @('最小部署：把本地服务做镜像并在 Compose/K8s 启动，保存 manifest。','受控变体：改副本、资源、探针、配置或版本，比较调度与行为。','综合故障：注入重启、网络、存储或依赖失败，验证恢复。','安全审计：检查 root、capabilities、Secret、镜像来源和网络策略。','开放研究：提交容量、SLO、成本、升级/回滚和多集群取舍。') }
        '交付与 IaC' { return @('最小流水线：提交→测试→构建→制品→本地部署，保存日志与哈希。','受控变体：改变矩阵、环境、状态或审批，验证计划与回滚。','综合交付：加入安全扫描、缓存、迁移、制品签名或预览环境。','故障审计：制造状态漂移、并发发布、密钥错误和半成功，写恢复。','开放研究：提交 IaC 模块、权限矩阵、供应链 SBOM 和 ADR。') }
        'SRE 与可观测性' { return @('最小观测：本地服务发出 metrics/logs/traces，按请求 ID 关联。','受控变体：改变采样、负载、错误率或依赖延迟，比较告警与成本。','综合故障：注入慢依赖、资源耗尽、重启和级联，按 Runbook 处置。','审计优化：降低高基数/告警噪声，测检测时间、误报和恢复时间。','开放研究：提交 SLI/SLO、错误预算、容量模型和无责复盘。') }
        '云安全与供应链' { return @('最小基线：为本地镜像/服务建立身份、密钥、依赖和日志清单。','受控变体：轮换密钥、升级依赖、收紧权限，验证拒绝路径。','综合检测：把扫描结果、运行日志和修复票据串成闭环。','故障演练：模拟密钥泄露/恶意依赖/配置漂移，执行撤销与回滚。','开放研究：提交 SBOM、威胁模型、残余风险和披露/审计报告。') }
        '云平台基础' { return @('最小资源：只在个人/本地模拟账户创建网络、存储、计算和最小权限。','受控变体：改变区域、配额、策略或存储级别，比较可用性和成本。','综合故障：模拟对象误删、权限错误、区域不可用和配额耗尽。','审计优化：检查公开暴露、日志、备份、密钥和账单异常。','开放研究：提交多云/托管/自建 ADR、迁移和退出方案。') }
        'Linux 与运行时' { return @('最小运行：在 WSL/本机观察进程、文件、权限、网络和服务。','受控变体：改变资源限制、日志级别、并发或定时，记录行为。','综合排障：制造磁盘/FD/锁/配置/依赖问题，按证据定位。','性能审计：用 profiler/系统工具测 CPU、内存、IO、上下文切换。','开放研究：提交最小权限、恢复、变更审批和长期维护 Runbook。') }
        '视觉与设计系统' { return @('最小组件：用 Figma/HTML 建一个可复用组件和 Token。','受控变体：长文本、窄屏、深色、低对比和国际化。','综合页面：把组件、状态、表单、错误和键盘操作组成任务流。','审计优化：做 WCAG/启发式/一致性审查，修复一项并记录。','开放研究：提交设计系统演进 ADR、贡献规则和开发者使用指南。') }
        'UX 与可访问性' { return @('最小任务：为一个真实但不敏感的任务画流程和可操作原型。','受控变体：键盘、读屏、低视力、慢网和错误输入。','综合测试：邀请至少一位测试者完成任务，记录观察而非引导。','审计优化：按 NN/g/WCAG 检查状态、反馈、错误预防和恢复。','开放研究：提交研究限制、优先级、指标和迭代方案。') }
        '研究与度量' { return @('最小研究：写问题、假设、样本、方法、指标和伦理说明。','受控变体：改变样本或问题顺序，记录偏差与置信度。','综合决策：把定性反馈和行为数据合并成一个产品建议。','审计优化：检查样本偏差、隐私、指标博弈和可复现性。','开放研究：提交研究报告、原始/脱敏资料、反例和下一轮计划。') }
        '产品策略与规格' { return @('最小 PRD：问题、目标用户、非目标、验收和风险。','受控变体：加入冲突需求/预算/时间约束，重排优先级。','综合规格：关联数据模型、API、错误状态和发布/回滚。','审计优化：邀请评审找歧义、不可测项和隐含安全风险。','开放研究：提交指标树、路线图、ADR、结果复盘和停止条件。') }
        '协作与交付' { return @('最小协作：为一个小任务写 issue、责任人、Definition of Done 和变更记录。','受控变体：模拟异步沟通、阻塞、范围变化和交付延期。','综合交付：把文档、代码、测试、发布和反馈串成可追踪链。','事故演练：写一份不责备个人的状态更新、复盘和行动项。','开放研究：总结沟通模式、信息损失、团队约定和改进指标。') }
        '职业表达' { return @('最小作品：为一个真实完成的项目写 README、截图、运行方法和限制。','受控变体：分别面向技术、产品和招聘读者改写。','综合答辩：用 5 分钟讲目标、证据、权衡、失败和下一步。','审计优化：让他人按文档复现，修复所有阻塞和夸大表述。','开放研究：建立作品集索引、能力矩阵、学习缺口和诚实的成长记录。') }
        default { return @('最小习惯：建立一个可持续的学习/复盘模板，记录目标、练习和证据。','受控变体：调整间隔、练习类型、时长或输入方式，比较记忆和疲劳。','综合迁移：把一个已学概念教给别人并用新问题检验迁移。','审计优化：找出错觉流畅、无效重复或身体负荷并改进计划。','开放研究：提交长期学习实验、指标、反例和下周期计划。') }
    }
}

function Write-Track([string]$kind, [string]$fileName, [string]$heading, [string]$outputName) {
    $source = Join-Path $Root $fileName
    $courses = Read-Courses $source $kind
    $out = [System.Collections.Generic.List[string]]::new()
    $out.Add("# $heading")
    $out.Add('')
    $out.Add("> 本文件是逐方向增补层：原课负责 11 段讲解，本文件负责逐课深挖、五级交付和五类 Lab。实验优先使用本机、模拟器、隔离容器或合成数据。")
    $out.Add('> 统一证据目录：`evidence/<课号>/README.md`、`commands.txt`、`tests/`、`artifacts/`、`notes.md`；记录版本、日期、清理步骤和未验证项。')
    $out.Add('')
    $out.Add('## 统一五级闯关')
    $out.Add('- Lv1：按原课跑通最小闭环，交输出/截图/测试。')
    $out.Add('- Lv2：只改一个参数、输入、设备条件或约束，交前后对比。')
    $out.Add('- Lv3：跨两节知识完成综合任务，交自动化测试、日志和设计图。')
    $out.Add('- Lv4：完成手写机制、性能/安全/可访问性/可靠性审计，交指标、根因和回归。')
    $out.Add('- Lv5：完成开放研究、架构、教学或产品交付，交 ADR、限制、反例和复现方法。')
    $out.Add('')
    foreach ($course in $courses) {
        $tick = [char]96
        $track = Classify $kind $course.Title
        $focus = Focus $track $course.Title
        $labs = Labs $track $course.Title
        $out.Add("## $($course.Id) · $($course.Title)")
        $out.Add('')
        $out.Add("- 原课文件：${tick}$fileName${tick}")
        $out.Add("- 主题轨道：$track")
        $out.Add('- 深挖问题：')
        foreach ($q in $focus) { $out.Add("  - $q") }
        $out.Add('- 闯关交付：')
        $out.Add("  - Lv1：${tick}$($course.Id)/lv1${tick} 最小闭环和环境证据。")
        $out.Add("  - Lv2：${tick}$($course.Id)/lv2${tick} 单变量变体、差异和失败解释。")
        $out.Add("  - Lv3：${tick}$($course.Id)/lv3${tick} 综合测试、日志、设计图和清理。")
        $out.Add("  - Lv4：${tick}$($course.Id)/lv4${tick} 基线、指标、审计/优化/回归报告。")
        $out.Add("  - Lv5：${tick}$($course.Id)/lv5${tick} 开放研究/ADR/教学/产品交付与限制。")
        $out.Add('- 五个 Lab：')
        $labNumber = 1
        foreach ($lab in $labs) {
            $out.Add("  - Lab $labNumber · $lab")
            $labNumber++
        }
        $out.Add('- 验收：至少 4/5 Lab 在干净环境可复现；成功、失败、边界、清理和未验证项均有记录。涉及安全、逆向、云资源或端侧发布时，只使用自有或明确授权资产。')
        $out.Add('')
    }
    $out.Add('## 方向毕业工程')
    $out.Add('')
    switch ($kind) {
        'MOB' { $out.Add('交付一个端侧作品集：Android/iOS/桌面/游戏/嵌入式各有一个最小可运行产物，并统一提供签名、权限、崩溃、功耗/帧率、离线、更新/回滚和安全审计证据。涉及逆向时只分析自己编译和签名的样例。') }
        'DAT' { $out.Add('交付一个可复现 AI 数据产品：合成/合规数据、数据契约、基线模型、PyTorch 训练、误差分析、RAG/工具调用、模型卡、漂移监控、成本和回滚；必须演示数据泄漏、提示注入、依赖失败与模型错版四类安全失败。') }
        'OPS' { $out.Add('交付一个本地云原生平台：IaC/流水线/制品签名/Kubernetes/OTel/SLO/告警/备份/成本齐全；演示节点重启、资源不足、依赖不可用、密钥轮换、发布失败和灾备恢复，并提交无责复盘。') }
        'PD' { $out.Add('交付一个证据驱动产品包：研究问题、访谈/可用性记录、PRD、原型、设计系统、WCAG/启发式审查、指标树、技术规格、发布沟通和结果复盘；所有作品描述必须可验证且不泄露个人数据。') }
    }
    $out.Add('')
    $out.Add('## 权威资料锚点')
    $out.Add('')
    switch ($kind) {
        'MOB' { $out.Add('- [Android Developers](https://developer.android.com/)'); $out.Add('- [Apple Developer Documentation](https://developer.apple.com/documentation/)'); $out.Add('- [OWASP MASVS](https://mas.owasp.org/MASVS/)') }
        'DAT' { $out.Add('- [PyTorch Tutorials](https://pytorch.org/tutorials/)'); $out.Add('- [scikit-learn User Guide](https://scikit-learn.org/stable/user_guide.html)'); $out.Add('- [NIST AI Risk Management Framework](https://www.nist.gov/itl/ai-risk-management-framework)') }
        'OPS' { $out.Add('- [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)'); $out.Add('- [OpenTelemetry Documentation](https://opentelemetry.io/docs/)'); $out.Add('- [Google SRE Books](https://sre.google/books/)') }
        'PD' { $out.Add('- [NN/g 10 Usability Heuristics](https://www.nngroup.com/articles/ten-usability-heuristics/)'); $out.Add('- [W3C WCAG](https://www.w3.org/WAI/standards-guidelines/wcag/)'); $out.Add('- [W3C Design Principles](https://www.w3.org/TR/design-principles/)') }
    }
    $out | Set-Content -LiteralPath (Join-Path $Root $outputName) -Encoding UTF8
    return $courses.Count
}

$counts = @{}
$counts.MOB = Write-Track 'MOB' '教案_方向8_移动桌面游戏嵌入式.md' '方向 8 · 移动 / 桌面 / 游戏 / 嵌入式闯关与实战补强' '方向8_移动桌面游戏嵌入式_闯关与实战补强.md'
$counts.DAT = Write-Track 'DAT' '教案_方向9_数据AI.md' '方向 9 · 数据 / AI / ML 闯关与实战补强' '方向9_数据AI_闯关与实战补强.md'
$counts.OPS = Write-Track 'OPS' '教案_方向10_运维云SRE.md' '方向 10 · 运维 / 云 / SRE 闯关与实战补强' '方向10_运维云SRE_闯关与实战补强.md'
$counts.PD = Write-Track 'PD' '教案_方向11_产品设计软技能.md' '方向 11 · 产品 / 设计 / 软技能闯关与实战补强' '方向11_产品设计软技能_闯关与实战补强.md'
$counts.GetEnumerator() | ForEach-Object { Write-Output "$($_.Key): $($_.Value) cards" }
