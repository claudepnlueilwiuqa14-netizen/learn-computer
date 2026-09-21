# 方向 1c · Rust/范式/SQL/Shell 闯关与实战补强

> 这是预备、编程、算法和底层系统的主题化补强层。原课负责 11 段讲解，本文件把每课落到可运行实验、反例、测量、故障和原创交付。
> 证据目录统一为 `evidence/<课号>/README.md`、`commands.txt`、`tests/`、`artifacts/`、`notes.md`；只使用自己的机器、代码、合成数据和隔离环境。

## 五级闯关合同
- Lv1：最小闭环可运行，交输出/截图/测试。
- Lv2：单变量变体，交前后对比和失败解释。
- Lv3：跨课综合，交自动化测试、日志、设计图和清理。
- Lv4：造轮子、性能/安全/可靠性审计，交基线、指标、根因和回归。
- Lv5：开放研究、教学或架构决策，交 ADR/证明/反例/复现和限制。

## RS1 · Rust 入门 / cargo

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：Rust 入门 / cargo 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS1/lv1 最小运行证据。
  - Lv2：RS1/lv2 单变量变体、对比和失败解释。
  - Lv3：RS1/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS1/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS1/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS2 · 所有权

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：所有权 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS2/lv1 最小运行证据。
  - Lv2：RS2/lv2 单变量变体、对比和失败解释。
  - Lv3：RS2/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS2/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS2/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS3 · 借用与生命周期

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：借用与生命周期 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS3/lv1 最小运行证据。
  - Lv2：RS3/lv2 单变量变体、对比和失败解释。
  - Lv3：RS3/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS3/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS3/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS4 · 结构体与枚举

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：结构体与枚举 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS4/lv1 最小运行证据。
  - Lv2：RS4/lv2 单变量变体、对比和失败解释。
  - Lv3：RS4/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS4/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS4/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS5 · trait 与泛型

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：trait 与泛型 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS5/lv1 最小运行证据。
  - Lv2：RS5/lv2 单变量变体、对比和失败解释。
  - Lv3：RS5/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS5/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS5/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS6 · 错误处理

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：错误处理 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS6/lv1 最小运行证据。
  - Lv2：RS6/lv2 单变量变体、对比和失败解释。
  - Lv3：RS6/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS6/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS6/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS7 · 集合类型

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：集合类型 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS7/lv1 最小运行证据。
  - Lv2：RS7/lv2 单变量变体、对比和失败解释。
  - Lv3：RS7/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS7/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS7/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS8 · 并发

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：并发 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS8/lv1 最小运行证据。
  - Lv2：RS8/lv2 单变量变体、对比和失败解释。
  - Lv3：RS8/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS8/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS8/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS9 · 宏

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：宏 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS9/lv1 最小运行证据。
  - Lv2：RS9/lv2 单变量变体、对比和失败解释。
  - Lv3：RS9/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS9/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS9/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS10 · async/await

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：async/await 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS10/lv1 最小运行证据。
  - Lv2：RS10/lv2 单变量变体、对比和失败解释。
  - Lv3：RS10/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS10/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS10/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS11 · FFI 与 unsafe

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：FFI 与 unsafe 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS11/lv1 最小运行证据。
  - Lv2：RS11/lv2 单变量变体、对比和失败解释。
  - Lv3：RS11/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS11/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS11/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS12 · 测试与工程

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：测试与工程 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS12/lv1 最小运行证据。
  - Lv2：RS12/lv2 单变量变体、对比和失败解释。
  - Lv3：RS12/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS12/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS12/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## PAR1 · 命令式范式

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：编程范式与抽象
- 资料锚点：Python Language Reference：https://docs.python.org/3/reference/；Rust Book：https://doc.rust-lang.org/book/；Go/JS 官方语言规范
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 抽象链路：命令式范式 如何改变状态、数据流、副作用、并发和可测试性？
  - 反例实验：抽象泄漏、性能退化、调试困难、共享状态和错误传播如何暴露？
  - 工程取舍：表达力、学习成本、性能、可组合性和团队协作如何权衡？
