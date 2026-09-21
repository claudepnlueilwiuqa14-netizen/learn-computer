# 方向10 · 运维 / 云 / SRE 深度教案（OPS1–OPS49）

> **学生**：泽泽。纯零基础，术后康复期、手有留置针、行动不便、时间极充裕；目标"计算机领域顶级大佬"，坚定白帽路线，愿为学习投资，拒绝野鸡包会班与盗版。
> **教学铁律**：极细拆分、单步可执行可验收、动手后必讲理论；任何头晕/疼痛立刻停学。
> **本文件定位**：方向10 的 49 节逐节深教案，每节严格含 11 段（🎯目标 / 📋小白前置 / 🟢最浅层 / 🟡动手层 / 🔵原理层 / 🟣深挖层 / 🔴顶级视角 / 🟠安全合规 / ✅验收 / ⚠️常见坑 / ➡️下一步）。
> **白帽红线（贯穿全案）**：只练自己控制的机器 / 授权靶场 / 自家虚拟机 / CTF。绝不攻击他人系统、不登录他人账号、不部署恶意工具。基础设施安全：最小权限、秘钥绝不硬编码进仓库（用环境变量/密钥管理）、不暴露未授权端口、不扫描他人网络。
> **工具链**：本机 Git Bash、Docker Desktop（Windows）、kubectl/minikube、terraform、ansible、prometheus、grafana（尽量用 Docker 起）。命令路径用 `/c/...`；能复制就复制，护手优先。

---

# OPS1 · Linux 安装 / 发行版 —— 内核 / 包管理

## 🎯 目标
学完这节，你能在自己电脑上装好一台 Linux 虚拟机（或 WSL2），说出"发行版"是什么、apt/dnf 是什么，并成功运行第一个命令 `uname -a` 看到内核版本。

## 📋 小白前置
PRE0–PRE8（认识电脑、终端、浏览器）、OPS6 之后会用到网络，但本节只需 PRE6 终端基础。

## 🟢 部分一·最浅层（生活比喻）
把电脑想象成"房子"，操作系统（OS）是房子的"物业管理系统"。Windows 是一套物业，macOS 是另一套，Linux 是开源社区一起盖的第三套。不同的 Linux 发行版（Ubuntu、CentOS、Debian）就像同一家开发商出的"精装版 / 毛坯版 / 商用版"——内核（kernel，房子的地基与承重墙）基本一样，但预装家具、物业规章（包管理）不同。你练手，先挑一套好上手的"精装房"：Ubuntu。

## 🟡 部分二·动手层（逐字操作 + 真实命令）
你手有留置针，优先用 WSL2（Windows 自带，不用另装虚拟机软件），复制粘贴即可。
1. 以管理员打开 Git Bash（右键 → 以管理员身份运行）。
2. 启用 WSL：`wsl --install` 然后重启。若已装，跳过。
3. 装 Ubuntu：`wsl --install -d Ubuntu`。装完设用户名 `zeze`、密码（屏幕不显示，输完回车即可）。
4. 进入 Linux：`wsl` 或开始菜单搜 Ubuntu。
5. 逐字敲（每条复制后回车）：
```bash
uname -a            # 看内核版本/架构
cat /etc/os-release # 看发行版信息
lsb_release -a 2>/dev/null || echo "无 lsb_release"
```
预期：`Linux ZezePC 5.15.x... x86_64 GNU/Linux` 一行 + `Ubuntu 22.04...`。

## 🔵 部分三·原理层
`uname -a` 调系统调用 `uname(2)`，内核把编译时写死的版本串（含 `VERSION`、`PATCHLEVEL`）返回。发行版的 `/etc/os-release` 是 systemd 推广的标准化文本，记录 `ID=ubuntu`、`VERSION_ID`。内核是唯一直接管硬件的程序，发行版 = 内核 + 用户态工具（GNU coreutils、systemd、包管理器）+ 预装软件。包管理器本质是"带依赖图的软件安装器"。

## 🟣 部分四·深挖层
为什么有这么多发行版？历史：1991 年 Linus 写内核，GNU 提供用户态工具；1993 年 Debian 出现（社区驱动、强调自由），1994 年 Red Hat（商业），2004 年 Ubuntu（基于 Debian、易用）。两大体系：**Debian 系**用 `apt`/`dpkg`（`.deb`），**RHEL 系**用 `dnf`/`rpm`（`.rpm`）。顶级工程师按场景选：服务器稳定选 Debian/Ubuntu LTS 或 RHEL 系；桌面玩新特性选 Fedora/Arch。内核版本号 `5.15` 中 5=主版本、15=次版本（偶数为稳定长期支持 LTS）。

## 🔴 部分五·顶级视角
顶级 SRE 把"装系统"抽象成代码：用 Packer 打镜像、cloud-init 初始化、Terraform 起机器（见 OPS33）。他们几乎不在生产中手动 `apt install`——一切 `IaC`（基础设施即代码）。内核版本选择直接影响安全补丁窗口（LTS ernel 拿 6 年补丁）。理解发行版谱系 = 理解你未来面对的每一条 CVE 公告属于哪条修复链。

## 🟠 部分六·安全 / 合规种子
只装来自官方源的发行版镜像（校验 SHA256/签名），绝不下载来路不明的"破解版 ISO"。虚拟机/ WSL 只连你自己网络，不对外开放端口。更新源只用官方 `archive.ubuntu.com`，避免第三方 PPA 投毒。

## ✅ 验收
截图：① `uname -a` 输出含 `x86_64`；② `cat /etc/os-release` 显示 `Ubuntu`。口头回答：apt 属于哪系、内核版本号怎么读。

## ⚠️ 常见坑
① WSL 装了却进不去：用 `wsl -l -v` 看状态，状态 `Stopped` 就 `wsl` 启动。② 密码不显示字符以为坏了——正常，盲打回车。③ 误用管理员权限装普通软件——日常用普通用户，sudo 才提权。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
真实装机还有一条路：Ventoy 启动盘（多 ISO 同盘选启），适合想裸装双系统的同学；但你留置针在身，WSL2 最省力。WSL2 本质是"Hyper-V 轻量虚拟机跑真 Linux 内核"，所以 `uname` 看到的是真内核而非模拟层——你学的全部命令在 WSL2 与云服务器 100% 一致，价值极高。发行版选择：生产主流 Ubuntu LTS（5 年支持）/ Debian（更稳包更老）/ RHEL 系（Rocky/Alma，企业爱用）。顶级工程师看"安全更新窗口+生态成熟度"权衡。包管理背后有"依赖地狱"：`apt-get install -f` 修断依赖，`dpkg -i` 不管依赖，`apt` 才解析。`/var/lib/dpkg/`（状态库）、`/var/cache/apt/`（下载缓存）是排障金矿。云上"装系统"多被镜像替代（AMI/自定义镜像，OPS12），但懂底层才知道镜像里到底有什么。护手：命令能复制就复制，WSL 右键即粘贴，别硬敲长路径。换源提速：`sudo sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list` 后 `sudo apt update`（仅用可信镜像源；不碰第三方 PPA 防投毒）。

## ➡️ 下一步
OPS2 · 文件系统 / 一切皆文件（inode / 挂载）。

---

# OPS2 · 文件系统 / 一切皆文件 —— inode / 挂载

## 🎯 目标
理解 Linux "一切皆文件"的含义，能列出目录树、看懂路径、用 `df`/`mount` 看挂载，说出 inode 是什么。

## 📋 小白前置
OPS1（已进 Linux）。

## 🟢 部分一·最浅层（生活比喻）
Linux 把"所有东西"都当文件：硬盘是文件、键盘是文件、甚至进程信息也是文件。就像一栋楼里，不管是人、电梯还是电表，都用"房间号"统一管理。inode 是"房间的档案卡"——记录这间房多大、谁有权进、里面东西在哪，但档案卡本身不写名字；名字（文件名）只是贴在门上的便利贴，可以撕掉重贴，但档案卡不变。

## 🟡 部分二·动手层
```bash
pwd                 # 我在哪（print working directory）
ls -la /            # 根目录下有什么
df -h               # 各分区用了多少（人类可读）
mount | head        # 挂载了哪些设备
ls -li /            # 看 inode 号（第一列）
stat /home/zeze     # 看某路径的 inode 元数据
```
预期：`ls -li /` 第一列是一串数字（inode）；`df -h` 显示 `/dev/sdX` 或 `overlay` 与各挂载点的使用率。

## 🔵 部分三·原理层
VFS（虚拟文件系统）给所有设备统一接口 `open/read/write/close`。硬盘分区格式化成 ext4/xfs 后，`mkfs` 分配 inode 表；每个文件 = 一个 inode（存权限、大小、数据块指针、时间戳）+ 若干数据块。目录本质是"文件名→inode 号"的映射表。硬链接 = 多个文件名指向同一 inode（`ln a b`，`stat` 看 `Links` 变 2）；软链接 = 文件内容存的是另一路径（`ln -s`）。`mount` 把一块设备"挂"到目录树的某个点，访问该点即访问设备。

## 🟣 部分四·深挖层
inode 耗尽 vs 空间耗尽：小文件极多会占满 inode 表（`df -i` 看 `%IUsed`），即使磁盘没满也写不进新文件——经典运维事故。ext4 的 extent（连续块）减少碎片；xfs 适合大文件高并发。一切皆文件延伸到 `/proc`（内核运行状态，如 `/proc/cpuinfo`）、`/dev`（设备节点）、`/sys`（sysfs）。`/proc/1/maps` 能看到 1 号进程（systemd）的内存映射——安全取证常用。

## 🔴 部分五·顶级视角
顶级工程师用"一切皆文件"做统一抽象：配置即文件（Git 管理）、日志即文件（被采集）、设备即文件（容器用 `/dev` 暴露 GPU）。Kubernetes 的 `emptyDir`/`hostPath` 本质就是挂载（OPS25）。理解 inode 是排查"磁盘满但 du 算不出"类疑难的根基。

## 🟠 部分六·安全 / 合规种子
`/proc`、`/sys` 只在本机、自己权限下读；不乱 mount 别人给的设备（可能藏恶意 udev 规则）。敏感目录权限收紧（如 `/etc` 仅 root 写）。不把密钥文件放在 world-readable 路径。

## ✅ 验收
截图 `df -h` 与 `ls -li /`；写一句话解释硬链接与软链接区别。

## ⚠️ 常见坑
① `rm` 删软链接本身不会删源（删源则链接悬空）。② WSL 里 `df` 显示 overlay 正常。③ `cd` 到不存在目录报错——先 `pwd` 确认位置。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
文件系统的"一切皆文件"在 `/proc` 体现得最妙：`/proc/cpuinfo`（CPU 信息）、`/proc/<PID>/cmdline`（进程命令行）、`/proc/<PID>/fd/`（打开的文件描述符）都是伪文件，读它们等于向内核问诊——这是排障与取证的底层入口（SEC88）。`/dev` 下 `sda` 是硬盘、`null` 是黑洞、`urandom` 是随机数源；`/dev/sda1` 挂到 `/` 才被访问，这就是 mount 的本质。实战：`find / -xdev -type f | wc -l` 数文件猜 inode 压力；`df -i` 看 inode 余量（小文件极多会先耗 inode 再耗空间）。硬链接不能跨文件系统、不能链目录（防环）；软链接可跨、可链目录，但源删则悬空（`readlink` 看指向）。ext4 的 64 位 inode、dir_index（htree）加速大目录；xfs 适合大文件高并发。容器里看到的 `/` 是镜像层叠加（OPS19 overlayfs），`df` 看到的是宿主机视图（经典误导，OPS7）。顶级视角：理解 inode=理解"磁盘满但 du 算不出"类疑难（删大文件但进程仍持句柄→空间不释放，`lsof | grep deleted` 查）。安全：敏感目录权限收紧，`/etc/shadow` 仅 root 读；不乱 mount 未知设备。

## ➡️ 下一步
OPS3 · 权限 / 用户 / 组（rwx / 特殊位 / ACL）。

---

# OPS3 · 权限 / 用户 / 组 —— rwx / 特殊位 / ACL

## 🎯 目标
说清 rwx 三位一组含义，会 `chmod`/`chown`，理解 `sudo`、SUID 位，知道 ACL 是什么，能把自己目录设为仅自己可读。

## 📋 小白前置
OPS1、OPS2。

## 🟢 部分一·最浅层（生活比喻）
权限像宿舍门禁：r=能看里面（读）、w=能改东西（写）、x=能进门执行（对目录=能进）。三组分别是"房主(u)/同宿舍(g)/外人(o)"。sudo 像"找宿管借万能卡"。SUID 像"借了班长卡，期间你以班长身份开门"。

## 🟡 部分二·动手层
```bash
id                  # 我是谁、属哪组
ls -la ~/          # 看权限串 如 -rw-r--r--
touch test.txt && chmod 600 test.txt   # 仅自己读写
chmod u+x script.sh                    # 给自己加执行位
chown zeze:zeze test.txt               # 改属主（需权限）
getfacl test.txt                       # 看 ACL（可能默认无）
mkdir safe && chmod 700 safe           # 私有目录
```
预期：`ls -la test.txt` 显示 `-rw-------`（600）。

## 🔵 部分三·原理层
权限串 10 字符：第1位类型（`-`文件/`d`目录/`l`链接），后9位 `rwx rwx rwx` 对应 u/g/o。底层是 12 位 mode 位（含特殊位）。`chmod 600` 是八进制：6=4+2(r+w)，0=无。进程访问文件时内核比对"进程 euid/egid"与文件 uid/gid 及 mode 位。sudo 通过 `/etc/sudoers` 授权，用 `setuid` 提权到 root 执行命令。

## 🟣 部分四·深挖层
三个特殊位：SUID（4，执行时 euid=文件 owner，如 `/usr/bin/passwd`）、SGID（2，目录里新建文件继承组）、Sticky（1，`/tmp` 仅创建者能删自己文件）。ACL 突破"只有三组"限制，`setfacl -m u:alice:r test.txt` 单独给 alice 读。umask 决定新建文件默认权限（022→644）。权限错误是"网站 403 / 上传失败"的头号原因，也是提权利用点（错误配置的 SUID 二进制 = 提权入口，见 SEC78）。

## 🔴 部分五·顶级视角
顶级 SRE 用"最小权限原则"：服务账户只配必需权限（K8s RBAC，OPS26）；用 `capabilities` 替代整 root（容器，OPS19）；用 `sudo` 细粒度授权而非给 root 密码。他们用 `auditd` 记录敏感文件访问，用 `find / -perm -4000` 定期盘点 SUID 二进制（防提权）。

## 🟠 部分六·安全 / 合规种子
绝不随意 `chmod 777`（等于对所有人开放，任何人可改内容植入后门）。不滥用 sudo，`/etc/sudoers` 用 `visudo` 编辑防语法错锁死。定期 `find / -perm -4000 -type f` 自查本机 SUID 程序，异常即排查（白帽自检，不碰他人机器）。

## ✅ 验收
截图 `ls -la test.txt` 显示 600；说出 SUID 位作用与一个真实例子（`/usr/bin/passwd`）。

## ⚠️ 常见坑
① `chmod +x` 只对文件生效，目录 x=可进入。② 改别人文件 `chown` 需 root。③ Windows 下 Git Bash 权限映射混乱——用 WSL 内操作最准。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
权限的根是"主体（进程 euid/egid）对客体（文件 mode 位）的比对"。实战：`id` 看当前身份；`sudo -i` 切 root（仅必要）；`su - zeze` 切用户。`umask 027` 让新建文件默认 640、目录 750（比默认 022 更严）。特殊位务必懂：SUID（4）让程序以文件 owner 身份跑（`/usr/bin/passwd` 借此改 `/etc/shadow`）；SGID（2）让目录下新文件继承组（共享目录协作）；Sticky（1）让 `/tmp` 仅创建者删自己文件。自查提权风险：`find / -perm -4000 -type f 2>/dev/null` 列出本机全部 SUID 二进制（白帽自检；发现非系统自带的异常 SUID 即排查，SEC78）。ACL 突破三组限制：`setfacl -m u:alice:r secret.txt` 单独授权、`getfacl` 查看、`mask` 位限定最大有效权限。容器里用 `runAsNonRoot`/`runAsUser` 降权（OPS26）。顶级视角：最小权限原则——服务账户只给必需权限，用 Linux capabilities（CAP_NET_BIND_SERVICE 等）替代整 root（OPS19）。安全：`/etc/sudoers` 必须用 `visudo` 编辑（防语法错锁死）；绝不 `chmod 777`（等于对所有人开放，任何人都可改内容植入后门）；定期盘点 SUID 防被利用提权。

## ➡️ 下一步
OPS4 · 进程管理（信号 / kill / 优先级）。

---

# OPS4 · 进程管理 —— 信号 / kill / 优先级

## 🎯 目标
理解进程/线程概念，会 `ps`/`top`，用信号 `kill -9`/`kill -15` 控制进程，理解 `nohup`/`&`，懂 nice 优先级。

## 📋 小白前置
OPS1–OPS3、OS1（进程线程概念可后补）。

## 🟢 部分一·最浅层（生活比喻）
进程像"正在运行的一个 App 窗口"，线程是窗口里同时干的多件事。kill 不是"杀"，是"发信号"——像拍人肩膀（`SIGTERM=15` 温和说下班、`SIGKILL=9` 直接断电关门，无法拒绝）。

## 🟡 部分二·动手层
```bash
sleep 1000 &         # 后台跑一个进程，记下 PID（如 [1] 1234）
ps aux | head        # 看进程列表
top -b -n 1 | head   # 快照（或交互 top）
kill -15 1234        # 温和终止
sleep 2000 & 
kill -9 %1           # 强制杀掉作业1
nice -n 10 sleep 999 & # 低优先级跑
renice 5 -p <PID>    # 改优先级
```
预期：`ps aux` 出现 `sleep` 行；`kill -15` 后进程退出；`kill -9` 必定退出。

## 🔵 部分三·原理层
`fork()` 复制进程、`exec()` 替换程序映像；PID 唯一。信号是内核发给进程的软中断，`kill(pid,sig)` 系统调用。SIGTERM(15) 可被程序捕获做清理（如保存文件），SIGKILL(9) 内核直接回收，程序无机会清理——故优先 15。优先级 `nice` 范围 -20（最高）~19（最低），默认 0；CPU 调度（CFS，OS2）按权重分配时间片。`&` 让进程进后台，`nohup` 使其忽略 SIGHUP（终端关也不死）。

## 🟣 部分四·深挖层
信号不可靠排队、处理函数要可重入（OS12）。僵尸进程：子进程死父未 `wait()`，占 PID 槽；用 `ps` 看 `Z` 状态，`kill` 父进程或 `wait` 解决。`D` 状态（不可中断睡眠，通常等 IO）常意味磁盘卡死，`kill -9` 也杀不掉——只能修底层。systemd 用 cgroup 管进程树（OPS10）。`/proc/<PID>` 暴露进程全部信息，是排障金矿。

## 🔴 部分五·顶级视角
顶级 SRE 把"进程生命周期"交给编排器：K8s 用 `SIGTERM`+`terminationGracePeriodSeconds` 优雅下线与 `preStop` 钩子（OPS22）；用 `liveness/readiness` 探针自动重启（OPS27）。他们懂 `SIGKILL` 会丢在途请求，故应用程序必须处理优雅关闭（关连接、刷缓冲）。理解 `D` 状态是定位存储故障的第一步。

## 🟠 部分六·安全 / 合规种子
只对本机自己起的进程 `kill`；绝不向他人进程/系统关键进程（如 PID 1）发信号。恶意程序常伪装成普通进程——排障时先确认进程来源（命令行、父 PID）再处理，不盲杀。

## ✅ 验收
截图 `ps aux | grep sleep` 与一次成功 `kill -15`；解释 15 与 9 区别。

## ⚠️ 常见坑
① `kill -9` 杀不掉 `D` 状态进程——先查存储。② 后台进程关终端死——加 `nohup` 或 `disown`。③ 误 `kill -9 1` 会关机——绝不碰 PID 1。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
进程是资源容器，线程是执行流（OS1 细讲）。实战加深：`ps -eo pid,ppid,stat,comm --sort=-%cpu | head` 看进程树与状态；`pgrep -a sleep` 按名找 PID；`pkill -f "python.*serve"` 按命令行杀（慎用）。信号全景：`kill -l` 列出 1–64；常用 SIGHUP(1 重读配置)、SIGINT(2 Ctrl+C)、SIGQUIT(3 核心转储)、SIGKILL(9)、SIGTERM(15)、SIGSTOP(19 暂停，不可捕获)。`kill -0 PID` 不杀、只探进程是否存活（健康检查技巧）。后台与守护：`cmd &` 进后台、`disown` 脱终端、`nohup cmd &` 忽略 HUP；`jobs`/`fg`/`bg` 管理。优先级：`nice -n 19` 最低、`renice` 改；实时调度 `chrt` 仅特殊场景。`D` 状态（不可中断睡眠，等 IO）杀不掉——定位存储故障（OPS7）。僵尸进程：子死父未 `wait()`，占 PID 槽，`kill` 父或重启父解决。顶级视角：K8s 用 `SIGTERM`+`terminationGracePeriodSeconds`+`preStop` 优雅下线（OPS22），应用须处理 SIGTERM 刷缓冲关连接，否则 `SIGKILL` 丢在途请求。安全：只对本机自己起的进程发信号；绝向 PID 1 或他人进程发信号；异常进程先确认来源（`/proc/PID`）再处理（SEC 自检不碰他人）。

## ➡️ 下一步
OPS5 · Shell / Bash 深入（数组 / 陷阱 / 调试）。

---

# OPS5 · Shell / Bash 深入 —— 数组 / 陷阱 / 调试

## 🎯 目标
写出带变量、数组、条件的 Bash 脚本，会用 `set -euo pipefail` 防错，会用 `shellcheck` 与 `bash -x` 调试。

## 📋 小白前置
OPS1–OPS4、SH1–SH3（Bash 基础前置，方向1c）。

## 🟢 部分一·最浅层（生活比喻）
Bash 像"厨房流水线脚本"：你写"洗菜→切菜→炒"，电脑逐条执行。陷阱是"某步失败你还继续炒，最后端出黑暗料理"——`set -e` 就是"任一步失败立刻停工"。

## 🟡 部分二·动手层
新建文件 `demo.sh`（VS Code 或 `nano`）：
```bash
#!/usr/bin/env bash
set -euo pipefail
names=("alice" "bob" "carol")
echo "总数: ${#names[@]}"
for n in "${names[@]}"; do
  echo "你好, $n"
done
# 调试运行
bash -x demo.sh
```
装 shellcheck：`sudo apt install shellcheck -y && shellcheck demo.sh`。
预期：打印三行问候；`bash -x` 显示每条命令展开过程。

## 🔵 部分三·原理层
Bash 是解释器，逐行读、做展开（变量 `$`、命令 `$(...)`、通配 `*`、算术 `$(( ))`）。`set -e` 遇命令返回非 0 即退出；`-u` 用未定义变量即报错；`-o pipefail` 管道任一环失败整体失败。数组 `${arr[@]}` 正确加引号避免分词。调试 `bash -x` 打印每步实际执行（PS4 可加行号）。引号是 Bash 头号坑：不加引号变量含空格会被拆成多参数。

## 🟣 部分四·深挖层
`$(cmd)` 命令替换 vs 反引号；`<<<` here-string；`2>&1` 重定向顺序敏感（`>file 2>&1` 正确，`2>&1 >file` 错）。子 shell `( ... )` 隔离变量。函数 `myfn(){ ...; }` 与 `local` 作用域。`trap 'cleanup' EXIT` 做退出清理（类似 try/finally）。`shellcheck` 是静态分析，能抓到未加引号、死循环等 200+ 类问题——顶级工程师 CI 里必跑（OPS30）。

## 🔴 部分五·顶级视角
顶级 SRE 把脚本当代码：版本控制、Code Review、CI 跑 shellcheck、用 `shellcheck -f diff` 接 pre-commit。复杂逻辑宁用 Python/Go 不用 Bash（可维护性）。他们用 `set -euo pipefail` 作为所有生产脚本的"安全气囊"，并用 `trap` 保证临时文件清理（防敏感泄露）。

## 🟠 部分六·安全 / 合规种子
脚本不 `curl | bash` 来历不明网址（投毒风险）；校验下载签名再执行。不把密码写进脚本——用环境变量/密钥管理（OPS47）。`eval` 慎用（命令注入）；用户输入进脚本先校验。

## ✅ 验收
提交 `demo.sh`（`set -euo pipefail` + 数组 + 循环），`shellcheck` 零报错截图。

## ⚠️ 常见坑
① 漏引号 `"${arr[@]}"` 致含空格元素断裂。② `set -e` 在 `if`/`while` 条件里不触发，误以为安全。③ 用 `[[ ]]` 而非 `[ ]`（后者是外部 test，前者内置更安全）。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Bash 是"解释器逐行执行 + 展开"。展开顺序：大括号 `{a,b}`→波浪号 `~`→变量 `$`→命令 `$( )`→算术 `$(( ))`→单词拆分（未引号变量按 IFS 拆）→文件名通配 `*`。头号坑：变量含空格未加引号被拆成多参数——永远 `"$var"`。调试三件套：`bash -x`（打印每步展开）、`set -x` 局部开、`PS4='+${LINENO}: '` 加行号、`shellcheck`（静态分析，CI 必跑，OPS30）。`set -euo pipefail` 是生产脚本安全气囊：遇错即停、未定义变量报错、管道失败整体失败。陷阱：`set -e` 在 `if`/`while` 条件里不触发；`(( ))` 算术返回非 0（如 0）也触发——用 `if ((n)); then` 注意。`trap 'rm -f "$TMP"; exit' EXIT INT TERM` 做清理（防敏感临时文件泄露）。函数 `myfn(){ local x; ...; }` 用 `local` 限作用域。子 shell `( ... )` 隔离变量改动。实战：读文件 `while IFS= read -r line; do ...; done < file`（`-r` 防反斜杠转义）；`mapfile -t arr < file` 读入数组。顶级视角：复杂逻辑宁用 Python/Go；脚本当代码——版本控制、Code Review、CI 跑 shellcheck。`eval` 慎用（命令注入）。安全：绝不 `curl | bash` 不明脚本；用户输入先校验；密钥不写脚本（用 env/Vault，OPS47）。

## ➡️ 下一步
OPS6 · 网络配置（接口 / 路由 / 防火墙），先回 OPS1–OPS5 巩固。

---

# OPS6 · 网络配置 —— 接口 / 路由 / 防火墙

## 🎯 目标
看懂本机 IP、网关、路由表，会用 `ip`/`ss` 排查端口占用，理解防火墙 `ufw`/`iptables` 基础。

## 📋 小白前置
OPS1–OPS5、NET1–NET6（网络模型基础）。

## 🟢 部分一·最浅层（生活比喻）
网卡像门，IP 是门牌号，网关是小区出口，路由表是"快递怎么出门"的地图，防火墙是门卫（只放名单内的人进）。

## 🟡 部分二·动手层
```bash
ip addr show          # 看所有网卡与 IP（新命令，替代 ifconfig）
ip route show         # 看路由表（默认网关 0.0.0.0/0）
ss -tulnp             # 看监听端口（t=tcp,u=udp,l=listen,n=数字,p=进程）
sudo ufw status       # 防火墙状态
sudo ufw allow 22     # 允许 SSH（仅自己机器）
ping -c 3 8.8.8.8     # 通不通
```
预期：`ip addr` 显示 `inet 172.x.x.x`；`ss -tulnp` 列出监听端口；`ufw` 显示 active/规则。

## 🔵 部分三·原理层
`ip` 命令操作内核 `netlink` 接口，管理 netdev/地址/路由/邻居（ARP）。`ss`（socket statistics）读 `/proc/net/tcp` 等，比旧 `netstat` 快。内核路由表按"最长前缀匹配"选下一跳；默认路由 `0.0.0.0/0` 指向网关。防火墙 `iptables`/`nftables` 在 Netfilter 钩子（PREROUTING/INPUT/...）按规则匹配五元组（源/目的 IP、端口、协议）决定 ACCEPT/DROP。`ufw` 是 iptables 的友好封装。

## 🟣 部分四·深挖层
`ip neigh` 看 ARP 缓存（MAC↔IP）。`ss -t state established` 看已连连接。MTU 影响分片；`tcpdump -i any port 80` 抓包（NET21）。容器网络用 veth pair + 网桥（OPS19）。`conntrack` 看状态化连接跟踪表（满则丢包，典型 DDoS 后故障）。systemd-resolved 管 DNS（`resolvectl status`，NET10）。

## 🔴 部分五·顶级视角
顶级 SRE 用"基础设施即代码"管网络：Terraform 建 VPC/安全组（OPS33）、Calico/Cilium 管 K8s 网络策略（OPS25）。他们排障顺序是"物理→链路→网络层→传输层→应用层"，`ss`/`tcpdump`/`mtr` 是武器。理解 Netfilter 钩子顺序 = 理解为何"容器端口映射""LB 健康检查"如何工作。

## 🟠 部分六·安全 / 合规种子
只对自己机器开端口；生产默认拒绝（`ufw default deny incoming`）。绝不扫描他人网络/端口（nmap 仅授权靶场，见 SEC70）。不开 0.0.0.0/0 放行 SSH 到公网；用密钥登录（OPS? SSH，本方向以密钥为铁律）。暴露端口最小化。

## ✅ 验收
截图 `ip addr` + `ss -tulnp` + `ufw status`；说出默认网关含义。