- 闯关交付：
  - Lv1：PAR1/lv1 最小运行证据。
  - Lv2：PAR1/lv2 单变量变体、对比和失败解释。
  - Lv3：PAR1/lv3 跨课测试、日志、设计图和清理。
  - Lv4：PAR1/lv4 基线、指标、审计/优化/回归。
  - Lv5：PAR1/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用两种范式写同一小问题，保存代码和测试。
  - Lab 2 · 受控变体：改变状态共享、数据规模或错误模型，比较可读性和结果。
  - Lab 3 · 综合任务：把纯函数/对象/事件/泛型/actor 中两种组合起来。
  - Lab 4 · 性能审计：测分配、调用、并发和调试成本，找出抽象泄漏。
  - Lab 5 · 开放研究：写“何时用哪种范式”的决策矩阵和教学例子。
- 必做失败实验：改变状态共享、错误模型或数据规模，记录抽象泄漏、性能退化和调试成本。
- 推荐命令骨架：`python -m pytest -q`、`cargo test`、`go test ./...`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## PAR2 · 面向对象

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：编程范式与抽象
- 资料锚点：Python Language Reference：https://docs.python.org/3/reference/；Rust Book：https://doc.rust-lang.org/book/；Go/JS 官方语言规范
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 抽象链路：面向对象 如何改变状态、数据流、副作用、并发和可测试性？
  - 反例实验：抽象泄漏、性能退化、调试困难、共享状态和错误传播如何暴露？
  - 工程取舍：表达力、学习成本、性能、可组合性和团队协作如何权衡？
- 闯关交付：
  - Lv1：PAR2/lv1 最小运行证据。
  - Lv2：PAR2/lv2 单变量变体、对比和失败解释。
  - Lv3：PAR2/lv3 跨课测试、日志、设计图和清理。
  - Lv4：PAR2/lv4 基线、指标、审计/优化/回归。
  - Lv5：PAR2/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用两种范式写同一小问题，保存代码和测试。
  - Lab 2 · 受控变体：改变状态共享、数据规模或错误模型，比较可读性和结果。
  - Lab 3 · 综合任务：把纯函数/对象/事件/泛型/actor 中两种组合起来。
  - Lab 4 · 性能审计：测分配、调用、并发和调试成本，找出抽象泄漏。
  - Lab 5 · 开放研究：写“何时用哪种范式”的决策矩阵和教学例子。
- 必做失败实验：改变状态共享、错误模型或数据规模，记录抽象泄漏、性能退化和调试成本。
- 推荐命令骨架：`python -m pytest -q`、`cargo test`、`go test ./...`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## PAR3 · 函数式

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：编程范式与抽象
- 资料锚点：Python Language Reference：https://docs.python.org/3/reference/；Rust Book：https://doc.rust-lang.org/book/；Go/JS 官方语言规范
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 抽象链路：函数式 如何改变状态、数据流、副作用、并发和可测试性？
  - 反例实验：抽象泄漏、性能退化、调试困难、共享状态和错误传播如何暴露？
  - 工程取舍：表达力、学习成本、性能、可组合性和团队协作如何权衡？
- 闯关交付：
  - Lv1：PAR3/lv1 最小运行证据。
  - Lv2：PAR3/lv2 单变量变体、对比和失败解释。
  - Lv3：PAR3/lv3 跨课测试、日志、设计图和清理。
  - Lv4：PAR3/lv4 基线、指标、审计/优化/回归。
  - Lv5：PAR3/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用两种范式写同一小问题，保存代码和测试。
  - Lab 2 · 受控变体：改变状态共享、数据规模或错误模型，比较可读性和结果。
  - Lab 3 · 综合任务：把纯函数/对象/事件/泛型/actor 中两种组合起来。
  - Lab 4 · 性能审计：测分配、调用、并发和调试成本，找出抽象泄漏。
  - Lab 5 · 开放研究：写“何时用哪种范式”的决策矩阵和教学例子。
- 必做失败实验：改变状态共享、错误模型或数据规模，记录抽象泄漏、性能退化和调试成本。
- 推荐命令骨架：`python -m pytest -q`、`cargo test`、`go test ./...`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## PAR4 · 泛型 / 元编程

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：编程范式与抽象
- 资料锚点：Python Language Reference：https://docs.python.org/3/reference/；Rust Book：https://doc.rust-lang.org/book/；Go/JS 官方语言规范
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 抽象链路：泛型 / 元编程 如何改变状态、数据流、副作用、并发和可测试性？
  - 反例实验：抽象泄漏、性能退化、调试困难、共享状态和错误传播如何暴露？
  - 工程取舍：表达力、学习成本、性能、可组合性和团队协作如何权衡？
- 闯关交付：
  - Lv1：PAR4/lv1 最小运行证据。
  - Lv2：PAR4/lv2 单变量变体、对比和失败解释。
  - Lv3：PAR4/lv3 跨课测试、日志、设计图和清理。
  - Lv4：PAR4/lv4 基线、指标、审计/优化/回归。
  - Lv5：PAR4/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用两种范式写同一小问题，保存代码和测试。
  - Lab 2 · 受控变体：改变状态共享、数据规模或错误模型，比较可读性和结果。
  - Lab 3 · 综合任务：把纯函数/对象/事件/泛型/actor 中两种组合起来。
  - Lab 4 · 性能审计：测分配、调用、并发和调试成本，找出抽象泄漏。
  - Lab 5 · 开放研究：写“何时用哪种范式”的决策矩阵和教学例子。
- 必做失败实验：改变状态共享、错误模型或数据规模，记录抽象泄漏、性能退化和调试成本。
- 推荐命令骨架：`python -m pytest -q`、`cargo test`、`go test ./...`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## PAR5 · 响应式 / 事件驱动

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：编程范式与抽象
- 资料锚点：Python Language Reference：https://docs.python.org/3/reference/；Rust Book：https://doc.rust-lang.org/book/；Go/JS 官方语言规范
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 抽象链路：响应式 / 事件驱动 如何改变状态、数据流、副作用、并发和可测试性？
  - 反例实验：抽象泄漏、性能退化、调试困难、共享状态和错误传播如何暴露？
  - 工程取舍：表达力、学习成本、性能、可组合性和团队协作如何权衡？
- 闯关交付：
  - Lv1：PAR5/lv1 最小运行证据。
  - Lv2：PAR5/lv2 单变量变体、对比和失败解释。
  - Lv3：PAR5/lv3 跨课测试、日志、设计图和清理。
  - Lv4：PAR5/lv4 基线、指标、审计/优化/回归。
  - Lv5：PAR5/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用两种范式写同一小问题，保存代码和测试。
  - Lab 2 · 受控变体：改变状态共享、数据规模或错误模型，比较可读性和结果。
  - Lab 3 · 综合任务：把纯函数/对象/事件/泛型/actor 中两种组合起来。
  - Lab 4 · 性能审计：测分配、调用、并发和调试成本，找出抽象泄漏。
  - Lab 5 · 开放研究：写“何时用哪种范式”的决策矩阵和教学例子。
- 必做失败实验：改变状态共享、错误模型或数据规模，记录抽象泄漏、性能退化和调试成本。
- 推荐命令骨架：`python -m pytest -q`、`cargo test`、`go test ./...`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## PAR6 · 面向切面 AOP

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：编程范式与抽象
- 资料锚点：Python Language Reference：https://docs.python.org/3/reference/；Rust Book：https://doc.rust-lang.org/book/；Go/JS 官方语言规范
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 抽象链路：面向切面 AOP 如何改变状态、数据流、副作用、并发和可测试性？
  - 反例实验：抽象泄漏、性能退化、调试困难、共享状态和错误传播如何暴露？
  - 工程取舍：表达力、学习成本、性能、可组合性和团队协作如何权衡？