## ⚠️ 常见坑
① WSL 里 `ufw` 可能无效（WSL 网络由 Windows 管）——用 Windows 防火墙或容器网络理解。② `ping` 不通不代表服务挂（ICMP 可能被禁，用 `ss`/应用层测）。③ 改路由前备份，误删默认路由会断网。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
网络四件套：`ip` 管 netdev/地址/路由/邻居（Netlink），`ss` 读 `/proc/net` 看套接字，`resolvectl` 看 DNS（systemd-resolved），`ufw` 是 iptables/nftables 友好封装。实战：`ip -br addr` 简表；`ip neigh` 看 ARP 缓存（MAC↔IP）；`ss -t state established '( dport = :443 )'` 看已连 443；`ss -pntl` 看监听+进程；`tracepath 8.8.8.8` 看路径；`mtr -n 8.8.8.8` 持续诊断丢包（NET23）。路由：`ip route get 1.1.1.1` 看选哪路由；最长前缀匹配；默认路由 `0.0.0.0/0`。防火墙层次：无状态（iptables raw/filter 按包匹配）、有状态（conntrack 记连接，SG 同源，OPS16）。容器网络用 veth pair+网桥（OPS19）；K8s 用 CNI（OPS25）。`conntrack -S` 看连接跟踪表，满了会丢包（DDoS 后常见）。DNS 排障：`dig +short A example.com`、`nslookup`；`/etc/resolv.conf` 配 nameserver。顶级视角：排障顺序"物理→链路→网络→传输→应用"；`ss`/`tcpdump`/`mtr` 是武器；理解 Netfilter 钩子（PREROUTING/INPUT/...）才懂端口映射/LB 怎么工作。安全：只对自己机器开端口，默认拒绝（`ufw default deny incoming`）；不扫描他人网络（nmap 仅授权靶场，SEC70）；SSH 用密钥（OPS 红线）；暴露最小化。

## ➡️ 下一步
OPS7 · 系统调优 / 性能（剖析 / 瓶颈）。

---

# OPS7 · 系统调优 / 性能 —— 剖析 / 瓶颈

## 🎯 目标
会用 `top`/`htop`/`vmstat`/`iostat`/`free` 看 CPU/内存/IO 瓶颈，理解负载均值、OOM，会用 `perf`/`strace` 初探。

## 📋 小白前置
OPS4（进程/信号）、OPS1–OPS6。

## 🟢 部分一·最浅层（生活比喻）
性能排查像"医院体检"：CPU 是脑子忙不忙、内存是桌面够不够摊东西、磁盘 IO 是仓库取货快不快、负载均值是"排队人数"。OOM 是桌面堆满、系统被迫扔东西（杀进程）。

## 🟡 部分二·动手层
```bash
top                 # 实时：看 %CPU、%MEM、load average
htop                # 更友好（sudo apt install htop -y）
free -h             # 内存/交换
vmstat 1 5          # CPU/IO/进程 每秒采样5次
iostat -xz 1 3      # 磁盘 IO（sudo apt install sysstat -y）
uptime              # 负载均值 1/5/15 分钟
dmesg | tail        # 内核日志（OOM 痕迹）
```
预期：`top` 显示各进程占用；`free -h` 显示 Mem 行；`iostat` 显示 `%util`、`await`。

## 🔵 部分三·原理层
负载均值（load average）= 运行队列（R）+ 不可中断（D）进程数，单核 >1 即饱和，多核看核数。CPU 时间分 us（用户）、sy（系统）、id（空闲）、wa（等 IO）、st（被偷，虚拟机）。内存：free 含 buff/cache（可回收），真紧张看 `available`。OOM Killer 在内存耗尽时按 `oom_score` 杀进程保系统。`strace -p PID` 跟踪系统调用；`perf top` 采样热点函数。

## 🟣 部分四·深挖层
`/proc/<PID>/status` 看 VmRSS（常驻）。`sar`（sysstat）做历史回放——顶级 SRE 靠它定位"昨夜 3 点慢"。CPU 瓶颈看 `us` 高（应用算法）vs `sy` 高（系统调用/锁）；IO 瓶颈看 `wa`/`%util` 高。调优层次：应用代码→JVM/运行时参数→内核参数（`sysctl` 如 `net.core.somaxconn`、`vm.swappiness`）→资源扩容。eBPF（OS17 延伸）是现代顶级观测手段。

## 🔴 部分五·顶级视角
顶级 SRE 把性能当"可量化目标"：先测基线、定 SLO（OPS37）、找瓶颈、改、再测（A/B）。他们用 profiling（perf/FlameGraph）而非猜；用 `USE 方法`（Utilization/Saturation/Errors）系统扫资源。容器里看 `kubectl top`、节点看 `node_exporter`（OPS38）。理解 cgroup 限制（`/sys/fs/cgroup`）为何容器内 `free` 看到的是宿主机值——经典误导。

## 🟠 部分六·安全 / 合规种子
性能压测只对自己系统/授权靶场；`stress`/`dd` 类负载工具不往他人机器跑。监测数据含敏感信息，日志不泄露到公网。OOM 配置不当可被利用做 DoS——理解 `oom_score_adj` 保护关键进程。

## ✅ 验收
截图 `vmstat 1 3` + `free -h`；解释 load average 三个数含义。

## ⚠️ 常见坑
① 容器内 `free` 看的是宿主机内存——用 `kubectl top`/`cgroup`。② 负载高但 CPU 空闲=IO 或 D 状态卡（查磁盘）。③ 只看 `top` 瞬时值误判——用 `sar` 看趋势。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
性能剖析先定基线再找瓶颈，别猜。实战：`top` 交互按 `P`(CPU)/`M`(MEM) 排序；`htop` 树视图看线程；`vmstat 1` 看 `r`(运行队列)、`b`(阻塞)、`si/so`(换页，>0 即内存紧)、`us/sy/wa/id`；`iostat -xz 1` 看 `%util`(盘忙)、`await`(IO 延迟)、`aqu-sz`(队列)；`free -h` 看 `available`（含可回收 cache，真紧张看它）；`pidstat -u 1` 按进程；`dmesg -T | grep -i 'oom\|kill'` 查 OOM。负载均值 = R 态+D 态进程数，单核 >1 饱和、多核看核数；高负载低 CPU=IO 或 D 态卡（查磁盘）。OOM Killer 按 `oom_score` 杀保系统，可调 `oom_score_adj` 保护关键进程。进阶：`perf top` 采样热点函数、`perf record -g`+`FlameGraph` 出火焰图；`strace -p PID -e trace=network` 跟系统调用；`bpftrace` 现代顶观测（eBPF，OS17）。容器里 `free` 看到宿主机值——用 `kubectl top`/cgroup（经典误导）。顶级视角：USE 方法（Utilization/Saturation/Errors）系统扫资源；调优层次"应用代码→运行时参数→内核 sysctl→扩容"；性能当可量化目标，靠 SLO 驱动（OPS37）。安全：压测只对自己/授权靶场；监测数据含敏感不泄露；OOM 配置不当可被利用做 DoS。

## ➡️ 下一步
OPS8 · 日志 / 系统日志（rsyslog / journald）。

---

# OPS8 · 日志 / 系统日志 —— rsyslog / journald

## 🎯 目标
理解 Linux 两套日志（rsyslog 文件 vs journald 二进制），会 `journalctl` 查日志、按时间/服务过滤，会配置轮转 `logrotate`。

## 📋 小白前置
OPS1–OPS7。

## 🟢 部分一·最浅层（生活比喻）
日志像"监控录像 + 值班日记"。journald 是把日记写进加密笔记本（二进制，得用专用阅读器）；rsyslog 是贴墙上大家都能读的文本。轮转像"旧日记归档、只留最近 7 天"。

## 🟡 部分二·动手层
```bash
journalctl -n 50                 # 最近50条
journalctl -u ssh.service -n 20  # 某服务
journalctl --since "10 min ago"  # 按时间
journalctl -f                     # 实时跟踪（Ctrl+C 退出）
ls /var/log/                      # 传统文本日志目录
cat /etc/logrotate.d/rsyslog      # 轮转配置样例
sudo logrotate -d /etc/logrotate.conf  # 模拟执行
```
预期：`journalctl -u ssh` 显示 SSH 启动/登录记录；`/var/log/` 有 `syslog`、`auth.log` 等。

## 🔵 部分三·原理层
systemd-journald 收集内核、服务、syslog 消息存 `/run/log/journal`（内存）或 `/var/log/journal`（持久），结构化二进制，支持按字段查（`_PID=`、`_COMM=`）。rsyslog 是传统 syslog 守护，按 `/etc/rsyslog.conf` 规则把消息写文件，支持远程转发（中心化，OPS40）。`logrotate` 按 size/time 切分、压缩、保留 N 份、可 `postrotate` 重开文件。日志级别：debug<info<notice<warn<err<crit<alert<emerg。

## 🟣 部分四·深挖层
journald 默认非持久（重启丢）——生产需 `Storage=persistent`。结构化日志（JSON）便于采集（OPS40 ELK）。`logger "测试"` 手动写一条。远程 syslog 用 TCP(514)/RELP 防丢。日志轮转忘了配会撑爆磁盘（经典事故：`/var` 100% 致系统不稳）。`auditd` 写 `/var/log/audit/audit.log` 是安全审计日志（SEC 合规必看）。

## 🔴 部分五·顶级视角
顶级 SRE 用"集中式日志 + 结构化 + 不可篡改"：Fluent Bit/Vector 采集→Kafka→ES（OPS40）；用 Loki（标签索引，省成本）。他们定日志等级规范、脱敏（不记密码/令牌）、设保留期合规（OPS18 责任共担）。理解 journald→rsyslog→远端 pipeline 是排障与取证链路。

## 🟠 部分六·安全 / 合规种子
日志可能含密码/令牌——写日志前脱敏（OPS47 密钥管理）。日志含 PII，按合规保留、不公开。只查自己机器/授权系统日志；不篡改他人审计日志（犯罪）。`auditd` 规则用于白帽自查本机异常。

## ✅ 验收
截图 `journalctl -u ssh -n 10`；说出 journald 与 rsyslog 区别；解释 logrotate 为何必要。

## ⚠️ 常见坑
① WSL 可能无 systemd，`journalctl` 不可用——用 `/var/log` 文本日志。② 日志爆炸占满磁盘——必配 logrotate。③ 改 rsyslog.conf 语法错会丢日志——先 `-N1` 校验。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
日志两派：journald（二进制结构化，存 `/run` 或 `/var/log/journal`，支持按 `_PID`/`_COMMAND`/`_SYSTEMD_UNIT` 查）与 rsyslog（文本，按 `/etc/rsyslog.conf` 规则写 `/var/log/{syslog,auth.log,...}`，可转发远端）。实战：`journalctl -u ssh.service --since "2026-09-08 10:00" --until "11:00"` 时间窗；`journalctl _PID=1234` 按进程；`journalctl -p err -b` 本次启动的错误；`journalctl -f` 实时；`logger -p auth.warning "测试"` 手写一条；`rsyslog` 远程用 `@host:514`(UDP)/`@@host:514`(TCP)。轮转：`/etc/logrotate.d/` 配 `size 100M`/`daily`、`rotate 7`、`compress`、`missingok`、`postrotate systemctl kill -s HUP rsyslog`。忘了轮转会撑爆 `/var`（经典事故）。持久化：`Storage=persistent`（默认非持久，重启丢）。`auditd` 写 `/var/log/audit/audit.log` 是安全审计（SEC 合规必看，`-w /etc/passwd -p wa` 监关键文件）。顶级视角：集中结构化+不可篡改——Fluent Bit/Vector 采集→Kafka→ES（OPS40）、或用 Loki（标签索引省成本）；日志等级规范、脱敏、保留期合规（OPS18）。安全：日志可能含密码/令牌→写前脱敏（OPS47）；含 PII 按合规保留不公开；只查自己机器；不篡改他人审计日志（犯罪）。

## ➡️ 下一步
OPS9 · 定时任务 cron（调度 / 锁）。

---

# OPS9 · 定时任务 cron —— 调度 / 锁

## 🎯 目标
会写 crontab 定时跑脚本，理解 5 段时间表，会用 `flock` 防重复执行，会看 `/var/log` 里 cron 日志。

## 📋 小白前置
OPS5（脚本）、OPS8（日志）。

## 🟢 部分一·最浅层（生活比喻）
cron 像"电饭煲定时"：你设"每天 3 点煮"，它到点自动跑。锁（flock）像"防止上一次还没煮完，这次又开锅"——避免两锅同时煮糊。

## 🟡 部分二·动手层
```bash
crontab -e            # 编辑当前用户定时任务
# 写入一行（每天 3:05 跑备份脚本，输出追加日志）：
# 5 3 * * * /usr/bin/flock -n /tmp/backup.lock /home/zeze/backup.sh >> /home/zeze/backup.log 2>&1
crontab -l            # 列出
systemctl status cron || systemctl status crond
# 测试：每分钟跑看效果
# * * * * * date >> /home/zeze/cron_test.log
```
预期：`crontab -l` 显示刚写的行；到点在 `backup.log` 看到输出。

## 🔵 部分三·原理层
cron 守护进程每分钟读 crontab，按"分 时 日 月 周"五字段匹配当前时间触发。字段 `*`=任意，`/`=步长（如 `*/5` 每5分），`,`=列表，`-`=区间。任务在子 shell 跑，环境变量极少（PATH 默认 `/usr/bin:/bin`）——故脚本用绝对路径。flock 用文件锁（`flock(2)`）保证同一时刻仅一个实例：拿不到锁立即退出，避免重叠。

## 🟣 部分四·深挖层
cron 默认邮件把输出发本地 mail（常丢弃）——务必重定向到日志。systemd 定时器（`.timer`+`.service`）是现代替代，精度高、可持久、有日志（OPS10）。`@reboot` 开机跑、`@daily` 等宏。时区坑：cron 用 `/etc/localtime`，容器里可能是 UTC 致定时错位。Anacron 管关机错过任务（笔记本/台式）。分布式用 `systemd timer`+`RandomizedDelaySec` 错峰。

## 🔴 部分五·顶级视角
顶级 SRE 极少用裸 cron：K8s 用 CronJob（OPS22）、云用 EventBridge/Cloud Scheduler（OPS17）、配置管理用 Ansible（OPS34）。他们用 `flock` 或 `systemd` `Conflicts` 防重叠，输出统一进集中日志，失败告警（OPS42）。理解"定时任务失败没人知"是事故温床——必须可观测。

## 🟠 部分六·安全 / 合规种子
cron 以某用户身份跑，权限即该用户——不在 root crontab 跑来路脚本。cron 是攻击者常藏持久化的地方（`/etc/cron.d/` 异常项自查，白帽）。脚本路径用绝对、权限 700 防篡改。绝不把 cron 指向他人给的下载脚本。

## ✅ 验收
提交一条 crontab（带 flock + 日志重定向）截图；说出 5 段字段含义。

## ⚠️ 常见坑
① 脚本里命令找不到——用绝对路径或脚本开头 `PATH=...`。② 输出不知去向——必须 `>>log 2>&1`。③ 容器/ WSL 无 cron 守护——确认 `systemctl status`。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
cron 五字段 `分 时 日 月 周`，`*` 任意、`/` 步长、`-` 区间、`,` 列表；宏 `@reboot`/`@daily`/`@weekly`。实战：`crontab -e` 写 `*/5 * * * * flock -n /tmp/j.lock /path/job.sh >> /var/log/j.log 2>&1`（flock 防重叠）；`crontab -l` 列；`/etc/cron.d/` 放系统级（格式多一个"用户"字段）；`anacron` 管关机错过任务（笔记本）。cron 跑在极简环境（PATH 仅 `/usr/bin:/bin`）——脚本用绝对路径或开头 `PATH=/usr/local/bin:/usr/bin:/bin`。输出默认发本地 mail（常丢）→务必 `>>log 2>&1`。时区坑：cron 用 `/etc/localtime`，容器里可能 UTC 致定时错位。现代替代 systemd timer：`.timer`（`OnCalendar=*-*-* 03:05:00`、`Persistent=true` 补错过、`RandomizedDelaySec` 错峰）+ `.service`，精度高、有日志、可 `systemctl status`。分布式：`systemd timer`+`flock`、K8s CronJob（OPS22）、云 EventBridge/Cloud Scheduler（OPS17）。顶级视角：失败必须可观测——输出进集中日志+失败告警（OPS42）；`flock`/`Conflicts` 防重叠。安全：cron 以某用户身份跑，权限即该用户，不在 root crontab 跑来路脚本；cron 是攻击者常藏持久化处（`/etc/cron.d/` 异常项自查，白帽）；脚本 700 防篡改；绝不指向他人下载脚本。

## ➡️ 下一步
OPS10 · 服务管理 systemd（unit / 依赖）。

---

# OPS10 · 服务管理 systemd —— unit / 依赖

## 🎯 目标
理解 systemd 是"服务总管家"，会写一份 `.service` 单元文件、用 `systemctl` 启停开机自启、看依赖与失败原因。

## 📋 小白前置
OPS4（进程/信号）、OPS8（journald）、OPS9（定时）。

## 🟢 部分一·最浅层（生活比喻）
systemd 像"小区物业总控"：每个 App 是一户，物业负责开张（start）、关门（stop）、自动托管（enable）、跳闸重启（restart）。unit 文件是每户的"入住须知"。