- 闯关交付：
  - Lv1：PAR6/lv1 最小运行证据。
  - Lv2：PAR6/lv2 单变量变体、对比和失败解释。
  - Lv3：PAR6/lv3 跨课测试、日志、设计图和清理。
  - Lv4：PAR6/lv4 基线、指标、审计/优化/回归。
  - Lv5：PAR6/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用两种范式写同一小问题，保存代码和测试。
  - Lab 2 · 受控变体：改变状态共享、数据规模或错误模型，比较可读性和结果。
  - Lab 3 · 综合任务：把纯函数/对象/事件/泛型/actor 中两种组合起来。
  - Lab 4 · 性能审计：测分配、调用、并发和调试成本，找出抽象泄漏。
  - Lab 5 · 开放研究：写“何时用哪种范式”的决策矩阵和教学例子。
- 必做失败实验：改变状态共享、错误模型或数据规模，记录抽象泄漏、性能退化和调试成本。
- 推荐命令骨架：`python -m pytest -q`、`cargo test`、`go test ./...`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## OTH1 · Lua 脚本

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Python 与通用编程
- 资料锚点：Python Tutorial：https://docs.python.org/3/tutorial/；Python Language Reference：https://docs.python.org/3/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 程序链路：Lua 脚本 如何由输入、状态、控制流、数据结构、函数和 I/O 形成结果？
  - 边界实验：空值、错误、规模、编码、路径、资源耗尽和重复执行如何处理？
  - 工程取舍：正确性、可读性、测试、性能、安全和维护成本如何量化？
- 闯关交付：
  - Lv1：OTH1/lv1 最小运行证据。
  - Lv2：OTH1/lv2 单变量变体、对比和失败解释。
  - Lv3：OTH1/lv3 跨课测试、日志、设计图和清理。
  - Lv4：OTH1/lv4 基线、指标、审计/优化/回归。
  - Lv5：OTH1/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：按原课写一个可运行程序，带输入、输出和测试。
  - Lab 2 · 边界变体：加入错误、空值、规模、编码、路径或重复执行。
  - Lab 3 · 综合任务：连接数据结构、文件、网络、并发或测试中的两个主题。
  - Lab 4 · 性能/安全审计：测一个瓶颈，检查输入、资源、依赖和日志。
  - Lab 5 · 开放研究：写设计决策、反例、复现步骤和下一步实验。
- 必做失败实验：改变一个输入或环境条件制造可恢复失败，记录“现象→假设→证据→修复→回归→清理”。
- 推荐命令骨架：`python -m pytest -q`、`python -m compileall .`、`git diff --check`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## OTH2 · Zig

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Python 与通用编程
- 资料锚点：Python Tutorial：https://docs.python.org/3/tutorial/；Python Language Reference：https://docs.python.org/3/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 程序链路：Zig 如何由输入、状态、控制流、数据结构、函数和 I/O 形成结果？
  - 边界实验：空值、错误、规模、编码、路径、资源耗尽和重复执行如何处理？
  - 工程取舍：正确性、可读性、测试、性能、安全和维护成本如何量化？
- 闯关交付：
  - Lv1：OTH2/lv1 最小运行证据。
  - Lv2：OTH2/lv2 单变量变体、对比和失败解释。
  - Lv3：OTH2/lv3 跨课测试、日志、设计图和清理。
  - Lv4：OTH2/lv4 基线、指标、审计/优化/回归。
  - Lv5：OTH2/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：按原课写一个可运行程序，带输入、输出和测试。
  - Lab 2 · 边界变体：加入错误、空值、规模、编码、路径或重复执行。
  - Lab 3 · 综合任务：连接数据结构、文件、网络、并发或测试中的两个主题。
  - Lab 4 · 性能/安全审计：测一个瓶颈，检查输入、资源、依赖和日志。
  - Lab 5 · 开放研究：写设计决策、反例、复现步骤和下一步实验。
- 必做失败实验：改变一个输入或环境条件制造可恢复失败，记录“现象→假设→证据→修复→回归→清理”。
- 推荐命令骨架：`python -m pytest -q`、`python -m compileall .`、`git diff --check`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## OTH3 · Nim

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Python 与通用编程
- 资料锚点：Python Tutorial：https://docs.python.org/3/tutorial/；Python Language Reference：https://docs.python.org/3/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 程序链路：Nim 如何由输入、状态、控制流、数据结构、函数和 I/O 形成结果？
  - 边界实验：空值、错误、规模、编码、路径、资源耗尽和重复执行如何处理？
  - 工程取舍：正确性、可读性、测试、性能、安全和维护成本如何量化？
- 闯关交付：
  - Lv1：OTH3/lv1 最小运行证据。
  - Lv2：OTH3/lv2 单变量变体、对比和失败解释。
  - Lv3：OTH3/lv3 跨课测试、日志、设计图和清理。
  - Lv4：OTH3/lv4 基线、指标、审计/优化/回归。
  - Lv5：OTH3/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：按原课写一个可运行程序，带输入、输出和测试。
  - Lab 2 · 边界变体：加入错误、空值、规模、编码、路径或重复执行。
  - Lab 3 · 综合任务：连接数据结构、文件、网络、并发或测试中的两个主题。
  - Lab 4 · 性能/安全审计：测一个瓶颈，检查输入、资源、依赖和日志。
  - Lab 5 · 开放研究：写设计决策、反例、复现步骤和下一步实验。
- 必做失败实验：改变一个输入或环境条件制造可恢复失败，记录“现象→假设→证据→修复→回归→清理”。
- 推荐命令骨架：`python -m pytest -q`、`python -m compileall .`、`git diff --check`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## OTH4 · Swift

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Python 与通用编程
- 资料锚点：Python Tutorial：https://docs.python.org/3/tutorial/；Python Language Reference：https://docs.python.org/3/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 程序链路：Swift 如何由输入、状态、控制流、数据结构、函数和 I/O 形成结果？
  - 边界实验：空值、错误、规模、编码、路径、资源耗尽和重复执行如何处理？
  - 工程取舍：正确性、可读性、测试、性能、安全和维护成本如何量化？
- 闯关交付：
  - Lv1：OTH4/lv1 最小运行证据。
  - Lv2：OTH4/lv2 单变量变体、对比和失败解释。
  - Lv3：OTH4/lv3 跨课测试、日志、设计图和清理。
  - Lv4：OTH4/lv4 基线、指标、审计/优化/回归。
  - Lv5：OTH4/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：按原课写一个可运行程序，带输入、输出和测试。
  - Lab 2 · 边界变体：加入错误、空值、规模、编码、路径或重复执行。
  - Lab 3 · 综合任务：连接数据结构、文件、网络、并发或测试中的两个主题。
  - Lab 4 · 性能/安全审计：测一个瓶颈，检查输入、资源、依赖和日志。
  - Lab 5 · 开放研究：写设计决策、反例、复现步骤和下一步实验。
- 必做失败实验：改变一个输入或环境条件制造可恢复失败，记录“现象→假设→证据→修复→回归→清理”。
- 推荐命令骨架：`python -m pytest -q`、`python -m compileall .`、`git diff --check`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## OTH5 · Kotlin

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Python 与通用编程
- 资料锚点：Python Tutorial：https://docs.python.org/3/tutorial/；Python Language Reference：https://docs.python.org/3/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 程序链路：Kotlin 如何由输入、状态、控制流、数据结构、函数和 I/O 形成结果？
  - 边界实验：空值、错误、规模、编码、路径、资源耗尽和重复执行如何处理？
  - 工程取舍：正确性、可读性、测试、性能、安全和维护成本如何量化？
- 闯关交付：
  - Lv1：OTH5/lv1 最小运行证据。
  - Lv2：OTH5/lv2 单变量变体、对比和失败解释。
  - Lv3：OTH5/lv3 跨课测试、日志、设计图和清理。
  - Lv4：OTH5/lv4 基线、指标、审计/优化/回归。
  - Lv5：OTH5/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：按原课写一个可运行程序，带输入、输出和测试。
  - Lab 2 · 边界变体：加入错误、空值、规模、编码、路径或重复执行。
  - Lab 3 · 综合任务：连接数据结构、文件、网络、并发或测试中的两个主题。
  - Lab 4 · 性能/安全审计：测一个瓶颈，检查输入、资源、依赖和日志。
  - Lab 5 · 开放研究：写设计决策、反例、复现步骤和下一步实验。