## 🟡 部分二·动手层
写 `/etc/systemd/system/hello.service`（sudo）：
```ini
[Unit]
Description=Hello Demo
After=network.target

[Service]
ExecStart=/home/zeze/hello.sh
Restart=on-failure
User=zeze

[Install]
WantedBy=multi-user.target
```
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now hello.service
systemctl status hello.service
journalctl -u hello.service -f
```
预期：`status` 显示 active(running)；日志滚动打印。

## 🔵 部分三·原理层
systemd 是 PID 1，用 cgroup 统一管所有进程树（替代 SysV init 脚本）。unit 分 service/socket/timer/mount 等。启动顺序靠 `After`/`Requires`/`Wants` 依赖图（拓扑排序并行启动，故快）。`ExecStart` 是主进程；`Restart=on-failure` 非 0 退出自动拉起。`enable` 建符号链接到 `WantedBy` 目标目录实现开机自启。状态机：inactive→active→failed；`journalctl -u` 直接绑该 unit 日志。

## 🟣 部分四·深挖层
`Type=`：simple（默认，ExecStart 即主进程）、forking（守护 fork）、notify（就绪通知）。`WantedBy` vs `RequiredBy`：前者失败不阻断启动。资源限制用 `[Service]` 的 `MemoryMax`/`CPUQuota`（cgroup v2）——顶级用来限流防雪崩。`drop-ins`（`/etc/systemd/system/xxx.d/*.conf`）覆盖片段。`systemd-analyze blame` 看启动慢的 unit。`coredumpctl` 抓崩溃转储（SEC 取证）。

## 🔴 部分五·顶级视角
顶级 SRE 把"跑一个服务"标准化为 unit（或 K8s Pod）：声明式、可重启、有依赖、资源受限、日志进 journald。他们用 `Restart=always`+探测做自愈，用 `CPUQuota`/`MemoryMax` 做多租户隔离（防止一个服务拖垮整机）。理解 systemd 依赖图 = 理解开机为何快、为何某服务起不来（依赖未就绪）。

## 🟠 部分六·安全 / 合规种子
service 用最小权限用户（勿 root 跑普通应用）；`NoNewPrivileges=yes`、`ProtectSystem=strict` 加固（SEC83 容器安全同源）。只写自己机器的 unit；不加载他人给的 service 文件（可含恶意 ExecStart）。`/etc/systemd/system` 权限收紧。

## ✅ 验收
提交 `hello.service` 与 `systemctl status` 截图（active）；说出 `enable` 与 `start` 区别。

## ⚠️ 常见坑
① 改了 unit 忘 `daemon-reload` 不生效。② `WantedBy` 写错导致不开机自启。③ `Restart=always` 配崩了的服务会疯狂重启刷日志——用 `on-failure`+`RestartSec`。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
systemd 是 PID 1，用 cgroup 统一管进程树（替代 SysV 脚本）。unit 类型：service/socket/timer/mount/path/slice。实战：`systemctl list-units --type=service --state=failed` 看失败；`systemctl status <u>` 看主 PID/内存/日志锚点；`journalctl -u <u> -b` 本次启动日志；`systemctl daemon-reload` 改 unit 后必跑；`systemctl cat <u>` 看生效配置（含 drop-in 合并）；`systemctl edit <u>` 加 drop-in（`/etc/systemd/system/<u>.d/override.conf`）不改原文件；`systemd-analyze blame` 看启动慢户；`systemd-analyze security <u>` 评安全等级；`coredumpctl` 抓崩溃转储（SEC 取证）。`[Service]` 资源限制：`MemoryMax=512M`、`CPUQuota=50%`（cgroup v2，防单服务拖垮整机）；`Restart=on-failure`+`RestartSec=2s` 自愈；`Type=notify` 就绪通知才算起好。`WantedBy`(失败不阻断) vs `RequiredBy`(失败阻断启动)。顶级视角：把"跑服务"标准化为 unit（或 K8s Pod）：声明式、可重启、有依赖、资源受限、日志进 journald；用 `Restart`+探针做自愈、`MemoryMax` 做多租户隔离。安全：`NoNewPrivileges=yes`、`ProtectSystem=strict`、`PrivateTmp=yes`、`CapabilityBoundingSet=` 降权（SEC83 同源）；只写自己机器 unit；不加载他人 service（可含恶意 ExecStart）；`/etc/systemd/system` 权限收紧。

## ➡️ 下一步
OPS11 · 云概论 / 虚拟化（Hypervisor / 多租户）。

---

# OPS11 · 云概论 / 虚拟化 —— Hypervisor / 多租户

## 🎯 目标
说清 IaaS/PaaS/SaaS 区别，理解虚拟化（Type1/Type2 Hypervisor）、多租户、弹性、按需付费，知道主流云厂商。

## 📋 小白前置
OPS1–OPS10（已有单机概念）、PRE0（电脑组成）。

## 🟢 部分一·最浅层（生活比喻）
自己买服务器像"自建厂房"；云像"租写字楼"：IaaS=只租毛坯+水电（虚拟机），PaaS=连装修带物业（运行环境），SaaS=直接入驻办公（现成软件，如网盘）。虚拟化像"一栋楼隔成多个独立套间，每套以为自己独占整栋"。

## 🟡 部分二·动手层
（概念为主，动手留到 OPS12 起真实云。先在你的本机装 VirtualBox 体会虚拟化——可选，护手优先用 WSL 已算轻量虚拟化）
```bash
# 看本机是否支持虚拟化
grep -E 'vmx|svm' /proc/cpuinfo | head -1   # 有输出=CPU 支持
lscpu | grep Hypervisor                      # 看是否在虚拟机里
```
预期：`vmx`/`svm` 出现 = 支持；`lscpu` 显示 Hypervisor 厂商（如 Microsoft，WSL2 用 WHP）。

## 🔵 部分三·原理层
Hypervisor：Type1（裸金属，如 ESXi/KVM 直跑硬件）、Type2（宿主 OS 上，如 VirtualBox）。KVM 把 Linux 内核变 Hypervisor，QEMU 提供设备模拟，VM 以普通进程跑（CPU 用 VT-x 硬件加速）。多租户：云厂商把物理机切多 VM 共享，靠 cgroup/namespace/网络隔离。弹性=按负载伸缩实例数；按需付费=用多少算多少（计量 billing）。虚拟化关键：CPU 嵌套页表（EPT）、设备透传（VFIO）、virtio 半虚拟化驱动降开销。

## 🟣 部分四·深挖层
容器（OPS19）是"操作系统级虚拟化"，共享内核、更轻；VM 是"硬件级虚拟化"，隔离更强。云 region/az（可用区）容灾概念（OPS45）。租户隔离失败="侧信道/逃逸"（SEC83）——云安全责任共担（OPS18）。Live migration 热迁移靠内存迭代拷贝。云"关机仍计费"陷阱（停实例≠删盘）。

## 🔴 部分五·顶级视角
顶级 SRE 把云当"无限的、可按代码申请的资源池"：用 Terraform 申（OPS33）、用 IaC 管、按单元（cell）划分故障域、用多 AZ 保高可用。他们懂"虚拟化开销"在哪儿（上下文切换、设备模拟），据此选型（VM vs 容器 vs 裸金属）。理解多租户噪声邻居（noisy neighbor）是性能抖动根因之一。

## 🟠 部分六·安全 / 合规种子
只用自己账号下的云资源；不拿他人云账号练手。开源/免费层（AWS Free Tier、阿里云试用）合规使用，超量会扣费——设预算告警（OPS48）。云上默认"责任共担"：你配的端口/权限你负责（OPS18）。绝不把实验实例暴露公网当靶机练攻击。

## ✅ 验收
画一张 IaaS/PaaS/SaaS 对比表（文字即可）；说出 Type1/Type2 区别。

## ⚠️ 常见坑
① 以为"关了 VM 就不花钱"——EBS 盘/公网 IP 仍计费。② 混淆容器与 VM 隔离强度。③ Free Tier 超时用信用卡扣费——设账单告警。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
虚拟化两层：Type1 裸金属（ESXi/KVM 直跑硬件，快、隔离强）、Type2 宿主 OS 上（VirtualBox，方便）。KVM 把 Linux 内核变 Hypervisor，QEMU 模拟设备，VM 是普通进程（CPU 用 VT-x/AMD-V 硬件加速）。容器（OPS19）是"操作系统级虚拟化"——共享内核、更轻、启动秒级；VM 是"硬件级虚拟化"——隔离最强、启动慢。多租户：云把物理机切多 VM 共享，靠 cgroup/namespace/网络隔离；租户隔离失败=侧信道/逃逸（SEC83）。弹性=按负载伸缩实例数；按需付费=用多少算多少（计量 billing）。关键概念：region（地理区域，如 us-east-1）/ AZ（可用区，同 region 内电力网络独立的数据中心，容灾单位）/ 配额。Live migration 热迁移靠内存迭代拷贝（不中断）。云"关机仍计费"陷阱：停实例≠删 EBS 盘/公网 IP。顶级视角：把云当"可按代码申请的资源池"——Terraform 申（OPS33）、IaC 管、按 cell 划故障域、多 AZ 保高可用；懂虚拟化开销（上下文切换/设备模拟）据此选型（VM vs 容器 vs 裸金属）；理解"噪声邻居"是多租性能抖动根因。安全：只用自己账号资源；不在他人云练手；Free Tier 设预算告警（OPS48）；责任共担——你配的端口/权限你负责（OPS18）；绝不把实验实例暴露公网当靶机。

## ➡️ 下一步
OPS12 · AWS 核心（EC2 / S3 / VPC / IAM）。

---

# OPS12 · AWS 核心 —— EC2 / S3 / VPC / IAM

## 🎯 目标
掌握 AWS 四大核心服务：EC2（计算）、S3（对象存储，OPS15 已部分接触）、VPC（网络，OPS16）、IAM（身份与访问，贯穿安全）；会用 AWS CLI 启一台 EC2、建安全组、理解 IAM 策略。

## 📋 小白前置
OPS11（云/虚拟化）、OPS3（权限思想）、OPS6（网络）、OPS15（S3 基础）。

## 🟢 部分一·最浅层（生活比喻）
AWS 核心四件套像"租房四件事"：EC2=租的房子（虚拟机，你管装修）、S3=带编号的储物柜（存东西，OPS15）、VPC=你圈的小区围墙（网络隔离，OPS16）、IAM=门禁卡系统（谁能进哪间、拿什么钥匙，权限）。这四样是你在云上盖任何东西的地基。

## 🟡 部分二·动手层
装 AWS CLI v2（Git Bash，需自有账号，配置凭证用 `aws configure`，输入 AccessKey/Secret——仅自己账号，最小权限）：
```bash
aws --version
# 启一台免费层 EC2（仅自己账号，练完 terminate 防计费）
aws ec2 run-instances --image-id ami-0c94855ba95c71c99 \
  --instance-type t2.micro --region us-east-1 \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=zeze-lab}]'
aws ec2 describe-instances --filters Name=tag:Name,Values=zeze-lab \
  --query 'Reservations[].Instances[].{id:InstanceId,state:State.Name,ip:PublicIpAddress}'
# 练完务必清理，避免持续计费
aws ec2 terminate-instances --instance-ids <上一步的id>
aws iam list-users
```
预期：`run-instances` 返回 InstanceId；`describe` 看到 `running`+公网 IP；`terminate` 后状态 `shutting-down`。

## 🔵 部分三·原理层
EC2：弹性计算，实例=虚拟化出来的 VM（OPS11），镜像 AMI（含 OS）+ 实例类型（CPU/内存档）+ EBS 块存储（持久盘）。IAM：身份（User/Role/Group）+ 策略（JSON 文档，声明允许哪些动作对哪些资源）+ 信任关系（Role 可被服务/跨账号扮演）。请求经签名（SigV4）鉴权。VPC 见 OPS16、S3 见 OPS15——本节重点是"用 CLI 把它们串起来配通"。安全组是 EC2 的虚拟防火墙（OPS16）。

## 🟣 部分四·深挖层
实例生命周期：pending→running→stopping→stopped→terminated（终止后盘可删也可保留）。实例角色（Instance Profile）让 EC2 免 AK 拿临时凭证（比硬编码安全，OPS47）。AMI 市场（含付费镜像）。EBS 类型（gp3 通用/ io2 高 IOPS/ st1 吞吐）。IAM 策略评估：默认拒绝，显式 Allow 才放行；权限边界（Permissions Boundary）限最大权限。跨账号用 Organization + SCP 管。IMDSv2 防 SSRF 偷角色（SEC12）。

## 🔴 部分五·顶级视角
顶级 SRE 用 IaC 管 AWS（Terraform，OPS33）：不手动点控制台。他们用 IAM 角色链（而非长期密钥）、用 SCP 做组织级护栏、用 VPC 端点免流量出网（OPS16）、用 AMI 烘焙（bake）标准镜像（含监控/扫描，OPS46）。理解"EC2 是临时牛（cattle not pet）"——可随时重建，状态外置（EBS/S3/DB）。

## 🟠 部分六·安全 / 合规种子
仅用自己账号；AccessKey 最小权限+轮转（OPS47），不提交仓库。EC2 用实例角色而非硬编码 AK。安全组不开 0.0.0.0/0:22（OPS16）。terminate 后清理防计费与暴露。绝对他人 AWS 操作。IAM 过宽=沦陷通道（SEC82）。

## ✅ 验收
截图 `run-instances`+`describe`+`terminate` 流程（或描述其步骤）；说出 IAM 策略"默认拒绝"含义与实例角色为何比 AK 安全。

## ⚠️ 常见坑
① 忘了 terminate→持续计费（Free Tier 超也扣）。② 安全组没开 22/80→连不上。③ AccessKey 泄露→立即禁用轮转。④ 用他人/教学公共 AMI 含后门→只信用官方。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
AWS 核心是云运维的地基。EC2 实例生命周期：pending→running→stopping→stopped→terminated（终止后盘可删可留，状态外置到 EBS/S3/DB 才持久）。实例角色（Instance Profile）让 EC2 经 IMDS 拿临时凭证，比硬编码 AK 安全得多（OPS47）。EBS 类型：gp3 通用、io2 高 IOPS、st1 吞吐优化；快照（snapshot）做备份/跨 AZ 恢复。AMI 是镜像（含 OS+预装），市场有付费镜像（只用官方/可信）。IAM 深度：User（长期人用，尽量少）/ Role（服务扮演，首选）/ Group；策略 JSON 三要素 `Effect`(Allow/Deny)/`Action`(如 `s3:GetObject`)/`Resource`(ARN)；评估顺序"显式 Deny 胜→显式 Allow→默认 Deny"；权限边界（Permissions Boundary）限最大权限；组织 SCP（Service Control Policy）做账号级护栏。VPC 见 OPS16、S3 见 OPS15。IMDSv2 用 PUT 拿 token 防 SSRF 偷角色（SEC12）。顶级视角：用 IaC（Terraform，OPS33）管 AWS，不手动点控制台；用 IAM 角色链而非长期密钥；用 SCP 做组织护栏；用 VPC 端点免流量出网；"EC2 是临时牛（cattle not pet）"——可随时重建，状态外置。安全：仅自己账号；AccessKey 最小权限+轮转不入库（OPS47）；安全组不开 0.0.0.0/0:22；terminate 后清理防计费与暴露；绝不操作他人 AWS；IAM 过宽=沦陷通道（SEC82）。

## ➡️ 下一步
OPS13 · 阿里云 / 腾讯云（国内实践）。

---

# OPS13 · 阿里云 / 腾讯云 —— 国内实践

## 🎯 目标
知道国内主流云对应 AWS 的产品名（ECS/OSS/VPC/RAM），会用 CLI 或控制台做基础操作，理解国内合规与备案要求。

## 📋 小白前置
OPS11、OPS12（云与 AWS 概念）。

## 🟢 部分一·最浅层（生活比喻）
阿里云/腾讯云就是"国内的云写字楼"，户型（产品）和 AWS 差不多，只是名字中文、物业按国内规矩（备案、实名）来。

## 🟡 部分二·动手层
装阿里云 CLI（需自有账号，合规）：
```bash
curl -sL https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-amd64.tgz -o aliyun.tgz
tar -xzf aliyun.tgz -C ~/.local/bin && aliyun --version
# 配置：aliyun configure（填 AccessKey，仅自己账号）
aliyun ecs DescribeInstances --RegionId cn-hangzhou
aliyun oss ls                          # 列 OSS bucket（需授权）
```
预期：`aliyun --version` 有版本；`DescribeInstances` 返回 JSON（空数组也正常）。

## 🔵 部分三·原理层
国内云与 AWS 同构：ECS≈EC2、OSS≈S3、VPC 同名、RAM≈IAM、SLB≈ELB、RDS≈RDS。CLI 调 OpenAPI（HTTPS+签名），用 AccessKey（AK/SK）鉴权——务必最小权限、绝不入库（OPS47）。国内特殊：域名需 ICP 备案才能公网访问、实名认证、数据出境合规（个人信息保护法）。

## 🟣 部分四·深挖层
国内云有"按量/包年包月/抢占"计费，包月更便宜但有锁定期。OSS 同 S3 有存储级（标准/低频/归档）、跨区域复制、防盗链 Referer。RAM 角色扮演（AssumeRole）跨账号授权。云企业网/CEN 做多 VPC 互联。政务云/金融云有等保合规要求（SEC87）。

## 🔴 部分五·顶级视角
顶级 SRE 做"多云/混合云"：用 Terraform 同一套代码适配 AWS/阿里云 provider；用 RAM 角色而非 AK 长期密钥；国内业务必做备案与等保。理解国内合规边界（数据本地化）是出海/合规架构前提。

## 🟠 部分六·安全 / 合规种子
AccessKey 仅自己账号、最小权限、轮转；不提交仓库。国内云需实名，不借他人资质。域名备案依规办理，不绕备案。绝不对他人云资源操作。

## ✅ 验收
截图 `aliyun --version`；列出 AWS↔阿里云产品对照表（≥6 项）。

## ⚠️ 常见坑
① AccessKey 泄露=账号被盗——立即禁用轮转。② 国内云 CLI 区域名是 `cn-hangzhou` 等，勿填错。③ 忘备案域名被墙——公网服务先备案。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
国内云与 AWS 同构，命名本地化：ECS≈EC2、OSS≈S3、VPC 同名、RDS≈RDS、SLB≈ELB、RAM≈IAM、NAS≈EFS、ACK≈EKS、函数计算≈Lambda。CLI：阿里云 `aliyun`、腾讯云 `tccli`，均调 OpenAPI（HTTPS+签名），用 AccessKey(AK/SK) 鉴权。实战：`aliyun ecs DescribeInstances`、`aliyun oss ls`、`tccli cvm DescribeInstances`。计费：按量/包年包月/抢占（竞价，便宜可被回收）；包月更省但有锁定；资源包（OSS 存储包/流量包）降本。OSS 同 S3：存储级（标准/低频/归档）、跨区复制、防盗链 Referer、服务端加密（SSE-KMS）。RAM 角色扮演（AssumeRole）跨账号/跨服务授权；STS 临时凭证。国内特殊合规：域名 ICP 备案才能公网访（不备案被墙）、实名认证、数据出境合规（个人信息保护法/数据安全法）。政务云/金融云有等保（SEC87）要求。顶级视角：多云/混合云用 Terraform 同套代码适配多 provider（OPS33）；RAM 角色而非长期 AK；国内业务必做备案与等保；理解数据本地化边界是合规架构前提。安全：AccessKey 仅自己账号、最小权限、轮转、不入库（OPS47）；国内云需实名不借他人资质；域名依规备案不绕；绝不对他人云资源操作。

## ➡️ 下一步
OPS14 · Azure / GCP（多云）。

---

# OPS14 · Azure / GCP —— 多云

## 🎯 目标
了解 Azure、GCP 的核心产品与定位，会用各自 CLI 做基础查询，理解"多云战略"的利弊。

## 📋 小白前置
OPS11、OPS12、OPS13。

## 🟢 部分一·最浅层（生活比喻）
Azure 是微软的写字楼（和 Windows/Office 一家，企业最爱），GCP 是 Google 的（大数据/AI/K8s 发源地，便宜网络）。多云像"同时在三栋楼租房，防一栋塌了没地儿去"。

## 🟡 部分二·动手层
GCP CLI（需账号）：
```bash
gcloud version
gcloud config set project <你的项目ID>   # 仅自己项目
gcloud compute instances list
az version                                # Azure CLI
az account show                           # 看当前订阅（需登录自己账号）
```
预期：`gcloud compute instances list` 返回列表；`az account show` 显示订阅。

## 🔵 部分三·原理层
Azure：VM≈EC2、Blob Storage≈S3、VNet≈VPC、Entra ID（原 AAD）≈IAM、AKS≈EKS。GCP：Compute Engine≈EC2、Cloud Storage≈S3、VPC 同名、IAM 角色模型、GKE≈EKS（GCP 是 K8s 发源地）。三者都提供托管 K8s、Serverless、对象存储，差异在生态/价格/合规。

## 🟣 部分四·深挖层
多云利弊：利=避免厂商锁死、容灾、谈价筹码；弊=复杂度↑、技能分散、跨云网络贵（出口费 egress）。用 Terraform 多 provider 统一（OPS33）。GCP 强在全局 VPC、按秒计费、BigQuery。Azure 强在企业 AD 集成、混合云（Arc）。

## 🔴 部分五·顶级视角
顶级架构师按需选云：数据密集用 GCP、企业 AD 用 Azure、全球覆盖用 AWS；用统一 IaC+GitOps（OPS32）抹平差异。他们算"egress 成本"（跨云传数据贵）决定是否真多云。理解每家的 IAM 模型差异是安全配置基础。

## 🟠 部分六·安全 / 合规种子
各云账号各自实名、最小权限；跨云统一用身份联合（SSO）而非散落密钥。多云增加攻击面——统一审计日志（SEC82 云安全）。绝用他人订阅。

## ✅ 验收
列出 Azure/GCP 各 4 个核心产品并对应 AWS 名称；说明多云一条缺点。

## ⚠️ 常见坑
① 跨云流量 egress 费高——架构时考虑。② CLI 未登录/项目错→空结果误判。③ 多云=三套安全模型，易漏配。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Azure/GCP 是另两家主流云。Azure：VM≈EC2、Blob Storage≈S3、VNet≈VPC、Entra ID（原 AAD）≈IAM、AKS≈EKS、Logic Apps≈Step Functions。GCP：Compute Engine≈EC2、Cloud Storage≈S3、VPC 同名、IAM 角色模型、GKE≈EKS（GCP 是 K8s 发源地，集成最深）。CLI：`az`/`gcloud`，`az account show` 看订阅、`gcloud config set project <id>` 设项目。GCP 强项：全局 VPC（子网跨区）、按秒计费、BigQuery、全球任播网络；Azure 强项：企业 AD 集成、混合云 Arc、企业合规。多云利弊：利=避免厂商锁死、容灾、谈价筹码；弊=复杂度↑、技能分散、跨云 egress 贵。实战陷阱：跨云传数据出口费（egress）高——架构时考虑；CLI 未登录/项目错→空结果误判。顶级视角：按需求选云（数据密集用 GCP、企业 AD 用 Azure、全球覆盖用 AWS）；用统一 IaC+GitOps（OPS32）抹平差异；算 egress 成本决定是否真多云；理解各家 IAM 模型差异是安全配置基础。安全：各云账号各自实名、最小权限；跨云用身份联合（SSO）而非散落密钥；多云增攻击面→统一审计日志（SEC82）；绝用他人订阅。

## ➡️ 下一步
OPS15 · 对象存储（持久 / 合规）。

---

# OPS15 · 对象存储 —— 持久 / 合规

## 🎯 目标
理解对象存储（S3/OSS）模型：bucket/object/key、持久性 11 个 9、版本控制、生命周期、访问控制，会 CLI 上传下载。

## 📋 小白前置
OPS12 或 OPS13（云账号）。

## 🟢 部分一·最浅层（生活比喻）
对象存储像"无限大的带编号储物柜"：bucket 是仓库，object 是柜里箱子，key 是箱号（路径）。它不是硬盘文件夹（没目录树），key 里带 `/` 只是名字长得像路径。

## 🟡 部分二·动手层
AWS CLI（需自己账号、配置凭证）：
```bash
aws s3 mb s3://zeze-lab-$(date +%s) --region us-east-1
echo "hello zeze" > note.txt
aws s3 cp note.txt s3://zeze-lab-xxxx/note.txt
aws s3 ls s3://zeze-lab-xxxx
aws s3 cp s3://zeze-lab-xxxx/note.txt - | cat
aws s3 rb s3://zeze-lab-xxxx --force   # 删桶（清理，避免计费）
```
预期：上传/下载成功；`ls` 看到 `note.txt`。

## 🔵 部分三·原理层
对象存储是 KV：key→(data+metadata)。数据按 EC（纠删码）跨多设备/可用区存，宣称 99.999999999%（11个9）持久性。无层级目录，用 key 前缀模拟。强一致性（现代 S3）。版本控制保留多版防误删。生命周期规则自动转低频/归档/过期。ACL/桶策略（基于资源的 JSON 策略）控访问；公共读需显式开（易误配泄露，SEC22）。

## 🟣 部分四·深挖层
存储级：标准/低频(IA)/智能分层/归档(Glacier，取回慢且收费)。分段上传大文件（>5GB 必须）。预签名 URL 临时授权下载（不暴露永久权限，安全做法）。SSE 加密（SSE-S3/KMS）。跨区复制（CRR）容灾。对象锁（WORM）合规防篡改。事件通知触发 Lambda（OPS17）。

## 🔴 部分五·顶级视角
顶级 SRE 用对象存储做"数据湖/备份/静态站点/制品库"：版本控制+生命周期+对象锁=不可变备份（防勒索，SEC63）。他们用预签名 URL 替代长期凭证共享、用 KMS 托管密钥、用存储级优化成本（OPS48）。理解"公开桶泄露"是第一大云安全事故（SEC82）。

## 🟠 部分六·安全 / 合规种子
桶默认私有；公开读仅授权场景、最小化。用 KMS 加密（密钥不碰明文）。预签名 URL 设短过期。定期 `aws s3 ls`/配置审计查公开桶（白帽自查）。绝不把私有数据放他人公开桶。

## ✅ 验收
截图上传+下载成功；说出 11 个 9 含义与版本控制作用。

## ⚠️ 常见坑
① 忘了删测试桶→持续小计费。② 误开 `public-read` 全桶→数据泄露。③ 归档层取回要钱且慢——别存热数据进 Glacier。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
对象存储是 KV：key→(data+metadata)，数据按纠删码（EC）跨多设备/可用区存，宣称 11 个 9 持久性（意为年均丢失概率 1e-11，非"永不丢"）。无层级目录，key 里 `/` 只是名字。强一致性（现代 S3）：写后立即读得到。版本控制保留多版防误删（开了删=加 delete marker，可恢复）。生命周期规则：`Transition` 转低频/归档、`Expiration` 过期删，省成本。存储级：Standard（热）/ Standard-IA（低频，取回快但按 GB 收取回费）/ Intelligent-Tiering（自动调）/ Glacier（归档，取回分钟~小时且收费，适合冷备）。分段上传（>5GB 必须，多段并传）。预签名 URL `aws s3 presign` 临时授权下载（不暴露永久权限，安全做法）。SSE-S3（托管密钥）/ SSE-KMS（你控密钥，有审计）/ SSE-C（自带密钥）。跨区复制（CRR）容灾。对象锁（WORM）合规防篡改。实战：`aws s3 cp`/`sync`、`aws s3api list-object-versions` 看版本、`aws s3 ls --recursive` 列全。顶级视角：对象存储做数据湖/备份/静态站点/制品库；版本控制+生命周期+对象锁=不可变备份（防勒索，SEC63）；预签名 URL 替长期凭证共享、KMS 托管密钥、存储级优化成本（OPS48）；公开桶泄露是第一大云安全事故（SEC82）。安全：桶默认私有；公开读仅授权场景最小化；KMS 加密；预签名短过期；定期查公开桶（白帽自检）；绝不把私有数据放他人公开桶。

## ➡️ 下一步
OPS16 · VPC / 安全组（网络隔离）。

---

# OPS16 · VPC / 安全组 —— 网络隔离

## 🎯 目标
理解 VPC（私有网络）、子网、路由表、安全组（SG，有状态防火墙）、NACL（无状态），会用 CLI/控制台建隔离网络。

## 📋 小白前置
OPS6（网络基础）、OPS12/OPS13（云）。

## 🟢 部分一·最浅层（生活比喻）
VPC 像"你在云里圈的一圈围墙院子"；子网是院里分出的房间（公开区/内安区）；安全组是每扇门的对讲（只放白名单访客，且记住谁进过好放他出）；NACL 是院子大门的总闸（进出门各查一次）。

## 🟡 部分二·动手层
AWS CLI（自己账号）：
```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=zeze-vpc}]'
aws ec2 create-subnet --vpc-id <vpc-id> --cidr-block 10.0.1.0/24 --availability-zone us-east-1a
aws ec2 create-security-group --group-name zeze-sg --description "lab" --vpc-id <vpc-id>
aws ec2 authorize-security-group-ingress --group-id <sg-id> --protocol tcp --port 22 --cidr 10.0.0.0/16
```
预期：返回 VpcId/SubnetId/GroupId。

## 🔵 部分三·原理层
VPC 是账号内逻辑隔离的虚拟网络，CIDR 定义地址范围（如 10.0.0.0/16 = 65536 地址）。子网绑 AZ，分公开（有 IGW 路由）/私有（仅 NAT）。安全组是有状态——允许入站即自动允许其回包；可引用其他 SG（微服务互信）。NACL 是无状态子网级 ACL，入/出各列规则、编号顺序匹配、默认拒绝。路由表决定子网流量去向（IGW/NAT/对等连接）。

## 🟣 部分四·深挖层
安全组是"实例级"，NACL 是"子网级"——纵深防御。安全组不能 deny 具体（只能 allow，隐式 deny 其余）；NACL 可显式 deny。VPC 端点（Gateway/Interface）让私网直连 S3/服务不绕公网（降本+安全）。对等连接/VPC Peering、Transit Gateway 互联多 VPC。私网 IP 不暴露公网=最小暴露面。

## 🔴 部分五·顶级视角
顶级 SRE 用"三层网络"：公开 ALB 层 / 应用私有层 / 数据层（无公网）。安全组按服务最小开（如 DB 仅允许应用 SG）。他们用 VPC 流日志（flow logs）做流量审计（SEC82）、用网段规划避免冲突（多云互通）。理解 SG 有状态特性避免画蛇添足规则。

## 🟠 部分六·安全 / 合规种子
安全组宁紧勿松；SSH(22) 不向 0.0.0.0/0 开（用堡垒机/密钥，OPS?）。公网暴露最小化（白帽红线：不暴露未授权端口）。VPC 流日志开启审计。绝不配 SG 放行他人网段。

## ✅ 验收
截图 create-vpc/ subnet/ sg 返回；说出 SG 与 NACL 三点区别。

## ⚠️ 常见坑
① SG 有状态→开入站即可回包，别重复开出站。② CIDR 算错致地址不够/冲突。③ 0.0.0.0/0 开 22 = 被扫爆破——用密钥+限定源。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
VPC 是你云上逻辑隔离的虚拟网络，CIDR 定义地址范围（如 `10.0.0.0/16` = 65536 地址；`/24`=256、可用 254）。子网绑 AZ，分公有（路由到 IGW 出公网）/私有（仅经 NAT 出）。安全组（SG）是有状态实例级防火墙：允许入站即自动允许其回包，可引用其他 SG（微服务互信），默认隐式拒绝其余；NACL 是无状态子网级、入/出各列规则、编号顺序匹配、可显式 deny——纵深防御用"SG + NACL"。路由表决定子网流量去向（IGW/NAT/对等连接/传输网关）。实战：`aws ec2 create-vpc`/`create-subnet`/`create-security-group`/`authorize-security-group-ingress`；`aws ec2 describe-flow-logs` 看流日志（审计）。VPC 端点（Gateway/Interface）让私网直连 S3/服务不绕公网（降本+安全）。对等连接/VPC Peering、Transit Gateway 互联多 VPC。私网 IP 不暴露公网=最小暴露面。顶级视角：用"三层网络"——公开 ALB 层/应用私有层/数据层（无公网）；SG 按服务最小开（DB 仅允许应用 SG）；用 VPC 流日志做流量审计（SEC82）、网段规划避冲突（多云互通）；理解 SG 有状态避免画蛇添足规则。安全：SG 宁紧勿松，SSH(22) 不向 0.0.0.0/0 开（堡垒机/密钥）；公网暴露最小化（红线：不暴露未授权端口）；开 VPC 流日志审计；绝不配 SG 放行他人网段。

## ➡️ 下一步
OPS17 · 无服务器 Lambda（事件 / 扩展）。

---

# OPS17 · 无服务器 Lambda —— 事件 / 扩展

## 🎯 目标
理解 Serverless/FaaS 模型，会写并部署一个 Lambda（或云函数），懂事件触发、冷启动、扩展、计费。

## 📋 小白前置
OPS12/OPS13（云）、OPS5（脚本）、OPS15（对象存储触发）。

## 🟢 部分一·最浅层（生活比喻）
Lambda 像"随叫随到的临时工"：没人叫就不占工位（不计费），一有活（事件）立刻来干，活多就同时叫 N 个（自动扩）。缺点：刚叫时可能"找工服"慢半秒（冷启动）。

## 🟡 部分二·动手层
AWS Lambda（Python），本地写 `handler.py`：
```python
def lambda_handler(event, context):
    return {"statusCode": 200, "body": f"hello {event.get('name','zeze')}"}
```
部署（需账号）：
```bash
zip f.zip handler.py
aws lambda create-function --function-name zeze-hello \
  --runtime python3.12 --handler handler.lambda_handler \
  --role <执行角色ARN> --zip-file fileb://f.zip
aws lambda invoke --function-name zeze-hello --payload '{"name":"zeze"}' out.json
cat out.json
```
预期：`out.json` 含 `hello zeze`。

## 🔵 部分三·原理层
FaaS：平台管运行时，你只交函数。事件源（API Gateway/S3/SQS/定时）触发，平台起沙箱（microVM/容器）跑函数、回收。冷启动=首次/闲置后启动运行时开销（语言相关：Java 慢、Python/Node 快）。并发=每事件一个新实例（默认账户级并发限额）。计费=执行次数×时长×内存（GB-秒）。无服务器=你不管服务器，但仍需管配置/权限/可观测。

## 🟣 部分四·深挖层
Provisioned Concurrency 预热消除冷启动。层（Layer）共享依赖。死信队列（DLQ）收失败事件。超时（默认 3s~15min）防卡死。权限用执行角色（最小权限，绝非 AK）。API Gateway + Lambda = 无服务器 Web（BE17）。局限：长连接/大状态/超低延迟不合适——选容器/ECS。

## 🔴 部分五·顶级视角
顶级 SRE 用 Serverless 做"事件驱动胶水/API/数据处理管道"：省运维、自动扩、按量计费。但警惕"分布式单体"与冷启动延迟；用 Step Functions 编排（状态机）。理解计费模型定架构（避免无限循环触发烧钱）。可观测靠 X-Ray/追踪（OPS41）。

## 🟠 部分六·安全 / 合规种子
执行角色最小权限；函数代码不硬编码密钥（用环境变量+KMS，OPS47）。公网函数加鉴权（API Gateway 鉴权，防被刷调用烧费/被滥用）。事件源（如 S3 触发）确认是你自己的桶。绝不部署他人给的函数。

## ✅ 验收
截图 `aws lambda invoke` 输出；说出冷启动是什么、为何发生。

## ⚠️ 常见坑
① 超时默认短→长任务失败，调 `timeout`。② 并发暴增=账单暴增，设并发上限。③ 角色权限不足→AccessDenied，用最小够用权限。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Serverless/FaaS：平台管运行时，你只交函数。事件源（API Gateway/S3/SQS/定时/EventBridge）触发，平台起微 VM/容器跑函数后回收。冷启动=首次/闲置后启动运行时开销（语言相关：Java 慢、Python/Node 快；用 Provisioned Concurrency 预热消除）。并发=每事件一个新实例（默认账户级并发限额，设 `ReservedConcurrency` 防烧钱）。计费=次数×时长(GB-秒)×内存。实战：`aws lambda create-function`/`invoke`/`update-function-code`；Layer 共享依赖；DLQ（死信队列）收失败事件；`timeout` 默认 3s 可到 15min；`memory` 调高也提速 CPU（同比例）。权限用执行角色（最小够用，绝非 AK）。API Gateway + Lambda = 无服务器 Web（BE17）。局限：长连接/大状态/超低延迟不合适→选容器/ECS。事件源冲突（S3 触发循环）会无限自激烧钱——加防重/限流。顶级视角：用 Serverless 做事件驱动胶水/API/数据管道，省运维自动扩按量计费；用 Step Functions 编排状态机；理解计费模型定架构（避免无限循环）；可观测靠 X-Ray/追踪（OPS41）。安全：执行角色最小权限；代码不硬编码密钥（env+KMS，OPS47）；公网函数加鉴权（防被刷调用烧费/滥用）；事件源确认是自己桶；绝不部署他人给的函数。

## ➡️ 下一步
OPS18 · 云安全 / 责任共担（共享模型）。

---

# OPS18 · 云安全 / 责任共担 —— 共享模型

## 🎯 目标
说清"责任共担模型"：云厂商管什么、你管什么；理解共享责任边界、合规性（SOC2/ISO/等保）、最小权限在云上的落地。

## 📋 小白前置
OPS11–OPS17（云全貌）。

## 🟢 部分一·最浅层（生活比喻）
租写字楼：物业管楼体结构/电梯/消防（厂商责任），你管自己房门钥匙/室内装修/不放违禁品（你的责任）。责任共担=谁的地盘谁负责，边界写进合同。

## 🟡 部分二·动手层
（概念+自查，无危险命令）列一张责任矩阵（文字）：
```
IaaS(EC2): 厂商管物理/ hypervisor；你管 OS/网络/应用/数据
PaaS: 厂商多管运行时/OS；你管数据/身份/配置
SaaS: 厂商几乎全管；你管账号/使用方式
```
自查本机/账号：
```bash
aws iam get-account-summary          # 看账号安全概况（自己账号）
aws iam generate-credential-report   # 账号凭证报告
```

## 🔵 部分三·原理层
责任共担（Shared Responsibility）：厂商负责"云本身"（硬件、设施、虚拟化、区域可用区物理安全）；客户负责"云里的内容"（数据、身份与访问、应用、网络配置、客户端）。PaaS/SaaS 厂商向上接管更多层。安全是"深度防御"：IAM+加密+网络隔离+日志审计+配置合规。合规框架（SOC2/ISO27001/PCI/等保）是第三方对控制的审计证明。

## 🟣 部分四·深挖层
"配置错误"是云头号风险（SEC82）：公开 S3、0.0.0.0/0 SG、硬编码 AK、过度 IAM。厂商提供合规工具：AWS Config/Audit Manager、Azure Policy、阿里云配置审计。数据驻留（Data Residency）合规：选 region 决定数据物理位置。密钥管理（KMS/CloudHSM）让你掌控加密密钥（OPS47）。IMDSv2 防 SSRF 偷元数据（SEC12）。

## 🔴 部分五·顶级视角
顶级架构师把"责任共担"写进设计：默认加密、默认私有、默认最小权限、默认开审计日志。用策略即代码（Sentinel/OPA）卡住违规配置（Gatekeeper，OPS26）。他们做"合规即代码"——每次 IaC 提交过合规扫描（OPS46）。理解边界=知道事故时该找谁（厂商 or 自己）。

## 🟠 部分六·安全 / 合规种子
这是全方向安全基石：你配的每处都是你的责任。绝不因"厂商说安全"就松懈。只对自己资源负责；用 MFA、密钥轮转、密钥库（OPS47）。白帽自检用 Config/审计工具查自己账号暴露面。

## ✅ 验收
交一份 IaaS/PaaS/SaaS 责任矩阵；说出云安全头号风险（配置错误）及一例。

## ⚠️ 常见坑
① 误以为"上云就安全"——配置错照样泄露。② 长期 AK 不轮转。③ 忽略合规 region（数据出境）。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
责任共担是云安全基石：厂商管"云本身"（硬件、设施、虚拟化、region/AZ 物理安全、托管服务内部）；客户管"云里的内容"（数据、身份与访问、应用、网络配置、客户端/运行时配置）。PaaS/SaaS 厂商向上接管更多层。安全是深度防御：IAM+加密+网络隔离+日志审计+配置合规。合规框架（SOC2/ISO27001/PCI-DSS/等保）是第三方对控制的审计证明，选 region 决定数据物理位置（数据驻留合规）。厂商提供合规工具：AWS Config/Audit Manager、Azure Policy、阿里云配置审计——自动查"公开 S3/0.0.0.0/0 SG/硬编码 AK"等配置错误（云头号风险，SEC82）。密钥管理（KMS/CloudHSM）让你控加密密钥（OPS47）。IMDSv2 防 SSRF 偷元数据（SEC12）。实战：`aws iam get-account-summary`、`aws configservice get-compliance-details-by-config-rule` 自查。顶级视角：把责任共担写进设计——默认加密、默认私有、默认最小权限、默认开审计；用策略即代码（Sentinel/OPA）卡违规配置（Gatekeeper，OPS26）；"合规即代码"——IaC 提交过合规扫描（OPS46）；理解边界=事故时知道该找谁。安全：绝因"厂商说安全"就松懈；只对自己资源负责；用 MFA、密钥轮转、密钥库（OPS47）；白帽自检用 Config/审计工具查自己账号暴露面；配置错误是第一大云风险。

## ➡️ 下一步
OPS19 · Docker 深入（镜像 / 层 / 卷 / 网络）。

---

# OPS19 · Docker 深入 —— 镜像 / 层 / 卷 / 网络

## 🎯 目标
在 Docker Desktop（Windows）跑通镜像构建/运行，理解镜像分层、容器与镜像区别、volume 持久化、容器网络、最小镜像与权限。

## 📋 小白前置
OPS1（Linux）、OPS5（脚本）、OPS11（虚拟化概念）。

## 🟢 部分一·最浅层（生活比喻）
镜像像"App 的打包快照（模具）"，容器是"用模具造出的正在跑的实例（蛋糕）"。层像"千层糕"——每层只记改动，复用省空间。volume 像"外接硬盘"，容器删了数据还在。

## 🟡 部分二·动手层
（Git Bash 跑，Docker Desktop 已装并启动）
```bash
docker version
mkdir hello-docker && cd hello-docker
cat > Dockerfile <<'EOF'
FROM python:3.12-slim
WORKDIR /app
COPY . .
CMD ["python","-c","print('hello zeze from container')"]
EOF
echo "x" > dummy.txt
docker build -t zeze-hello .
docker run --rm zeze-hello
docker run --rm -v "$PWD/data:/data" -e NAME=zeze python:3.12-slim python -c "print('hi', '$NAME')"
```
预期：`docker run` 打印 `hello zeze from container`；`docker images` 见 `zeze-hello`。

## 🔵 部分三·原理层
Docker = 用户态容器引擎，用 Linux namespace（隔离 PID/网络/挂载等，OS15）+ cgroup（限额）+ OverlayFS（分层存储）。Dockerfile 每条指令=一层（只读），`RUN` 改层、`COPY` 加层；最终容器在只读层上叠可写层（COW）。镜像存 registry（Docker Hub/私有）。`docker run` 建容器=加可写层+起进程（PID1）。volume 是宿主机目录挂进容器，绕过可写层持久化。网络用桥接（默认 docker0）+ veth pair。

## 🟣 部分四·深挖层
层缓存：变动频繁的 `COPY` 放后、不变依赖（requirements）先装，加速构建。`.dockerignore` 排除无关文件（防泄密/瘦身）。镜像瘦身：slim/alpine 基础、多阶段构建（builder 编译→runtime 只留产物）。rootless 容器、非 root 用户跑（`USER 1001`）降风险（SEC83）。`docker scan`/Trivy 扫漏洞（OPS46）。`--read-only` 根文件系统、cap-drop 降权。

## 🔴 部分五·顶级视角
顶级 SRE 视镜像为"不可变交付物"：一次构建多处运行（环境一致，消除"我机器能跑"）。多阶段构建+最小化基础=小攻击面+快拉取。他们用 distroless/chainguard 基础、签名镜像（cosign）、SBOM（OPS20）。理解 OverlayFS 层=理解为何 `apt upgrade` 进容器不持久（改可写层，重建丢）。

## 🟠 部分六·安全 / 合规种子
不跑 `--privileged`（等于几乎 root，逃逸风险）。用非 root 用户（`USER`）。`.dockerignore` 防把 `.env`/密钥打进镜像（密钥管理 OPS47）。只拉官方/签名镜像，扫漏洞。绝用他人给的未审镜像。

## ✅ 验收
截图 `docker build`+`docker run` 成功；说出镜像与容器区别、volume 作用。

## ⚠️ 常见坑
① Docker Desktop 没启动→`docker version` 连不上，先开桌面端。② 改代码忘重新 build→跑旧镜像。③ 容器里数据不挂 volume→删容器数据没。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Docker = 用户态容器引擎，用 namespace（隔离 PID/网络/挂载/UTS/IPC，OS15）+ cgroup（限额 CPU/内存/IO）+ OverlayFS（分层存储）。动手增强：`docker images` 看层；`docker history zeze-hello` 看每层命令（密钥会暴露！）；`docker system df` 看占用、`docker system prune -a` 清悬虚镜像（省空间）；`docker exec -it <c> sh` 进容器排障；`docker logs -f <c>` 跟日志；`docker inspect <c>` 看完整配置（挂载/网络/环境变量）。Dockerfile 优化：变动少的 `COPY requirements.txt`+`pip install` 放前享缓存；`RUN apt-get update && apt-get install -y ... && rm -rf /var/lib/apt/lists/*` 清缓存减层；多阶段构建（`FROM builder AS build`→`FROM python:slim` `COPY --from=build /app/dist /app`）只留产物。`.dockerignore` 排除 `.env`/`node_modules`/`.git` 防泄密瘦身。镜像瘦身：slim/alpine/distroless/chainguard。运行：`--read-only` 根文件系统、`--cap-drop ALL --cap-add NET_BIND_SERVICE` 降权、`--user 1001` 非 root、`--memory`/`--cpus` 限额、`--pids-limit` 防 fork 炸弹。顶级视角：镜像=不可变交付物（一次构建处处运行，消除"我机器能跑"）；多阶段+最小基础=小攻击面+快拉取；distroless/chainguard+cosign 签名+SBOM（OPS20）。安全：不跑 `--privileged`（几乎 root、逃逸风险）；用非 root（`USER`）；`.dockerignore` 防密钥进镜像（密钥管理 OPS47）；只拉官方/签名镜像、扫漏洞；绝用他人未审镜像。

## ➡️ 下一步
OPS20 · 镜像 / 仓库 / 安全（扫描 / 签名）。

---

# OPS20 · 镜像 / 仓库 / 安全 —— 扫描 / 签名

## 🎯 目标
理解镜像仓库（registry）、镜像扫描、签名（cosign）、SBOM、信任链；会用 Trivy 扫自己镜像（真实命令）。

## 📋 小白前置
OPS19（镜像基础）。

## 🟢 部分一·最浅层（生活比喻）
仓库像"App 应用商店"，你上传/下载镜像。扫描像"上架前安检"查有没有带危险品（漏洞）。签名像"防伪封条"——确认这包真是你打的、没被调包。

## 🟡 部分二·动手层
装 Trivy（Git Bash / WSL）：
```bash
# 用 docker 跑 trivy 最省事（护手）
docker run --rm aquasec/trivy:latest image python:3.12-slim
# 或本机装
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh
./bin/trivy image zeze-hello
# 生成 SBOM
trivy image --format cyclonedx zeze-hello > sbom.json
```
预期：Trivy 输出 CVE 列表（含严重/高/中/低与修复版本）；`sbom.json` 生成。

## 🔵 部分三·原理层
Registry 存镜像层+清单（manifest），支持 tag/digest。漏洞扫描比对镜像里软件版本与 CVE 数据库（NVD/厂商）。签名用 cosign（Sigstore）对镜像 digest 签名，验证方用公钥确认来源与完整（防篡改）。SBOM（软件物料清单）列所有组件，便于漏洞追溯。信任链：构建→签名→扫描→入库→部署校验（Supply-chain，SLSA 框架）。

## 🟣 部分四·深挖层
`digest`（sha256）比 tag 不可变——生产用 `image@sha256:...` 而非 `:latest`（latest 漂变致不可复现）。私有仓库（ECR/Harbor/ACR）+ 接入扫描门禁。Notary/cosign 密钥用 KMS。Base image 选 distroless/chainguard 减组件。CI 里"扫描不过不让推"（OPS30/OPS46）。

## 🔴 部分五·顶级视角
顶级 SRE 建"可信供应链"：SLSA 三级、镜像签名+验证、SBOM 入库、策略门禁（OPA/Gatekeeper 在 K8s 侧 OPS26）。他们把"latest"视为反模式，所有部署锁定 digest。理解 CVE 修复 SLA（按 CVSS 定）是合规基础（SEC86）。

## 🟠 部分六·安全 / 合规种子
只扫自己镜像、只推自己仓库；拉取镜像验签名。`.dockerignore` 防泄密。不忽略高危 CVE（修或换基础）。密钥绝不进镜像层（历史可被 `docker history` 看，OPS47）。

## ✅ 验收
截图 Trivy 扫描输出；说出为何生产不用 `:latest` 而用 digest。

## ⚠️ 常见坑
① 忽略中危 CVE 累积成雷。② tag 漂变→"昨天能跑今天挂"。③ 镜像里藏密钥——`docker history` 可见，立即轮转。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
镜像仓库（registry）存镜像层+manifest（清单）；tag 可漂变，digest（sha256）不可变——生产用 `image@sha256:...`。漏洞扫描：Trivy/Grype 比对镜像内软件版本与 CVE 库（NVD/厂商），按 CVSS（0-10）分级，EPSS 预测被利用概率排优先级。签名：cosign（Sigstore）对 digest 签名，验证方用公钥确认来源+完整（防篡改、防投毒）。SBOM（CycloneDX/SPDX）列所有组件，便于漏洞对账（如 Log4Shell 爆发分钟级定位受影响服务）。信任链：构建→签名→扫描→入库→部署校验（SLSA 框架，L1-L4）。私有仓库：ECR/Harbor/ACR + 接入扫描门禁；Notary/cosign 密钥用 KMS。实战：`trivy image`/`fs`/`config` 扫镜像/代码/IaC；`cosign sign`/`verify`；`trivy sbom`。Base image 选 distroless/chainguard 减组件。CI 里"扫描不过不让推"（OPS30/OPS46）。顶级视角：建可信供应链——SLSA L3、镜像签名+验证、SBOM 入库、策略门禁（OPA/Gatekeeper，OPS26）；把 `:latest` 当反模式，所有部署锁 digest；CVE 修复 SLA 按 CVSS 定（合规基础，SEC86）。安全：只扫自己镜像、只推自己仓库；拉取验签名；`.dockerignore` 防泄密；不忽略高危 CVE（修/换基础）；密钥绝不进镜像层（`docker history` 可见→立即轮转，OPS47）。

## ➡️ 下一步
OPS21 · Kubernetes 架构（控制面 / 数据面）。

---

# OPS21 · Kubernetes 架构 —— 控制面 / 数据面

## 🎯 目标
说清 K8s 架构：控制面（API Server/etcd/scheduler/controller-manager）、数据面（kubelet/kube-proxy/容器运行时）、用 minikube 起集群并跑起 Pod。

## 📋 小白前置
OPS19（容器）、OPS11（虚拟化）、OPS10（systemd 思想）。

## 🟢 部分一·最浅层（生活比喻）
K8s 像"集装箱码头调度中心"：控制面是"调度总部"（接单/记账/排班/监工），数据面是"码头工人（节点）"真把箱子（容器）摆上船。你只说"我要 3 个箱子"，总部安排工人落地。

## 🟡 部分二·动手层
装并起 minikube（本机，护手优先用虚拟化）：
```bash
# Windows Git Bash 装 minikube/kubectl（用 choco 或 预编译二进制）
curl -LO https://dl.k8s.io/release/v1.30.0/bin/windows/amd64/kubectl.exe -o /c/Users/qq/.local/bin/kubectl.exe
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe -o /c/Users/qq/.local/bin/minikube.exe
minikube start --driver=docker
kubectl get nodes
kubectl run zeze --image=nginx --port=80
kubectl get pods
```
预期：`kubectl get nodes` 显示 Ready；`get pods` 显示 zeze Running。

## 🔵 部分三·原理层
控制面：API Server（唯一入口，鉴权/校验/持久化到 etcd）、etcd（一致 KV 存储集群状态）、scheduler（按资源/亲和选节点）、controller-manager（调谐循环，使实际=期望，如 ReplicaSet 保副本数）。数据面：kubelet（节点代理，管 Pod 生命周期）、kube-proxy（维护 iptables/IPVS 转发规则做服务发现）、容器运行时（containerd/CRI-O 跑容器）。声明式：你写期望状态，控制器持续对齐（reconcile）。

## 🟣 部分四·深挖层
API Server 用 watch 机制推变更；etcd 用 Raft 一致。控制面 HA=多 API Server+etcd 奇数节点。kubectl 是 API 客户端（认证用 kubeconfig）。Admission 控制器在写前改/验（OPA/Gatekeeper，OPS26）。CRD 扩 API（Helm/Operator 基础，OPS24）。网络模型：每个 Pod 独立 IP（CNI 插件，OPS25）。

## 🔴 部分五·顶级视角
顶级 SRE 把 K8s 当"分布式 OS"：调度、自愈、扩缩、服务发现、配置/密钥（OPS23）全内置。他们懂控制面瓶颈在 etcd（写放大/磁盘 IO）；用 operator 模式封装有状态应用（数据库）。理解 reconcile 循环=理解为何 K8s "最终一致"（改了配置要等几秒生效）。

## 🟠 部分六·安全 / 合规种子
minikube 仅本机练；生产 K8s 用 RBAC（OPS26）、网络策略（OPS25）、不在 Pod 跑特权。kubeconfig 是凭证，不泄露/不提交（OPS47）。绝不连他人集群。API Server 不暴露公网。

## ✅ 验收
截图 `kubectl get nodes`+`get pods` Running；说出控制面 4 组件职责。

## ⚠️ 常见坑
① minikube 驱动错（无虚拟化用 `--driver=docker`，需 Docker Desktop）。② kubectl 版本与集群差太多不兼容。③ Pod 一直 Pending=资源/镜像拉取失败，看 `describe`。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
K8s 架构：控制面（control plane）+ 数据面（worker nodes）。控制面四件：API Server（唯一入口，认证/鉴权/准入/持久化 etcd，所有 `kubectl` 都打它）、etcd（一致 KV 存集群全部状态，Raft 多数派写、是单点瓶颈）、scheduler（按资源/亲和/污点选节点放 Pod）、controller-manager（一组调谐循环，ReplicaSet 保副本数=期望、Deployment 管滚动、Namespace 等）。数据面：kubelet（节点代理，管 Pod 生命周期、报状态）、kube-proxy（维护 iptables/IPVS 规则做 Service 转发）、容器运行时（containerd/CRI-O 跑容器，替代 docker-shim）。声明式：你写期望状态，控制器持续 reconcile 对齐（最终一致）。实战：`minikube start --driver=docker`、`kubectl get componentstatuses`（旧）、`kubectl get pods -n kube-system` 看系统组件；`kubectl proxy` 开 API 本地代理。Admission 控制器（webhook）在写前改/验（OPA/Gatekeeper，OPS26）；CRD 扩 API（Helm/Operator 基础）。顶级视角：K8s=分布式 OS（调度/自愈/扩缩/服务发现/配置密钥全内置）；控制面瓶颈在 etcd（写放大/磁盘 IO）→用本地 SSD+合理 QPS；operator 模式封装有状态应用（数据库）；理解 reconcile 循环=为何 K8s "最终一致"（改配置等几秒生效）。安全：minikube 仅本机；生产用 RBAC（OPS26）、网络策略、不特权；kubeconfig 当凭证不泄露/不提交（OPS47）；绝不连他人集群；API Server 不暴露公网。

## ➡️ 下一步
OPS22 · Pod / Deployment / Svc（编排原语）。

---

# OPS22 · Pod / Deployment / Svc —— 编排原语

## 🎯 目标
会写 Pod/Deployment/Service 的 YAML，理解副本集、滚动更新、服务发现（ClusterIP/NodePort），部署并访问。

## 📋 小白前置
OPS21（架构）、OPS19（容器）、OPS6（端口/网络）。

## 🟢 部分一·最浅层（生活比喻）
Pod 是"最小调度单位"（常一个容器，偶尔同箱哥俩）。Deployment 是"我要几个、坏了自动补、升级慢慢换"的说明书。Service 是"稳定的前台电话号"，背后换了多少工人客人不打不通（负载均衡）。

## 🟡 部分二·动手层
写 `app.yaml`：
```yaml
apiVersion: apps/v1
kind: Deployment
metadata: {name: zeze-web}
spec:
  replicas: 3
  selector: {matchLabels: {app: zeze-web}}
  template:
    metadata: {labels: {app: zeze-web}}
    spec:
      containers:
      - name: web
        image: nginx:1.27
        ports: [{containerPort: 80}]
---
apiVersion: v1
kind: Service
metadata: {name: zeze-web-svc}
spec:
  selector: {app: zeze-web}
  ports: [{port: 80, targetPort: 80}]
  type: ClusterIP
```
```bash
kubectl apply -f app.yaml
kubectl rollout status deployment/zeze-web
kubectl get pods -l app=zeze-web
kubectl expose deployment zeze-web --type=NodePort --port=80   # 或改 type
```

## 🔵 部分三·原理层
Deployment 管理 ReplicaSet（保 N 副本），控制 Pod 模板。滚动更新（`strategy.rollingUpdate`）逐步替旧 Pod（maxSurge/maxUnavailable）零停机。Service 用 label selector 选后端 Endpoints，kube-proxy 写 iptables/IPVS 规则把 ClusterIP 流量 DNAT 到 Pod IP。ClusterIP（集群内）、NodePort（节点端口 30000+）、LoadBalancer（云 LB）。Pod IP 会变，靠 Service 名（DNS，CoreDNS）稳定访问。

## 🟣 部分四·深挖层
`kubectl rollout undo` 回滚（`revisionHistoryLimit`）。`readinessProbe`/`livenessProbe` 控流量/自愈（OPS27）。`resources.requests/limits` 抢调度（OPS7）。`terminationGracePeriodSeconds`+`preStop` 优雅下线（OPS4 信号）。HPA（Horizontal Pod Autoscaler）按 CPU 自动扩（OPS45）。headless Service（clusterIP: None）用于有状态/StatefulSet。

## 🔴 部分五·顶级视角
顶级 SRE 把"应用=Deployment+Service+Ingress+Config/Secret+HPA+探针"组合（GitOps，OPS32）。他们用 `kubectl apply` + `kustomize` 管理环境差异。理解滚动更新+探针=零停机发布；理解就绪探针缺失=上线即接流量崩。

## 🟠 部分六·安全 / 合规种子
Pod 用非 root/`securityContext`（runAsNonRoot、drop capabilities，SEC83）。Service 不滥用 NodePort 暴露公网。镜像锁 digest（OPS20）。最小权限 SA（OPS26）。只对自己集群 apply。

## ✅ 验收
截图 3 副本 Running + Service；说出 Deployment 与 Pod 关系、三种 Service 类型。

## ⚠️ 常见坑
① selector 与 pod label 不一致→Service 无后端。② 无就绪探针→流量打进未起好的 Pod。③ 改镜像忘改 tag→旧版。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
编排原语实战加深：`kubectl apply -f app.yaml`  declaratively 建；`kubectl rollout status` 等滚动完成；`kubectl rollout undo deployment/zeze-web` 回滚；`kubectl scale --replicas=5` 扩；`kubectl expose` 建 Service；`kubectl port-forward svc/zeze-web-svc 8080:80` 本机访问（调试用）。滚动更新：`strategy.rollingUpdate.maxSurge`(最多多几个)/`maxUnavailable`(最多下几个) 控零停机；`revisionHistoryLimit` 留几版可回。探针：`readinessProbe`(不就绪不加流量)、`livenessProbe`(失败重启)、`startupProbe`(慢启动保护)——用 `exec`/`httpGet`/`tcpSocket`，配 `initialDelaySeconds`/`periodSeconds`/`failureThreshold`。资源：`resources.requests`(调度依据，保证给到) vs `limits`(上限，超则 throttle/OOM)。优雅下线：`terminationGracePeriodSeconds`+`preStop`(如 `sleep 5` 或 `nginx -s quit`) 让在途请求跑完再 SIGTERM。HPA：`kubectl autoscale deploy zeze-web --cpu-percent=70 --min=3 --max=10` 按 CPU 扩（精准用自定义指标，OPS45）。StatefulSet 管有状态（稳定网络标识+持久盘，如 DB）；headless Service（`clusterIP: None`）直连 Pod。顶级视角：应用=Deployment+Service+Ingress+Config/Secret+HPA+探针组合（GitOps，OPS32）；无就绪探针=上线即接流量崩；理解滚动+探针=零停机发布。安全：Pod 非 root/`securityContext`（runAsNonRoot、drop capabilities，SEC83）；Service 不滥用 NodePort 暴露；镜像锁 digest（OPS20）；最小权限 SA（OPS26）；只对自己集群 apply。

## ➡️ 下一步
OPS23 · Ingress / Config / Secret（流量 / 配置）。

---

# OPS23 · Ingress / Config / Secret —— 流量 / 配置

## 🎯 目标
理解 Ingress（七层路由）、ConfigMap（配置）、Secret（敏感），会分离配置与代码，用环境变量/卷注入。

## 📋 小白前置
OPS22（Service）、OPS18（责任共担/密钥）。

## 🟢 部分一·最浅层（生活比喻）
Ingress 像"大楼前台"：按访客说的楼层名（域名/路径）指到对应公司。ConfigMap 是"便签配置"（普通设置），Secret 是"保险柜里的密码"（敏感，不能贴墙上）。

## 🟡 部分二·动手层
```bash
# ConfigMap
kubectl create configmap zeze-cfg --from-literal=GREETING=hello
# Secret（仅演示，真实用密封/外部密钥库）
kubectl create secret generic zeze-secret --from-literal=TOKEN=change-me
kubectl get configmap zeze-cfg -o yaml
kubectl get secret zeze-secret -o jsonpath='{.data.TOKEN}' | base64 -d; echo
# Ingress（需装 ingress-nginx）
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
```
预期：configmap/secret 创建成功；secret 的 data 是 base64（非加密！）。

## 🔵 部分三·原理层
Ingress 是 API 对象，由 Ingress Controller（nginx/contour）watch 后生成反向代理配置，按 host/path 路由到 Service（七层，NET12）。ConfigMap 存非机密配置，容器以环境变量或卷挂载消费。Secret 默认仅 base64 编码（不是加密！）——etcd 静态加密需开（`kms` provider，OPS18）。容器用 `envFrom`/`volumeMount` 注入。配置与镜像分离=可同镜像多环境。

## 🟣 部分四·深挖层
Secret 类型：Opaque/generic、tls、dockerconfigjson（拉私有镜像）、service-account-token（API 凭证）。Sealed Secrets / External Secrets Operator 把密钥管在外部（Vault，OPS47），Git 里只存加密密文（GitOps 安全）。Ingress 注解配 TLS/限流/重写。multiple Ingress class。ConfigMap 改需重启读它的 Pod 才生效（或用 reload 机制）。

## 🔴 部分五·顶级视角
顶级 SRE 用"12-factor"：配置外置（env/ConfigMap）、密钥外置（Secret/ESO/Vault）、构建一次跑多处。他们用 cert-manager 自动签 TLS（Let's Encrypt），用 External Secrets 接云密钥库，绝把 Secret 明文进 Git。理解 Ingress=边缘流量入口，是安全与限流第一关（BE15/OPS16）。

## 🟠 部分六·安全 / 合规种子
Secret 不是加密——etcd 须静态加密+ RBAC 限读（OPS26）。绝不把 Secret 提交 Git 明文；用 Sealed/外部密钥。生产密钥用 Vault/云 KMS（OPS47）。base64 不是保护，别误以为安全。

## ✅ 验收
截图 configmap/secret 创建；说出 Secret 默认只是 base64、生产如何真正保护。

## ⚠️ 常见坑
① 误以为 Secret=加密，明文存 etcd 泄露。② ConfigMap 改 Pod 不自动生效。③ Ingress 无 Controller=不工作。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
配置与密钥分离是 12-factor 核心。Ingress：七层路由（按 host/path 到 Service），由 Ingress Controller（nginx/contour/HAProxy）watch 后生成反代配置；实战 `kubectl apply -f https://.../deploy.yaml` 装 ingress-nginx，再写 Ingress 资源（`spec.rules[].http.paths[].backend.service`）；注解配 TLS/限流/重写。`cert-manager` 自动签 Let's Encrypt 证书（生产必备）。ConfigMap：非机密配置，容器以 `envFrom.configMapRef` 或 `volumeMount` 消费；改 CM 需重启读它的 Pod 才生效（或用 reload 机制/Reloader）。Secret：默认仅 base64 编码（不是加密！）——etcd 静态加密需开 `kms` provider（OPS18）；类型 Opaque/generic、tls、dockerconfigjson（拉私有镜像）、service-account-token（API 凭证）。`kubectl create secret generic`/`docker-registry`/`tls`。Secret 用卷挂载比 env 安全（env 易泄露到进程环境/日志）。Sealed Secrets / External Secrets Operator 把密钥管在外部（Vault，OPS47），Git 里只存加密密文（GitOps 安全）。实战：`kubectl get secret -o jsonpath='{.data.x}' | base64 -d` 看（仅自己集群）。顶级视角：配置外置（env/ConfigMap）、密钥外置（Secret/ESO/Vault）、构建一次跑多处；cert-manager 自动 TLS；ESO 接云密钥库；绝把 Secret 明文进 Git；Ingress=边缘流量入口，安全与限流第一关（BE15/OPS16）。安全：Secret 不是加密——etcd 须静态加密+RBAC 限读（OPS26）；不提交 Git 明文，用 Sealed/ESO；生产用 Vault/KMS；base64 非保护别误以为安全。

## ➡️ 下一步
OPS24 · Helm（模板 / 发布）。

---

# OPS24 · Helm —— 模板 / 发布

## 🎯 目标
理解 Helm 是 K8s 的"包管理器/模板引擎"，会 `helm create`/`install`/`upgrade`/`rollback`，理解 values 与模板。

## 📋 小白前置
OPS22、OPS23（YAML 基础）。

## 🟢 部分一·最浅层（生活比喻）
写 K8s YAML 像"手写给每家公司的说明书"；Helm 像"Word 模板+填空"：一套模板，填不同 values（公司名/楼层）就生成不同说明书，还能整体升级/回退（像版本管理）。

## 🟡 部分二·动手层
```bash
# 装 helm（用包或二进制）
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm create zeze-chart
cd zeze-chart
helm install zeze ./zeze-chart -n default   # 或 helm install zeze .
kubectl get all -l app.kubernetes.io/name=zeze
helm upgrade zeze . --set replicaCount=4
helm history zeze
helm rollback zeze 1
```
预期：安装出 deployment/svc；`helm list` 显示 zeze；rollback 回到 1 副本。

## 🔵 部分三·原理层
Helm Chart = 模板目录（templates/）+ values.yaml + Chart.yaml。模板用 Go template 语法（`{{ .Values.replicaCount }}`）渲染成 K8s 清单，交给 kubectl apply。Release 是某 chart 在某 namespace 的一次安装实例，带版本号。upgrade 渲染新清单并 apply；rollback 回到旧 release 的渲染结果。依赖（Chart.yaml dependencies）可引子 chart（如 mysql）。

## 🟣 部分四·深挖层
`helm template` 仅本地渲染不部署（审查用）。`--set`/values 文件覆盖。`helm lint`/`helm test`（集成测试）。Hooks（pre-install/per-upgrade）做迁移。与 GitOps（OPS32）结合：ArgoCD 直接 sync chart。Helm 仓库（OCI registry）分发。注意：模板逻辑过复杂难维护——顶级倾向 Kustomize 或原始 YAML+工具。

## 🔴 部分五·顶级视角
顶级 SRE 用 Helm 做"应用打包分发"，但强调 chart 可审查（`helm template`+策略扫描）。他们权衡 Helm（模板强）vs Kustomize（无逻辑、叠加）。理解 Helm release 版本=回滚安全网，配合健康检查（OPS27）实现可控发布。

## 🟠 部分六·安全 / 合规种子
审查 chart 模板（防 `helm template` 出危险 RBAC/特权）。只装可信源 chart（官方/校验 checksum）。values 里不写密钥——用 Secret/外部密钥（OPS23/OPS47）。不装来路不明 chart。

## ✅ 验收
截图 `helm install`+`helm list`+`rollback`；说出 Chart 与 Release 区别。

## ⚠️ 常见坑
① 模板 `{{ }}` 缩进错致 YAML 非法。② 忘了 `helm repo update` 装旧版。③ values 覆盖不生效→检查 key 路径。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Helm = K8s 的包管理器/模板引擎。Chart 目录：`Chart.yaml`(元数据/依赖)、`values.yaml`(默认参数)、`templates/`(Go template 清单)、`templates/NOTES.txt`(安装提示)、`charts/`(子 chart)。实战：`helm create zeze`、`helm lint`、`helm template .`（仅本地渲染不部署，审查用）、`helm install zeze . --dry-run=server`、`helm upgrade zeze . --set replicaCount=4`、`helm history zeze`、`helm rollback zeze 1`、`helm uninstall zeze`。模板语法：`{{ .Values.replicaCount }}`、`{{ .Release.Name }}`、`{{ .Chart.Version }}`、`{{- if .Values.ingress.enabled }}`、`{{- range .Values.ports }}`；`helm get values zeze` 看生效值。依赖：`Chart.yaml` 的 `dependencies`+`helm dependency build` 引子 chart（如 mysql/redis）；仓库 `helm repo add`/`update`，OCI registry 分发（`helm push`）。Hooks：`pre-install`/`post-upgrade`/`pre-rollback` 做迁移。与 GitOps（OPS32）结合：ArgoCD 直接 sync chart（或 `helm template` 出清单入库）。顶级视角：Helm 做应用打包分发，但强调 chart 可审查（`helm template`+策略扫描）；权衡 Helm（模板强）vs Kustomize（无逻辑、叠加，适合多环境）；理解 Helm release 版本=回滚安全网，配合健康检查（OPS27）实现可控发布。安全：审查 chart 模板（防出危险 RBAC/特权）；只装可信源 chart（官方/校验 checksum）；values 不写密钥——用 Secret/ESO（OPS23/47）；不装来路不明 chart。

## ➡️ 下一步
OPS25 · K8s 网络 / 存储（CNI / CSI）。

---

# OPS25 · K8s 网络 / 存储 —— CNI / CSI

## 🎯 目标
理解 K8s 网络模型（每个 Pod 独立 IP、扁平互通）、CNI 插件、存储（PV/PVC/StorageClass、CSI），会挂一个 PVC。

## 📋 小白前置
OPS21–OPS24（K8s 基础）、OPS6（网络）、OPS15（对象存储）。

## 🟢 部分一·最浅层（生活比喻）
K8s 网络约定"每家（Pod）有独立门牌，且全小区互通，不用 NAT 中转"。CNI 是"小区网络施工队"，负责给新住户拉网线。存储 CSI 像"外接硬盘租赁公司"，PVC 是你租的盘，Pod 挂上就能存。

## 🟡 部分二·动手层
```bash
# 看 CNI 插件（minikube 默认 kindnet/calico）
kubectl get pods -n kube-system | grep -E 'cni|calico|kindnet'
# 动态 PVC（minikube 有默认 storageclass）
cat > pvc.yaml <<'EOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata: {name: zeze-pvc}
spec:
  accessModes: [ReadWriteOnce]
  resources: {requests: {storage: 100Mi}}
EOF
kubectl apply -f pvc.yaml
kubectl get pvc
```
预期：PVC 状态 Bound；CNI pod Running。

## 🔵 部分三·原理层
K8s 网络模型三约：Pod 有集群唯一 IP、节点上 Pod 互通无需 NAT、Pod 与节点互通。CNI（Container Network Interface）是插件标准，kubelet 调插件给 Pod 配网卡/IP（flannel=Overlay VXLAN、Calico=BGP+网络策略、Cilium=eBPF）。存储：PV=实际存储（管理员/动态供应）、PVC=Pod 对存储的请求、StorageClass=动态供应模板（provisioner 走 CSI 驱动）。Pod 通过 `volume` 挂 PVC，数据跨容器重启保留。

## 🟣 部分四·深挖层
网络策略（NetworkPolicy）是 K8s 的"微隔离"（需 CNI 支持，如 Calico/Cilium），默认全通（安全坑，OPS26）。Service 网格（Istio）做 mTLS/流量管理。CSI 让任意存储（EBS/CEPH/NFS/S3 通过 CSI）接入。本地卷（hostPath）仅测试。ReadWriteOnce/Many 访问模式。emptyDir 临时（Pod 删即没）。

## 🔴 部分五·顶级视角
顶级 SRE 用 NetworkPolicy 默认拒绝+显式放行（零信任，SEC83）；用 Cilium eBPF 做可观测+安全。存储选对 StorageClass（SSD/网络盘/备份）。理解 CNI 是网络排障核心（Pod 不通先查 CNI）。理解 CSI 动态供应=运维免手动建盘。

## 🟠 部分六·安全 / 合规种子
默认网络全通=风险，用 NetworkPolicy 最小连通（OPS26）。hostPath 慎用（可逃逸）。存储加密（KMS）。只对自己集群操作。不暴露未授权端口（红线）。

## ✅ 验收
截图 PVC Bound + CNI pod；说出 K8s 网络三约定与 PV/PVC 关系。

## ⚠️ 常见坑
① 默认无 NetworkPolicy 全通——以为隔离实则没。② PVC Pending=无 StorageClass/供应失败。③ hostPath 数据在节点，Pod 漂移丢。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
K8s 网络模型三约：每 Pod 集群唯一 IP、节点上 Pod 互通无需 NAT、Pod 与节点互通。CNI 插件：kubelet 调插件（二进制，如 `/opt/cni/bin`）给 Pod 配网卡/IP；flannel=Overlay VXLAN（简单、跨节点隧道）、Calico=BGP+网络策略（无Overlay、性能高、可 NetworkPolicy）、Cilium=eBPF（可观测+安全最强）。存储：PV=实际存储（管理员静态建或 StorageClass 动态供应）、PVC=Pod 对存储请求（绑定 PV）、StorageClass=动态供应模板（`provisioner` 走 CSI 驱动）；Pod 通过 `volume` 挂 PVC，数据跨容器重启保留。访问模式：ReadWriteOnce（单节点）、ReadWriteMany（多节点，如 NFS/EFS）、ReadOnlyMany。实战：`kubectl get cni`(pod)、`kubectl get sc`(存储类)、`kubectl get pvc`；`emptyDir`(临时、Pod 删没)、`hostPath`(节点目录、仅测试、有逃逸风险)、`configMap`/`secret`(配置挂载)。CSI 让任意存储（EBS/CEPH/NFS/S3-via-CSI）统一接入。顶级视角：用 NetworkPolicy 默认拒绝+显式放行（零信任，SEC83）；Cilium eBPF 做可观测+安全；选对 StorageClass（SSD/网络盘/备份）；理解 CNI 是网络排障核心（Pod 不通先查 CNI）；CSI 动态供应=免手动建盘。安全：默认网络全通=风险，用 NetworkPolicy 最小连通（OPS26）；hostPath 慎用（逃逸）；存储加密（KMS）；只对自己集群操作；不暴露未授权端口（红线）。

## ➡️ 下一步
OPS26 · K8s 安全 / RBAC（最小权限）。

---

# OPS26 · K8s 安全 / RBAC —— 最小权限

## 🎯 目标
理解 K8s 认证/鉴权、RBAC（Role/ClusterRole/Binding）、ServiceAccount、Pod 安全（PSP→Pod Security Admission）、网络安全策略。

## 📋 小白前置
OPS21–OPS25、OPS3（权限思想）、OPS18（责任共担）。

## 🟢 部分一·最浅层（生活比喻）
RBAC 像"门禁卡系统"：Role 是"能进哪些房"的规则，Binding 是把卡（ServiceAccount）和规则绑一起。Pod 安全像"进机房前检查：不准带万能钥匙（privileged）、必须戴工牌（非 root）"。

## 🟡 部分二·动手层
```bash
# 建命名空间与 SA
kubectl create ns zeze-secure
kubectl create serviceaccount zeze-sa -n zeze-secure
# 角色：只能读 Pod
kubectl create role pod-reader --verb=get,list --resource=pods -n zeze-secure
kubectl create rolebinding zeze-sa-read --role=pod-reader --serviceaccount=zeze-secure:zeze-sa -n zeze-secure
# 用该 SA 跑个临时 Pod 试权限
kubectl --as=system:serviceaccount:zeze-secure:zeze-sa get pods -n zeze-secure
```
预期：该 SA 能 get pods；`delete` 会被拒绝（Forbidden）。

## 🔵 部分三·原理层
认证（AuthN）：证书/SA token/OIDC。鉴权（AuthZ）：RBAC（主流），规则=谁的（Subject）对哪些资源（Resource）做哪些动作（Verb）。Role 限 namespace，ClusterRole 集群级；Binding 绑定。默认 SA 权限极小（不自动有全权）。Pod Security Admission（替代旧 PSP）：enforce/privileged/baseline/restricted 三档，restricted 禁特权、要求非 root。准入控制器（OPA/Gatekeeper）写前校验策略。

## 🟣 部分四·深挖层
`kubectl auth can-i` 查权限（排障/审计）。集群角色聚合（ClusterRole 合多个）。TokenReview/SubjectAccessReview API。逃逸风险：privileged、hostPath、capabilities、挂载 docker.sock（SEC83）。审计日志（Audit Policy）记 API 调用（合规）。多租户用 Namespace 隔离+网络策略+资源配额（ResourceQuota/LimitRange）。

## 🔴 部分五·顶级视角
顶级 SRE 用"默认拒绝"RBAC、每应用独立 SA、Pod Security=restricted、OPA 策略门禁（如禁止 latest 镜像/特权）。他们跑 `kube-bench`（CIS 基线）、`kube-hunter`（授权自检）。理解 RBAC 过宽=入侵者拿 SA token 横向移动（SEC83/SEC72）。

## 🟠 部分六·安全 / 合规种子
绝不给 SA cluster-admin（除非必要且自知）。Pod 用 restricted 档、非 root。定期 `kubectl auth can-i` 审自己集群权限。只对自己集群练，不碰他人。kubeconfig 当密钥管（OPS47）。

## ✅ 验收
截图 SA 能 get pods 但 delete 被 Forbidden；说出 Role 与 ClusterRole 区别。

## ⚠️ 常见坑
① 误绑 cluster-admin 到默认 SA=全权泄露风险。② Pod Security 未开→特权容器跑起。③ 忘了 namespace→binding 不生效。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
K8s 安全=认证(AuthN)+鉴权(AuthZ)+准入+运行时。AuthN：客户端证书/ServiceAccount token/OIDC（企业 SSO）。AuthZ：RBAC 主流，规则=谁(Subject: User/Group/SA) 对哪些资源(Resource: pods/deployments/...) 的哪些动作(Verb: get/list/watch/create/update/delete)。Role 限 namespace、ClusterRole 集群级；RoleBinding/ClusterRoleBinding 绑定。实战：`kubectl create role`/`rolebinding`、`kubectl --as=system:serviceaccount:ns:sa get pods` 模拟鉴权、`kubectl auth can-i --as=... delete pods -n ns` 查权限（审计/排障利器）。默认 SA 权限极小（不自动全权）。Pod Security：旧 PSP 弃用，Pod Security Admission（PSA）三档——privileged/baseline/restricted（restricted 禁特权、要求非 root、禁 hostPath）；`kubectl label ns ns pod-security.kubernetes.io/enforce=restricted`。准入控制器 OPA/Gatekeeper 写前校验（如禁 `latest` 镜像/特权/0.0.0.0 暴露）。审计：Audit Policy 记 API 调用（合规）。实战自检：`kubectl get clusterroles` 看绑定、`kube-bench`（CIS 基线）、`kube-hunter`（授权自检）。顶级视角：默认拒绝 RBAC、每应用独立 SA、Pod Security=restricted、OPA 策略门禁；理解 RBAC 过宽=入侵者拿 SA token 横向移动（SEC83/72）。安全：绝给 SA cluster-admin（除非必要自知）；restricted 档+非 root；定期 `auth can-i` 审自己集群；只对自己集群练；kubeconfig 当密钥管（OPS47）。

## ➡️ 下一步
OPS27 · K8s 排障（诊断 / 事件）。

---

# OPS27 · K8s 排障 —— 诊断 / 事件

## 🎯 目标
掌握 K8s 排障套路：describe/events/logs/exec、Pod 各状态含义、常见失败（ImagePull/CrashLoop/未就绪）。

## 📋 小白前置
OPS21–OPS26。

## 🟢 部分一·最浅层（生活比喻）
排障像"医生问诊"：先看病人状态（Pod 状态）、查病历（events）、量体温（logs）、必要时进病房看（exec）。状态 Pending/ImagePull/CrashLoop 各有典型病因。

## 🟡 部分二·动手层
```bash
kubectl get pods
kubectl describe pod <pod>        # 看 Events、原因
kubectl logs <pod> --tail=50
kubectl logs <pod> -c <容器>      # 多容器
kubectl exec -it <pod> -- sh      # 进容器（若镜像有 shell）
kubectl get events --sort-by=.lastTimestamp
kubectl port-forward <pod> 8080:80 # 本机转发访问
```
预期：能定位常见错误（如 `ErrImagePull` 镜像名错、`CrashLoopBackOff` 启动即退）。

## 🔵 部分三·原理层
Pod 相位：Pending（调度/拉取中）、Running、Succeeded、Failed、Unknown。Events 来自控制器/ kubelet 上报（如 FailedScheduling 资源不足、Unhealthy 探针失败）。CrashLoopBackOff=容器退出→kubelet 指数退避重启。Readiness 不通过=不进 Service Endpoints（流量不打）。`kubectl exec` 经 API Server→kubelet→CRI 进容器（需容器有 shell）。

## 🟣 部分四·深挖层
排障顺序：Events→logs→describe→exec→节点（kubelet/磁盘/DNS）。CoreDNS 故障→Pod 内域名解析失败。节点 NotReady→kubelet 挂/资源满。OOMKilled=内存超 limits（OPS7）。`kubectl debug` 用临时容器排障（无 shell 镜像）。`kubectl get events` 看级联原因。节点级看 `journalctl -u kubelet`。

## 🔴 部分五·顶级视角
顶级 SRE 建"排障手册 + 黄金信号"：错误率/延迟/饱和度（OPS37）。他们用 `kubectl` + 集群级可观测（Prometheus，OPS38）+ 追踪（OPS41）定位跨服务问题。理解"最终一致"——改完等 reconcile。用 `ephemeral containers`+`kubectl debug` 不破坏原 Pod。

## 🟠 部分六·安全 / 合规种子
`kubectl exec` 是强权限操作，仅授权场景；审计日志记 exec（SEC90）。不进他人 Pod。排障只读优先，不随意改生产。端口转发仅本机调试，不长期暴露。

## ✅ 验收
故意造一个 CrashLoop Pod 并用上述命令定位原因（截图 describe events）；说出 3 种常见失败态。

## ⚠️ 常见坑
① 只看 `get pods` 不看 events→找不到根因。② 镜像 tag 错→ImagePull。③ OOM 只看 logs 忽略 limits。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
排障套路（黄金顺序）：1) `kubectl get pods` 看相位；2) `kubectl describe pod <p>` 看 Events/原因/容器状态；3) `kubectl logs <p>`（多容器 `-c`）；4) `kubectl exec -it <p> -- sh` 进容器（需有 shell）；5) 节点级 `kubectl get nodes`/`describe node`、`journalctl -u kubelet`（节点 NotReady 查 kubelet/磁盘/DNS）；6) 集群级看 kube-system 组件。Pod 相位：Pending（调度/拉取中，原因 FailedScheduling 资源不足、ImagePullBackOff 镜像错）、Running、Succeeded、Failed、Unknown。CrashLoopBackOff=容器退出→kubectl 指数退避重启（查日志看启动即退因）。OOMKilled=超内存 limits（OPS7）。Readiness 不通过=不进 Endpoints（流量不打）。CoreDNS 故障→Pod 内域名解析失败（`kubectl run dns --image=busybox --rm -it -- nslookup kubernetes`）。`kubectl debug` 用临时容器排障（无 shell 镜像也能进）。`kubectl get events --sort-by=.lastTimestamp` 看级联原因。`kubectl port-forward` 本机调。顶级视角：建排障手册+黄金信号（错误/延迟/饱和，OPS37）；用 kubectl+Prometheus（OPS38）+追踪（OPS41）定位跨服务问题；理解最终一致——改完等 reconcile；ephemeral containers 不破坏原 Pod。安全：`kubectl exec` 强权限仅授权；审计日志记 exec（SEC90）；不进他人 Pod；排障只读优先；端口转发仅本机调试不长期暴露。

## ➡️ 下一步
OPS28 · CKA 备考（实操认证）。

---

# OPS28 · CKA 备考 —— 实操认证

## 🎯 目标
了解 CKA（Certified Kubernetes Administrator）认证定位、考试形式（实操上机）、核心考点与学习路径；能列出备考清单。

## 📋 小白前置
OPS21–OPS27（K8s 全栈基础）。

## 🟢 部分一·最浅层（生活比喻）
CKA 像"码头调度师上岗证"：不考背诵，考你真的会开机器调度箱子。全程上机敲命令，给你集群你完成活。

## 🟡 部分二·动手层
（备考环境，用本机 minikube/killerkoda 免费实验台）
```bash
# 每日练手：限时创建 deployment+暴露+排障
kubectl create deployment nginx --image=nginx:1.27
kubectl scale deployment nginx --replicas=3
kubectl expose deployment nginx --port=80 --type=NodePort
kubectl exec -it nginx-xxx -- cat /etc/os-release
```
预期：形成肌肉记忆；考试为 2 小时 15–20 题，66% 及格。

## 🔵 部分三·原理层
CKA 由 CNCF/Linux Foundation 发，考集群运维实操：排障、调度、网络、存储、安全（RBAC/PSP）、升级、etcd 备份恢复。环境是真实 K8s，用 `kubectl`/etcdctl。考点分布：集群架构/安装 25%、工作负载排障 30%、安全 15%、网络 20%、存储/升级 10%（概数）。

## 🟣 部分四·深挖层
备考资源：官方 curriculum、kodekloud/killercoda 实验、cka-exam 模拟。速查：`--dry-run=client -o yaml > file` 生成模板省打字（护手）。考 `etcdctl snapshot save` 备份恢复、节点 cordon/drain、证书轮换。考试允许看官方文档（kubernetes.io），故练"查得快"也关键。

## 🔴 部分五·顶级视角
顶级工程师视认证为"能力刻度"而非终点：CKA→CKAD（开发）→CKS（安全，SEC83）。他们用认证体系规划学习路径。理解 CKA 覆盖的"集群生命周期"是 SRE 基本功（升级不出事=OPS44 事故响应能力）。

## 🟠 部分六·安全 / 合规种子
考试/练习只用授权环境（killercoda/minikube 自己账号）。不共享考题（违反 NDA）。生产考 CKS 强化安全观。绝不拿考试集群干别的。

## ✅ 验收
提交一份"CKA 备考 30 天计划表"（含每日练习命令清单）。

## ⚠️ 常见坑
① 只看书不敲→考试手生。② `--dry-run` 省时不会用。③ 忽视 etcd 备份恢复（高频题）。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
CKA（Certified Kubernetes Administrator）由 CNCF/Linux Foundation 发，是 SRE/运维含金量高的实操认证：全程上机（2 小时，约 15–20 题，66% 及格），环境真 K8s，考你"真的会"。核心考点分布（概）：集群架构安装与运维 ~25%、工作负载与调度 ~15%、服务与网络 ~20%、存储 ~10%、排障 ~30%、安全 ~15%。动手练：每天限时做——创建 Deployment+暴露+排障+扩缩、etcd 快照备份恢复（`ETCDCTL_API=3 etcdctl snapshot save`/`restore`）、节点 cordon/drain、证书轮换、升级控制面、建 RBAC/NetworkPolicy、建 PV/PVC。速查救命：`kubectl create deploy x --image=... --dry-run=client -o yaml > x.yaml` 生成模板省打字（护手）；`kubectl explain deploy.spec` 看字段文档（考试允许查官方文档 kubernetes.io）。资源：kodekloud 实验、killercoda 免费上机、cka-exam 模拟。进阶路线：CKAD（开发，重工作负载/调试）→ CKS（安全，重加固/威胁，SEC83）。顶级视角：认证是能力刻度非终点；CKA 覆盖的"集群生命周期/升级不出事"=事故响应基本功（OPS44）；理解考试不考背诵考肌肉记忆——每日敲。安全：练习用授权环境（killercoda/minikube/自己账号）；不共享考题（NDA）；生产考 CKS 强化安全观；绝不拿考试集群干别的。

## ➡️ 下一步
OPS29 · Git 深入（分支模型 / 变基 / 钩子）。

---

# OPS29 · Git 深入 —— 分支模型 / 变基 / 钩子

## 🎯 目标
理解 Git 内部（blob/tree/commit）、分支模型（Git Flow/Trunk）、rebase 与 merge 区别、会用 hooks（pre-commit）做检查。

## 📋 小白前置
PRE6（终端）、方向1a PY20 虚拟环境（有 Git 概念更佳）。

## 🟢 部分一·最浅层（生活比喻）
Git 像"带快照的时间相机"：每次提交拍一张全屋照（commit），分支是"不同人的拍摄路线"，合并是把两人照片叠合，rebase 是把你的照片重新贴到别人最新照片后面（历史更直）。

## 🟡 部分二·动手层
```bash
cd /c/Users/qq/WorkBuddy/2026-08-26-13-18-54
mkdir gitlab && cd gitlab && git init
echo "# lab" > README.md && git add . && git commit -m "init"
git checkout -b feature
echo "x" >> README.md && git commit -am "feat"
git checkout main && git merge feature --no-ff -m "merge feature"
# rebase 示例
git checkout feature2 && git rebase main
# hook
cat > .git/hooks/pre-commit <<'EOF'
#!/usr/bin/env bash
set -e
command -v shellcheck >/dev/null && shellcheck *.sh || true
EOF
chmod +x .git/hooks/pre-commit
```
预期：merge 出合并提交；rebase 历史线性；pre-commit 在提交前跑。

## 🔵 部分三·原理层
Git 对象库：blob（文件内容，按内容 hash）、tree（目录结构）、commit（指向 tree+父+作者+消息）、tag。分支只是指向 commit 的指针（轻便）。`merge` 建新 commit 保留分叉历史；`rebase` 把当前分支 commit 重放到目标后，改写 hash（历史更干净但别 rebase 已推送的公共分支）。HEAD 指向当前。`.git/hooks` 是本地脚本钩子（pre-commit/commit-msg/pre-push）。

## 🟣 部分四·深挖层
分支模型：Git Flow（develop/release/hotfix 多长活分支，重）、GitHub Flow（只 main+短特性分支，轻）、Trunk-Based（小步合 main，CI 强）。交互 rebase `git rebase -i` 改写/ squash。cherry-pick 摘提交。reflog 救误删。`.gitignore` 防泄密/垃圾。submodule/monorepo 取舍。钩子仅本机——团队规范用 Husky（pre-commit 框架）。

## 🔴 部分五·顶级视角
顶级 SRE 用 Trunk-Based+PR+CI（OPS30）：小步合、特性开关（feature flag）而非长分支。他们用 `pre-commit` 框架跑 lint/secret 扫描（防密钥入库，OPS47）。理解 rebase 改写历史的风险=只在私有分支用。理解 `.git` 内对象=一切可追溯。

## 🟠 部分六·安全 / 合规种子
`pre-commit` 接 secret 扫描（如 gitleaks）防密钥提交（红线：密钥不入库）。不 `push --force` 公共分支（丢他人工作）。不commit `.env`。只对自己仓库操作。历史里泄露密钥=立即轮转（OPS47）。

## ✅ 验收
截图一次 merge + 一次 rebase 的 `git log --oneline --graph`；说出 merge/rebase 区别。

## ⚠️ 常见坑
① rebase 已推送分支→他人冲突。② 误 `git push --force` 覆盖。③ 密钥进了历史→轮转+清历史（BFG）。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Git 内部对象库：blob（文件内容，按内容 SHA1 存，去重）、tree（目录→blob/tree 映射）、commit（指向 tree+父 commit+作者+消息+时间戳）、tag（轻量/附注）。分支只是指向 commit 的指针（轻便，建分支≈建文件）。实战：`git cat-file -t <hash>` 看对象类型、`git cat-file -p <hash>` 看内容、`git log --oneline --graph --all` 看分支图、`git reflog` 救误删（记录 HEAD 每次移动）、`git reset --hard <hash>` 回退、`git cherry-pick <hash>` 摘提交、`git rebase -i HEAD~3` 交互改写/squash。merge vs rebase：`merge` 建合并提交保留分叉；`rebase` 把当前 commit 重放到目标后、改写 hash（历史直）——只在私有分支用，别 rebase 已推送公共分支（他人冲突）。分支模型：Git Flow（develop/release/hotfix 多长活分支，重、企业用）、GitHub Flow（只 main+短特性分支，轻）、Trunk-Based（小步合 main+特性开关，CI 强，现代主流）。钩子：`pre-commit`(提交前)/`commit-msg`(验格式)/`pre-push`(推前)/`post-receive`(服务端)；本机 `.git/hooks/` 脚本，团队用 Husky/预提交框架统一。`.gitignore` 防泄密/垃圾；submodule/monorepo 取舍。顶级视角：Trunk-Based+PR+CI（OPS30）：小步合、特性开关而非长分支；`pre-commit` 跑 lint/secret 扫描（防密钥入库，OPS47）；理解 rebase 改写历史风险=只在私有分支；`.git` 内对象=一切可追溯。安全：pre-commit 接 gitleaks 防密钥提交（红线不入库）；不 `push --force` 公共分支（丢他人工作）；不 commit `.env`；历史泄露密钥=立即轮转+BFG 清（OPS47）。

## ➡️ 下一步
OPS30 · GitHub Actions（工作流 / 矩阵）。

---

# OPS30 · GitHub Actions —— 工作流 / 矩阵

## 🎯 目标
会写 `.github/workflows/*.yml`：触发（push/PR）、job/steps、矩阵构建、缓存、制品、用 secret；理解 CI/CD 概念。

## 📋 小白前置
OPS29（Git）、OPS5（脚本）、OPS19（Docker）、OPS46（扫描后续）。

## 🟢 部分一·最浅层（生活比喻）
GitHub Actions 像"自动流水线工人"：你 push 代码（按铃），它自动编译、测试、打包、部署（一连串动作），全按你写的说明书（workflow）来。矩阵像"同时派多个工人用不同工具干同活"。

## 🟡 部分二·动手层
写 `.github/workflows/ci.yml`：
```yaml
name: ci
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix: { python: ["3.11","3.12"] }
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: ${{ matrix.python }} }
      - run: python -m pytest || echo "no tests yet"
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: docker build -t zeze:ci .
```
预期：push 后 Actions 页显示 test（两版本）/build 跑过。

## 🔵 部分三·原理层
workflow=YAML 在 `.github/workflows/`。事件（on）触发：push/PR/schedule（cron，OPS9）/手动。Runner=执行机（GitHub 托管/自托管）。job 并行（needs 定依赖）。step 顺序跑。action（`uses:`）是可复用单元（市场/官方）。`secrets` 加密环境变量（不打印）。产物 `actions/upload-artifact` 跨 job 传。缓存 `actions/cache` 加速依赖。

## 🟣 部分四·深挖层
矩阵（matrix）一键多版本/多 OS 测试。环境（environment）+ 审批（production 需 manual approval）。可重用 workflow（`workflow_call`）。OIDC 给云临时凭证（免长期 AK，OPS47）。`concurrency` 防并发部署冲突。缓存投毒/供应链攻击防范：锁 action 版本（@v4 固定 sha）、仅用可信 action（SEC84 DevSecOps）。制品签名（SLSA）。

## 🔴 部分五·顶级视角
顶级 SRE 把 CI 当"质量门禁"：lint+test+scan+构建+签名，全绿才准合。GitOps（OPS32）让 CD 也声明式。他们用矩阵保多版本兼容、用缓存提速、用 OIDC 免去密钥。理解 CI 是"左移安全"第一道（OPS46/SEC84）。

## 🟠 部分六·安全 / 合规种子
secrets 不 echo/不进日志；用 OIDC 替代 AK（OPS47）。action 锁版本防篡改（供应链）。`pull_request_target` 慎用（可泄 secret）。不跑他人 PR 的未审代码（投毒）。只对自己仓库配。

## ✅ 验收
提交含矩阵+缓存的 workflow 并跑绿（截图）；说出 secret 与变量区别。

## ⚠️ 常见坑
① `secrets` 在 PR 来自 fork 不可用（防泄露）。② action 不锁版本→漂移/投毒。③ 自托管 runner 不隔离→多租风险。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
GitHub Actions 是托管 CI/CD。workflow=`.github/workflows/*.yml`，事件 `on: [push, pull_request, schedule: cron(OPS9), workflow_dispatch]` 触发。Runner 执行机（GitHub 托管/自托管，矩阵可跨 OS）。job 并行（`needs` 定依赖），step 顺序；`uses:` 复用 action（市场/官方，如 `actions/checkout@v4`），`run:` 跑 shell。真实进阶：矩阵 `strategy.matrix` 多 python/多 OS 一键测；`actions/cache` 缓存依赖（`~/.cache/pip`）提速；`actions/upload-artifact`/`download-artifact` 跨 job 传制品；`environment:`+审批做生产门禁；`concurrency:` 防并发部署冲突；`permissions:` 最小 token 权限（默认收紧）；OIDC `id-token` 换云临时凭证（免长期 AK，OPS47）。密钥 `secrets.*` 加密、不打印、不进日志。门禁：lint+test+scan+构建+签名全绿才准合；`if:` 条件分步。实战：`act` 本地跑 workflow 省提交（护手）。供应链：锁 action 版本（`@v4` 固定或 pin SHA）防投毒；`pull_request_target` 慎用（可泄 secret）；只跑已审 PR。顶级视角：CI=质量门禁，左移安全第一道（OPS46/SEC84）；矩阵保多版本兼容、缓存提速、OIDC 免密钥；理解"流水线即代码"=可审查可回滚。安全：secrets 不 echo/不日志；OIDC 替 AK（OPS47）；action 锁版本防篡改（供应链）；不跑他人未审 PR 代码（投毒）；只对自己仓库配。

## ➡️ 下一步
OPS31 · GitLab CI / Jenkins（流水线即代码）。

---

# OPS31 · GitLab CI / Jenkins —— 流水线即代码

## 🎯 目标
了解 GitLab CI（`.gitlab-ci.yml`）与 Jenkins（Jenkinsfile）两种"流水线即代码"；会写基础 stages；理解自托管 Runner/节点。

## 📋 小白前置
OPS29、OPS30（CI 概念）。

## 🟢 部分一·最浅层（生活比喻）
GitLab CI / Jenkins 是另外两家"自动流水线公司"：GitLab 自带（配置写在 `.gitlab-ci.yml`），Jenkins 是老牌可高度定制的工厂（配置写 Jenkinsfile 或网页点）。

## 🟡 部分二·动手层
GitLab CI 示例 `.gitlab-ci.yml`：
```yaml
stages: [build, test, deploy]
build:
  stage: build
  image: docker:24
  script:
    - docker build -t zeze:$CI_COMMIT_SHA .
test:
  stage: test
  script: [echo "run tests"]
deploy:
  stage: deploy
  rules: [{ if: $CI_COMMIT_BRANCH == "main" }]
  script: [echo "deploy"]
```
Jenkinsfile（声明式）片段：
```groovy
pipeline {
  agent any
  stages {
    stage('Build') { steps { sh 'docker build -t zeze .' } }
    stage('Test')  { steps { sh 'echo test' } }
  }
}
```

## 🔵 部分三·原理层
GitLab CI：项目根 `.gitlab-ci.yml` 定义 stages/jobs，Runner（注册到实例）按 tag 领取执行。Jenkins：Master/ Agent 架构，Jenkinsfile（Groovy）描述 pipeline，agent 指定跑的节点。两者都是"代码定义流水线"，版本化、可审查。共享库（Jenkins shared lib / GitLab includes）复用步骤。

## 🟣 部分四·深挖层
GitLab Runner 用 Docker/shell/kubernetes executor。Jenkins 插件生态庞大但维护负担重（现代倾向 Jenkinsfile+少插件）。蓝绿/金丝雀发布在 deploy 阶段做（OPS44）。制品库集成（OPS35）。机密用 CI/CD variables（加密，等效 secret）。Webhook 触发、父子流水线（child pipeline）。

## 🔴 部分五·顶级视角
顶级 SRE 选工具看团队：GitLab 一体（SCM+CI+Registry）、Jenkins 老厂定制、GitHub Actions 轻量。统一原则：流水线即代码、可审查、有门禁、机密外置。理解"自托管 Runner 安全"=隔离+最小权限（防供应链，SEC84）。

## 🟠 部分六·安全 / 合规种子
Runner/ Agent 执行不可信代码——隔离（容器/独立节点）、最小权限。CI 变量当 secret 管，不打印。Jenkins 插件勤更新（历史漏洞多，SEC84）。只对自己实例配。

## ✅ 验收
写一份 `.gitlab-ci.yml`（3 stages）并说明与 GitHub Actions 两点差异。

## ⚠️ 常见坑
① Runner 未注册/tag 不匹配→job 一直 pending。② 变量误设"明文可见"。③ Jenkins 插件不更新→漏洞。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
GitLab CI / Jenkins 是"流水线即代码"另两家。GitLab CI：项目根 `.gitlab-ci.yml` 定义 `stages`/`jobs`，`rules` 控触发（如仅 main 部署），Runner（注册到实例）按 `tags` 领取；executor 有 Docker/shell/kubernetes。Jenkins：Master/Agent 架构，Jenkinsfile（Declarative/Pipeline 语法）描述 pipeline，`agent` 指定跑的节点；共享库（shared lib）复用步骤。实战差异：GitLab 一体（SCM+CI+Registry+安全扫描），Jenkins 老牌可高度定制但插件维护重。蓝绿/金丝雀在 deploy 阶段做（OPS44）。制品库集成（OPS35）、机密用 CI/CD variables（加密，等效 secret）。Webhook 触发、父子流水线（child pipeline 拆分大流水线）。进阶：`needs` 建 DAG 并行、`cache`/`artifacts` 提速、`environment`+手动审批、`.gitlab-ci.yml` `include` 复用模板。Jenkins 用 `stage`/`parallel`/`post`(always/success/failure)。顶级视角：选工具看团队——GitLab 一体、Jenkins 老厂定制、GitHub Actions 轻量；统一原则：流水线即代码、可审查、有门禁、机密外置；理解"自托管 Runner 安全"=隔离+最小权限（防供应链，SEC84）。安全：Runner 执行不可信代码——隔离（容器/独立节点）、最小权限；CI 变量当 secret 管不打印；Jenkins 插件勤更新（历史漏洞多，SEC84）；只对自己实例配。

## ➡️ 下一步
OPS32 · ArgoCD / GitOps（声明式交付）。

---

# OPS32 · ArgoCD / GitOps —— 声明式交付

## 🎯 目标
理解 GitOps 理念（Git 是真理源、自动同步）、会装 ArgoCD 并用它同步一个 K8s 应用，看 drift 检测。

## 📋 小白前置
OPS21–OPS24（K8s）、OPS29/OPS30（Git/CI）。

## 🟢 部分一·最浅层（生活比喻）
传统部署像"你打电话叫工人改"；GitOps 像"你把期望状态写进公告栏（Git），监理（ArgoCD）不停看公告栏，发现现场和公告不符就自动改回"。Git 是唯一真相，谁改都以 Git 为准。

## 🟡 部分二·动手层
（本机 minikube 起 ArgoCD）
```bash
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd
# 暴露 UI（本机）
kubectl port-forward svc/argocd-server -n argocd 8080:443
# 登录密码取 admin
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d
```
预期：argocd pod Running；UI 可开（本机 8080）。

## 🔵 部分三·原理层
GitOps：Git 仓库存 K8s 期望清单（YAML/Helm/Kustomize）；ArgoCD Controller watch 仓+集群，持续 reconcile（对比实际 vs 期望），有偏差（drift）则同步（apply）。Application CRD 描述"源仓库+路径+目标集群/namespace"。Sync 策略 auto/manual、prune（删多余）、self-heal（集群被手改自动回期望）。审计：所有变更经 Git（可追溯、可回滚）。

## 🟣 部分四·深挖层
ArgoCD App-of-Apps 模式管多应用；ApplicationSet 批量。Image Updater 自动升版本。与 CI 分工：CI 构建镜像（OPS30），CD（Argo）只同步清单。多集群：Argo 管 N 个集群。Sealed Secrets/ESO 解决 Git 里 Secret（OPS23）。渐进交付用 Argo Rollouts（金丝雀/蓝绿）。

## 🔴 部分五·顶级视角
顶级 SRE 用 GitOps 实现"可审计、可回滚、防漂移"的交付：生产变更必须 PR（审查），合并即部署。他们把 Argo 接通知（Slack）、接策略门禁（OPA）。理解 Git 即审计日志=合规利器（SEC87）。对比 push（CI 直连集群）vs pull（Argo 拉，集群不出网更安全）。

## 🟠 部分六·安全 / 合规种子
Argo 接集群的 RBAC 最小（OPS26）。Git 仓私有+保护分支（防未审改生产）。Secret 用 Sealed/ESO 不裸存（OPS23/OPS47）。只对自己集群/仓库练。

## ✅ 验收
截图 ArgoCD pod Running + UI 开；说出 GitOps 与"传统 CI 直连部署"的核心区别。

## ⚠️ 常见坑
① Argo 没 RBAC→同步失败。② Git 路径/分支错→找不到清单。③ 手改集群被 self-heal 回滚（这正是设计）。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
GitOps 理念：Git 是唯一真理源（声明期望状态），控制器持续 reconcile（实际 vs 期望），有偏差（drift）自动同步；所有变更经 PR（审查+可回滚+可审计）。ArgoCD 组件：API Server、Repo Server（拉 Git）、Application Controller（watch 仓+集群、算 diff、sync）、Application CRD（描述 source 仓库+路径+目标集群/namespace）、ApplicationSet（批量）、App-of-Apps（管多应用）。sync 策略：`auto`(自动同步)/`manual`(手动)、`prune`(删集群多余)、`self-heal`(集群被手改自动回期望)。实战：`argocd app create`/`get`/`sync`；UI 看同步状态（OutOfSync/Healthy）；`argocd app diff` 看将改什么；Image Updater 自动升版本；接 cert-manager/通知。与 CI 分工：CI 构建镜像（OPS30），CD（Argo）只 sync 清单——pull 模式（集群主动拉）比 push（CI 直连集群）更安全（集群不出网）。多集群：Argo 一个控制面管 N 个集群。Sealed Secrets/ESO 解 Git 里 Secret（OPS23）。渐进交付用 Argo Rollouts（金丝雀/蓝绿，OPS44）。顶级视角：GitOps=可审计/可回滚/防漂移交付；生产变更必须 PR（审查），合并即部署；接通知（Slack）+策略门禁（OPA）；理解 Git=审计日志=合规利器（SEC87）；对比 push vs pull。安全：Argo 接集群 RBAC 最小（OPS26）；Git 私有+保护分支（防未审改生产）；Secret 用 Sealed/ESO 不裸存（OPS23/47）；只对自己集群/仓库练。

## ➡️ 下一步
OPS33 · Terraform / IaC（状态 / 模块 / 计划）。

---

# OPS33 · Terraform / IaC —— 状态 / 模块 / 计划

## 🎯 目标
理解 IaC 与 Terraform 工作流（init/plan/apply/destroy）、state 文件、module、会用本地/云 provider 建资源。

## 📋 小白前置
OPS11–OPS16（云概念）、OPS29（Git）。

## 🟢 部分一·最浅层（生活比喻）
IaC 像"用图纸盖楼"：你写 HCL 图纸，Terraform 按图施工（建/改/拆），并留一份"已建清单"（state）。传统手工点控制台=凭记忆盖，易乱；IaC=一切有图可查可复现。

## 🟡 部分二·动手层
```bash
# 装 terraform（二进制或 choco）
terraform version
mkdir tf-demo && cd tf-demo
cat > main.tf <<'EOF'
terraform {
  required_providers { aws = { source = "hashicorp/aws" } }
}
provider "aws" { region = "us-east-1" }
resource "aws_s3_bucket" "lab" {
  bucket = "zeze-tf-lab-$(timestamp())"  # 仅示意，需唯一
}
EOF
terraform init
terraform plan      # 看将要做什么（不执行）
# terraform apply    # 需自己账号凭证，确认后再跑
# terraform destroy   # 清理
```
预期：`plan` 显示 `+ create` 一个 bucket；`state` 文件生成。

## 🔵 部分三·原理层
Terraform 读 HCL，构建资源依赖图，`plan` 算增量（create/update/destroy）并显示，`apply` 调云 API 落地，写 `terraform.tfstate`（记录真实 ID/属性，作后续 diff 基准）。state 是本地文件（团队用 remote backend：S3+ DynamoDB 锁防并发写）。provider 是与各云/服务的插件（AWS/Aliyun/K8s）。变量 `variable`/输出 `output`/模块 `module` 复用。

## 🟣 部分四·深挖层
state 含敏感（明文！）——远程 backend 加密+锁；绝不提交 Git（用 `.gitignore`）。`terraform import` 接管手建资源。模块（registry/module）封装最佳实践。workspace 多环境。plan 阈值门禁（CI 里审 plan）。drift：云上手改→`plan` 检出。count/for_each 批量。生命周期 `prevent_destroy`/`create_before_destroy`。

## 🔴 部分五·顶级视角
顶级 SRE 把"一切基础设施 IaC"：网络/计算/数据库全 HCL，PR 审查、CI 跑 plan、审批后 apply（GitOps 同源）。他们用 remote state+锁+加密、用模块标准化、用 policy（Sentinel/OPA）卡违规（OPS18）。理解 state 是双刃剑（强但敏感）——用 backend 保护。

## 🟠 部分六·安全 / 合规种子
state 明文含密钥/ID——远程加密 backend+不提交 Git（红线：密钥不入库）。provider 凭证用环境变量/OIDC（OPS47），不写 tf。只对自己账号 apply。CI 里审 plan 防误删（带 `prevent_destroy`）。

## ✅ 验收
截图 `terraform plan` 显示 create；说出 state 作用与为何敏感。

## ⚠️ 常见坑
① state 提交 Git→泄露。② 并发 apply 无锁→冲突。③ `apply` 前没 `plan`→误建/误删烧钱。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Terraform 工作流：`init`（下 provider/模块、建 `.terraform`）、`plan`（算增量：+/-/~，显示将做什么，可存 plan 文件）、`apply`（调云 API 落地，写 state）、`destroy`（拆）。state 文件 `terraform.tfstate` 记真实 ID/属性，作后续 diff 基准；含敏感（明文！）——用 remote backend（S3+ DynamoDB 锁/ GCS/Consul）加密+状态锁防并发写，绝不提交 Git（`.gitignore`）。provider 插件（AWS/Aliyun/K8s/...）与云/服务对接；`required_providers` 锁版本。变量 `variable`/`output`、模块 `module`（封装复用，registry/本地）、`data`(读已有资源)、`for_each`/`count` 批量、`dynamic` 块、生命周期 `prevent_destroy`/`create_before_destroy`/`ignore_changes`。`terraform import` 接管手建资源（存量上云）；`terraform state mv/rm` 整理；`terraform taint` 强制重建（新写法 `replace`）。plan 阈值门禁（CI 里审 plan，批准再 apply）。drift：云上手改→`plan` 检出（GitOps 同源，OPS32）。顶级视角：一切基础设施 IaC——网络/计算/DB 全 HCL，PR 审查、CI 跑 plan、审批后 apply；remote state+锁+加密、模块标准化、policy（Sentinel/OPA）卡违规（OPS18）；理解 state 是双刃剑（强但敏感）——用 backend 保护。安全：state 明文含密钥/ID→远程加密 backend+不提交 Git（红线不入库）；provider 凭证用 env/OIDC（OPS47）不写 tf；只对自己账号 apply；CI 审 plan 防误删（带 prevent_destroy）。

## ➡️ 下一步
OPS34 · Ansible / 配置（幂等 / 剧本）。

---

# OPS34 · Ansible / 配置 —— 幂等 / 剧本

## 🎯 目标
理解配置管理、Ansible 幂等性、inventory/playbook/role；会写剧本在本机/本机 SSH 自己装软件。

## 📋 小白前置
OPS1–OPS10（Linux）、OPS5（YAML/脚本）。

## 🟢 部分一·最浅层（生活比喻）
Ansible 像"远程遥控器+说明书"：你写 playbook（要做的事），它对一批机器喊话执行，且"喊多次结果一样"（幂等）——不怕重复按。

## 🟡 部分二·动手层
```bash
pip install ansible   # 或 sudo apt install ansible -y
cat > hosts.ini <<'EOF'
[local]
127.0.0.1 ansible_connection=local
EOF
cat > play.yml <<'EOF'
- hosts: local
  tasks:
    - name: 确保装 htop
      apt: { name: htop, state: present }
      become: true
    - name: 确保目录存在
      file: { path: /home/zeze/ansible-demo, state: directory }
EOF
ansible-playbook -i hosts.ini play.yml
ansible local -i hosts.ini -m ping
```
预期：playbook 跑成功（changed/failed 0）；`ping` 返回 success。

## 🔵 部分三·原理层
Ansible 无 agent（靠 SSH/WinRM），控制节点 push 模块（Python）到目标执行。inventory 列主机分组。playbook=YAML 任务列表，module（apt/yum/file/copy/systemd...）幂等：state=present 已存在则 ok、不存在则 changed。幂等靠模块内部检查。变量 hosts/group_vars/extra-vars。role 封装可复用（目录约定 tasks/vars/templates）。

## 🟣 部分四·深挖层
`--check --diff` 干跑看改动；`--limit` 限定主机。handler（notify→flush）做重启（如改配置后 reload）。template（Jinja2）生成配置文件。vault 加密敏感（等同 Secret，OPS47）。与 Terraform 分工：TF 建资源（基建），Ansible 配资源内软件（配置）。 ad-hoc `ansible all -m command -a 'uptime'`。幂等失败的坑：命令式 module（command/shell）不幂等→用 `creates:` 守卫。

## 🔴 部分五·顶级视角
顶级 SRE 用 Ansible 做"黄金镜像后的配置/存量机收口"，或与 TF 配合（TF 起机→user_data 调 Ansible）。现代更倾向"不可变基础设施"（镜像含配置，OPS19）+ GitOps。他们用 Ansible Vault/ESO 管机密、用 role/collection 复用。理解幂等=可重复执行不漂移。

## 🟠 部分六·安全 / 合规种子
Ansible 用 SSH key（非密码，OPS?）。vault 加密敏感、不入库明文（OPS47）。`become` 提权仅必要步骤。只对授权自有主机跑；不批量控他人机器。密钥/ inventory 不泄露。

## ✅ 验收
截图 playbook 跑成功（changed=1 ok=...）；说出幂等含义并举例不幂等的 module 及对策。

## ⚠️ 常见坑
① `command`/`shell` 不幂等→加 `creates:`/`when:`。② SSH 不通→先配密钥。③ vault 口令忘→解不开。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Ansible 无 agent：控制节点经 SSH（Linux）/WinRM（Windows）push 模块（Python 小脚本）到目标执行、结果回传。inventory：`ini`/`yaml` 列主机分组（`[web]`/`[db]`），`ansible_host`/`ansible_user`/`ansible_ssh_private_key_file` 配连；动态 inventory 从云/K8s 拉。playbook=YAML 任务序：`hosts`(目标)、`become: true`(提权)、`tasks`(module 列表)、`handlers`(notify 触发，如改配置后 reload)、`vars`/`vars_files`、`tags`(选择性跑)。模块幂等：state=present 已存在→ok，不存在→changed（apt/yum/file/copy/systemd/template 等）。`--check --diff` 干跑看改动；`--limit` 限定主机；`--start-at-task` 续跑；ad-hoc `ansible all -m ping`/`command -a uptime`。role 封装可复用（目录约定 tasks/vars/templates/defaults/handlers/handlers）；`ansible-galaxy init` 建；collection 分发。模板 `template`(Jinja2) 生成配置。`ansible-vault` 加密敏感（等同 Secret，OPS47）。与 Terraform 分工：TF 建资源（基建），Ansible 配资源内软件（配置），或 user_data 调 Ansible。幂等陷阱：`command`/`shell`/`raw` 不幂等→用 `creates:`/`removes:`/`when:` 守卫或改专用模块。顶级视角：用 Ansible 做"黄金镜像后配置/存量机收口"，或与 TF 配合；现代更倾向"不可变基础设施"（镜像含配置，OPS19）+GitOps；用 Vault/ESO 管机密、role/collection 复用；理解幂等=可重复执行不漂移。安全：SSH key 非密码（OPS?）；vault 加密敏感不入库明文（OPS47）；become 仅必要步骤；只对授权自有主机跑；不批量控他人机器；inventory 不泄露。

## ➡️ 下一步
OPS35 · 制品库（Nexus / Artifactory）。

---

# OPS35 · 制品库 —— Nexus / Artifactory

## 🎯 目标
理解制品（artifact）与制品库作用，会用 Docker 起 Nexus，推送/拉取一个镜像或通用文件，理解版本不可变。

## 📋 小白前置
OPS19（镜像）、OPS20（仓库）、OPS30（CI）。

## 🟢 部分一·最浅层（生活比喻）
制品库像"公司内部的快递仓"：构建出的成品（jar/镜像/包）存这里，团队统一取，保证"大家用的同一版、来源可信"。比直接去公网下更稳更可控。

## 🟡 部分二·动手层
（Docker 起 Nexus，护手）
```bash
docker run -d --name nexus -p 8081:8081 -p 8082:8082 sonatype/nexus3
sleep 30
curl -s http://localhost:8081 | head -c 100; echo
# 取初始 admin 密码
docker exec nexus cat /nexus-data/admin.password
```
预期：8081 返回 Nexus 页面；admin.password 可读（首次登录改密）。

## 🔵 部分三·原理层
制品库统一存多格式（Docker/ Maven/ npm/ PyPI/ Helm/ raw），提供代理（缓存公网）、宿主（私发）、组（聚合）三类仓库。CI 构建后 `push` 到这里（不可变版本号），部署从这里 `pull`，切断对公网依赖、加速、可控可信。对比 Docker Hub/ECR：私有制品库=企业内网可控（合规/隔离，OPS18）。

## 🟣 部分四·深挖层
不可变版本：发版后不覆盖（重发用新版本），保证可复现/审计。代理仓库缓存公网防断供+降出网费。Helm chart 库/PyPI 私服同理。制品扫描集成（Nexus IQ/Trivy，OPS20/OPS46）。权限/RBAC 控谁能推（CI）拉（部署）。与 OIDC 集成免密码。

## 🔴 部分五·顶级视角
顶级 SRE 把"制品库"当供应链核心：所有依赖/产物经它、带 SBOM、带扫描、带签名（SLSA）。他们用代理仓做公网缓存（降本+抗断）、宿主仓做私发、组仓统一入口。理解"依赖直接从公网拉"=供应链单点风险（Log4Shell 类，SEC84）。

## 🟠 部分六·安全 / 合规种子
制品库设 RBAC：CI 可推、部署可拉、人少直推。镜像扫漏洞再入库（OPS46）。不代理来路不明上游。admin 密码改+轮转。只对自己实例练。

## ✅ 验收
截图 Nexus 启动页面；说出制品库三类仓库（代理/宿主/组）作用。

## ⚠️ 常见坑
① 8081 未开/容器没起→先 `docker ps`。② 初始密码不保存→无法登录。③ 制品覆盖=破坏不可变，禁用 overwrite。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
制品库统一存多格式（Docker/Maven/npm/PyPI/Helm/raw），三类仓库：proxy（缓存公网，如 `maven-central`）、hosted（私发，如 `zeze-releases`）、group（聚合多仓为一个入口，如 `public` 同时含 proxy+hosted）。实战：Docker 起 Nexus（`sonatype/nexus3`，8081 UI/8082 docker）、`curl -u admin:pass -X POST` 建 repo；Helm 用 `helm push --registry` 到 OCI（Nexus 3.65+ 支持）；`pip install -i <nexus>/repository/pypi/simple/ pkg` 走私服；`docker login <nexus>:8082` 推镜像。CI 构建后 `docker push` 到这里（不可变版本号），部署从这里 `pull`——切断对公网依赖、加速、可控可信。价值：1) 稳定（公网抖/被墙不影响）、2) 安全（私发+扫描门禁）、3) 合规（审计来源）、4) 降本（缓存省出网费）。进阶：Nexus IQ/Trivy 集成扫漏洞（OPS46）；RBAC 控谁能推（CI）/拉（部署）；清理策略（清理旧 snapshot/过期）。对比 Docker Hub/ECR：私有制品库=企业内网可控。顶级视角：制品库是供应链核心——所有依赖/产物经它、带 SBOM、带扫描、带签名（SLSA）；用代理仓做公网缓存（降本+抗断）、宿主仓私发、组仓统一入口；理解"依赖直接拉公网"=供应链单点风险（Log4Shell 类，SEC84）。安全：RBAC（CI 可推/部署可拉/人少直推）；镜像扫漏洞再入库（OPS46）；不代理来路不明上游；admin 改密+轮转；只对自己实例练。

## ➡️ 下一步
OPS36 · SRE 原则 / 错误预算。

---

# OPS36 · SRE 原则 / 错误预算 —— 可靠性文化

## 🎯 目标
理解 SRE（Google 提出）核心：用软件工程做运维、错误预算（error budget）、可靠性与迭代速度平衡、toil 消除。

## 📋 小白前置
OPS1–OPS35（全栈运维概念打底）。

## 🟢 部分一·最浅层（生活比喻）
传统运维像"消防队随时待命"；SRE 像"既当建筑师又当消防员"：用自动化减少半夜救火（toil），并和开发约定"这个月允许坏多久"（错误预算）——预算内放心发新功能，超预算先停发修稳定性。

## 🟡 部分二·动手层
（概念+算一笔账）
设 SLO=99.9%（月允许停机 43.8 分钟）。写个简单账本（bash）：
```bash
python3 - <<'PY'
slo=0.999
month_min=30*24*60
allowed=month_min*(1-slo)
print(f"SLO {slo*100}% => 月允许不可用 {allowed:.1f} 分钟")
PY
```
预期：99.9%→约 43.8 分钟；99.95%→约 21.9 分钟。

## 🔵 部分三·原理层
SRE（Site Reliability Engineering）由 Google 定义：雇佣软件工程师做运维，用代码管系统。核心等式：可靠性 = 1 - 故障时间/总时间。错误预算 = 1 - SLO，是用完即可"停止发布新功能、全力维稳"的配额。SLI 测真实用户指标（如成功率）；SLO 是 SLI 目标；SLA 是合同罚则。平衡：100% 可靠不现实且贵，用预算换迭代速度。

## 🟣 部分四·深挖层
toil=手工重复无持久价值运维，目标消除（自动化/自服务）。Postmortem 无责复盘（OPS44）。On-call 人性化（合理轮换/报警降噪，OPS42）。消除单点/容量（OPS45）。SRE 与 Dev 共担可靠性（You build it, you run it）。错误预算策略：burn rate 快烧→熔断发布。4 黄金信号（延迟/流量/错误/饱和度，OPS37）。

## 🔴 部分五·顶级视角
顶级 SRE 把"可靠性"当产品特性管理：定 SLO、测 SLI、设预算、建自动化、做无责复盘。他们拒绝"人肉运维"，用 SLO 驱动优先级（预算烧得快就停功能修稳定性）。理解"错误预算"是 Dev 与 SRE 的共同语言，化解"快发 vs 稳"的永恒矛盾。

## 🟠 部分六·安全 / 合规种子
可靠性也含安全事件响应（安全事故计入预算/触发复盘，OPS44）。变更（主要故障源）走渐进发布+回滚（OPS44）。安全加固不牺牲可用性——用错误预算权衡。合规 SLA 写进合同（OPS37）。

## ✅ 验收
交一份"错误预算计算表"（3 个 SLO 档对应的月允许停机）；说出 toil 是什么。

## ⚠️ 常见坑
① 追求 100% 可靠→成本爆炸且不现实。② 无错误预算→要么不敢发要么乱发。③ SLO 没 SLI 支撑=空谈。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
SRE（Site Reliability Engineering）由 Google 定义：雇佣软件工程师做运维，用代码管系统。核心等式：可靠性 = 1 − 故障时间/总时间；错误预算 = 1 − SLO，是用完即可"停止发布新功能、全力维稳"的配额。这套化解了"开发想快发 vs 运维想稳"的永恒矛盾——用数字说话。toil（手工重复无持久价值运维）目标消除：自动化/自服务。实践：On-call 人性化（合理轮班/升级策略/心理安全）、无责复盘（OPS44）、消除单点/容量（OPS45）、渐进发布。关键指标 DORA：部署频率、前置时间、变更失败率、恢复时间（OPS49）。SLO 与错误预算联动发布门禁：预算烧得快（burn rate 高）自动熔断发布。错误预算政策示例：月预算剩 <20% → 冻结非紧急发布、只修稳定性。实战算账：`slo=0.999 → 月允许 43.8 分`；多窗口多燃烧率（MWMB）告警精准抓真实 SLO 威胁（OPS42）。顶级视角：把"可靠性"当产品特性管理——定 SLO、测 SLI、设预算、建自动化、做无责复盘；拒绝人肉运维，用错误预算驱动优先级；理解"错误预算是 Dev 与 SRE 共同语言"。安全：可靠性含安全事件响应（安全事故计入预算/触发复盘，OPS44）；变更（主要故障源）走渐进发布+回滚（OPS44）；安全加固不牺牲可用性——用预算权衡；合规 SLA 写进合同（OPS37）。

## ➡️ 下一步
OPS37 · SLI / SLO / SLA（指标 / 目标）。

---

# OPS37 · SLI / SLO / SLA —— 指标 / 目标

## 🎯 目标
清晰区分 SLI/SLO/SLA，会为服务定义 SLI（如成功率/延迟）、设 SLO、用 PromQL 算达标率（接 OPS38）。

## 📋 小白前置
OPS36（错误预算）、OPS6/OPS7（指标基础）。

## 🟢 部分一·最浅层（生活比喻）
SLI 是"实测成绩"（这次响多快/成没成）；SLO 是"目标线"（平均分要 99.9）；SLA 是"合同罚则"（没达标赔钱）。三件套：测量→目标→合同。

## 🟡 部分二·动手层
（先写定义，PromQL 在 OPS38 实测）列出一个 Web 服务的 SLI/SLO：
```
SLI: 请求成功率 = 成功响应数 / 总请求数
SLO: 成功率 >= 99.9% (30天滚动)
SLI: P99 延迟 <= 300ms
SLO: P99 <= 300ms 的占比 >= 95%
```
bash 验证概念：
```bash
python3 - <<'PY'
total, ok = 100000, 99900
print("成功率", ok/total, "SLO达成?" , ok/total>=0.999)
PY
```

## 🔵 部分三·原理层
SLI（Service Level Indicator）= 可量化指标（成功率、延迟、吞吐、可用性）。SLO（Objective）= SLI 的目标阈值（如 99.9%）。SLA（Agreement）= 对外合同，含违约后果（赔偿/ credit）。关系：先有 SLI 才能定 SLO；SLO 内嵌于 SLA 但更严（SLA 通常比内部 SLO 松，留缓冲）。窗口：滚动（rolling）vs 日历月。燃烧率=实际消耗预算速度。

## 🟣 部分四·深挖层
SLI 选取：用户可感知的指标优先（延迟/错误/可用），而非 CPU 等内部指标。多窗口多燃烧率告警（OWI 法）精准抓真实 SLO 威胁（OPS42）。SLO 文档化+评审（业务对齐）。错误预算策略联动发布门禁（OPS36）。P99/P95 分位比平均更反映长尾用户体验。合成监控（黑盒 probe）补真实用户监控。

## 🔴 部分五·顶级视角
顶级 SRE 用 SLO 驱动一切：告警基于 SLO（烧预算才叫）、容量基于 SLO、发布基于预算。他们做"SLI 金字塔"（业务→用户→系统）。理解"SLO 不是越严越好"——对齐业务价值。用错误预算政策把可靠性变成可协商的数字（OPS36）。

## 🟠 部分六·安全 / 合规种子
安全事件（入侵/数据泄露）是可用性/完整性破坏，计入 SLO 与复盘（OPS44）。SLA 违约有合规后果——合同写清范围（排除计划维护/不可抗力）。监控数据含敏感→合规留存（OPS18）。

## ✅ 验收
为一个自选服务写 SLI/SLO/SLA 三件套（含窗口与阈值）；说出三者区别。

## ⚠️ 常见坑
① 用内部指标（CPU）当 SLO→用户无感。② SLA=SLO→无缓冲必违约。③ 平均延迟掩盖长尾（看 P99）。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
SLI/SLO/SLA 三件套是可靠性的度量基础。SLI（可量化指标）：成功率 `success/total`、延迟 P99、吞吐、可用性 `up`、饱和度。务必选"用户可感知"的指标（延迟/错误/可用），而非内部指标（CPU）——CPU 高用户可能无感。SLO = SLI 目标阈值（如 99.9% 成功率、P99≤300ms 占比≥95%）；窗口用滚动（rolling 30d）或日历月。SLA = 对外合同含违约后果（赔偿/credit），通常比内部 SLO 松（留缓冲，避免必违约）。关系：先有 SLI 才能定 SLO；SLO 内嵌 SLA 但更严。错误预算 = 1−SLO，是"允许坏多久"的配额。燃烧率 burn rate = 实际消耗预算速度（如 14.4 = 1% 预算/分钟烧完→快烧）。多窗口多燃烧率（MWMB）告警：长窗口定"是否真超"、短窗口定"是否快烧"，精准抓真实 SLO 威胁、减误报（接 OPS42）。实战：`kubectl`/`promtool` 算；用 RED（Rate/Errors/Duration）方法定 SLI（OPS38）。合成监控（黑盒 probe）补真实用户监控。顶级视角：用 SLO 驱动一切——告警基于 SLO（烧预算才叫）、容量基于 SLO、发布基于预算；做 SLI 金字塔（业务→用户→系统）；理解"SLO 不是越严越好"——对齐业务价值；用错误预算政策把可靠性变可协商数字（OPS36）。安全：安全事件（入侵/泄露）是可用性/完整性破坏，计入 SLO 与复盘（OPS44）；SLA 违约有合规后果——合同写清范围（排除计划维护/不可抗力）；监控数据含敏感→合规留存（OPS18）。

## ➡️ 下一步
OPS38 · Prometheus（抓取 / PromQL）。

---

# OPS38 · Prometheus —— 抓取 / PromQL

## 🎯 目标
用 Docker 起 Prometheus，理解拉模型（pull）、Exporter、TSDB，会写 PromQL 查指标、算成功率/分位（接 OPS37）。

## 📋 小白前置
OPS37（SLI/SLO）、OPS7（性能）。

## 🟢 部分一·最浅层（生活比喻）
Prometheus 像"定时巡检员"：每隔几秒去各服务门口抄表（拉指标）存进时序库；你用 PromQL"提问"，它从表里算答案（如"过去 5 分钟成功率多少"）。

## 🟡 部分二·动手层
（Docker 起 Prometheus + node-exporter）
```bash
mkdir -p prom && cd prom
cat > prometheus.yml <<'EOF'
global: { scrape_interval: 15s }
scrape_configs:
  - job_name: prometheus
    static_configs: [{ targets: ['localhost:9090'] }]
EOF
docker run -d --name prom -p 9090:9090 -v "$PWD/prometheus.yml:/etc/prometheus/prometheus.yml" prom/prometheus
sleep 5
curl -s http://localhost:9090/api/v1/query?query=up | head -c 200; echo
```
预期：9090 UI 可开；`up` 指标返回 1。

## 🔵 部分三·原理层
Prometheus 拉模型：按 `scrape_configs` 定时 HTTP GET `/metrics` 端点，解析文本格式（metric{label} value）。Exporter 把系统/应用指标转成该格式（node-exporter=主机、cadvisor=容器）。TSDB 存带时间戳的样本（metric+labels+value+ts）。数据模型：多维 label（如 `status="200"`）支持灵活切分。Alertmanager 接告警（OPS42）。Pushgateway 补短任务。

## 🟣 部分四·深挖层
PromQL：瞬时 `up`、区间 `rate(http_requests[5m])`、聚合 `sum by (status)`、分位 `histogram_quantile(0.99, rate(...[5m]))`（需 histogram 指标）。`rate` vs `irate`（瞬时）。记录规则（recording rule）预计算降查询负担。远程写（remote_write）到长存（Thanos/Mimir）解决单点。联邦（federation）分层。拉模型缺：短生命周期任务需 Pushgateway。

## 🔴 部分五·顶级视角
顶级 SRE 用 Prometheus 做"指标中枢"：RED（Rate/Errors/Duration）方法定 SLI（OPS37）。他们理解拉模型利弊（易暴露端点、需服务发现）、用 Recording Rule 优化、用 Thanos/Mimir 做全局长存。理解 histogram 分位计算=用户体感延迟可量化（OPS37）。

## 🟠 部分六·安全 / 合规种子
Prometheus 端口不暴露公网（含指标可能泄内部拓扑）。`/metrics` 不泄敏感（脱敏）。scrape 用 mTLS/网络策略（OPS25/OPS26）。告警含敏感→加密通道。只对自己实例练。

## ✅ 验收
截图 Prometheus UI 查 `up` 与一条 `rate(...)`；说出拉模型与推模型区别。

## ⚠️ 常见坑
① 9090 暴露公网→信息泄露。② 没 histogram 却用 `histogram_quantile`→空。③ 指标名打错→查不到（看 targets 状态）。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Prometheus 拉模型（pull）：按 `scrape_configs` 定时（默认 1m）HTTP GET 目标 `/metrics` 端点，解析文本格式（Exposition format：`metric{label="v"} value`）。Exporter 把系统/应用指标转该格式：node-exporter（主机 CPU/内存/磁盘）、cadvisor（容器）、kube-state-metrics（K8s 对象）、blackbox-exporter（探测）、应用自建 `/metrics`（client library）。TSDB 存带时间戳样本（metric+labels+value+ts），本地高效、单点（需远程写 Thanos/Mimir 长存）。实战加深：`rate(http_requests_total[5m])` 算 QPS（rate 自动处理 counter 重置）；`irate` 更灵敏（瞬时）；`sum by (code) (rate(...))` 聚合；`histogram_quantile(0.99, sum by (le) (rate(http_request_duration_seconds_bucket[5m])))` 算 P99（需 histogram 指标）；`up==0` 实例掉；`topk(5, ...)`。记录规则（recording rule）预计算降查询负担；告警规则（alerting rule）expr+for+label→Alertmanager（OPS42）。Pushgateway 补短任务（批处理）；联邦（federation）分层采集；服务发现（kubernetes_sd）自动发现 Pod。顶级视角：指标中枢——RED 方法定 SLI（OPS37）；理解拉模型利弊（易暴露端点、需服务发现）、用 Recording Rule 优化、用 Thanos/Mimir 全局长存；理解 histogram 分位=用户体感延迟可量化。安全：9090 不暴露公网（指标泄内部拓扑）；`/metrics` 不泄敏感（脱敏）；scrape 用 mTLS/网络策略（OPS25/26）；告警含敏感→加密通道；只对自己实例练。

## ➡️ 下一步
OPS39 · Grafana（面板 / 告警）。

---

# OPS39 · Grafana —— 面板 / 告警

## 🎯 目标
用 Docker 起 Grafana，接入 Prometheus 数据源，建一个dashboard 面板（如成功率/CPU），理解可视化与告警规则。

## 📋 小白前置
OPS38（Prometheus）、OPS37（SLO）。

## 🟢 部分一·最浅层（生活比喻）
Grafana 像"仪表盘装修队"：它不存数据，专门把 Prometheus 的数据画成好看的图表墙，让你一眼看全屋状态；还能在数值越线时亮红灯（告警）。

## 🟡 部分二·动手层
```bash
docker run -d --name grafana -p 3000:3000 grafana/grafana
sleep 5
curl -s http://localhost:3000/login | head -c 60; echo
# 浏览器开 3000，登录 admin/admin（首次改密）
# 加数据源：Configuration -> Data sources -> Prometheus -> http://prom:9090（同网络用容器名）
# 建面板：PromQL: rate(http_requests_total[5m])  （示例，按你有的指标）
```
预期：3000 可登录；数据源连上后可画图。

## 🔵 部分三·原理层
Grafana 是可视化层，数据源可接 Prometheus/Loki/Tempo/ES/MySQL 等。Dashboard=JSON（可版本化，GitOps 思想）。Panel 用查询（PromQL）→ 图表（time series/stat/heatmap）。变量（template variable `${ds}`）做动态。告警：在 Grafana 或 Prometheus 定义规则（如 `up==0` 持续 1m 告警），经 Alertmanager/Contact point 通知（Ops42）。

## 🟣 部分四·深挖层
Dashboard as code（JSON/ grafana provisioning）可 Git 管。合理面板：少而精、对齐 SLO（OPS37）、用阈值着色。Loki 日志（OPS40）+ Tempo 追踪（OPS41）在 Grafana 统一（可观测性三件套）。告警降噪：分组/抑制/静默（Ops42）。导出/导入 dashboard（社区库）。多数据源混合。

## 🔴 部分五·顶级视角
顶级 SRE 用 Grafana 做"单一可观测面板"：指标+日志+追踪联动（跳转到 trace）。他们把 dashboard 当代码评审、按 SLO 着色、告警接 On-call（Ops42）。理解"可视化误导"——选错聚合/分位会掩盖问题（Ops37 P99）。

## 🟠 部分六·安全 / 合规种子
Grafana 改默认密码+不开公网；数据源凭证加密。面板可能泄架构→权限控（Viewer/Editor 角色）。告警通道加密。只对自己实例。

## ✅ 验收
截图 Grafana 一个面板（含 Prometheus 数据源）；说出 Grafana 与 Prometheus 分工。

## ⚠️ 常见坑
① 默认 admin/admin 没改→被控。② 数据源地址填错（容器名 vs localhost）。③ 面板查询空→先 PromQL 在 Prometheus 验。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
Grafana 是可视化层（不存数据），数据源可接 Prometheus/Loki/Tempo/ES/MySQL/云监控。Dashboard=JSON（可版本化、GitOps 思想，provisioning 目录注入）。Panel 类型：time series（时序）、stat（单值）、heatmap（热力）、table、logs、trace。变量（template variable `${ds}`/`${pod}`）做动态筛选。实战：加 Prometheus 数据源（`http://prometheus:9090`，同 docker 网络用服务名）、建面板 PromQL `rate(http_requests_total[5m])`、用 `($__rate_interval)` 自适应区间、阈值着色（绿/黄/红对应 SLO）。告警：Grafana 9+ 统一告警（rule + contact point + notification policy），或 Prometheus 侧规则经 Alertmanager（OPS42）；用 `for` 防抖。Dashboard as code（JSON + `grafana provisioning` 目录）可 Git 管；社区 dashboard（`grafana.com/dashboards`）导入即用（Node Exporter Full 等）。Loki（标签索引+对象存）做日志、Tempo 做追踪，三者在 Grafana 统一（可观测性三件套）。调优：少而精面板、对齐 SLO、用阈值；降噪（OPS42）。顶级视角：单一可观测面板——指标+日志+追踪联动（点 traceID 跳 trace）；dashboard 当代码评审、按 SLO 着色、告警接 On-call（OPS42）；理解"可视化误导"——选错聚合/分位掩盖问题（OPS37 P99）。安全：Grafana 改默认密码（admin/admin）+不开公网；数据源凭证加密；面板可能泄架构→Viewer/Editor 角色控；告警通道加密；只对自己实例。

## ➡️ 下一步
OPS40 · 日志 ELK / EFK（集中分析）。

---

# OPS40 · 日志 ELK / EFK —— 集中分析

## 🎯 目标
理解集中式日志架构（采集→缓冲→存储→检索）：Elasticsearch/Logstash(或 Fluentd/Beat)/Kibana，或 EFK（Fluentd/Fluent Bit）；用 Docker Compose 起一套并查日志。

## 📋 小白前置
OPS8（日志基础）、OPS38/OPS39（可观测）。

## 🟢 部分一·最浅层（生活比喻）
单机日志像"每户贴墙日记"（OPS8）；集中日志像"把全小区日记收进图书馆，统一索引，想查'昨夜谁家漏水'一搜就有"。ELK=采集(Logstash)+仓库(ES)+前台(Kibana)。

## 🟡 部分二·动手层
（用 docker 跑轻量 EFK 思路；完整 ELK 资源大，下面给单 ES+Kibana 最小验）
```bash
docker run -d --name es -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:8.13.0
docker run -d --name kibana -p 5601:5601 docker.elastic.co/kibana/kibana:8.13.0
sleep 30
curl -s http://localhost:9200 | head -c 120; echo
# 写一条测试日志
curl -s -X POST http://localhost:9200/zeze-logs/_doc -H 'Content-Type: application/json' -d '{"msg":"hello zeze","ts":"now"}'
curl -s http://localhost:9200/zeze-logs/_search?q=hello | head -c 200; echo
```
预期：ES 返回集群信息；`_search` 命中刚写文档。

## 🔵 部分三·原理层
ELK：Beats（轻采集器，如 filebeat 读文件）→ Logstash（过滤/解析/富化，Groq 表达式）→ Elasticsearch（倒排索引存 JSON 文档，近实时搜索）→ Kibana（可视化/检索）。EFK 用 Fluentd/Fluent Bit 替 Logstash（更轻，K8s 友好）。采集器 daemonset 跑每节点（OPS25）。管道：解析 JSON、加字段、脱敏、路由。索引生命周期（ILM）滚动/压缩/删除。

## 🟣 部分四·深挖层
日志结构化（JSON）便于字段查询；非结构化靠 grok 解析（如 Nginx 日志）。ILM 省成本（热→温→冷→删）。ES 分片/副本影响性能与容灾。Loki 是"标签索引+对象存"的便宜替代（Ops39）。采样/降量防爆。关联：log→traceID（Ops41）跳转。集中日志是排障与取证（SEC88）核心。

## 🔴 部分五·顶级视角
顶级 SRE 选栈看规模/成本：ELK 强但重、Loki 省。他们做"日志分级+保留+脱敏+索引生命周期"，接告警（异常日志触发，Ops42）。理解"日志即审计"——合规留存（Ops18）。用 traceID 把指标-日志-追踪串成一条链路（可观测性）。

## 🟠 部分六·安全 / 合规种子
日志脱敏（不记密码/令牌，Ops47）；集中日志含 PII→权限+保留合规（Ops18）。ES/Kibana 不开公网。采集器最小权限。只对自己系统。日志可被用于取证（SEC88），也别在日志写密钥。

## ✅ 验收
截图 ES `_search` 命中；说出 ELK 四组件职责与 EFK 差别。

## ⚠️ 常见坑
① ES 内存大→本机可能 OOM，用 single-node+限资源。② 日志非结构化难查→先 JSON 化。③ Kibana 连不上 ES→网络/版本匹配。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
集中日志架构（采集→缓冲→存储→检索）：Beats（轻采集，filebeat 读文件/容器日志）→ Logstash（过滤/解析/富化，grok 表达式）或 Fluentd/Fluent Bit（更轻，K8s 友好，DaemonSet 跑每节点）→ Elasticsearch（倒排索引存 JSON 文档，近实时搜索）→ Kibana（检索/可视化）。EFK 用 Fluentd/Fluent Bit 替 Logstash（资源省，K8s 原生）。实战加深：docker 起 ES(`discovery.type=single-node`，资源有限设 `-e ES_JAVA_OPTS=-Xms512m -Xmx512m`)+Kibana；filebeat 配 `input`(paths)+`output.elasticsearch`；grok 解析 Nginx 日志（`%{IPORHOST:ip} ...`）；ILM（索引生命周期）hot→warm→cold→delete 自动滚动压缩删（省成本）。日志结构化（JSON）便于字段查询；非结构化靠 grok。采样/降量防爆（高吞吐丢弃/抽样）。关联：log 打 traceID（OPS41）跳转 trace。Loki 是"标签索引+对象存"便宜替代（只索引 label，日志原文存对象，查 label 快、全文慢）。顶级视角：选栈看规模/成本——ELK 强但重、Loki 省；做"日志分级+保留+脱敏+索引生命周期"，接告警（异常日志触发，OPS42）；理解"日志即审计"——合规留存（OPS18）；用 traceID 把指标-日志-追踪串成链路（可观测性）。安全：日志脱敏（不记密码/令牌，OPS47）；集中日志含 PII→权限+保留合规（OPS18）；ES/Kibana 不开公网；采集器最小权限；只对自己系统；日志可被取证（SEC88），别在日志写密钥。

## ➡️ 下一步
OPS41 · 链路追踪 OTel / Jaeger（上下文传播）。

---

# OPS41 · 链路追踪 OTel / Jaeger —— 上下文传播

## 🎯 目标
理解分布式追踪（trace/span/context propagation）、OpenTelemetry 标准、用 Docker 起 Jaeger 看一条 trace。

## 📋 小白前置
OPS38–OPS40（可观测三件套）、NET19（gRPC/RPC 概念）。

## 🟢 部分一·最浅层（生活比喻）
一个请求跨多个服务像"快递经多站"；trace 是整段行程单，span 是每站耗时。上下文传播像"每张交接单带同一个运单号"，这样各站记录能拼成完整路线，找出哪站最慢。

## 🟡 部分二·动手层
（Docker 起 Jaeger all-in-one）
```bash
docker run -d --name jaeger -p 16686:16686 -p 4317:4317 jaegertracing/all-in-one:latest
sleep 5
curl -s http://localhost:16686/api/services | head -c 120; echo
# 用 OTel SDK 发一条 trace（Python 示例需装 opentelemetry-sdk）
pip install opentelemetry-sdk opentelemetry-exporter-otlp
```
预期：16686 UI 可开；初始 services 可能为空（有数据后显示）。

## 🔵 部分三·原理层
Trace=一次请求全链路；Span=其中一段工作（起止时间、操作名、父子关系 via spanID/parentID）；Context 携带 traceID 跨进程传播（HTTP header `traceparent`，W3C 标准）。OpenTelemetry（OTel）是厂商中立的采集/导出标准（SDK+采集器 Collector），后端可接 Jaeger/Tempo/商业。采样（头采样/尾采样）控成本。传播靠上下文注入/提取（自动埋点 or 手动）。

## 🟣 部分四·深挖层
三种信号统一（metrics/logs/traces）是 OTel 目标。Collector 做接收/处理/导出（解耦后端）。尾采样（tail sampling）能据整 trace 状态决定留（如只留错误），省成本且有用。上下文传播格式 W3C `traceparent`/`tracestate`。baggage 传业务字段。与日志关联：在日志打 traceID（Ops40）跳转。自动埋点（框架插件）vs 手动 span。

## 🔴 部分五·顶级视角
顶级 SRE 用 OTel 统一三信号、用尾采样省成本、用 trace 定位跨服务延迟/错误根因（"哪个服务慢"）。他们把 traceID 贯穿日志/指标形成"可观测性闭环"。理解上下文传播=微服务排障前提（无 traceID 只能盲猜）。

## 🟠 部分六·安全 / 合规种子
trace 可能含请求参数（敏感）→采样/脱敏。Collector 端点不暴露公网。传播 header 不被篡改（完整性）。只对自己服务埋点。不外传他人流量 trace。

## ✅ 验收
截图 Jaeger UI；说出 trace/span/context 传播作用与 W3C header 名。

## ⚠️ 常见坑
① 16686 空数据→先有流量产生 trace。② 跨服务丢 context→看不到完整链路（检查传播）。③ 采样过低→难排查偶发。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
分布式追踪定位"跨服务慢/错在哪"。Trace=一次请求全链路；Span=其中一段（起止、操作名、self/time、父子 via spanID/parentID）；Context 携带 traceID 跨进程传播（HTTP header `traceparent`=W3C 标准：`00-traceid-spanid-01`，`tracestate` 带厂商态）。OpenTelemetry（OTel）= 厂商中立的采集/导出标准（SDK + Collector + 协议 OTLP），后端可接 Jaeger/Tempo/Honeycomb/商业；目标统一 metrics/logs/traces 三信号。实战：Python `opentelemetry-sdk` + `opentelemetry-exporter-otlp` 自动/手动埋点；Collector（`otelcol`）接收→处理→导出（解耦后端）；`docker run jaegertracing/all-in-one` 起；UI 16686 看 trace 瀑布（每 span 耗时、依赖）。采样：头采样（按比例）、尾采样（tail sampling，据整 trace 状态如只留错误，省成本且有用）。baggage 传业务字段。与日志关联：日志打 traceID（OPS40）跳转。自动埋点（框架插件）vs 手动 span（精细）。顶级视角：用 OTel 统一三信号、尾采样省成本、trace 定位跨服务延迟/错误根因（"哪个服务慢"）；把 traceID 贯穿日志/指标形成"可观测性闭环"；理解上下文传播=微服务排障前提（无 traceID 只能盲猜）。安全：trace 可能含请求参数（敏感）→采样/脱敏；Collector 端点不暴露公网；传播 header 不被篡改（完整性）；只对自己服务埋点；不外传他人流量 trace。

## ➡️ 下一步
OPS42 · 告警 / 值班（降噪 / 轮换）。

---

# OPS42 · 告警 / 值班 —— 降噪 / 轮换

## 🎯 目标
理解告警设计原则（有效/可行动/降噪）、Alertmanager 路由/分组/静默、On-call 轮换与心理安全。

## 📋 小白前置
OPS37（SLO）、OPS38/OPS39（Prometheus/Grafana 告警）。

## 🟢 部分一·最浅层（生活比喻）
告警像"火灾警报"：太灵敏（炒菜也响）=狼来了被人无视；太迟钝（烧起来才响）=没用。好告警=真着火才响、且告诉你去哪灭。值班像"排班守警报"，轮换避免一个人累垮。

## 🟡 部分二·动手层
写一条 Prometheus 告警规则 `rules.yml`：
```yaml
groups:
  - name: example
    rules:
      - alert: InstanceDown
        expr: up == 0
        for: 1m
        labels: { severity: critical }
        annotations:
          summary: "实例 {{ $labels.instance }} 掉线"
```
接入：`prometheus.yml` 加 `rule_files: ['rules.yml']` 重启；Alertmanager 路由（略）。bash 验证表达式：
```bash
curl -s "http://localhost:9090/api/v1/query?query=up==0" | head -c 120
```

## 🔵 部分三·原理层
告警三要素：症状（symptom，如错误率高）优于原因（cause）做用户面告警；可行动（收到能干活）；有 owner。Alertmanager：分组（同告警聚一批）、抑制（已知大故障压下相关小告警）、静默（维护期）、路由（按 label 发不同渠道）、重试。基于 SLO 的告警：燃烧率快→告警（Ops37）。On-call：轮班（如一周一轮）、升级策略（Escalation）、事后复盘（Ops44）。

## 🟣 部分四·深挖层
降噪技术：去重、分组、抑制、依赖静默、合成监控过滤瞬断。多窗口多燃烧率（MWMB）减少误报。页面疲劳（alert fatigue）是头号敌——无效告警比无告警更糟。值班健康：合理的时长/负载、无责文化、复盘改进而非追责。事件分级（SEV1-3）。值班表工具（PagerDuty/OpsGenie）。

## 🔴 部分五·顶级视角
顶级 SRE 把"告警"当产品：每个告警有文档（runbook）、有 SLO 依据、有降噪。他们用错误预算驱动告警阈值（烧得快才叫）、用依赖图做抑制、用 On-call 工程化减负担。理解"无责复盘+降噪"=可持续运维（Ops44 文化）。

## 🟠 部分六·安全 / 合规种子
安全事件也走告警（入侵/异常登录/配置漂移，SEC82/SEC90）。告警通道加密、防伪造。值班信息最小必要。事故计入合规报告。只对授权系统接告警。

## ✅ 验收
交一条基于 SLO 的告警规则（expr+for+label）；说出降噪三手段（分组/抑制/静默）。

## ⚠️ 常见坑
① 告警无 runbook→收到不会处理。② 太多无效告警→疲劳无视真警。③ `for` 太短→抖动误报。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
告警设计原则：症状（symptom，用户面，如错误率高）优于原因（cause）做用户面告警；可行动（收到能干活，有 runbook）；有 owner。Alertmanager：分组（同告警聚一批）、抑制（已知大故障压下相关小告警）、静默（维护期）、路由（按 label 发不同渠道 Slack/PagerDuty）、重试/确认。基于 SLO 的告警：燃烧率快→告警（MWMB，OPS37）；`for` 防抖（持续 N 分钟才触发，避免抖动）。实战：`prometheus.yml` 加 `rule_files`、`alerting: alertmanagers:`；规则 `expr: up==0 for: 1m`；`amtool` 查路由/静默。降噪三手段：分组（group_by）/抑制（inhibit_rules）/静默（silence）。多窗口多燃烧率（MWMB）减误报。On-call：轮班（一周一轮）、升级策略（Escalation：L1→L2→经理）、心理安全（无责，OPS44）、事后复盘。事件分级 SEV1-3；值班表工具 PagerDuty/OpsGenie/VictorOps。页面疲劳（alert fatigue）是头号敌——无效告警比无告警更糟（人无视真警）。顶级视角：告警当产品——每个告警有文档（runbook）、有 SLO 依据、有降噪；用错误预算驱动阈值（烧快才叫）、依赖图做抑制、On-call 工程化减负担；理解"无责复盘+降噪"=可持续运维（OPS44 文化）。安全：安全事件也走告警（入侵/异常登录/配置漂移，SEC82/90）；告警通道加密防伪造；值班信息最小必要；事故计入合规报告；只对授权系统接告警。

## ➡️ 下一步
OPS43 · 混沌工程（受控失败）。

---

# OPS43 · 混沌工程 —— 受控失败

## 🎯 目标
理解混沌工程理念（主动注入故障验证韧性）、原则（先定稳态假设、在生产最小爆炸半径做受控实验）、用工具（Chaos Mesh）体验。

## 📋 小白前置
OPS21–OPS27（K8s）、OPS36/OPS37（SLO/预算）。

## 🟢 部分一·最浅层（生活比喻）
传统等地震来了才知楼脆；混沌工程像"定期做消防演练"：主动关掉一台机器/拔一根网线，看系统是不是真像说的那样"挂一台没事"。在受控范围故意制造小乱子，验证大乱时不崩。

## 🟡 部分二·动手层
（Chaos Mesh，需 K8s/minikube）
```bash
# 装 chaos-mesh（本机 minikube，资源够再试）
curl -sSL https://mirrors.chaos-mesh.org/v1.4.0/install.sh | bash
kubectl get pods -n chaos-testing
# 示例：杀 Pod 实验（先有 zeze-web 部署）
cat > kill-pod.yaml <<'EOF'
apiVersion: chaos-mesh.org/v1alpha1
kind: PodChaos
metadata: {name: kill-zeze}
spec:
  action: pod-kill
  mode: one
  selector: { labelSelectors: { app: zeze-web } }
  duration: 30s
EOF
# kubectl apply -f kill-pod.yaml   # 确认理解后再跑
```
预期：chaos-testing pod Running；实验让 zeze-web 副本被删后由 Deployment 自愈（Ops22）。

## 🔵 部分三·原理层
混沌工程（Netflix 起源）原则：1) 用稳态指标（如 SLO，Ops37）定义正常；2) 假设对照组与实验组稳态一致；3) 注入真实故障（CPU/网络/Pod 杀/延迟）；4) 在生产近生产环境做；5) 最小爆炸半径+可中止。验证"冗余/自愈/降级"是否真有效。工具：Chaos Mesh（K8s）、Gremlin、Litmus。与 SLO 联动：实验不得击穿错误预算（Ops36）。

## 🟣 部分四·深挖层
实验类型：资源（CPU/IO 压）、网络（延迟/丢包/分区）、态（Pod 杀/节点宕）、应用层（异常注入）。游戏日（GameDay）组织全员演练。混沌≠乱搞——有假设、有度量、可回滚。与故障注入测试（FIT）区别。渐进：从非生产→生产小范围。爆炸半径控制=命名空间/标签限定。

## 🔴 部分五·顶级视角
顶级 SRE 把混沌当"持续验证韧性"的手段：CI/CD 接混沌（每次发布跑小实验）、用 GameDay 验证大设计。他们用 SLO 当稳态、用错误预算当护栏（超预算停实验）。理解"没演练过的容灾=没容灾"——墨菲定律。

## 🟠 部分六·安全 / 合规种子
混沌实验仅自己集群/授权环境，最小半径，可一键停（chaos-mesh 有 `kubectl delete`）。绝不注入他人系统。实验避开合规窗口。结果用于加固（白帽：提升自身韧性）。不模拟攻击他人。

## ✅ 验收
写出一次"杀 Pod 验证自愈"实验设计（假设/稳态/注入/观察/可中止）；说出混沌工程 5 原则之一。

## ⚠️ 常见坑
① 没稳态假设→不知算成功否。② 爆炸半径太大→真影响用户。③ 生产做无中止手段→失控。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
混沌工程（Netflix 起源）理念：主动注入故障验证系统韧性，而非等事故才发现脆弱。五原则：1) 用稳态指标（如 SLO，OPS37）定义正常；2) 假设对照组与实验组稳态一致；3) 注入真实故障（CPU/网络/Pod 杀/延迟/节点宕）；4) 在生产近生产环境做（才有意义）；5) 最小爆炸半径+可一键中止。工具：Chaos Mesh（K8s，PodChaos/NetworkChaos/StressChaos）、Gremlin、Litmus、AWS Fault Injection Simulator。实验类型：资源（CPU/IO 压）、网络（延迟/丢包/分区）、状态（Pod 杀/节点宕）、应用层（异常注入）。GameDay：组织全员演练（模拟大故障）。与 SLO 联动：实验不得击穿错误预算（Ops36）。实战加深：Chaos Mesh `kubectl apply` 一个 `PodChaos`(pod-kill 单实例)，观察 Deployment 是否自愈（OPS22）、错误率是否在 SLO 内；`kubectl delete` 即中止。渐进：非生产→生产小范围；爆炸半径用 namespace/label 限定。顶级视角：持续验证韧性——CI/CD 接小实验、GameDay 验证大设计；用 SLO 当稳态、错误预算当护栏（超预算停实验）；理解"没演练过的容灾=没容灾"（墨菲）。安全：实验仅自己集群/授权环境，最小半径，可一键停；绝不注入他人系统；避开合规窗口；结果用于加固（白帽提升自身韧性）；不模拟攻击他人。

## ➡️ 下一步
OPS44 · 事故响应 / 复盘（无责复盘）。

---

# OPS44 · 事故响应 / 复盘 —— 无责复盘

## 🎯 目标
理解事故生命周期（检测→响应→缓解→复盘）、IRC（事件指挥）、无责复盘（blameless postmortem）写法、与白帽合规衔接。

## 📋 小白前置
OPS36–OPS43（SRE 全链）、OPS42（告警/值班）。

## 🟢 部分一·最浅层（生活比喻）
事故像"着火"：先报警（检测）、派人指挥灭火（响应）、扑灭（缓解）、事后开会"为啥着、怎么防"（无责复盘——只找系统漏洞，不骂人，因为骂人下次没人敢说真话）。

## 🟡 部分二·动手层
写一份"无责复盘模板"练习（文字）：
```
# 事故：zeze-web 5xx 升高
时间线：14:02 告警 / 14:10 定位 DB 连接耗尽 / 14:25 扩容恢复
影响：错误率 8%（SLO 0.1% 内，预算烧 80%）
根因：连接池未限+发布涨流量
改进：加连接池上限 + 限流 + 加该 SLI 告警
责任人：系统改进项，非个人追责
```
bash 计时练习：`date +%s` 记录事件起点。

## 🔵 部分三·原理层
事故响应（NIST/Google IR）：Preparation→Detection&Analysis→Containment→Eradication→Recovery→Post-Incident。事件指挥（ICS）：IC 统筹、通讯、记录时间线。无责复盘（blameless）：聚焦系统/流程缺陷，鼓励透明，避免归咎个人——这样才能学到真因（人为失误是系统漏洞信号）。复盘要素：影响、时间线、根因（5 Whys/鱼骨）、改进项（带 owner/期限）、经验教训。

## 🟣 部分四·深挖层
SEV 分级（1 最高）。战争室（war room）/ 异步协作。状态页（status page）对外透明。回滚 vs 前滚（fix forward）。MTTR/MTTD 指标。与变更管理：多数事故源于变更（Ops36 预算门禁）。复盘改进项进 backlog 并跟踪关闭。安全事件走 DFIR（SEC88/SEC90）但同用无责文化。

## 🔴 部分五·顶级视角
顶级 SRE 把"事故"当学习资产：无责复盘文化让组织越打越强。他们用时间线+5 Whys 挖系统根因、把改进项当功能排期、用错误预算量化影响（Ops36）。理解"复盘质量是组织成熟度刻度"——掩盖追责=重复踩坑。

## 🟠 部分六·安全 / 合规种子
安全事故（入侵/泄露）同样无责复盘+走 DFIR 流程（SEC88/SEC90/SEC87 合规）。不掩盖（违法）、及时上报合规方。复盘不泄露 PII。只对自己系统做响应演练。白帽：提升自身韧性，不模拟攻击他人。

## ✅ 验收
交一份完整无责复盘（含时间线/根因/改进项）；说出无责复盘为何重要。

## ⚠️ 常见坑
① 复盘变追责→没人说真话。② 改进项无 owner→永不关。③ 只写现象不挖系统根因。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
事故响应生命周期（NIST/Google IR）：Preparation（准备，演练/手册/工具）→ Detection&Analysis（检测分析，靠告警 SLI，OPS42）→ Containment（遏制，隔离/回滚/降级）→ Eradication（根除，修根因）→ Recovery（恢复，验证 SLO）→ Post-Incident（无责复盘）。事件指挥（ICS）：IC 统筹、通讯官、记录时间线。无责复盘（blameless postmortem）：聚焦系统/流程缺陷，鼓励透明，不归咎个人——人为失误是系统漏洞信号，追责让人掩盖真相。复盘要素：影响（用户/业务/SLO 消耗，OPS36）、时间线（精确到分，含检测/缓解点）、根因（5 Whys/鱼骨）、改进项（带 owner+期限+验收）、经验教训。SEV 分级（1 最高，影响广/数据损）；战争室（war room）/异步协作；状态页（status page）对外透明；回滚 vs 前滚（fix forward）。MTTD（检测时延）/MTTR（恢复时延）指标。与变更管理：多数事故源于变更（Ops36 预算门禁拦）。顶级视角：事故是学习资产——无责复盘文化让组织越打越强；时间线+5 Whys 挖系统根因、改进项当功能排期、错误预算量化影响（Ops36）；理解"复盘质量=组织成熟度刻度"——掩盖追责=重复踩坑。安全：安全事故（入侵/泄露）同样无责复盘+走 DFIR（SEC88/90/87 合规）；不掩盖（违法）、及时上报合规方；复盘不泄露 PII；只对自己系统做响应演练；白帽提升自身韧性不模拟攻击他人。

## ➡️ 下一步
OPS45 · 容量规划（预测 / 扩容）。

---

# OPS45 · 容量规划 —— 预测 / 扩容

## 🎯 目标
理解容量规划：基于指标预测、垂直/水平扩容、HPA/CA、多 AZ、队列与余量；会算简单容量。

## 📋 小白前置
OPS7（性能）、OPS21–OPS27（K8s 扩缩）、OPS37（SLO）。

## 🟢 部分一·最浅层（生活比喻）
容量规划像"备粮"：看过去吃了多少、将来多少人来，提前多备并留余量；人多了就加桌子（水平扩）或换大桌（垂直扩）。留余量=防止突然爆满没座。

## 🟡 部分二·动手层
算一笔账（bash/python）：
```bash
python3 - <<'PY'
cur=1000      # 当前 QPS
growth=0.1    # 月增 10%
month=6
need=cur*((1+growth)**month)
print(f"{month}月后预计 QPS {need:.0f}")
print("按单实例 300 QPS，需实例", -(-int(need)//300))  # 向上取整
PY
```
预期：6 月后约 1772 QPS，需 6 实例；留余量取 8。

## 🔵 部分三·原理层
容量=满足 SLO 所需资源。来源：历史趋势外推、压测（负载测试定单实例上限）、业务预测。扩容：垂直（升配，有上限、需重启）、水平（加副本，K8s HPA 按 CPU/自定义指标，OPS22/OPS27）。Cluster Autoscaler 按 Pending Pod 加节点。多 AZ 分布防单点（Ops11/16）。余量（headroom）应对突发。队列/限流（BE15）削峰保护。

## 🟣 部分四·深挖层
HPA 基于 CPU 不够时（自定义指标如 QPS 更准，用 Prometheus Adapter，Ops38）。VPA（垂直）自动调 requests。预测性扩（scheduled）应对已知高峰（大促）。容量模型：Little's Law（L=λW）。压测工具（k6/vegeta/locust）。成本权衡（Ops48）：预留/按需/Spot。混沌验证余量（Ops43）。

## 🔴 部分五·顶级视角
顶级 SRE 把容量当"持续工程"：压测定基线、HPA+CA 自动弹性、多 AZ 容灾、错误预算指导余量（Ops36）。他们用"队列+限流+降级"三件套抗峰（BE15）。理解"容量不足"是头号可用性问题——用预测+自动扩避免半夜扩容。

## 🟠 部分六·安全 / 合规种子
容量含抗滥用/DoS 余量（限流熔断，BE15）。压测只对自己系统/授权靶场（不 DDoS 他人）。容量不足被利用做 DoS——合理余量也是安全。多云/多 AZ 合规要求（Ops18）。

## ✅ 验收
交一份容量计算（当前+增长+所需实例+余量）；说出 HPA 与 VPA 区别。

## ⚠️ 常见坑
① 只按平均不看峰值→高峰崩。② HPA 基于 CPU 但瓶颈在别处（用自定义指标）。③ 不留余量→突发无缓冲。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
容量=满足 SLO（OPS37）所需资源。来源：历史趋势外推、压测（负载测试定单实例上限）、业务预测。扩容：垂直（升配，有上限、常需重启）、水平（加副本，K8s HPA 按 CPU/自定义指标，OPS22/27）。Cluster Autoscaler 按 Pending Pod 加节点（K8s）。多 AZ 分布防单点（Ops11/16）。余量（headroom）应对突发——"容量不足"是头号可用性问题。实战：`kubectl autoscale`/`kubectl top`；压测 `k6`/`vegeta`/`locust` 定单实例 QPS 上限；Little's Law（L=λW）估并发。HPA 基于 CPU 不够准（瓶颈常不在 CPU）→ 用 Prometheus Adapter 接自定义指标（如 QPS/队列深，OPS38）。VPA（垂直）自动调 requests；预测性扩（scheduled）应对已知高峰（大促）；队列+限流+降级三件套抗峰（BE15）。成本权衡（OPS48）：预留/按需/Spot。混沌验证余量（Ops43）。指标驱动：用 SLI（延迟/错误/饱和）判断何时该扩。顶级视角：容量当持续工程——压测定基线、HPA+CA 自动弹性、多 AZ 容灾、错误预算指导余量（Ops36）；用"队列+限流+降级"抗峰；理解容量不足=头号可用性问题—预测+自动扩避免半夜扩容。安全：容量含抗滥用/DoS 余量（限流熔断，BE15）；压测只对自己系统/授权靶场（不 DDoS 他人）；容量不足被利用做 DoS——合理余量也是安全；多云/多 AZ 合规要求（Ops18）。

## ➡️ 下一步
OPS46 · 安全扫描 Trivy / Snyk（供应链）。

---

# OPS46 · 安全扫描 Trivy / Snyk —— 供应链

## 🎯 目标
理解软件供应链安全：SCA/SAST/镜像扫描、用 Trivy 扫镜像与 repo 依赖、接 CI 门禁；理解 SBOM。

## 📋 小白前置
OPS20（镜像扫描/SBOM）、OPS30（CI）、SEC84（DevSecOps）。

## 🟢 部分一·最浅层（生活比喻）
供应链安全像"查食材来源"：你做的菜（软件）用了很多买来的料（依赖/基础镜像），得查这些料有没有毒（CVE）。Trivy/Snyk 是"食材安检仪"，上桌前先扫一遍。

## 🟡 部分二·动手层
```bash
# 扫镜像
docker run --rm aquasec/trivy:latest image python:3.12-slim
# 扫代码仓库依赖（在 git 项目里）
docker run --rm -v "$PWD:/app" aquasec/trivy:latest fs /app
# 扫 IaC 配置（Terraform）
docker run --rm -v "$PWD:/app" aquasec/trivy:latest config /app
# 生成 SBOM
docker run --rm aquasec/trivy:latest image --format cyclonedx python:3.12-slim > sbom.json
```
预期：列出 CVE、依赖、IaC 误配（如公开 S3）。

## 🔵 部分三·原理层
软件供应链攻击面：依赖（第三方库）、基础镜像、构建流水线、分发。SCA（软件成分分析）扫依赖 CVE；SAST 扫源码漏洞（模式/污点，SEC20）；镜像扫描查层内包 CVE；IaC 扫描查 Terraform/K8s 配置错误（公开端口/特权，Ops26）。Trivy 一体覆盖。SBOM（Ops20）让"已知漏洞"可快速对账（如 Log4Shell）。CI 门禁：扫描不过不让合并/发布（左移，SEC84）。

## 🟣 部分四·深挖层
漏洞分级 CVSS（0-10）/ 严重度高。误报/修复优先级（EPSS 预测被利用概率）。签名验证（cosign，Ops20）。SLSA 等级（构建溯源）。依赖锁定（lockfile 防漂）。私有漏洞库/合规（等保，SEC87）。策略即代码（Conftest/OPA 扫 IaC）。预提交（pre-commit）扫（Ops29）。

## 🔴 部分五·顶级视角
顶级 SRE 建"供应链防线"：SBOM+签名+扫描门禁+依赖更新机器人（Dependabot/Renovate）+ 策略卡口。他们用"SBOM 对账"在 0-day 爆发时分钟级定位受影响服务（Log4Shell 教训）。理解"依赖直接拉公网"=单点风险（Ops35 制品库）。

## 🟠 部分六·安全 / 合规种子
只扫自己仓库/镜像；修复高危 CVE 或换基础（Ops20）。密钥/Secret 扫描（gitleaks）防入库（Ops29/47）。不忽略扫描结果上生产。只对自己资产。白帽：自检加固，不扫他人。

## ✅ 验收
截图 Trivy 扫镜像 + fs 扫依赖；说出 SCA/SAST/镜像扫描各查什么。

## ⚠️ 常见坑
① 忽略中危累积成雷。② 没 lockfile→依赖漂变。③ 扫描在 CI 缺失→漏洞进生产。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
软件供应链攻击面：依赖（第三方库）、基础镜像、构建流水线、分发。SCA（软件成分分析）扫依赖 CVE；SAST 扫源码漏洞（模式/污点，SEC20）；镜像扫描查层内包 CVE；IaC 扫描查 Terraform/K8s 配置错误（公开端口/特权，Ops26）；DAST/IAST 运行时。Trivy 一体覆盖（image/fs/config/repo/sbom）。SBOM（CycloneDX/SPDX）让"已知漏洞"可快速对账——Log4Shell 爆发时分钟级定位受影响服务。CI 门禁：扫描不过不让合并/发布（左移，SEC84）。CVSS 0-10 分级；EPSS 预测被利用概率排优先级；依赖锁定（lockfile 防漂）。签名验证（cosign，Ops20）。SLSA 等级（构建溯源 L1-L4）：L1 脚本构建、L2 有平台+审计、L3 防篡改+审计、L4 最高。策略即代码（Conftest/OPA 扫 IaC）。预提交（pre-commit）扫（Ops29）。私有漏洞库/合规（等保，SEC87）。实战：`trivy image`/`fs`/`config`/`repo`/`sbom`；`grype`/`syft` 替代；Dependabot/Renovate 自动升级。顶级视角：建供应链防线——SBOM+签名+扫描门禁+依赖更新机器人+策略卡口；用 SBOM 对账在 0-day 爆发分钟级定位（Log4Shell 教训）；理解"依赖直接拉公网"=单点风险（Ops35 制品库）。安全：只扫自己仓库/镜像；修复高危 CVE 或换基础（Ops20）；密钥/Secret 扫描（gitleaks）防入库（Ops29/47）；不忽略扫描结果上生产；只对自己资产；白帽自检加固不扫他人。

## ➡️ 下一步
OPS47 · 密钥管理 Vault（动态凭证）。

---

# OPS47 · 密钥管理 Vault —— 动态凭证

## 🎯 目标
理解密钥管理（不硬编码）、环境变量 vs 密钥库、HashiCorp Vault 动态凭证/租约、用 Docker 起 Vault 取密。

## 📋 小白前置
OPS23（Secret）、OPS18（责任共担）、OPS33/OPS34（IaC 机密）。

## 🟢 部分一·最浅层（生活比喻）
把密码写进代码/仓库，像"把家门钥匙贴在门上"（谁 clone 谁有）。密钥库像"智能保险柜"：应用用时才问柜子要一把临时钥匙，用完作废，且柜子记谁拿过。

## 🟡 部分二·动手层
（Docker 起 Vault 开发模式体验）
```bash
docker run -d --name vault -p 8200:8200 hashicorp/vault:latest server -dev -dev-root-token-id=zeze-token
sleep 5
export VAULT_ADDR='http://localhost:8200'
export VAULT_TOKEN='zeze-token'
curl -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/secret/data/zeze \
  -X POST -d '{"data":{"db_pass":"strong-secret"}}' | head -c 120; echo
curl -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/secret/data/zeze | head -c 120; echo
```
预期：写入/读取成功（dev 模式仅练手，生产用 HA+ unseal）。

## 🔵 部分三·原理层
密钥管理目标：集中、加密、访问控制、审计、动态/短命。反模式：硬编码/环境变量明文进仓库（历史可挖，Ops29）。Vault 提供：KV 秘钥、动态凭证（为 DB 临时建用户、自动过期）、PKI（发证书）、 transit（加解密即服务）、租赁（lease）+ 续租/吊销。认证：K8s/ AWS/OIDC（应用用身份换令牌，免长期 AK）。密封（seal/unseal）用密钥分片（ Shamir）。

## 🟣 部分四·深挖层
动态凭证消除"长期密钥泄露"风险：DB 口令每分钟换、应用无静态密。云 KMS/Secrets Manager 同思路。External Secrets Operator 把 Vault 密同步进 K8s Secret（Ops23）。名称空间隔离。审计日志全量。HSM/云 KMS 托管根密钥。与 OIDC 联动（CI 免 AK，Ops30）。Auto-unseal 云 KMS。

## 🔴 部分五·顶级视角
顶级 SRE 把"密钥"当最高敏感资产：动态凭证+短租约+审计+轮转，绝不静态长期密钥。他们用 Vault/云 Secrets Manager + ESO + OIDC 实现"零静态密钥"。理解"硬编码密钥=定时炸弹"——历史提交挖出即沦陷（Ops29 BFG 清）。

## 🟠 部分六·安全 / 合规种子
这是白帽红线核心：密钥绝不硬编码/入库（本方向铁律）。用 Vault/云 KMS/ESO。泄露立即吊销轮转。dev 模式 Vault 仅本机练，勿当生产。只对自己资产。

## ✅ 验收
截图 Vault 写入+读取；说出动态凭证为何比静态密钥安全。

## ⚠️ 常见坑
① dev 模式当生产→无密封无 HA。② 令牌提交→等价于密钥泄露。③ 忘了租约到期→应用断连。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
密钥管理目标：集中、加密、访问控制、审计、动态/短命。反模式：硬编码（源码/配置文件）、环境变量明文进仓库（历史可挖，Ops29）、长期静态 AK。Vault 能力：KV（密钥）、动态凭证（为 DB 临时建用户、自动过期，消除静态密钥）、PKI（发/轮换证书）、transit（加解密即服务）、租赁（lease）+续租/吊销、Auto-unseal（云 KMS 分片）。认证：K8s/AWS/OIDC——应用用身份换短期令牌，免长期 AK（接 OIDC 后 CI 免 AK，Ops30）。密封（seal/unseal）用 Shamir 分片（需 M 份解封）。实战（dev 模式仅练）：`vault kv put`/`get`、`vault secrets enable database`+配置动态 DB 角色、`vault lease revoke`、Audit device 全量记。生产：HA（多节点）+ Auto-unseal + 备份。云等价物：AWS Secrets Manager/Parameter Store、GCP Secret Manager、Azure Key Vault、阿里云 KMS/Secrets Manager。External Secrets Operator 把 Vault/云密同步进 K8s Secret（Ops23）。顶级视角：密钥=最高敏感资产——动态凭证+短租约+审计+轮转，绝不静态长期密钥；Vault/云 Secrets Manager+ESO+OIDC 实现"零静态密钥"；理解"硬编码密钥=定时炸弹"——历史提交挖出即沦陷（Ops29 BFG 清）。安全（白帽红线核心）：密钥绝不硬编码/入库（本方向铁律）；用 Vault/云 KMS/ESO；泄露立即吊销轮转；dev 模式 Vault 仅本机练勿当生产；只对自己资产。

## ➡️ 下一步
OPS48 · 成本优化（闲置 / 预留）。

---

# OPS48 · 成本优化 —— 闲置 / 预留

## 🎯 目标
理解云成本构成（计算/存储/网络 egress）、常见浪费（闲置/过量/未删）、优化手段（右配/预留/Spot/标签），会算账。

## 📋 小白前置
OPS11–OPS17（云资源）、OPS45（容量）。

## 🟢 部分一·最浅层（生活比喻）
云账单像"水电费"：开着灯（实例）就计费，哪怕没人用；忘关水龙头（空闲 LB/盘）也扣钱。优化=关不用的灯、换节能灯泡、包月更便宜。

## 🟡 部分二·动手层
查闲置（AWS CLI，自己账号）：
```bash
aws ec2 describe-instances --query 'Reservations[*].Instances[?State.Name==`running`].{id:InstanceId,type:InstanceType,launch:LaunchTime}'
# 看未关联 EIP / 未挂载卷（概念）
aws ec2 describe-volumes --filters Name=status,Values=available
```
算账（python）：
```bash
python3 - <<'PY'
on=0.1/3600   # 按需每小时约 0.1 美元（示例）
print("空转1月:", on*24*30, "美元")
print("包月约:", 0.06*24*30, "美元（省约", round((1-0.06/0.1)*100), "%)")
PY
```

## 🔵 部分三·原理层
云成本三块：计算（实例，按秒/时）、存储（盘/对象，按 GB·月+请求）、网络（出口 egress 最贵，跨区/公网）。浪费源：空闲实例（忘关）、过度配置（要 2G 给 16G）、未删资源（EIP/快照/旧 LB）、公网流量。优化：右配（监控定实际，Ops7/37）、预留/储蓄计划（1-3 年锁折扣）、Spot（抢占，省 70% 但可被回收，适合无状态/批处理）、自动伸缩（Ops45）、标签（tag）归因到团队/项目做 showback。

## 🟣 部分四·深挖层
标签策略（cost allocation tag）让账单可归因。预算告警（防止 Free Tier 超，OPS11）。生命周期规则自动转冷/删（Ops15）。承诺使用折扣（CUD）。FinOps 文化：工程+财务协作，按单北京单位成本（如 $/请求）。多云 egress 成本（Ops14）。闲置检测工具（原生 Cost Explorer/三方）。

## 🔴 部分五·顶级视角
顶级 SRE 用 FinOps：标签归因、预算门禁、Spot 跑批、自动启停非生产、Right-sizing 基于真实指标（Ops37）。他们把"成本"当可靠性之外的第二目标——浪费=不可持续。理解 egress 是隐性大头（架构时避免跨区/跨云传数据）。

## 🟠 部分六·安全 / 合规种子
成本异常可能是被滥用/被挖矿信号（监控账单防入侵后门，SEC82）。预算告警防意外扣费（学生账户尤其）。不暴露资源省费同时不降安全（最小暴露，Ops16）。只对自己账号优化。

## ✅ 验收
交一份"成本优化清单"（≥5 条针对自己实验环境的动作）；说出 egress 为何贵。

## ⚠️ 常见坑
① 忘了删测试实例/盘→持续计费。② 忽视 egress 费。③ 过度预留锁死灵活性。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
成本构成：计算（实例，按秒/时，最大头）、存储（盘/对象，按 GB·月+请求）、网络（出口 egress 最贵，跨区/公网）。浪费源：空闲实例（忘关）、过度配置（要 2G 给 16G）、未删资源（EIP/快照/旧 LB/NAT）、公网流量。优化手段：Right-sizing（监控定实际用量，Ops7/37）、预留实例/储蓄计划（1-3 年锁折扣，省 30-70%）、Spot/抢占（省 70% 但可被回收，适合无状态/批处理）、自动启停非生产（按上班时间）、自动伸缩（Ops45）、标签（cost allocation tag）归因到团队/项目做 showback/chargeback、预算告警（防 Free Tier 超/异常，Ops11）、生命周期规则自动转冷/删（Ops15）、承诺使用折扣（CUD）。FinOps 文化：工程+财务协作，按单位成本（如 $/千请求）衡量。实战：`aws ce`(Cost Explorer)、`aws ec2 describe-volumes` 查 available（未挂）盘、标签归因。多云 egress 成本（Ops14）。顶级视角：成本当可靠性之外的第二目标——标签归因、预算门禁、Spot 跑批、自动启停、Right-sizing 基于真实指标（Ops37）；理解 egress 是隐性大头（架构避跨区/跨云传数据）；浪费=不可持续。安全：成本异常可能是被滥用/挖矿信号（监控账单防入侵后门，SEC82）；预算告警防意外扣费（学生账户尤其）；不暴露资源省费同时不降安全（最小暴露，Ops16）；只对自己账号优化。

## ➡️ 下一步
OPS49 · 平台工程（内部开发平台）。

---

# OPS49 · 平台工程 —— 内部开发平台

## 🎯 目标
理解平台工程：内部开发者平台（IDP）、Golden Path、自助服务、与 DevOps/SRE 关系；会用 Backstage 概念串联全栈。

## 📋 小白前置
OPS1–OPS48（全栈贯通）。

## 🟢 部分一·最浅层（生活比喻）
平台工程像"给开发同事建好一套精装厨房"：水电（CI/CD）、冰箱（制品库）、消防（安全扫描）都预装好，开发者只管做菜（写业务），不用每人从砌墙开始。Golden Path=官方推荐的标准做法。

## 🟡 部分二·动手层
（概念串联，可本机起 Backstage 体验，资源大，列步骤）
```bash
# Backstage（需 Node，资源允许再装）
# npx @backstage/create-app@latest
# 它把：服务目录 / 模板（生成带 CI+K8s 的服务）/ 文档 / 工具链 集成一屏
echo "平台工程 = 把 OPS1-48 的能力封装成自助服务"
```
预期：理解 IDP 把前面所学（GitOps/TF/Ansible/Prometheus/Vault）产品化给开发者。

## 🔵 部分三·原理层
平台工程（Puppet/Spotify 推动）建 IDP：服务目录（谁有什么服务）、脚手架（Golden Path 模板一键生成合规服务）、自助环境、内部 API/工具市场。目标：降低认知负担、统一最佳实践、提速交付、减 toil（Ops36）。区别于 DevOps（文化运动）：平台工程是落实 DevOps 的"产品化"角色。IDP 组件：Portal(Backstage)+ 自动化（TF/Argo/Ansible）+ 可观测（Prom/Grafana）+ 安全（Vault/扫描）。

## 🟣 部分四·深挖层
Golden Path 不是唯一路径（留逃生舱）。平台团队按"产品"对待内部用户（开发者），做调研/满意度/迭代。认知负载（cognitive load）理论：减开发者需记的细节。与 SRE 协作：平台供能力、SRE 定 SLO/可靠性（Ops36）。CNCF 平台工程成熟度模型。内部开发者门户（IDP）避免"平台即阻碍"——自助且不强制。

## 🔴 部分五·顶级视角
顶级工程师看到"运维云 SRE"的终点不是救火，而是把能力产品化：用 IDP 让 100 个开发者安全、合规、快速地自助交付（前面 OPS1-48 全部沉淀为平台能力）。他们衡量平台成功用"部署频率/前置时间/变更失败率/恢复时间（DORA 指标）"。理解平台工程=组织规模化的杠杆。

## 🟠 部分六·安全 / 合规种子
IDP 内置安全左移：模板自带扫描/Vault/RBAC/网络策略（Ops46/47/26）。最小权限默认。合规（等保/ISO）以模板落地。只对自己组织/授权环境建平台。白帽：平台把安全做成默认，而非事后补。

## ✅ 验收
画一张"我的 IDP 蓝图"：列出将 OPS21/OPS30/OPS32/OPS38/OPS47 哪些能力接到 Golden Path；说出平台工程与 DevOps 区别。

## ⚠️ 常见坑
① 平台变"强制官僚"→开发者绕开。② Golden Path 无逃生口→特殊需求卡死。③ 只堆工具不改善验（DORA）指标。

## ➡️ 下一步
### 深度延展（补强原理 / 实战 / 顶级 / 安全）
平台工程（Puppet/Spotify 推动）建 IDP（内部开发者平台）：服务目录（谁有什么服务/owner/SLI）、脚手架（Golden Path 模板一键生成合规服务，含 CI/K8s/监控/密钥）、自助环境、内部 API/工具市场。目标：降开发者认知负担、统一最佳实践、提速交付、减 toil（Ops36）。区别于 DevOps（文化运动）：平台工程是落实 DevOps 的"产品化"角色——把平台当产品，内部开发者是用户，做调研/满意度/迭代。IDP 组件：Portal(Backstage)+自动化（TF/Argo/Ansible）+可观测（Prom/Grafana）+安全（Vault/扫描）。认知负载（cognitive load）理论：减开发者需记的细节（如不必懂 K8s 细节也能安全发布）。与 SRE 协作：平台供能力、SRE 定 SLO/可靠性（Ops36）。CNCF 平台工程成熟度模型。Golden Path 不是唯一路径——留逃生舱（escape hatch）给特殊需求。实战：Backstage `npx @backstage/create-app` 起（资源大，概念为重）；软件模板（Software Template）一键生成带 CI+K8s 的服务。顶级视角：运维云 SRE 的终点不是救火，而是把能力产品化——IDP 让 100 开发者安全合规自助交付（前面 OPS1-48 全部沉淀为平台能力）；用 DORA 指标（部署频率/前置时间/变更失败率/恢复时间）衡量平台成功。安全：IDP 内置安全左移——模板自带扫描/Vault/RBAC/网络策略（Ops46/47/26）；最小权限默认；合规（等保/ISO）以模板落地；只对自己组织/授权环境建平台；白帽：平台把安全做成默认而非事后补。

## ➡️ 下一步
方向10 全 49 节已贯通。下一步可回补方向7（安全攻防）把运维与安全结合（SEC82/SEC83/SEC84），或进方向9（数据 AI）做可观测数据湖，或方向11（产品/软技能）把平台当产品运营。按总纲顺序，建议巩固 OPS21–OPS49 中任一手感弱的节，再进方向7c 云安全/容器安全实战（授权靶场）。