- 必做失败实验：改变一个输入或环境条件制造可恢复失败，记录“现象→假设→证据→修复→回归→清理”。
- 推荐命令骨架：`python -m pytest -q`、`python -m compileall .`、`git diff --check`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## OTH6 · Dart

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Python 与通用编程
- 资料锚点：Python Tutorial：https://docs.python.org/3/tutorial/；Python Language Reference：https://docs.python.org/3/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 程序链路：Dart 如何由输入、状态、控制流、数据结构、函数和 I/O 形成结果？
  - 边界实验：空值、错误、规模、编码、路径、资源耗尽和重复执行如何处理？
  - 工程取舍：正确性、可读性、测试、性能、安全和维护成本如何量化？
- 闯关交付：
  - Lv1：OTH6/lv1 最小运行证据。
  - Lv2：OTH6/lv2 单变量变体、对比和失败解释。
  - Lv3：OTH6/lv3 跨课测试、日志、设计图和清理。
  - Lv4：OTH6/lv4 基线、指标、审计/优化/回归。
  - Lv5：OTH6/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：按原课写一个可运行程序，带输入、输出和测试。
  - Lab 2 · 边界变体：加入错误、空值、规模、编码、路径或重复执行。
  - Lab 3 · 综合任务：连接数据结构、文件、网络、并发或测试中的两个主题。
  - Lab 4 · 性能/安全审计：测一个瓶颈，检查输入、资源、依赖和日志。
  - Lab 5 · 开放研究：写设计决策、反例、复现步骤和下一步实验。
- 必做失败实验：改变一个输入或环境条件制造可恢复失败，记录“现象→假设→证据→修复→回归→清理”。
- 推荐命令骨架：`python -m pytest -q`、`python -m compileall .`、`git diff --check`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## OTH7 · TypeScript

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：JavaScript 与运行时
- 资料锚点：MDN Web Docs：https://developer.mozilla.org/en-US/docs/Web；Node.js Docs：https://nodejs.org/docs/latest/api/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 事件链路：TypeScript 如何经过词法作用域、任务队列、DOM/Node、Promise 和 I/O？
  - 边界实验：竞态、微任务饥饿、原型污染、类型边界、内存泄漏和模块冲突如何发现？
  - 工程取舍：交互、并发、兼容性、类型安全、包体和供应链如何量化？
- 闯关交付：
  - Lv1：OTH7/lv1 最小运行证据。
  - Lv2：OTH7/lv2 单变量变体、对比和失败解释。
  - Lv3：OTH7/lv3 跨课测试、日志、设计图和清理。
  - Lv4：OTH7/lv4 基线、指标、审计/优化/回归。
  - Lv5：OTH7/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：在浏览器或 Node 运行本课示例，保存 console/Network/版本。
  - Lab 2 · 边界变体：制造微任务饥饿、竞态、类型边界、原型/模块冲突或泄漏。
  - Lab 3 · 综合任务：把 DOM/API/状态/测试或 Node I/O 连接成完整流程。
  - Lab 4 · 性能/安全审计：用 DevTools、TypeScript、依赖扫描和性能记录修复一项问题。
  - Lab 5 · 开放研究：写事件循环/包边界/浏览器安全和替代方案笔记。
- 必做失败实验：在自己的浏览器/Node 项目制造竞态、微任务饥饿、类型边界、模块冲突或泄漏，保存 DevTools 证据。
- 推荐命令骨架：`node --version`、`node --test`、`npm audit --omit=dev`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SQL1 · 查询基础

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：查询基础 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SQL1/lv1 最小运行证据。
  - Lv2：SQL1/lv2 单变量变体、对比和失败解释。
  - Lv3：SQL1/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SQL1/lv4 基线、指标、审计/优化/回归。
  - Lv5：SQL1/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SQL2 · 联结 JOIN

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：联结 JOIN 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SQL2/lv1 最小运行证据。
  - Lv2：SQL2/lv2 单变量变体、对比和失败解释。
  - Lv3：SQL2/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SQL2/lv4 基线、指标、审计/优化/回归。
  - Lv5：SQL2/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SQL3 · 子查询 / CTE / 窗口函数 / 递归查询

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：子查询 / CTE / 窗口函数 / 递归查询 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SQL3/lv1 最小运行证据。
  - Lv2：SQL3/lv2 单变量变体、对比和失败解释。
  - Lv3：SQL3/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SQL3/lv4 基线、指标、审计/优化/回归。
  - Lv5：SQL3/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SQL4 · 事务与隔离

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：事务与隔离 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SQL4/lv1 最小运行证据。
  - Lv2：SQL4/lv2 单变量变体、对比和失败解释。
  - Lv3：SQL4/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SQL4/lv4 基线、指标、审计/优化/回归。
  - Lv5：SQL4/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SQL5 · 索引与执行计划（含性能陷阱 / JSON 字段）

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：索引与执行计划（含性能陷阱 / JSON 字段） 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SQL5/lv1 最小运行证据。
  - Lv2：SQL5/lv2 单变量变体、对比和失败解释。
  - Lv3：SQL5/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SQL5/lv4 基线、指标、审计/优化/回归。
  - Lv5：SQL5/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SQL6 · 存储过程 / 触发器 / 与 ORM 对照

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：存储过程 / 触发器 / 与 ORM 对照 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SQL6/lv1 最小运行证据。
  - Lv2：SQL6/lv2 单变量变体、对比和失败解释。
  - Lv3：SQL6/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SQL6/lv4 基线、指标、审计/优化/回归。
  - Lv5：SQL6/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SH1 · Bash 基础

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：Bash 基础 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SH1/lv1 最小运行证据。
  - Lv2：SH1/lv2 单变量变体、对比和失败解释。
  - Lv3：SH1/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SH1/lv4 基线、指标、审计/优化/回归。
  - Lv5：SH1/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SH2 · 管道 / 重定向 / 文本三剑客

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：管道 / 重定向 / 文本三剑客 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SH2/lv1 最小运行证据。
  - Lv2：SH2/lv2 单变量变体、对比和失败解释。
  - Lv3：SH2/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SH2/lv4 基线、指标、审计/优化/回归。
  - Lv5：SH2/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SH3 · 脚本与函数（含调试）

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：脚本与函数（含调试） 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SH3/lv1 最小运行证据。
  - Lv2：SH3/lv2 单变量变体、对比和失败解释。
  - Lv3：SH3/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SH3/lv4 基线、指标、审计/优化/回归。
  - Lv5：SH3/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SH4 · PowerShell

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：PowerShell 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SH4/lv1 最小运行证据。
  - Lv2：SH4/lv2 单变量变体、对比和失败解释。
  - Lv3：SH4/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SH4/lv4 基线、指标、审计/优化/回归。
  - Lv5：SH4/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SH5 · 正则与文本处理实战（三剑客 + 正则）

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：正则与文本处理实战（三剑客 + 正则） 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SH5/lv1 最小运行证据。
  - Lv2：SH5/lv2 单变量变体、对比和失败解释。
  - Lv3：SH5/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SH5/lv4 基线、指标、审计/优化/回归。
  - Lv5：SH5/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## RS13 · Rust 并发与 async（无畏并发 / Tokio）

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：Rust 与内存安全
- 资料锚点：The Rust Book：https://doc.rust-lang.org/book/；Rust Reference：https://doc.rust-lang.org/reference/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 不变量：Rust 并发与 async（无畏并发 / Tokio） 如何由所有权/借用/trait/async/unsafe 规则保证内存和并发安全？
  - 边界实验：生命周期冲突、Pin、Send/Sync、FFI、panic 和错误传播如何处理？
  - 工程取舍：零成本、可读性、编译时间、生态、unsafe 边界和运行时性能如何量化？
- 闯关交付：
  - Lv1：RS13/lv1 最小运行证据。
  - Lv2：RS13/lv2 单变量变体、对比和失败解释。
  - Lv3：RS13/lv3 跨课测试、日志、设计图和清理。
  - Lv4：RS13/lv4 基线、指标、审计/优化/回归。
  - Lv5：RS13/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：用 cargo 跑通本课 API，并写单元测试。
  - Lab 2 · 边界变体：引入一个生命周期/并发/错误/unsafe 变化，记录编译器或运行时反馈。
  - Lab 3 · 综合任务：连接 trait、集合、async/FFI 中至少两项，处理取消和资源释放。
  - Lab 4 · 性能审计：用 criterion/基准与 sanitizer/解释器检查分配、锁和 unsafe 边界。
  - Lab 5 · 开放研究：写安全不变量、替代设计、生态限制和迁移建议。
- 必做失败实验：在自己的 crate 中引入生命周期、Send/Sync、panic 或 unsafe 边界变化，记录编译器/测试反馈和修复。
- 推荐命令骨架：`cargo test`、`cargo clippy -- -D warnings`、`cargo miri test`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SQL7 · SQL 深（执行计划 / 索引 / 事务隔离）

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：SQL 深（执行计划 / 索引 / 事务隔离） 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SQL7/lv1 最小运行证据。
  - Lv2：SQL7/lv2 单变量变体、对比和失败解释。
  - Lv3：SQL7/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SQL7/lv4 基线、指标、审计/优化/回归。
  - Lv5：SQL7/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

## SH6 · Shell 自动化与 CI 脚本（健壮性 / set -euo pipefail）

- 原课文件：教案_方向1c_Rust_范式_SQL_Shell.md
- 主题轨道：SQL 与自动化脚本
- 资料锚点：PostgreSQL/SQLite 文档：https://www.postgresql.org/docs/current/；https://www.sqlite.org/docs.html；GNU Bash：https://www.gnu.org/software/bash/manual/
- 资料记录要求：写明文档/章节标题、版本或提交日期、访问日期、适用范围和未验证项。
- 深挖问题：
  - 解释链路：Shell 自动化与 CI 脚本（健壮性 / set -euo pipefail） 如何由声明/命令、解析、管道、执行器和副作用形成结果？
  - 边界实验：空格/引号、NULL、退出码、管道失败、注入、并发和重跑如何暴露？
  - 工程取舍：可读性、幂等、可移植性、安全和自动化收益如何量化？
- 闯关交付：
  - Lv1：SH6/lv1 最小运行证据。
  - Lv2：SH6/lv2 单变量变体、对比和失败解释。
  - Lv3：SH6/lv3 跨课测试、日志、设计图和清理。
  - Lv4：SH6/lv4 基线、指标、审计/优化/回归。
  - Lv5：SH6/lv5 开放研究、证明、教学或 ADR。
- 五个 Lab：
  - Lab 1 · 最小实现：运行本课 SQL/脚本，保存退出码、输出和版本。
  - Lab 2 · 边界变体：空值、空格/引号、失败管道、重复执行和权限错误。
  - Lab 3 · 综合任务：把脚本连接数据库/HTTP/文件并加入幂等、日志和测试。
  - Lab 4 · 安全审计：对自有代码做参数化、最小权限、依赖和供应链检查。
  - Lab 5 · 开放研究：写可移植、可回滚、可观测的自动化 Runbook。
- 必做失败实验：在本地数据库/脚本中制造 NULL、失败管道、约束冲突、注入输入或重复执行，记录退出码、回滚和清理。
- 推荐命令骨架：`sqlite3 lab.db`、`EXPLAIN QUERY PLAN ...`、`bash -n script.sh`
- 验收：至少 4/5 Lab 在干净环境可复现；记录版本、输入、输出、失败路径、清理、未验证项和身体负荷调整。

