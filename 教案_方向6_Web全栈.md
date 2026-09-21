# 教案 · 方向6 Web 全栈（FE/BE，毕业作 = 闪电号卡）

> **本文件覆盖范围**：FE1–FE18（前端 18 节）+ BE1–BE26（后端 26 节），共 **44 节**。
> **毕业实战**：BE26 把前面所有知识整合为「闪电号卡」雏形（一个真实的号卡/套餐展示+下单小站）。
> **每节写法**：严格 11 段深模板（🎯目标 → 📋小白前置 → 🟢最浅层 → 🟡动手层 → 🔵原理层 → 🟣深挖层 → 🔴顶级视角 → 🟠安全合规 → ✅验收 → ⚠️常见坑 → ➡️下一步）+ 实战 Lab。
> **学生画像**：真·零基础、术后留置针手不便、时间极充裕、目标是计算机顶级大佬。
> **护手约定**：能复制就复制，少打字；Windows 环境；用 VS Code + 已装好的 Python / Flask；命令与代码全部可复制粘贴。
> **呼应项目**：凡是能用「闪电号卡」举例的地方，都尽量用它来串，让 44 节最终在 BE26 收口成真东西。

---

## ========== 前端 FE1–FE18 ==========

---

## FE1 · HTML 语义化（DOM / 可访问性 / SEO）

### 🎯 目标
学完这节，你能用「有意义的标签」写出一个结构正确的网页骨架（标题、段落、导航、列表、表格、表单），并在浏览器里看到它；理解为什么 `<h1>` 不等于 `<div class="title">`。

### 📋 小白前置
- 方向1 编程基础（本文件首节按约定写「方向1 编程基础」，即 PRE0–PRE5 + PY1–PY5 的直觉）
- 预备层：PRE4 安装 VS Code、PRE7 浏览器与网络极简
- 本文件内：无（这是前端第 1 节）

### 🟢 部分一·最浅层（生活比喻）
HTML 就像**盖房子的框架图**。你不用管墙刷什么颜色（那是 CSS 的活），也不用管灯怎么开关（那是 JS 的活）。你只管说「这里是门、那里是窗、这面墙是承重墙」。语义化标签就是「在图上一眼能看出这是门还是窗」——以后装修师傅（浏览器、读屏软件、搜索引擎）一看就懂，不会把承重墙当隔断拆了。

### 🟡 部分二·动手层（逐字操作）
1. 打开 VS Code（开始菜单搜 VS Code 回车）。
2. 点左上「文件 → 打开文件夹」，新建一个文件夹 `闪电号卡-fe`，选中它打开。
3. 在左侧资源管理器点「新建文件」，命名为 `index.html`。
4. 把下面整段复制进去（Ctrl+A 全选再 Ctrl+V，护手少打字）：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>闪电号卡 · 首页</title>
</head>
<body>
  <header>
    <h1>闪电号卡</h1>
    <nav>
      <a href="#plans">套餐</a>
      <a href="#buy">购买</a>
    </nav>
  </header>
  <main>
    <section id="plans">
      <h2>热门套餐</h2>
      <ul>
        <li>闪电卡 19 元：30G 流量</li>
        <li>闪电卡 39 元：100G 流量</li>
      </ul>
    </section>
    <section id="buy">
      <h2>立即购买</h2>
      <form>
        <label for="phone">手机号：</label>
        <input id="phone" name="phone" type="tel">
        <button type="submit">下单</button>
      </form>
    </section>
  </main>
  <footer>
    <p>© 2026 闪电号卡</p>
  </footer>
</body>
</html>
```

5. 按 `Ctrl+S` 保存。
6. 在文件标签页右键 →「在文件资源管理器中显示」→ 双击 `index.html`，它会在默认浏览器打开。你能看到标题、导航、套餐列表、表单。

### 🔵 部分三·原理层（底层发生了什么）
浏览器拿到这段 HTML 后做两件事：① **解析（Parse）** 把文本变成一棵「DOM 树」（Document Object Model，文档对象模型）；② **渲染** 按树结构画出页面。每个标签都是树上的一个「节点」。`<header><main><footer>` 这些语义标签，本质上给节点贴了「角色标签」，让读屏软件和搜索引擎能理解结构，而不是只看到一堆 `<div>`。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么不用全 `<div>`？因为「结构语义」是给机器看的契约。搜索引擎爬虫、屏幕阅读器（视障用户靠它听网页）、甚至你未来的后端模板系统，都依赖这些语义。顶级工程师会追问：标签的「可访问性角色（ARIA role）」和原生语义冲突时谁优先？答案是原生语义优先，ARIA 只做补充。这引出了 FE16 的可访问性主题。

### 🔴 部分五·顶级视角
在大型项目里，HTML 语义化是「组件契约」的地基：React/Vue 的组件最终都编译成语义 DOM；微前端（FE18）里多个团队各写一块，靠统一语义避免冲突。搜索引擎优化（SEO）、无障碍合规（法律要求，如美国 ADA、欧盟 EN 301 549）都从这一节开始。顶级全栈会把语义当作「API 设计」的一部分来对待。

### 🟠 部分六·安全/合规种子（白帽）
HTML 本身没有「攻击」，但**语义被滥用**会埋坑：比如把按钮写成 `<div onclick>` 会让键盘用户无法触发（a11y 漏洞，属合规风险）。另外，所有「用户输入」进 HTML 都要转义（FE15 同源/CSP、BE4/SSTI 会展开），否则会演变成 XSS。现在只记住一句：永远用对的标签做对的事，别用 `<div>` 假装按钮。

### ✅ 验收
交一个 `index.html`，浏览器打开后能正确显示：一个一级标题「闪电号卡」、一个导航、两个套餐项、一个带输入框和按钮的表单、一个页脚。截图给我即可。

### ⚠️ 常见坑
- 忘了 `<!DOCTYPE html>`：浏览器会进「怪异模式（Quirks Mode）」，布局乱掉。永远放第一行。
- `<meta charset>` 没写或写错：中文变乱码。复制上面模板即可。
- 标签不闭合：HTML5 容错强，但结构会错乱，读屏软件会迷路。
- 把 `lang="zh-CN"` 写成 `lang="en"`：影响发音与 SEO 地域判断（小事但顶级会抠）。

### ➡️ 下一步
**FE2 · CSS 盒模型/层叠**——给你的「房子框架」刷漆、定尺寸、摆家具。

### 🧪 实战 Lab（FE1）
在 `index.html` 基础上，新增一个 `<section id="faq">` 放「常见问题」用 `<dl>`（定义列表：`<dt>` 问题 + `<dd>` 答案）写 2 条 Q&A；再给页脚加一个 `<address>` 写「客服邮箱：support@shandian.example」。保存刷新，确认结构层次清晰。**验收点**：页面里出现定义列表和 address 元素，且浏览器无报错。

---

## FE2 · CSS 盒模型 / 层叠（特异度 / 继承）

### 🎯 目标
学完这节，你能给 FE1 的页面上色、调间距、控制字体，并理解「一个元素为什么看起来是这么大」——因为它是一个「盒子」。

### 📋 小白前置
- 方向1 编程基础
- 预备层：PRE4 VS Code、PRE7 浏览器
- 本文件内：**FE1**（要先有 HTML 骨架）

### 🟢 部分一·最浅层（生活比喻）
网页里每个元素都是一个**快递盒**。盒子有：内容（你买的东西）、内边距 padding（盒子里的泡沫）、边框 border（盒子外壳）、外边距 margin（盒子之间的空隙）。CSS 就是规定「这个盒子多大、泡沫多厚、外壳多宽、离邻居多远」的规则书。

### 🟡 部分二·动手层（逐字操作）
在 `闪电号卡-fe` 文件夹里新建 `style.css`，复制下面内容：

```css
* { box-sizing: border-box; }   /* 让宽度包含 padding 和 border，算尺寸更直观 */
body {
  font-family: "Microsoft YaHei", sans-serif;
  margin: 0;
  color: #222;
}
header {
  background: #0b5;            /* 闪电绿 */
  color: #fff;
  padding: 16px;
}
h1 { margin: 0; font-size: 28px; }
nav a { color: #fff; margin-right: 16px; text-decoration: none; }
section { padding: 16px; border-bottom: 1px solid #eee; }
button {
  background: #f60; color: #fff; border: 0;
  padding: 8px 16px; border-radius: 4px; cursor: pointer;
}
```

然后回到 `index.html` 的 `<head>` 里，在 `<title>` 下面加一句（复制粘贴）：
```html
<link rel="stylesheet" href="style.css">
```
按 Ctrl+S，浏览器刷新（F5），页面立刻有颜色、有间距。

### 🔵 部分三·原理层（底层发生了什么）
浏览器先建 DOM 树，再建「CSSOM 树」（CSS 对象模型），然后把两棵树合并成「渲染树（Render Tree）」。每个节点根据盒模型计算出「内容区 + padding + border + margin」的真实像素盒子，再交给布局（Layout）和绘制（Paint）。`box-sizing: border-box` 改变了「width 到底包含谁」——默认 `content-box` 时 width 只算内容，加了 padding/border 盒子会更大，新手最容易在这里算错尺寸。

### 🟣 部分四·深挖层（为什么 & 延伸）
**层叠（Cascade）** 决定「多条规则打架听谁的」。优先级顺序：① 重要性（`!important`）② 来源（作者样式 > 浏览器默认）③ **特异度（specificity）** ④ 顺序（后者覆盖前者）。特异度像「地址精确度」：行内 `style=` > ID `#x` > 类 `.x` > 标签 `div`。顶级工程师追问：为什么 `!important` 是坏味道？因为它破坏了层叠的可预测性，让维护变成「谁的 !important 更狠」。这引出 CSS-in-JS、BEM 命名规范等工程解法。

### 🔴 部分五·顶级视角
盒模型是「布局系统」的数学基础。flex/grid（FE3）、响应式（FE4）、甚至浏览器性能优化（FE14 避免重排）都建立在它之上。在 Design System（PD6 Token）里，间距、圆角、颜色都是「设计令牌」，CSS 变量（`--token`）把它们参数化。顶级前端会把盒模型当作「像素级预算」来管理。

### 🟠 部分六·安全/合规种子（白帽）
CSS 本身安全，但有两个边角：① `user-select: none` 滥用会阻碍视障用户复制——属 a11y 合规问题；② CSS 可被用来「视觉隐藏」敏感信息做钓鱼（把假按钮盖在真按钮上）。白帽原则：样式只服务于清晰，不用于欺骗或阻碍无障碍。

### ✅ 验收
交 `style.css` + 更新后的 `index.html`，刷新后页面有绿色顶栏、橙色按钮、区段分隔线，且按钮点击区域明显。截图给我。

### ⚠️ 常见坑
- 忘了 `<link>` 引入 CSS：页面无样式。检查路径和文件名大小写（Windows 不区分，但部署到 Linux 区分）。
- `box-sizing` 没设：宽度算错，元素「超出预期」。
- 特异度理解错：`#id` 比 `.class` 强，想覆盖却改不动——用更具体的选择器或重构。
- margin 折叠：上下两个块的外边距会「取大值合并」，不是相加，新手以为有双倍空隙。

### ➡️ 下一步
**FE3 · CSS 布局（flex/grid/定位）**——学会把盒子排成一行、一排、或叠在一起。

### 🧪 实战 Lab（FE2）
给 `index.html` 的套餐 `<ul>` 加 `class="plan-list"`，在 CSS 里写 `.plan-list { list-style: none; padding: 0; }`，并为每个 `<li>` 加 `class="plan-card"`，写 `.plan-card { background:#fafafa; border:1px solid #ddd; padding:12px; margin:8px 0; border-radius:6px; }`。刷新看卡片效果。**验收点**：套餐变成带边框的卡片样式。

---

## FE3 · CSS 布局（flex / grid / 定位）

### 🎯 目标
学完这节，你能把元素排成横向导航、网格卡片墙、固定悬浮按钮，理解 flex 与 grid 各自最适合什么场景。

### 📋 小白前置
- 方向1 编程基础
- 本文件内：**FE1、FE2**

### 🟢 部分一·最浅层（生活比喻）
- **flex（弹性盒）** 像「一排挂钩」：东西往一条线上挂，多了就挤、少了就松，还能指定谁占空间大。
- **grid（网格）** 像「棋盘/Excel 表格」：你先画几行几列，再把东西放进格子，最适合整页大布局。
- **定位（position）** 像「贴纸条」：relative 是「相对原位挪一点」，absolute 是「贴到最近的有定位的父盒子上」，fixed 是「贴到屏幕窗口上死活不动」。

### 🟡 部分二·动手层（逐字操作）
在 `style.css` 里追加以下内容（复制粘贴到底部）：

```css
/* 导航横向排列 */
nav { display: flex; gap: 16px; }

/* 套餐卡片排成自适应网格：每列最小 200px，自动填满 */
.plan-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 12px; }

/* 悬浮「回到顶部」按钮（先加个元素到 HTML 试验） */
.back-top {
  position: fixed; right: 16px; bottom: 16px;
  background: #0b5; color: #fff; border: 0;
  width: 44px; height: 44px; border-radius: 50%; cursor: pointer;
}
```

在 `index.html` 的 `</body>` 前加：
```html
<button class="back-top" onclick="window.scrollTo(0,0)">↑</button>
```
刷新：导航横排、套餐成网格、右下角出现圆形悬浮按钮，点它滚回顶部。

### 🔵 部分三·原理层（底层发生了什么）
布局阶段（Layout/Reflow）根据 `display` 决定「这个盒子内部怎么排孩子」。flex 走「主轴+交叉轴」算法：先按 `flex-basis` 给基准尺寸，再按 `flex-grow/shrink` 分配剩余/收缩空间。grid 走「轨道（track）算法」：先算行高列宽（可来自 `fr` 比例、`minmax`、固定值），再把项目放入由 `grid-template` 定义的网格。position 各值在布局后做「偏移修正」，`fixed` 的包含块是视口。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么有了 flex 还要 grid？因为 flex 是「一维」（一条线），grid 是「二维」（行列同时）。导航条用 flex，整页仪表盘用 grid。顶级工程师追问：`subgrid`（子网格）为何重要？它让嵌套网格与父网格对齐，解决「卡片内部标签和兄弟卡片不对齐」的经典难题。还有 `gap` 替代 `margin` 避免折叠——这是现代布局的「去 margin 化」趋势。

### 🔴 部分五·顶级视角
布局能力直接决定「组件复用度」。在微前端（FE18）、设计系统（PD6）里，布局原语（Stack/Grid/Box）是跨团队共享的乐高积木。Flutter（MOB34）、SwiftUI（MOB24）、甚至终端 UI 都用同一套「flex/grid 思想」。顶级全栈看到任何 UI 框架，都能一眼映射到这套布局心智模型。

### 🟠 部分六·安全/合规种子（白帽）
布局本身无攻击性，但要警惕：用 `position: absolute` + 透明层「盖住」真实按钮做点击劫持（clickjacking）是黑产手法。白帽防御在后端用 `Content-Security-Policy` 的 `frame-ancestors`（FE15）禁止被嵌入。我们只在自己页面练布局，绝不拿去盖别人。

### ✅ 验收
交更新后的两文件，刷新后：导航横排有间距、套餐是响应式网格（窗口拉窄会自动换行）、右下角悬浮按钮可点。截图给我。

### ⚠️ 常见坑
- flex 容器里的子项被「压扁」：因为默认 `min-width: auto`，加 `min-width: 0` 或 `overflow: hidden` 解决。
- grid 的 `1fr` 溢出：内容太长撑破，配合 `minmax(0, 1fr)`。
- `position: absolute` 跑偏：父级没设 `position: relative`，它跑去找更上层祖先。
- 忘了 `gap` 在某些老浏览器不支持（现代可忽略，但顶级要知道降级方案）。

### ➡️ 下一步
**FE4 · 响应式设计（媒体查询 / 移动优先）**——让页面在手机和电脑上都好看。

### 🧪 实战 Lab（FE3）
给 `.plan-card` 加一条：`transition: transform .2s;`，再加 `.plan-card:hover { transform: translateY(-4px); box-shadow: 0 4px 12px rgba(0,0,0,.15); }`。刷新后鼠标移上卡片会「浮起来」。**验收点**：hover 出现上浮+阴影动画（为 FE17 动画预热）。

---

## FE4 · 响应式设计（媒体查询 / 移动优先）

### 🎯 目标
学完这节，你能让同一套页面在手机（窄屏）和电脑（宽屏）自动调整布局，理解「移动优先」的工程哲学。

### 📋 小白前置
- 方向1 编程基础
- 本文件内：**FE1、FE2、FE3**

### 🟢 部分一·最浅层（生活比喻）
响应式就像**一件伸缩衣**：小孩穿合身、大人穿也合身，因为它会随身材变。媒体查询（media query）就是「当屏幕比 X 窄/宽时，换一套剪裁规则」。

### 🟡 部分二·动手层（逐字操作）
在 `style.css` 顶部（`*` 规则附近）确认已有：
```css
meta viewport（HTML 里已有）  /* 这行是提醒：HTML 的 <meta name="viewport"> 必须存在，否则手机按桌面宽度渲染 */
```
在 `style.css` 末尾追加：

```css
/* 默认（移动优先）：单列 */
.plan-list { grid-template-columns: 1fr; }

/* 屏幕宽度 ≥ 600px（平板/电脑）：多列 */
@media (min-width: 600px) {
  .plan-list { grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); }
}
/* 大屏限制最大宽度，居中 */
@media (min-width: 1000px) {
  body { max-width: 960px; margin: 0 auto; }
}
```
打开浏览器，按 F12 开「开发者工具 → 设备工具栏（Ctrl+Shift+M）」，切换 iPhone / 桌面，看布局变化。

### 🔵 部分三·原理层（底层发生了什么）
CSS 媒体查询在**样式计算阶段**生效：浏览器根据视口（viewport）特征（宽度、分辨率、方向）筛选匹配的 `@media` 规则，再并入层叠。viewport 的像素是「CSS 像素」而非物理像素，DPI 缩放靠 `devicePixelRatio`（FE7 渲染原理会讲）。没有 `<meta viewport>`，移动浏览器会假装自己有 980px 宽，然后缩小显示，于是你写的媒体查询永远按 980px 算——这是新手第一坑。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么「移动优先（mobile-first）」而不是「桌面优先」？因为：① 手机用户更多；② 先写窄屏约束少，再用 `min-width` 向上增强，比先写宽屏再用 `max-width` 向下删减更不容易漏；③ 性能更好（默认加载简单布局）。顶级工程师追问：响应式 vs 自适应（Adaptive，多套独立页面）怎么选？内容型用响应式，功能差异大（App vs 官网）用自适应/独立移动站。

### 🔴 部分五·顶级视角
响应式是「多端统一」思想的入门：同一份 DOM，不同 CSS = 不同形态。这与 React Native（MOB33）、Flutter（MOB34）的「一份逻辑多端渲染」同源。顶级全栈把「断点（breakpoint）」当作产品决策（依据用户设备分布数据定断点），而非拍脑袋。

### 🟠 部分六·安全/合规种子（白帽）
响应式本身安全，但注意：① 别用响应式「隐藏」违法内容（桌面显示、手机隐藏 —— 这是欺骗监管/用户的手法，违规）；② 移动端常走弱网，加载策略要谨慎（FE14 性能）。白帽只做「体验增强」，不做「内容欺诈」。

### ✅ 验收
交两文件，用开发者工具设备模式分别截图「手机宽度」和「桌面宽度」各一张，证明布局随宽度变化（手机单列、桌面多列/居中）。

### ⚠️ 常见坑
- 忘写 `<meta viewport>`：媒体查询在手机上不生效。
- 断点取「设备型号像素」：应取内容断点（布局在哪开始挤），不是 iPhone/ iPad 具体值。
- 用 `width: 100vw`：垂直滚动条会让 100vw 比可见区宽，出现横向滚动条，改用 `100%`。
- 图片不缩放：`img { max-width: 100%; }` 忘加，大图撑破布局。

### ➡️ 下一步
**FE5 · JS 基础（类型 / 作用域）**——页面要「动起来」了，开始学网页的编程语言。

### 🧪 实战 Lab（FE4）
给 `.back-top` 按钮加 `display: none;`，然后在媒体查询里 `(min-width: 600px)` 时设 `display: block;`（手机上不显示悬浮按钮，桌面才显示）。**验收点**：手机视图无悬浮按钮，桌面视图有。

---

## FE5 · JS 基础（类型 / 作用域）

### 🎯 目标
学完这节，你能用 JavaScript 写变量、判断、循环，给页面加一点交互（比如点按钮弹出提示），并搞懂 JS 的「类型怪癖」和「作用域」。

### 📋 小白前置
- 方向1 编程基础（PY1–PY6 变量/条件/循环、PY11 作用域直觉）
- 本文件内：**FE1–FE4**（要有页面和按钮）

### 🟢 部分一·最浅层（生活比喻）
HTML 是房子的框架，CSS 是装修，那 **JS 就是「电路和开关」**——它让灯能亮、门能开。变量像「贴了标签的盒子」装数据；作用域像「这个盒子只能在哪间屋里被找到」。

### 🟡 部分二·动手层（逐字操作）
在 `index.html` 的 `</body>` 前、悬浮按钮之后，加：
```html
<script src="app.js"></script>
```
新建 `app.js`，复制：
```js
// 1) 变量与类型
let price = 19;            // number
const name = "闪电卡";      // string（常量，不能再改）
let isHot = true;          // boolean
let plan = null;           // 空值

// 2) 条件
if (price < 30) {
  console.log(name + " 是低价套餐");
}

// 3) 循环 + 数组
const plans = [19, 39, 59];
for (let i = 0; i < plans.length; i++) {
  console.log("套餐" + (i + 1) + "：" + plans[i] + "元");
}

// 4) 给按钮加交互
const btn = document.querySelector(".back-top");
btn.addEventListener("click", () => {
  alert("已回到顶部！");
});
```
刷新页面，按 F12 看「Console」输出；点悬浮按钮会弹窗。

### 🔵 部分三·原理层（底层发生了什么）
JS 是「单线程 + 事件循环」语言（JS3/JS8 深入）。`let/const` 是块级作用域，`var` 是函数级（已不推荐）。代码经「解析→编译（V8 即时编译）→执行」。`document.querySelector` 是在 DOM 树里按选择器找节点（呼应 FE1 的 DOM 树）。`addEventListener` 把函数「挂」到事件上，事件发生时由浏览器回调——这就是「事件驱动」。

### 🟣 部分四·深挖层（为什么 & 延伸）
JS 的「类型怪癖」是顶级必懂：`typeof null === "object"` 是历史 bug；`0.1 + 0.2 !== 0.3` 是浮点精度（PY3 讲过二进制补码/浮点）；`==` 会做隐式转换（`"1" == 1` 为真），所以永远用 `===`。作用域链 + 闭包（JS4）是 JS 最强大也最易错的特性。顶级追问：`let` 的「暂时性死区（TDZ）」是什么？变量声明前访问会报错，这避免了 `var` 的变量提升混乱。

### 🔴 部分五·顶级视角
JS 是「全栈同一门语言」的关键：前端（浏览器）、后端（Node.js，JS7）、甚至桌面（Electron，MOB41）、移动（React Native，MOB33）都用它。理解 JS 类型系统，是通向 TypeScript（FE13/JS6）和后端 Node 的桥梁。顶级工程师把 JS 的「动态灵活」与「类型安全」平衡得极好。

### 🟠 部分六·安全/合规种子（白帽）
**JS 是 XSS 的主战场**。绝对不要写 `element.innerHTML = 用户输入`（会被注入脚本）。用 `textContent`。本文件 FE15 会系统讲同源/CSP/XSS 防御。现在先记住铁律：**用户给的任何字符串，都当成「数据」不是「代码」**。

### ✅ 验收
交 `app.js` + 更新后 `index.html`：Console 打印出 3 条套餐信息；点悬浮按钮弹窗。截图 Console 输出给我。

### ⚠️ 常见坑
- 把 `<script>` 写在了 `<head>` 里而 DOM 还没生成：取到 `null`。用 `src` 引入且放 `</body>` 前，或用 `DOMContentLoaded`。
- `let`/`const` 重复声明报错；`var` 能重复声明但不报错（埋雷）。
- 用 `==` 出怪结果：`"0" == false` 居然为真。一律 `===`。
- 中文引号/全角符号混进代码：JS 报错。复制粘贴时检查。

### ➡️ 下一步
**FE6 · DOM / 事件（冒泡捕获 / 委托）**——真正学会「点一下页面，程序该干什么」。

### 🧪 实战 Lab（FE5）
在 `app.js` 里加：点「下单」按钮时，读取输入框手机号，若长度≠11 则 `alert("手机号格式不对")`，否则 `alert("已为 " + 手机号 + " 创建订单")`。**验收点**：输入错误长度提示错误，正确长度提示成功。

---

## FE6 · DOM / 事件（冒泡捕获 / 委托）

### 🎯 目标
学完这节，你能动态改页面内容（不用刷新），理解事件怎么从子元素「冒泡」到父元素，并用「事件委托」高效处理一堆按钮。

### 📋 小白前置
- 方向1 编程基础（PY6 函数、PY11 对象）
- 本文件内：**FE1–FE5**

### 🟢 部分一·最浅层（生活比喻）
DOM 是**家谱树**：你是某个节点，你爸是父节点，你孩子是孩子节点。事件像「扔水球」：你在叶子节点（按钮）上扔，水球会一层层往上溅到祖先（冒泡）；也可以从根往下接（捕获）。**事件委托** = 不在每个按钮上装监听器，而在它们共同的「爹」身上装一个，谁被点了我看一眼水球是谁扔的就行。

### 🟡 部分二·动手层（逐字操作）
在 `index.html` 套餐 `<ul>` 里给每个 `<li>` 加 `data-price` 和「选这个」按钮（改造成）：
```html
<ul class="plan-list">
  <li class="plan-card" data-price="19">闪电卡 19 元：30G <button class="choose">选这个</button></li>
  <li class="plan-card" data-price="39">闪电卡 39 元：100G <button class="choose">选这个</button></li>
</ul>
```
在 `app.js` 里加（事件委托，只挂一次）：
```js
const list = document.querySelector(".plan-list");
list.addEventListener("click", (e) => {
  const btn = e.target.closest(".choose");   // 找到被点的按钮
  if (!btn) return;                          // 点空白处忽略
  const card = btn.closest(".plan-card");
  const price = card.dataset.price;          // 读 data-price
  document.querySelector("#buy h2").textContent = "已选：" + price + " 元套餐";
});
```
刷新：点不同套餐的按钮，购买区标题会跟着变。

### 🔵 部分三·原理层（底层发生了什么）
浏览器把事件封装成「事件对象」沿 DOM 树传播，分三阶段：**捕获（根→目标）→ 目标 → 冒泡（目标→根）**。`addEventListener` 第三个参数 `true` 监听捕获、`false`（默认）监听冒泡。`e.target` 是「真正被点的元素」，`e.currentTarget` 是「绑定监听的元素」（这里是 list）。`closest()` 向上找最近的匹配祖先——委托的核心。改动 `textContent` 会触发该节点的「重渲染」（小范围，不整页刷新）。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么用事件委托？① 动态新增的按钮（比如从后端拉来的套餐）自动生效，不用逐个绑定；② 省内存（一个监听代替 N 个）。顶级追问：事件委托的「坑」在哪？`e.target` 可能命中子元素文本节点或被嵌套标签干扰，`closest` 解决。还有 `stopPropagation()` 会阻断冒泡——滥用它会让委托失效，是调试噩梦。

### 🔴 部分五·顶级视角
DOM 事件模型是「前端状态与界面同步」的底层机制。React 的 SyntheticEvent（FE10）、Vue 的事件（FE9）都是对它的封装。顶级全栈理解：浏览器事件循环 + 事件委托 = 高性能交互的基石；在大型应用里，不当的事件绑定会导致内存泄漏（监听器没解绑）。

### 🟠 部分六·安全/合规种子（白帽）
事件可被「伪造」：`dispatchEvent` 能程序化触发点击——这是自动化攻击/爬虫手法，也是测试工具用法。白帽边界：只对自己页面做自动化测试；绝用脚本替他人点击、刷量、越权操作。另：处理用户输入进 DOM 仍坚持 `textContent`，防 XSS（FE15）。

### ✅ 验收
交更新两文件：点不同「选这个」按钮，购买区标题正确显示对应价格；Console 无报错。

### ⚠️ 常见坑
- 委托绑在错误祖先上：要保证被点元素确实是它的后代，否则收不到。
- 忘了 `if (!btn) return`：点卡片空白也会触发逻辑。
- `e.target` vs `e.currentTarget` 混淆：委托里取「被点元素」用 `target`，取「监听器所在」用 `currentTarget`。
- 重复绑定：每次渲染都 `addEventListener` 却不移除 → 内存泄漏、事件触发多次。

### ➡️ 下一步
**FE7 · 浏览器渲染原理（解析 / 布局 / 绘制 / 合成）**——知道「你写的代码怎么变成屏幕上的像素」。

### 🧪 实战 Lab（FE6）
把套餐列表改成「从 JS 数组动态生成」：在 `app.js` 里写一个 `renderPlans(arr)` 函数，用 `document.createElement` 创建 `<li>` 并 `appendChild` 到 `list`，点击委托逻辑保持不变。**验收点**：页面套餐由 JS 生成且点击仍生效（为后面接后端 API 打基础）。

---

## FE7 · 浏览器渲染原理（解析 / 布局 / 绘制 / 合成）

### 🎯 目标
学完这节，你能说清「从输入网址到看到页面」浏览器内部发生了哪几步，并理解为什么有些写法会让页面「卡」。

### 📋 小白前置
- 方向1 编程基础
- 方向4 网络（NET8 HTTP、NET9 HTTPS 概念）
- 本文件内：**FE1–FE6**

### 🟢 部分一·最浅层（生活比喻）
浏览器像一条**流水线工厂**：① 收货（下载 HTML/CSS/JS）→ ② 拼装图纸（建 DOM+CSSOM 树）→ ③ 排工位（布局算每个盒子位置）→ ④ 上漆（绘制像素）→ ⑤ 贴到玻璃（合成上屏）。任何一步卡住，整条线就慢。

### 🟡 部分二·动手层（逐字操作）
1. 打开页面，按 F12 → 「Performance（性能）」标签 → 点「录制」→ 刷新页面 → 停录。
2. 你会看到一段「火焰图」：Parse HTML、Recalculate Style、Layout、Paint、Composite 各占时间。
3. 在 `app.js` 末尾加一句故意触发重排的代码体验：
```js
// 仅用于观察：连续读/写布局属性会强制同步重排
const el = document.querySelector("h1");
for (let i = 0; i < 1000; i++) { el.style.fontSize = (20 + i % 5) + "px"; }
console.log("done");
```
4. 再录一次性能，对比「Layout」时间变长。体验完把这段删掉（不要留坑）。

### 🔵 部分三·原理层（底层发生了什么）
关键管线：**HTML 解析 → DOM**；**CSS 解析 → CSSOM**；合并成 **Render Tree**（只含可见节点）；**Layout/Reflow** 算几何位置；**Paint** 生成绘制指令（分图层）；**Composite** 把图层合成最终帧送 GPU。JS 会阻塞解析（除非 `async/defer`）。读 `offsetHeight` 等布局属性会强制浏览器「立刻重排」——这就是「强制同步布局（Forced Synchronous Layout）」，性能杀手。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么分「布局/绘制/合成」三步？因为 GPU 擅长合成（平移缩放快），不擅长改布局。于是工程上尽量把动画做成 `transform/opacity`（只触发合成，不重排不重绘）——FE17 动画的黄金法则。顶级追问：`will-change` 是什么？预先告诉浏览器「这个元素要动画」，让它提前提升为独立图层，但滥用会吃内存。

### 🔴 部分五·顶级视角
渲染原理是「前端性能优化（FE14）」的理论根。CORE WEB VITALS（LCP/CLS/INP）全建立在这条管线上。顶级全栈能把「卡顿」翻译成具体阶段：是 JS 执行长（INP）、布局抖（CLS）、还是资源大（LCP），逐个击破。后端（BE24 性能调优）与前端性能是同一枚硬币两面。

### 🟠 部分六·安全/合规种子（白帽）
渲染层有「点击劫持」风险（透明层盖真按钮，FE3 提过）。防御靠后端 CSP `frame-ancestors` 与前端 `X-Frame-Options`。另外，第三方脚本（统计、广告）会拖慢管线甚至窃取数据——白帽要求「最小第三方依赖 + Subresource Integrity（SRI，FE15）」校验脚本完整性。

### ✅ 验收
交一份「你录制的 Performance 火焰图截图」+ 一段文字说明：页面经历了哪 5 个阶段（解析/样式/布局/绘制/合成）。

### ⚠️ 常见坑
- JS 放 `<head>` 阻塞渲染：用 `defer`（顺序执行、不阻塞）或 `async`（异步乱序）。
- 大图不优化：LCP 爆表。
- 频繁改 `top/left/width` 触发重排：改成 `transform`。
- 漏删实验代码：上面那段循环要删掉，否则每次刷新都卡。

### ➡️ 下一步
**FE8 · 浏览器存储（cookie / localStorage / sessionStorage / indexedDB）**——让页面「记住」用户。

### 🧪 实战 Lab（FE7）
在 FE6 的「已选套餐」逻辑里，把选中的 `price` 存起来并在页面加载时读取：加载时若有保存值就直接显示。这用 `localStorage`（下节正式讲），先体验：`localStorage.setItem("chosen", price)` 和 `localStorage.getItem("chosen")`。**验收点**：刷新后之前选的套餐仍显示。

---

## FE8 · 浏览器存储（cookie / localStorage / sessionStorage / indexedDB）

### 🎯 目标
学完这节，你能用浏览器存储「记住」用户选择/登录态，并分清四种存储的用途与安全边界（尤其 cookie 和 XSS 的关系）。

### 📋 小白前置
- 方向1 编程基础（PY8 字典/键值对直觉）
- 本文件内：**FE1–FE7**

### 🟢 部分一·最浅层（生活比喻）
- **localStorage** = 你家墙上便利贴，关电脑还在，永久。
- **sessionStorage** = 临时便签，关掉这个标签页就没了。
- **cookie** = 随身门禁卡，每次进门（请求）自动出示给服务器。
- **IndexedDB** = 家里的大衣柜，能塞很多结构化东西。

### 🟡 部分二·动手层（逐字操作）
在 `app.js` 里把 FE7 的「记住选择」正式化：
```js
// 保存选择
localStorage.setItem("chosenPlan", price);

// 页面加载时恢复
window.addEventListener("DOMContentLoaded", () => {
  const saved = localStorage.getItem("chosenPlan");
  if (saved) {
    document.querySelector("#buy h2").textContent = "已选：" + saved + " 元套餐";
  }
});

// cookie 写法（后端登录后会用到）
document.cookie = "sid=abc123; path=/; max-age=3600; Secure; SameSite=Lax";
console.log("cookie:", document.cookie);
```
刷新并选套餐 → 关页再开 → 选择还在（localStorage）。Console 能看到 cookie 字符串。

### 🔵 部分三·原理层（底层发生了什么）
存储都在**浏览器进程**里，按「源（origin = 协议+域名+端口）」隔离（同源策略，FE15）。localStorage/sessionStorage 是同步的键值对（字符串），容量约 5MB；cookie 随每个 HTTP 请求自动带上（所以小，约 4KB），由 `Set-Cookie` 响应头写入；IndexedDB 是异步的事务型数据库，存结构化/大量数据。读取 localStorage 是同步阻塞主线程，别存太大。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么 cookie 不能存大东西？因为它**每次请求都自动发送**，大了浪费带宽且拖慢。为什么有 sessionStorage？因为「标签页级隔离」适合「单次会话草稿」。顶级追问：`localStorage` 的 XSS 灾难——一旦页面有 XSS，攻击者能读走里面所有东西（包括你存的 token）。所以**敏感信息绝不放 localStorage**，放 httpOnly cookie（JS 读不到）。

### 🔴 部分五·顶级视角
存储策略是「前后端状态分工」的核心：登录态 token 的设计（BE5 认证授权）直接决定存哪。顶级全栈会结合「过期时间、加密、httpOnly、SameSite」做一组安全决策。IndexedDB 还用于离线 PWA、缓存 API 响应（FE14 性能），是「前端也能当数据库」的入口。

### 🟠 部分六·安全/合规种子（白帽）
**重中之重**：① 设 cookie 一定要 `HttpOnly`（防 JS 读，抗 XSS 偷 token）+ `Secure`（仅 HTTPS）+ `SameSite=Lax`（防 CSRF，FE15/SEC16）；② localStorage 绝存密码/ token；③ 不读他人域的存储（同源隔离保证）；④ 别用存储做「隐藏」违规内容。白帽只护自己用户，不偷不看他人。

### ✅ 验收
交更新 `app.js`：选套餐后刷新页面，选择被记住；Console 打印出带属性的 cookie 字符串。

### ⚠️ 常见坑
- 忘了 `JSON.stringify`：存对象会变成 `[object Object]`。取时 `JSON.parse`。
- cookie 没设 `path=/`：只在当前路径可见。
- localStorage 跨「源」不共享：localhost 和 127.0.0.1 算不同源。
- 隐私模式 localStorage 可能抛异常（配额/禁用），生产要 try-catch。

### ➡️ 下一步
**FE9 · Vue（响应式 / 虚拟 DOM / 组件）**——用一个现代框架，让「数据和页面」自动同步。

### 🧪 实战 Lab（FE8）
用 localStorage 实现一个「购物车数量」：页面加一个「加入购物车」按钮，点击 `count++` 并 `localStorage.setItem("cart", count)`，刷新后数量恢复；再加「清空」按钮 `localStorage.removeItem("cart")`。**验收点**：购物车数量持久化、可清空。

---

## FE9 · Vue（响应式 / 虚拟 DOM / 组件）

### 🎯 目标
学完这节，你能用 Vue 3（CDN 版，免安装）把「数据」和「页面」绑起来：数据一变，页面自动更新；并把页面拆成可复用「组件」。

### 📋 小白前置
- 方向1 编程基础（PY11 对象、PY14 装饰器/高阶函数直觉）
- 本文件内：**FE1–FE8**

### 🟢 部分一·最浅层（生活比喻）
之前你手动 `textContent` 改页面，像**每次改数据都自己跑去找油漆刷新墙**。Vue 像装了「智能感应器」：你只改数据，感应器自动把墙刷好。组件像**乐高积木**：一个积木（组件）做好了，能到处用。

### 🟡 部分二·动手层（逐字操作）
新建 `vue.html`（单独练 Vue，不破坏之前文件）：
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>闪电号卡 · Vue 版</title>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
  <div id="app">
    <h1>{{ title }}</h1>
    <p>已选套餐：{{ chosen }} 元</p>
    <button @click="choose(19)">选19元</button>
    <button @click="choose(39)">选39元</button>
    <plan-card v-for="p in plans" :price="p" @pick="choose"></plan-card>
  </div>

  <script>
    const { createApp } = Vue;
    const PlanCard = {
      props: ['price'],
      template: `<button @click="$emit('pick', price)">选 {{ price }} 元</button>`
    };
    createApp({
      components: { PlanCard },
      data() { return { title: "闪电号卡", chosen: 0, plans: [19, 39, 59] }; },
      methods: {
        choose(p) { this.chosen = p; }
      }
    }).mount("#app");
  </script>
</body>
</html>
```
保存，双击用浏览器打开（需联网加载 Vue CDN）。点按钮，已选套餐数字自动变。

### 🔵 部分三·原理层（底层发生了什么）
`@click` 是 `v-on:click` 的语法糖；`{{ }}` 是插值。`createApp().mount()` 把 Vue「接管」`#app` 节点。Vue 用 **Proxy（响应式）** 包裹 `data`：你读数据时收集「谁在用」，你改数据时通知「依赖的视图」更新。视图更新走 **虚拟 DOM**：先在内存里算出新旧两棵虚拟树的差异（diff），只把「真变了的节点」应用到真实 DOM——避免整页重绘，性能高。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么需要虚拟 DOM？直接操作真实 DOM 慢且繁琐；虚拟 DOM 把「改什么」交给 diff 算法批量、最小化处理。顶级追问：Vue 的「响应式」和「响应式编程（RxJS/PAR5）」不是一回事——Vue 是「数据→视图」自动同步；响应式编程是「数据流」范式。还有 `ref` vs `reactive`、`setup` 语法糖、`Teleport`、`Suspense` 等进阶，决定大型项目组织方式。

### 🔴 部分五·顶级视角
Vue/React 是「声明式 UI」代表：你描述「界面应该是什么样（基于状态）」，框架负责「怎么变成 DOM」。这思想通用于 SwiftUI（MOB24）、Flutter（MOB34）、Jetpack Compose。顶级全栈看框架之争（Vue vs React，FE10）本质是在选「团队心智模型」，而非技术高低。组件化 = 微前端（FE18）、设计系统的地基。

### 🟠 部分六·安全/合规种子（白帽）
Vue 的 `{{ }}` 默认**不执行 HTML**，比手写 `innerHTML` 安全。但 `v-html` 指令会渲染 HTML 字符串——**永远别把用户输入喂给 `v-html`**，那是 XSS 入口。白帽：用插值 `{{ }}` 而非 `v-html`；必须用富文本时先做净化（DOMPurify）。

### ✅ 验收
交 `vue.html`：页面显示标题、已选套餐数字、3 个套餐按钮（含组件渲染的）；点不同按钮数字正确变化。截图给我。

### ⚠️ 常见坑
- CDN 没联网：Vue 报错 `Vue is not defined`。换网络或下载本地引入。
- `v-for` 忘了 `:key`：列表更新错乱（虽小例不明显，工程必加）。
- 在 `data` 之外直接给对象加新属性：Vue 3 Proxy 能追踪，但 Vue 2 旧版不行（了解差异）。
- 把 `@click="choose(19)"` 写成 `@click="choose"`，导致事件是对象不是 19。

### ➡️ 下一步
**FE10 · React（hooks / 协调 / 并发）**——看另一个主流框架怎么干同一件事。

### 🧪 实战 Lab（FE9）
把 Vue 版套餐列表改成「从 `data` 里的 `plans` 数组渲染」，并加一个输入框 `v-model="title"` 实时改标题（双向绑定体验）。**验收点**：标题随输入实时变，套餐由数组驱动。

---

## FE10 · React（hooks / 协调 / 并发）

### 🎯 目标
学完这节，你能用 React 18（CDN + Babel 版，免安装）写出一个组件，理解 `useState` / `useEffect` 这些 hooks 怎么让「状态」和「界面」同步，并和 Vue 做对照。

### 📋 小白前置
- 方向1 编程基础（PY6 函数、PY13 生成器/闭包直觉）
- 本文件内：**FE1–FE9**（建议先懂 Vue 再对比 React）

### 🟢 部分一·最浅层（生活比喻）
React 像**用函数画画**：你写一个函数，输入是「当前数据（state）」，输出是「对应的界面长相」。数据变了，React 重新调用函数画出新界面。hooks 像「在函数里挂的几个小钩子」：`useState` 是「记住一个数值的便签」，`useEffect` 是「画完之后顺便做点事（比如存本地）」。

### 🟡 部分二·动手层（逐字操作）
新建 `react.html`：
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>闪电号卡 · React 版</title>
  <script src="https://unpkg.com/react@18/umd/react.development.js"></script>
  <script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
  <script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
</head>
<body>
  <div id="root"></div>
  <script type="text/babel">
    function App() {
      const [chosen, setChosen] = React.useState(0);
      const plans = [19, 39, 59];
      return (
        <div>
          <h1>闪电号卡</h1>
          <p>已选套餐：{chosen} 元</p>
          {plans.map(p => (
            <button key={p} onClick={() => setChosen(p)}>选 {p} 元</button>
          ))}
        </div>
      );
    }
    ReactDOM.createRoot(document.getElementById("root")).render(<App />);
  </script>
</body>
</html>
```
保存打开（需联网）。点按钮，已选数字变。

### 🔵 部分三·原理层（底层发生了什么）
`useState` 返回 `[值, 设值函数]`；调用 `setChosen` 会**触发组件重新渲染**（React 再跑一遍函数）。React 用 **Fiber 协调（Reconciliation）** 算法对比新旧「虚拟 DOM」树，算出最小更新。Babel 把 JSX（`<>...</>` 像 HTML 的语法）编译成 `React.createElement(...)` 调用。注意：`onClick={() => setChosen(p)}` 用了闭包把 `p` 包进去。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么 React 用「函数 + hooks」而非「类」？因为函数更贴合「UI = f(state)」的纯函数心智，hooks 解决了「类组件逻辑复用难（HOC/渲染劫持混乱）」的问题。`useEffect` 的「依赖数组」是新手重灾区：依赖写错会导致「不更新」或「死循环」。顶级追问：React 18 的 **并发特性（Concurrent）** 让渲染可中断、可优先级调度（`<Suspense>`、transition），这是和 Vue 的重要差异。

### 🔴 部分五·顶级视角
React 生态（Next.js、Remix）统治了大量生产站点；它和 Vue 之争本质是「显式（React 手动管理多）vs 约定（Vue 自动多）」。顶级全栈通常两者都会，按团队选。React 的「组件 = 函数」思想深刻影响了后端（Server Components、RSC 把组件渲染搬到服务端，呼应 BE4 SSR）。

### 🟠 部分六·安全/合规种子（白帽）
React 默认对插值 `{变量}` 做 HTML 转义，**防 XSS** 比手写 `dangerouslySetInnerHTML` 安全一万倍。铁律：绝用 `dangerouslySetInnerHTML` 渲染用户输入；富文本走净化。白帽还注意：React 的 `key` 若用数组下标当唯一 id，在列表增删时会导致状态错乱（功能 bug，也可能被利用做 UI 欺骗）。

### ✅ 验收
交 `react.html`：点不同按钮，已选数字正确变化；页面由 `plans.map` 渲染出 3 个按钮。

### ⚠️ 常见坑
- 漏 `<script type="text/babel">`：JSX 不被编译，直接报语法错。
- `useState` 解构成 `[a,b]` 顺序写反：`[setX, x]` 会调用错。
- 在渲染里直接 `setChosen`（无事件）：造成无限重渲染。
- `key` 用 index 且列表会变动：状态错位。

### ➡️ 下一步
**FE11 · 状态管理（Redux / Pinia / 信号）**——当组件多了，怎么统一管理「全局数据」。

### 🧪 实战 Lab（FE10）
给 React 版加「购物车数量」：`useState` 一个 `cart`，点套餐时 `setCart(cart+1)`，页面显示「购物车：N 件」。**验收点**：多次点击数量累加，刷新归零（持久化留到 FE11/状态管理讨论）。

---

## FE11 · 状态管理（Redux / Pinia / 信号）

### 🎯 目标
学完这节，你能解释「为什么组件一多就需要集中式状态」，并用 Vue 的 Pinia（或 React 的 Context+useReducer）做一个「闪电号卡购物车」全局状态。

### 📋 小白前置
- 方向1 编程基础（PY8 字典、PY11 对象）
- 本文件内：**FE9 或 FE10**（先懂一个框架）

### 🟢 部分一·最浅层（生活比喻）
小房子（几个组件）里，谁要用数据就自己拿。但大楼（几十个组件）里，如果每个房间都自己藏一份「购物车」，就会**对不上账**。状态管理就是建一个**中央账本**：所有人改账都走账本，账本一变，相关房间自动同步。

### 🟡 部分二·动手层（逐字操作）
用 Vue + Pinia（CDN 版）新建 `state.html`：
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
  <script src="https://unpkg.com/pinia@2/dist/pinia.iife.js"></script>
</head>
<body>
  <div id="app">
    <h1>闪电号卡</h1>
    <p>购物车：{{ store.cartCount }} 件，合计 {{ store.total }} 元</p>
    <button @click="store.add(19)">加19元卡</button>
    <button @click="store.add(39)">加39元卡</button>
    <button @click="store.clear()">清空</button>
  </div>
  <script>
    const { createApp } = Vue;
    const { createPinia, defineStore } = Pinia;
    const useStore = defineStore("cart", {
      state: () => ({ items: [] }),
      getters: {
        cartCount: (s) => s.items.length,
        total: (s) => s.items.reduce((a, b) => a + b, 0)
      },
      actions: {
        add(price) { this.items.push(price); },
        clear() { this.items = []; }
      }
    });
    createApp({}).use(createPinia()).mount("#app");
    // 让模板能访问 store：
    const app = createApp({
      computed: { store() { return useStore(); } }
    });
    app.use(createPinia()).mount("#app");
  </script>
</body>
</html>
```
（注：上面为简化演示，真实项目用单文件组件；此处重点是理解 store 模式。）打开后点按钮，购物车与合计实时更新。

### 🔵 部分三·原理层（底层发生了什么）
集中式 store 本质是一个**被框架响应式包裹的全局对象**。组件「订阅」store 的某部分；当 action 修改 state，响应式系统通知所有订阅者重渲染。`getter` 是「派生状态」（像 Excel 公式，依赖变自动重算）。这解决了「props 层层钻传（prop drilling）」的痛苦——深层组件不用父传父，直接读 store。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么不用一个全局普通对象？因为**没有「变更可追溯」**。Redux 用「单向数据流 + 纯 reducer + action 日志」让每次状态变化都可回放（时间旅行调试）。Pinia 更轻量（Vue 响应式）。顶级追问：状态管理的「服务端同源」——Next.js/RSC（FE10 提过）把部分状态放服务端，减少客户端 store 体积；还有「信号（Signals，SolidJS/Angular）」用细粒度依赖追踪挑战 Redux「整树通知」。

### 🔴 部分五·顶级视角
状态管理是「前端架构」的分水岭。顶级全栈懂得按规模选型：小组件局部 `useState`；中型用 Context/Provide；大型用 Redux/Zustand/Pinia。更关键的是**状态边界**：哪些该放客户端（UI 状态）、哪些该放 URL（可分享/可刷新）、哪些该放后端（权威数据，BE9 REST）。这直接关联 BE5 认证状态、BE9 API 设计。

### 🟠 部分六·安全/合规种子（白帽）
集中状态里**绝不能放密钥/密码**。前端状态天生「用户可见」（F12 一看就有）。白帽：敏感判定（是否 VIP、余额）必须以后端返回为准，前端状态只做展示，不能当「权限依据」（越权漏洞，SEC11）。另：状态持久化到 localStorage 时，别存可反推个人的敏感聚合。

### ✅ 验收
交 `state.html`：购物车件数、合计金额随点击实时变化，可清空。

### ⚠️ 常见坑
- 多 `createApp`/`createPinia` 实例导致 store 不共享：一个应用只 `use(createPinia())` 一次。
- 直接改 `state` 而非走 action：Pinia 允许但破坏可追踪性；Redux 直接改会失效。
- getter 里改 state：getter 应纯计算，副作用放 action。
- 把大量服务端数据塞前端 store 当缓存：用 BE13 缓存/请求库更合适。

### ➡️ 下一步
**FE12 · 构建工具（Webpack / Vite / Tree-shaking）**——学会把「多个源文件」打包成浏览器能跑的产物。

### 🧪 实战 Lab（FE11）
在 store 里加一个 `isVip` 布尔和 `totalAfterDiscount` getter（VIP 打 9 折）。页面显示折后价。**验收点**：切换 isVip 时折后价变化（理解派生状态 = getter）。

---

## FE12 · 构建工具（Webpack / Vite / Tree-shaking）

### 🎯 目标
学完这节，你能理解「为什么现代前端要构建步骤」，用 Vite 初始化一个项目，跑起 `npm run dev`，并知道 Tree-shaking 是什么。

### 📋 小白前置
- 方向1 编程基础（PY20 venv/pip 包管理直觉）
- 预备层：PRE6 终端/命令行
- 本文件内：**FE9–FE11**（有框架基础更好懂）

### 🟢 部分一·最浅层（生活比喻）
你写了很多「零件文件」（组件、样式、图片），浏览器不认识「零件仓库」的规矩。构建工具像**工厂打包线**：把零件合并、压缩、翻译（比如把 TS 翻成 JS、把新语法翻成老浏览器能懂的），最后产出一份「商场能直接卖的成品包」。

### 🟡 部分二·动手层（逐字操作）
1. 打开 VS Code 终端（菜单「终端 → 新建终端」）。
2. 确认有 Node（已装 Python 但前端需 Node）：在终端输入 `node -v`，若显示版本继续；没有则先装 Node（官网 next 安装，下一步确认）。
3. 用 Vite 快速建项目（复制粘贴，少打字）：
```bash
npm create vite@latest shandian-fe -- --template vanilla
cd shandian-fe
npm install
npm run dev
```
4. 终端会显示一个 `http://localhost:5173` 地址，Ctrl+点击在浏览器打开，看到 Vite 欢迎页即成功。

### 🔵 部分三·原理层（底层发生了什么）
`npm install` 按 `package.json` 下载依赖到 `node_modules`（类比 Python 的 venv+pip，PY20）。`npm run dev` 启动 **Vite 开发服务器**：它用「原生 ES 模块 + 按需编译」，改文件即时热更新（HMR），不用整包重建，所以快。生产构建 `npm run build` 走 Rollup：做**Tree-shaking**（摇树——把没被引用的代码像枯叶摇掉）、压缩、代码分割，产出 `dist/` 静态文件（可丢给 BE23 部署的 Nginx）。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么需要构建？因为：① 浏览器不直接支持「从 node_modules 引模块」「TS」「最新语法」；② 要压缩体积提速；③ 要处理图片/字体等资源。Webpack 是老牌「全家桶」，Vite 用「ESM 原生 + esbuild 预编译」解决 Webpack 冷启动慢。顶级追问：Tree-shaking 依赖 **ESM 的静态 `import/export`**（编译期可知谁被用），所以 `import * as _ from 'lodash'` 摇不掉，要用 `import debounce from 'lodash/debounce'`。

### 🔴 部分五·顶级视角
构建工具是「前端工程化」的引擎，连接着 CI/CD（OPS30）、Docker 部署（BE23/OPS19）、性能预算（FE14）。顶级全栈懂「为什么构建产物体积影响 LCP」，会把构建配置当性能杠杆。Rust 系新工具（esbuild、SWC、Turbopack）正把构建速度推向极致——跨语言（方向1b Rust RS1）思维在此交汇。

### 🟠 部分六·安全/合规种子（白帽）
构建链路是**供应链攻击面**：恶意 npm 包（如 `event-stream` 事件）能偷密钥。白帽：① 锁版本（`package-lock.json` 提交）；② 用 `npm audit` 查漏洞；③ 不装来路不明包；④ CI 里跑 SCA 扫描（OPS46 Trivy/Snyk）。绝不在构建脚本里写「回传用户数据到未知服务器」的代码。

### ✅ 验收
交：终端 `npm run dev` 成功截图 + 浏览器打开 localhost 页面的截图。

### ⚠️ 常见坑
- 没装 Node 就跑 `npm`：报「不是内部命令」。先装 Node LTS。
- `npm install` 很慢/卡：可换国内镜像 `npm config set registry https://registry.npmmirror.com`（仅配置，不改变学习内容）。
- 端口被占：Vite 会自动换端口，看终端提示的地址。
- 改完不刷新：确认 HMR 生效；有时需手动 F5。

### ➡️ 下一步
**FE13 · TS 在前端（类型安全）**——给 JS 加「类型保险」，少出 bug。

### 🧪 实战 Lab（FE12）
在 Vite 项目里的 `main.js` 改成 `main.ts`，写一段带类型的代码：`function add(a: number, b: number): number { return a + b; }`，故意传字符串看 Vite 报错（类型检查体验）。**验收点**：传错类型时编辑器/构建提示类型错误。

---

## FE13 · TS 在前端（类型安全）

### 🎯 目标
学完这节，你能用 TypeScript 给变量、函数、对象加类型标注，理解「编译期报错」如何帮你提前抓 bug，并对接 JS6/类型思维。

### 📋 小白前置
- 方向1 编程基础（PY18 typing 类型标注、PY11 对象）
- 本文件内：**FE5（JS 基础）、FE12（构建工具，TS 需要构建）**

### 🟢 部分一·最浅层（生活比喻）
JS 像**不检查身份证的门口**：谁都能进，进错了事到半路才炸。TS 像**门口查身份证**：你声明「这个变量必须是数字」，若有人塞字符串，门卫（编译器）当场拦下，不让你进场惹祸。

### 🟡 部分二·动手层（逐字操作）
在 Vite 项目里新建 `types.ts`：
```ts
// 定义「套餐」数据类型
interface Plan {
  id: number;
  name: string;
  price: number;
  hot?: boolean;          // 可选
}

function formatPlan(p: Plan): string {
  return `${p.name}：${p.price} 元`;
}

const plan: Plan = { id: 1, name: "闪电卡19", price: 19 };
console.log(formatPlan(plan));

// 故意写错，看 TS 报红：
// const bad: Plan = { id: 2, name: "x" };   // 缺 price → 报错
```
在 `main.ts` 里 `import "./types";`。Vite/编辑器会标红类型错误。运行 `npm run build` 时 TS 也会拦下错误（若配置严格）。

### 🔵 部分三·原理层（底层发生了什么）
TS 是 JS 的**超集 + 类型层**。它不在运行时存在——`tsc`（TS 编译器）把 `.ts` 编译成 `.js`（剥离类型），所以浏览器只跑纯 JS。类型检查在**编译期**做：编译器遍历 AST（CMP4）比对类型是否相容。Vite 用 esbuild 快速转译（不严格检查类型，速度优先），严格检查交给 `tsc --noEmit` 或 IDE。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么大项目爱 TS？因为「类型即文档 + 类型即测试」：改一个接口，所有用错的地方编译期全红，重构不再心惊。泛型（`<T>`，JS6/PY13 泛型思维）、联合类型、字面量类型、条件类型让类型系统图灵完备。顶级追问：`any` 是「逃生舱」也是「腐蚀剂」——滥用 `any` 等于退回 JS；顶级团队用 `unknown` + 类型收窄替代 `any`。

### 🔴 部分五·顶级视角
TS 类型和「后端类型」（Python typing、Go 类型、Java 泛型）是同一套思维（PAR4 泛型/元编程）。顶级全栈在前后端共用「同一份类型定义」（比如用 OpenAPI/GraphQL 生成前后端类型，BE9/BE10），消除「接口对不齐」的协作损耗。类型系统能力上限决定了大型系统的可维护性上限。

### 🟠 部分六·安全/合规种子（白帽）
类型不是安全边界！TS 类型在运行时消失，攻击者不看你的 TS。**权限/校验必须后端做**（BE5/BE9）。白帽陷阱：有人误以为「TS 说这是 number 就安全」，结果把未校验的用户输入当 number 用 → 后端注入/越权。类型只防「自己人写错」，不防「外人使坏」。

### ✅ 验收
交：一个 `.ts` 文件含 `interface Plan` + 使用；故意缺字段时编辑器/构建报类型错误截图。

### ⚠️ 常见坑
- 以为 TS 运行时校验：它只编译期检查，运行时仍是 JS。
- `tsconfig` 里 `strict: false`：放过了大量隐患，生产应 `strict: true`。
- 把 `null` 当「有值」用：开启 `strictNullChecks` 后必须显式处理空。
- Vite 不报类型错只报语法错：需 `tsc --noEmit` 才严格。

### ➡️ 下一步
**FE14 · 性能优化（首屏 / 懒加载 / 缓存 / CORE WEB VITALS）**——让页面飞快。

### 🧪 实战 Lab（FE13）
给 `Plan` 加一个 `discountedPrice(): number` 方法（VIP 9 折），用 TS 严格模式（不写 any）实现，并写一处「故意传错类型」被拦下的例子。**验收点**：类型错误在编译期被捕获。

---

## FE14 · 性能优化（首屏 / 懒加载 / 缓存 / CORE WEB VITALS）

### 🎯 目标
学完这节，你能说清 CORE WEB VITALS 三个指标（LCP/CLS/INP），并用至少 3 种手段（代码分割、懒加载、缓存头）给「闪电号卡」提速。

### 📋 小白前置
- 方向1 编程基础
- 方向4 网络（NET8 HTTP/2、NET20 CDN）
- 本文件内：**FE7（渲染原理）、FE12（构建工具）**

### 🟢 部分一·最浅层（生活比喻）
性能优化像**让外卖更快到**：① 别让顾客等开门（首屏快= LCP）；② 别让页面突然「跳一下」把顾客晃倒（布局稳定= CLS）；③ 点单后别卡半天不理（响应快= INP）。慢一步，顾客就走了。

### 🟡 部分二·动手层（逐字操作）
在 Vite 项目体验「懒加载路由」（用动态 `import`）：
```ts
// 原本一次性引入
// import Heavy from './heavy';
// 改成按需：
button.onclick = async () => {
  const mod = await import("./heavy");  // 只有点击才下载这坨代码
  mod.run();
};
```
并在 `index.html` 的 `<head>` 给大图加：
```html
<link rel="preload" as="image" href="hero.png">
```
用 F12 → Lighthouse 跑一次性能评分（需 Chrome），看 LCP/CLS/INP 三项分数。

### 🔵 部分三·原理层（底层发生了什么）
每项指标对应 FE7 的管线阶段：**LCP（最大内容绘制）** 受「资源大小 + 关键渲染路径阻塞」影响——JS/CSS 阻塞解析，大图晚到；**CLS（累积布局偏移）** 来自「无尺寸的元素突然插入把页面挤动」（图没设宽高、字体闪一下）；**INP（交互到下一次绘制）** 受「主线程长任务」影响（FE7 的强制同步布局、大循环）。优化 = 缩短关键路径、减少主线程阻塞、用缓存避免重复下载。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么「代码分割」有效？因为用户首屏只用 20% 代码，却常被逼下载 100%。`import()` 动态切分出「按需块」。顶级追问：HTTP 缓存策略——`Cache-Control: max-age` + `ETag`/`Last-Modified` 协商缓存（NET8 呼应），配合「内容哈希文件名」（Vite 默认 `main.a1b2c3.js`）实现「永久缓存 + 更新即换名」。还有 `prefetch`/`preload` 的资源优先级博弈。

### 🔴 部分五·顶级视角
前端性能是「用户体验 → 业务指标（转化/留存）」的直接杠杆，也是 SRE（OPS37 SLI/SLO）的前端侧。顶级全栈把性能当「预算」管理（性能预算卡 CI，超了不让合并），并和后端（BE24 调优、BE13 缓存、CDN NET20）协同。CORE WEB VITALS 已是 Google 搜索排名因素——SEO 与性能同源。

### 🟠 部分六·安全/合规种子（白帽）
性能优化别牺牲安全：① 为提速关掉 CSP / 不校验 SRI 是错误取舍——安全优先；② 第三方脚本（统计/广告）常被懒加载掩盖成「必要」，白帽要求最小依赖 + SRI（FE15）；③ 不为省流量而「偷工减料」隐藏合规声明。提速与合规两手都要硬。

### ✅ 验收
交：Lighthouse 性能报告截图（显示 LCP/CLS/INP）+ 文字说明你用了哪 3 种优化手段。

### ⚠️ 常见坑
- 给图片没设 `width/height`：CLS 飙升。
- 一次 `import` 全部页面：首屏包巨大，LCP 差。
- 缓存设 `max-age` 太长又不哈希文件名：更新用户看不到。
- `preload` 太多：抢了真正关键的资源带宽。

### ➡️ 下一步
**FE15 · Web 安全基础（同源 / CSP / SRI）**——前端安全的「三道闸」。

### 🧪 实战 Lab（FE14）
给 Vite 构建配置加「手动分包」：把某个大依赖（如示例 `heavy.ts`）单独切出；再用 Lighthouse 对比分包前后首屏 JS 体积。**验收点**：首屏 JS 体积下降、LCP 改善。

---

## FE15 · Web 安全基础（同源 / CSP / SRI）

### 🎯 目标
学完这节，你能解释「同源策略」是什么、为什么重要，并会给页面加 CSP（内容安全策略）和 SRI（子资源完整性）两道防线，理解 XSS/CSRF 的前端侧防御。

### 📋 小白前置
- 方向1 编程基础
- 方向4 网络（NET8/9 HTTP/HTTPS、NET12 同源相关）
- 本文件内：**FE5（JS）、FE8（cookie）、FE14**

### 🟢 部分一·最浅层（生活比喻）
**同源策略**像小区门禁：A 栋的人不能随便进 B 栋拿东西（不能读 B 站的数据）。**CSP** 像「白名单告示」：本店只接受来自这几家供应商的货，别的来源的货一律拒收（挡掉恶意脚本）。**SRI** 像「验货封条」：货到了核对封条编号，被调包立刻发现。

### 🟡 部分二·动手层（逐字操作）
在 `index.html`（最早的那个）的 `<head>` 加 CSP meta（复制）：
```html
<meta http-equiv="Content-Security-Policy"
      content="default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:;">
```
含义：默认只允许同源资源；脚本只同源；样式同源+允许内联；图片同源+data。加了之后，FE9 用的「外链 CDN Vue」会被**拦截**（因为它来自 unpkg.com 非同源）——这正是 CSP 在生效。
再体验 SRI：给 CDN 脚本加完整性校验：
```html
<script src="https://unpkg.com/vue@3/dist/vue.global.js"
        integrity="sha384-填你算出的哈希"
        crossorigin="anonymous"></script>
```
（哈希用 `sha384-` 前缀，可用在线工具或 `openssl` 生成；此处重在理解机制。）

### 🔵 部分三·原理层（底层发生了什么）
**同源 = 协议 + 域名 + 端口** 三者全同。浏览器据此隔离：A 页面的 JS 不能读 B 页面的 DOM、Cookie、Fetch 响应（除非 CORS 放行，NET12）。**CSP** 是响应头/`meta` 里的策略，浏览器据此决定「哪些来源的资源可执行/可连接」，从根源挡 XSS 注入的脚本执行。**SRI** 用子资源内容的哈希，加载时比对，不符则拒绝执行——防 CDN 被黑/被投毒。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么同源这么重要？因为浏览器把「用户凭证（cookie）」按源隔离，没有它，任意网页都能拿你的登录态去打你的银行。顶级追问：同源过严导致「正当跨域」难做，于是有 CORS（服务端声明放行，SEC16）、postMessage（窗口间安全通信）、`rel="noopener"`（防 `window.opener` 劫持）。还有 `Trusted Types` 防 DOM XSS、`COOP/COEP` 跨源隔离——纵深防御层层加码。

### 🔴 部分五·顶级视角
前端安全是「纵深防御」第一道闸，但**真防线在后端**（SEC9 OWASP、SEC10 注入、SEC16 CORS/CSRF）。顶级全栈把安全当「默认拒绝」：CSP 用 `report-only` 先观测再收紧；SRI 配 CDN；配合后端 HttpOnly cookie（FE8）、CSRF token（BE5）、输入校验（BE9）。安全是「全栈共同责任」，前端挡君子，后端挡小人。

### 🟠 部分六·安全/合规种子（白帽）——本节核心
- **XSS**：绝不 `innerHTML/v-html/dangerouslySetInnerHTML` 用户数据；输出编码；CSP 兜底。
- **CSRF**：用 `SameSite=Lax` cookie + 后端 token（BE5）。
- **点击劫持**：后端 `X-Frame-Options: DENY` 或 CSP `frame-ancestors 'none'`。
- 红线：以上技术**只用于保护和测试自己的站点**；绝不写脚本绕过他人 CSP、伪造请求、做点击劫持攻击他人。白帽 = 授权内自查 + 上报漏洞拿赏金（SEC100）。

### ✅ 验收
交：一个加了 CSP `meta` 的 `index.html`，并文字说明「这条 CSP 拦住了什么（举例：外链脚本）」+ 解释 SRI 哈希作用。

### ⚠️ 常见坑
- CSP 写 `'unsafe-inline'` 又想防 XSS：内联脚本被放行，CSP 形同虚设。改用 nonce/hash。
- 把 `script-src 'self'` 配了却用 CDN：功能全挂，需显式加域名。
- `integrity` 哈希算错：脚本直接不执行，排查半天。
- 把 CSP 当「唯一防线」：XSS 还得靠后端转义。

### ➡️ 下一步
**FE16 · 可访问性 a11y（ARIA / 键盘导航）**——让所有人（含残障）都能用。

### 🧪 实战 Lab（FE15）
给 FE1 的表单加 `aria-label` 和 `required`，并给按钮加 `:focus-visible` 焦点样式；在 CSP 里保留 `style-src 'self' 'unsafe-inline'` 以便本地样式。**验收点**：Tab 键能聚焦表单元素，焦点有可见轮廓。

---

## FE16 · 可访问性 a11y（ARIA / 键盘导航）

### 🎯 目标
学完这节，你能让「闪电号卡」页面可被键盘操作、被读屏软件读懂，理解 a11y 既是道德也是法律合规（ADA/EN 301 549）。

### 📋 小白前置
- 方向1 编程基础
- 本文件内：**FE1（语义化）、FE6（事件）、FE15（安全）**

### 🟢 部分一·最浅层（生活比喻）
可访问性像**给大楼加坡道和盲道**：大多数人走楼梯（鼠标），但有人坐轮椅（键盘/开关控制）、有人看不见（读屏软件）。坡道不占多少成本，却决定一群人「能不能进门」。

### 🟡 部分二·动手层（逐字操作）
在 `index.html` 表单改进（复制替换原表单段）：
```html
<form>
  <label for="phone">手机号：</label>
  <input id="phone" name="phone" type="tel"
         required aria-required="true"
         aria-describedby="phone-help">
  <span id="phone-help">用于接收发货通知</span>
  <button type="submit">下单</button>
</form>
```
在 `style.css` 加键盘焦点可见（护手：复制）：
```css
:focus-visible { outline: 3px solid #0b5; outline-offset: 2px; }
```
按 Tab 键在浏览器里走一遍：焦点应能在输入框/按钮间移动，且有明显绿框。

### 🔵 部分三·原理层（底层发生了什么）
读屏软件（如 NVDA、VoiceOver）读取**无障碍树（Accessibility Tree）**——它是 DOM 的「语义子集」，由元素角色（role）、状态（state）、属性（property）组成。语义化标签（FE1）自动提供正确角色；对非语义元素用 `role`/`aria-*` 补全。键盘导航依赖「焦点顺序 = DOM 顺序」，所以**结构清晰 = 可访问**。`aria-describedby` 把「帮助文本」关联给输入框。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么 a11y 常被忽视却极重要？① 法律合规（美 ADA、欧 EN 301 549、中无障碍环境建设法），违规可被告；② 商业：残障用户 + 临时的「手不便」（如你术后留置针）都是真实用户；③ SEO 收益（语义=SEO）。顶级追问：**WCAG 2.2 四原则 POI-R**（可感知/可操作/可理解/稳健），是评估国际标准；`prefers-reduced-motion`（FE17 动画）让用户「关动画」也是 a11y。

### 🔴 部分五·顶级视角
a11y 是「包容性设计（PD3 心智模型）」的硬指标，也是顶级工程师的素养分水岭——能写出「人人可用」的系统。它与自动化测试（BE22）、设计系统（PD6 Token）结合：组件库默认带 a11y 属性。顶级全栈把 a11y 当「质量门禁」而非「补丁」。

### 🟠 部分六·安全/合规种子（白帽）
a11y 与安全的汇合点：**不要为「绕过」做 a11y 伪装**（比如用读屏专用文本隐藏违规内容）。白帽合规：a11y 是用来「帮人」不是「骗审查」。另：ARIA 用错（如错误 `role`）反而破坏读屏——「无 ARIA 胜错 ARIA」。我们只在自己项目练，提升真实可用性。

### ✅ 验收
交更新两文件：Tab 键可遍历表单且焦点可见；表单含 `label/aria-*`；文字说明「无障碍树」是什么。

### ⚠️ 常见坑
- 用 `<div onclick>` 当按钮：键盘无法触发，且无按钮角色。用 `<button>`。
- `aria-hidden="true"` 套住了还能聚焦的元素：读屏跳过但键盘能进，混乱。
- 图片没 `alt`：读屏念出文件名。装饰图用 `alt=""`。
- 焦点顺序靠 CSS 改视觉位置而非 DOM：Tab 顺序错乱。

### ➡️ 下一步
**FE17 · 动画与交互（requestAnimationFrame）**——让界面「活」起来且流畅。

### 🧪 实战 Lab（FE16）
给页面加「跳转链接」`<a href="#buy" class="skip-link">跳到购买</a>`，CSS 里默认隐藏、`:focus` 时显示（屏幕阅读器/键盘用户专用跳过导航）。**验收点**：Tab 第一下出现「跳到购买」链接。

---

## FE17 · 动画与交互（requestAnimationFrame）

### 🎯 目标
学完这节，你能用 CSS 过渡/动画和 JS 的 `requestAnimationFrame` 做出流畅动画，并知道「为什么动画要只用 transform/opacity」才不卡。

### 📋 小白前置
- 方向1 编程基础（PY5 循环）
- 本文件内：**FE3（布局）、FE7（渲染原理）、FE16（a11y）**

### 🟢 部分一·最浅层（生活比喻）
动画就像**翻页书**：快速连续翻很多张略有变化的画，眼睛就以为是「动」。浏览器每秒翻约 60 张（60fps），每张间隔约 16ms。如果某张画「磨蹭」超过 16ms，你就看到「卡顿」。

### 🟡 部分二·动手层（逐字操作）
在 `style.css` 给卡片加悬停过渡（复制）：
```css
.plan-card { transition: transform .2s ease, box-shadow .2s ease; }
.plan-card:hover { transform: translateY(-4px); box-shadow: 0 6px 16px rgba(0,0,0,.15); }
```
JS 动画（数字滚动）放 `app.js`：
```js
function animateNumber(el, to) {
  let start = null;
  function step(ts) {
    if (!start) start = ts;
    const p = Math.min((ts - start) / 800, 1);   // 0→1 用 800ms
    el.textContent = Math.round(p * to);
    if (p < 1) requestAnimationFrame(step);
  }
  requestAnimationFrame(step);
}
// 用法：animateNumber(document.querySelector("#count"), 100);
```
刷新看卡片浮动 + 数字滚动。

### 🔵 部分三·原理层（底层发生了什么）
CSS `transition/animation` 由浏览器合成器线程处理，**只触发 Composite（FE7）**，不重排不重绘，所以丝滑。`requestAnimationFrame(step)` 告诉浏览器「下次重绘前调用我」，把动画对齐到刷新节奏，避免「掉帧」。反之改 `top/left/width` 会触发 Layout+Paint，每帧都重算几何——卡。这就是为什么「动画只用 transform/opacity」。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么 60fps？源于早期 CRT 刷新率，今成行业默契；高刷屏 120fps 更顺。顶级追问：`will-change: transform` 提前提升图层（FE7 提过），但滥用占 GPU 内存；还有「FLIP 技术」（先测终态再反放，让布局动画也走 transform）。另：`prefers-reduced-motion`（FE16）让前庭敏感用户关动画——a11y 与动画的硬接口。

### 🔴 部分五·顶级视角
动画是「交互反馈」的灵魂，也关乎「感知性能」（即便真慢，有意义的动画让人感觉快）。顶级全栈懂得：动画是产品体验（PD4 交互反馈）的一部分，也是性能预算（FE14）的消耗项。游戏开发（MOB44 Unity）的帧循环思想与 `requestAnimationFrame` 同源。

### 🟠 部分六·安全/合规种子（白帽）
动画/交互勿用于**欺骗**：比如「假进度条」掩盖真实慢、用动画掩盖违规弹窗、用视觉干扰阻碍用户关闭（暗黑模式）。白帽：动画只增强清晰与愉悦，尊重 `prefers-reduced-motion`，不制造操控性 UI（dark pattern 合规风险）。

### ✅ 验收
交更新文件：卡片 hover 上浮流畅；`animateNumber` 能把数字从 0 滚到目标值（可在 Console 调用验证）。

### ⚠️ 常见坑
- 动画用 `top/left`：卡顿（触发重排）。改 `transform: translate`。
- 忘记 `if (p<1) rAF` 递归：动画只跑一帧。
- `transition` 写在 hover 里而非元素本身：首次无过渡。
- 动画太多同时跑：GPU 内存爆，反而卡。

### ➡️ 下一步
**FE18 · 微前端（隔离 / 模块联邦）**——前端世界的「乐高拼装」。

### 🧪 实战 Lab（FE17）
给「下单成功」加一个 `transition` 淡入提示框；并加 `@media (prefers-reduced-motion: reduce) { * { animation: none !important; transition: none !important; } }`。**验收点**：系统开了「减少动态效果」时动画消失。

---

## FE18 · 微前端（隔离 / 模块联邦）

### 🎯 目标
学完这节，你能解释「微前端」解决什么问题（多个团队独立开发、独立部署一个大站），理解「样式/JS 隔离」和「模块联邦（Module Federation）」两种主流思路。

### 📋 小白前置
- 方向1 编程基础
- 本文件内：**FE9–FE13（框架）、FE12（构建）**

### 🟢 部分一·最浅层（生活比喻）
普通前端像**一个施工队盖整栋楼**。微前端像**把楼拆成若干独立单元**：A 队盖东翼、B 队盖西翼，各自用料（框架）可不同，盖完拼一起。关键是「墙隔音」（隔离）——A 队刷红漆别染到 B 队。

### 🟡 部分二·动手层（逐字操作）
先理解「隔离」最简方案——用 **iframe/Web Components** 体验样式不串：
```html
<!-- 主站 -->
<div id="host">
  <h2>闪电号卡主站</h2>
  <!-- 子应用：用 Web Component 封装，自带 Shadow DOM 隔离样式 -->
  <plan-widget></plan-widget>
</div>

<script>
  class PlanWidget extends HTMLElement {
    connectedCallback() {
      const shadow = this.attachShadow({ mode: "open" });
      shadow.innerHTML = `<style>p{color:green}</style><p>子应用：19元套餐</p>`;
    }
  }
  customElements.define("plan-widget", PlanWidget);
</script>
```
保存打开：子应用的绿色 `p` 不会污染主站样式（Shadow DOM 隔离）。这就是「隔离」的最小可运行示范。

### 🔵 部分三·原理层（底层发生了什么）
微前端的核心是**运行时集成**：主应用加载多个子应用的「入口」，各自挂载到不同 DOM 节点。**样式隔离**靠：① Shadow DOM（原生隔离）；② CSS 作用域（Vue scoped / CSS Modules）；③ 约定命名空间。**JS 隔离**靠：① 模块作用域（ESM 天然隔离）；② 沙箱（qiankun 用 `Proxy` 代理 window）。**Module Federation（模块联邦）** 是 Webpack5/Vite 的能力：构建时声明「我提供哪些模块 / 需要哪些远程模块」，运行时跨应用共享代码，避免重复打包。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么大厂爱微前端？因为「康威定律」：组织结构决定系统结构——多个独立团队本就该有独立仓库/技术栈/发布节奏。顶级追问：微前端的代价——① 重复依赖（每个子应用带一份 React）；② 通信复杂（用自定义事件/共享 store）；③ 性能（多框架初始化）。所以中小项目**不值得**微前端，「单体应用 + 模块化」更优。这是「架构权衡」的顶级思维。

### 🔴 部分五·顶级视角
微前端是「系统拆分」思想在前端的落地，与后端微服务（BE16）、Serverless（BE17）、K8s（OPS21）同源——都是「把大系统拆小、独立演进」。顶级全栈懂得按「团队边界 + 规模」决定拆不拆，而非追潮流。模块联邦甚至能「前端调前端模块」如同「服务间 RPC」，与 BE11 gRPC 思想呼应。

### 🟠 部分六·安全/合规种子（白帽）
微前端**扩大攻击面**：子应用越多，信任边界越复杂。白帽：① 子应用必须来自可信源 + SRI（FE15）；② 主应用对子应用做 CSP 沙箱（`sandbox` 属性 iframe）；③ 跨子应用通信走受控事件总线，不共享全局凭证；④ 绝加载未授权第三方微应用（供应链投毒）。我们只在自己多仓库练隔离。

### ✅ 验收
交一个用 Web Component + Shadow DOM 的小 demo：主站与子应用样式互不影响，子应用显示套餐信息。

### ⚠️ 常见坑
- Shadow DOM 里想用外部 CSS 变量：需显式 `var(--x)` 继承（能继承自定义属性）。
- 微前端「为拆而拆」：小项目过度工程化，维护更累。
- 模块联邦版本不一致：共享 React 双实例，hooks 报错。
- iframe 跨域通信没用 `postMessage` + 校验 origin：被劫持。

### ➡️ 下一步
**BE1 · 后端概论 / HTTP 服务（请求-响应 / 无状态）**——前端之外的大陆，开始写「服务器」。

### 🧪 实战 Lab（FE18）
把 FE1–FE17 做的「闪电号卡前端」拆成「主站 + 一个套餐子组件（Web Component）」两个文件，子组件通过 `customElements` 注册，主站引入。验证样式隔离。**验收点**：两个文件独立、样式不串。

---

## ========== 后端 BE1–BE26 ==========

---

## BE1 · 后端概论 / HTTP 服务（请求-响应 / 无状态）

### 🎯 目标
学完这节，你能用 Python 标准库（无需 Flask 也可）写一个「能响应浏览器请求的服务器」，理解「前端发请求、后端回响应」的闭环，以及「无状态」是什么意思。

### 📋 小白前置
- 方向1 编程基础（PY1–PY6 变量/函数/字符串）
- 方向4 网络（NET8 HTTP、NET6 TCP 概念）
- 本文件内：**FE1–FE5**（懂前端怎么发请求）

### 🟢 部分一·最浅层（生活比喻）
前端像**顾客**，后端像**餐厅厨房**。顾客（浏览器）递菜单（HTTP 请求）给前台，厨房（服务器）做好菜（HTML/JSON）递回来。每次点单都是独立事件——厨房不记你上次点了啥（**无状态**），你要续杯得自己再说一遍（带 cookie/session，BE5）。

### 🟡 部分二·动手层（逐字操作）
用 Python 标准库起一个最小服务器（护手：复制）：
```python
# server.py
from http.server import BaseHTTPRequestHandler, HTTPServer

class H(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.end_headers()
        html = "<h1>闪电号卡 · 后端已启动</h1><p>路径：%s</p>" % self.path
        self.wfile.write(html.encode("utf-8"))

if __name__ == "__main__":
    HTTPServer(("127.0.0.1", 8000), H).serve_forever()
```
在 VS Code 终端运行：`python server.py`。浏览器打开 `http://127.0.0.1:8000`，看到页面。改路径 `http://127.0.0.1:8000/abc` 页面会显示 `/abc`。

### 🔵 部分三·原理层（底层发生了什么）
浏览器按 HTTP 协议发一个**请求报文**（方法 GET、路径、头、体）到 `127.0.0.1:8000`（NET6/8：TCP 三次握手后发 HTTP）。`HTTPServer` 监听端口、接收连接、把请求交给 `do_GET` 处理；你 `send_response` + `send_header` + `wfile.write` 组装出**响应报文**回给浏览器。每次请求都是独立的 TCP 连接（HTTP/1.0）或复用（HTTP/1.1 keep-alive，NET8），服务器本身不保存「你是谁」——这就是无状态。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么「无状态」是好事？因为服务器可以任意横向扩容（加机器），不用同步彼此的「用户状态」，简单且可扩展。代价是「状态要自己带」（cookie/session/token，BE5）。顶级追问：HTTP 方法语义——GET（取，幂等）、POST（建，不幂等）、PUT/PATCH/DELETE（改/删）；「幂等（idempotent）」是 REST（BE9）的基石。还有状态码（200/301/404/500）是「机器间对话的语气」。

### 🔴 部分五·顶级视角
「请求-响应 + 无状态」是**所有 Web 架构的公理**，延伸到 gRPC（BE11）、消息队列（BE14）、甚至服务网格。顶级全栈看到任何「客户端-服务端」交互，都先问：状态在哪？是否幂等？能否水平扩展？这是系统设计的元问题（BE25）。

### 🟠 部分六·安全/合规种子（白帽）
最小服务器也要守边界：① 只监听 `127.0.0.1`（本机），不要 `0.0.0.0` 暴露公网练手；② 不对用户输入的路径做文件读取（路径穿越漏洞，PY9 提过）；③ 不写任何「后门接口」。白帽只对自己机器练，不把练手服务暴露到公网被他人利用。

### ✅ 验收
交 `server.py` + 浏览器打开 `127.0.0.1:8000` 截图，页面显示「后端已启动」及当前路径。

### ⚠️ 常见坑
- 端口被占（8000 被用）：换 `8001` 等。
- 中文乱码：响应头加 `charset=utf-8` 且 `encode("utf-8")`。
- 改了代码没重启服务器：Python 不热更新，需 Ctrl+C 重跑。
- 用 `0.0.0.0` 练手：暴露在局域网，违反「只本机」护手约定。

### ➡️ 下一步
**BE2 · Web 框架 Flask / FastAPI（WSGI / ASGI / 生命周期）**——用框架少写 90% 样板代码。

### 🧪 实战 Lab（BE1）
在 `do_GET` 里判断 `self.path`：若为 `/plans` 返回一段写死的 JSON 套餐列表（`[{"name":"闪电卡19","price":19}]`），浏览器访问看到 JSON。**验收点**：访问 `/plans` 返回 JSON 文本（为 BE9 REST 预热）。

---

## BE2 · Web 框架 Flask / FastAPI（WSGI / ASGI / 生命周期）

### 🎯 目标
学完这节，你能用 Flask 写一个带路由的 API 服务（这也是「闪电号卡」后端真正的起点），理解 WSGI/ASGI 是什么、Flask 与 FastAPI 怎么选。

### 📋 小白前置
- 方向1 编程基础（PY6 函数、PY20 venv/pip）
- 本文件内：**BE1**（已懂原始 HTTP 服务）

### 🟢 部分一·最浅层（生活比喻）
BE1 的 `http.server` 像**自己砌灶台做饭**，啥都得自己来。Flask 像**用现成厨具套餐**：你只写「这道菜怎么做（函数）」，框架帮你接单、摆盘、上菜。WSGI 是「厨具和厨房之间的接口标准」，保证换厨具也能用。

### 🟡 部分二·动手层（逐字操作）
在 `闪电号卡-fe` 同级新建 `闪电号卡-be` 文件夹，VS Code 打开它。终端建虚拟环境（护手：复制）：
```bash
python -m venv venv
.\venv\Scripts\activate      # Windows 激活
pip install flask
```
新建 `app.py`：
```python
from flask import Flask, jsonify
app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>闪电号卡 API</h1>"

@app.route("/plans")
def plans():
    data = [{"name": "闪电卡19", "price": 19}, {"name": "闪电卡39", "price": 39}]
    return jsonify(data)

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=True)
```
终端 `python app.py`，浏览器开 `http://127.0.0.1:5000/plans` 看到 JSON。

### 🔵 部分三·原理层（底层发生了什么）
`@app.route` 是**装饰器（PY14）**，把函数注册到「路径 → 处理函数」映射表。请求进来，Flask 的 **WSGI 服务器（开发用 Werkzeug）** 解析请求，匹配路由，调用你的函数，把返回值按 Content-Type 包装成响应。WSGI 是 Python Web 的同步网关标准（一个请求占一个线程）。**ASGI**（FastAPI 用）支持异步（async/await，PY17），适合高并发/WebSocket（BE19）。`debug=True` 开热重载 + 错误页（**生产必须关**，BE23）。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么有 Flask 还有 FastAPI？Flask 极简、学习曲线低、生态老；FastAPI 基于 ASGI + Pydantic，自动校验参数、自带 OpenAPI 文档、性能好（async）。顶级追问：WSGI vs ASGI 本质是「同步 I/O vs 异步 I/O」（OS9/PY17）——当请求在等数据库/网络时，异步能腾出线程服务别人。选框架看「团队/性能/类型需求」。

### 🔴 部分五·顶级视角
框架是「关注点分离」产物：路由、中间件（BE3）、序列化、错误处理都由框架管，你专注业务。**框架无关思维**是顶级标志——换 Flask/FastAPI/Go net/http（GO4）/Node Express，核心都是「路由表 + 处理函数 + 中间件链」。顶级全栈能把业务逻辑写成「框架中立」的纯函数，方便迁移测试。

### 🟠 部分六·安全/合规种子（白帽）
`debug=True` 暴露**交互式错误控制台（PIN 保护可被绕过）**——生产绝不能开（BE23）。框架默认不防注入/越权，这些要自己加（BE5/BE9/SEC）。白帽：只用框架官方稳定版；不装来路中间件；不开启「允许任意文件读取」的调试功能。

### ✅ 验收
交 `app.py` + 虚拟环境说明：访问 `/` 和 `/plans` 分别得到 HTML 与 JSON 截图。

### ⚠️ 常见坑
- 忘了激活 venv：`flask` 命令找不到。先 `.\venv\Scripts\activate`。
- 端口 5000 被占：改 `port=5001`。
- `debug=True` 忘关就上线：重大安全隐患。
- 返回中文 JSON 乱码：Flask 默认 `ensure_ascii=True` 会转义；`jsonify` 已处理，放心用。

### ➡️ 下一步
**BE3 · 路由与中间件（管道 / 拦截）**——给请求「过几道关」再到你手里。

### 🧪 实战 Lab（BE2）
给 `/plans` 加一个查询参数 `?hot=true`，只返回 `hot` 为真的套餐（先给数据加 `hot` 字段）。访问 `/plans?hot=true` 验证过滤。**验收点**：查询参数过滤生效（为 BE9 REST 查询预热）。

---

## BE3 · 路由与中间件（管道 / 拦截）

### 🎯 目标
学完这节，你能组织多路由（首页/套餐/下单），并用「中间件」在所有请求前后统一做日志、计时、校验——理解请求像「穿过几道滤网的流水线」。

### 📋 小白前置
- 方向1 编程基础（PY14 装饰器、PY6 函数）
- 本文件内：**BE1、BE2**

### 🟢 部分一·最浅层（生活比喻）
路由像**前台分诊**：不同门牌号（URL 路径）带你去不同科室。中间件像**进门安检 + 出门盖章**：每个请求进来先过安检（记日志/查身份），出去前再统一盖个章（加响应头/计时）。一道一道串成「管道」。

### 🟡 部分二·动手层（逐字操作）
在 `app.py` 里加「计时中间件」（用 Flask 的 `before/after` 钩子，复制）：
```python
import time
from flask import request

@app.before_request
def log_start():
    request._t = time.time()   # 把开始时间挂在请求对象上

@app.after_request
def log_end(resp):
    dt = time.time() - getattr(request, "_t", 0)
    print(f"[{request.method}] {request.path} 耗时 {dt*1000:.1f}ms")
    resp.headers["X-Powered-By"] = "Shandian"
    return resp
```
再加一个下单路由：
```python
@app.route("/order", methods=["POST"])
def order():
    return jsonify({"msg": "下单成功（演示）", "order_id": 1001})
```
重启服务，访问几个路径看终端打印耗时；用前面 FE 的表单或 `curl` 访问 `/order`（POST）。

### 🔵 部分三·原理层（底层发生了什么）
Flask 的请求生命周期：**请求进来 → 依次跑 `before_request` 列表 → 匹配路由函数 → 跑 `after_request` 列表 → 返回响应**。`before/after` 就是 Flask 的「中间件」雏形。更通用的是 **WSGI middleware**：一个包裹 app 的函数，接收 `environ` 和 `start_response`，可改请求/响应。中间件按顺序形成「洋葱模型」（进入一层层往里，返回一层层往外）——这是 Express/Koa/Go 中间件（GO4）的通用范式。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么需要中间件？因为「横切关注点」（日志、认证、CORS、限流）不属于某个具体业务，却要全局生效（呼应 PAR6 AOP 面向切面）。顶级追问：中间件的「顺序」是隐形 bug 源——认证中间件必须在路由前、CORS 头必须在响应前加。还有「短路」：中间件可提前返回（如未登录直接 401），不再往下走。

### 🔴 部分五·顶级视角
中间件/拦截器是「管道-过滤器架构」的经典实现，贯通后端（BE3）、API 网关（BE16）、Service Mesh（sidecar 拦截）、甚至前端（FE9 的全局 mixin）。顶级全栈设计系统时长这样问：这个逻辑是「某个接口特有」还是「所有请求共有」？共有的就进中间件，保持业务函数纯净。

### 🟠 部分六·安全/合规种子（白帽）
中间件是**安全闸门的好位置**：统一加安全响应头（CSP、X-Frame-Options，FE15）、统一校验来源（CORS，SEC16）、统一限流（BE15）。白帽：① 认证中间件务必「拒绝优先」（默认拒，显式放行）；② 不在中间件里记录密码等敏感字段（BE21 日志合规）；③ 慎用第三方中间件，防供应链投毒。

### ✅ 验收
交更新 `app.py`：终端打印每个请求的耗时与路径；`/order` POST 返回 JSON；响应头带 `X-Powered-By`。

### ⚠️ 常见坑
- `before_request` 里忘了 `return` 就继续执行：正常（它返回 None 才继续）；但若返回响应则短路。
- 在 `after_request` 改了 `resp` 却没 `return resp`：响应丢失。
- 中间件顺序错：CORS 头没加上导致前端跨域失败。
- 日志打印了整个请求体含密码：合规雷。

### ➡️ 下一步
**BE4 · 模板 / SSR（服务端渲染 / 注入）**——后端直接「吐出完整网页」。

### 🧪 实战 Lab（BE3）
写一个 `auth_mw` 中间件：对所有 `/admin` 开头的路径，若请求头没有 `X-Token: secret` 就返回 401。**验收点**：带正确 token 才能访问 `/admin`，否则 401。

---

## BE4 · 模板 / SSR（服务端渲染 / 注入）

### 🎯 目标
学完这节，你能用 Flask 的 Jinja2 模板把「套餐数据」渲染成完整 HTML 页面（SSR 服务端渲染），并彻底理解「模板注入（SSTI）」为何危险、如何防。

### 📋 小白前置
- 方向1 编程基础（PY12 模块/字符串格式化）
- 本文件内：**BE2、BE3**、前端 **FE1（HTML）**

### 🟢 部分一·最浅层（生活比喻）
SSR 像**厨房现做现卖**：顾客点单，厨房当场把菜炒好装盘递上（后端生成完整 HTML）。模板像**菜单模板**：空白处（{{ 套餐名 }}）由厨房填入真实数据。SSTI 漏洞像**让顾客自己在菜单上写「把厨房也给我」**——危险。

### 🟡 部分二·动手层（逐字操作）
在 `app.py` 同目录建 `templates/plans.html`（Flask 默认找 `templates/` 文件夹）：
```html
<!DOCTYPE html>
<html lang="zh-CN">
<head><meta charset="UTF-8"><title>闪电号卡</title></head>
<body>
  <h1>{{ title }}</h1>
  <ul>
  {% for p in plans %}
    <li>{{ p.name }}：{{ p.price }} 元</li>
  {% endfor %}
  </ul>
</body>
</html>
```
`app.py` 加：
```python
from flask import render_template
@app.route("/web/plans")
def web_plans():
    plans = [{"name":"闪电卡19","price":19},{"name":"闪电卡39","price":39}]
    return render_template("plans.html", title="闪电号卡套餐", plans=plans)
```
重启访问 `http://127.0.0.1:5000/web/plans`，看到服务端生成的套餐页。

### 🔵 部分三·原理层（底层发生了什么）
`render_template` 用 **Jinja2 引擎**读模板文件，把 `{{ }}`（输出，自动 HTML 转义）和 `{% %}`（逻辑）编译成 Python 代码执行，把变量填进去生成字符串返回。`{{ }}` 默认开启**自动转义**——这就是 SSR 防 XSS 的第一道闸（FE15 呼应）。SSR 适合「首屏要 SEO/快」的页面；SPA（FE9/10）则把渲染放前端（CSR）。现代还有「同构/脱水注水」（RSC，FE10）。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么有 SSR 又有 CSR？SSR 首屏快、利于 SEO、低端设备友好；CSR 交互顺滑、前后端分离清晰。于是出现「混合」：首屏 SSR + 后续 CSR（Next.js/Nuxt）。顶级追问：**SSTI（服务端模板注入，SEC19）**——若把用户输入拼进模板字符串（`render_template_string(user_input)`），攻击者可注入 `{{ 7*7 }}` 甚至执行命令。防御：绝不把用户输入当模板，只用「数据填充」。

### 🔴 部分五·顶级视角
模板引擎是「View 层」的实现，对应 MVC 的 V。顶级全栈懂「渲染职责放哪」的权衡：BFF（Backend For Frontend，BE16）常在后端做 SSR 聚合多服务数据；而纯 API 后端（BE9）只吐 JSON 给前端渲染。这条边界决定了团队分工与性能特征。

### 🟠 部分六·安全/合规种子（白帽）——核心
- **SSTI**：绝不用 `render_template_string` 拼接用户输入；用「变量传参 + 自动转义」。
- **XSS via SSR**：即便 SSR 也要保证数据走 `{{ }}` 而非 `|safe` 强行关转义；`|safe` 只用于你 100% 信任且已净化的内容。
- 富文本：后端用 Bleach/DOMPurify 净化后再存（FE9 提过）。
- 红线：绝不写「执行任意用户输入为代码」的接口（那是后门，违法）。

### ✅ 验收
交 `templates/plans.html` + 更新 `app.py`：访问 `/web/plans` 看到服务端渲染的套餐列表；说明「自动转义如何防 XSS」。

### ⚠️ 常见坑
- 模板放错文件夹：Flask 默认 `templates/`（复数、同名），放错 404。
- 用 `|safe` 关转义又填了用户输入：XSS。
- 把用户输入拼进 `render_template_string`：SSTI 高危。
- 模板里变量名拼错：Jinja2 报 `UndefinedError`。

### ➡️ 下一步
**BE5 · 认证授权（session / JWT / OAuth2 / OIDC）**——搞清「你是谁、你能干啥」。

### 🧪 实战 Lab（BE4）
在 `/web/plans` 模板里加一个「下单」表单（POST 到 `/order`），后端 `/order` 接收后**再 render_template** 一个「下单成功」页（而非只返回 JSON）。**验收点**：从网页表单提交后看到服务端渲染的成功页。

---

## BE5 · 认证授权（session / JWT / OAuth2 / OIDC）

### 🎯 目标
学完这节，你能区分「认证（你是谁）」和「授权（你能干啥）」，用 Flask 实现「密码登录 + session」和「JWT 令牌」两种会话方案，并知道各自的适用场景与安全注意。

### 📋 小白前置
- 方向1 编程基础（PY8 字典、哈希直觉）
- 本文件内：**BE2、BE3、BE4**、前端 **FE8（cookie/storage）**
- 安全方向预告：SEC4/SEC5/SEC6（先练，后面系统学）

### 🟢 部分一·最浅层（生活比喻）
**认证（Authentication）** = 查身份证：「你是张三吗？」。**授权（Authorization）** = 看门禁卡：「张三能进机房吗？」。Session 像**寄存手牌**：你进门押身份证，前台给你手牌，之后凭手牌认人（状态在服务端）。JWT 像**自带防伪章的通行证**：证件上写了你是谁、能去哪，盖章防伪，前台不存底（状态在令牌里）。

### 🟡 部分二·动手层（逐字操作）
安装：`pip install flask-session pyjwt`（或只用标准库 `secrets`/`hashlib`）。简单 session 登录：
```python
from flask import session, request, redirect, url_for
import secrets
app.secret_key = secrets.token_hex(16)   # 用于签名 session cookie，务必随机

@app.route("/login", methods=["POST"])
def login():
    # 演示：正确账号密码（真实要用 BE6 哈希比对 + 查库）
    if request.form.get("u") == "test" and request.form.get("p") == "123456":
        session["user"] = "test"
        return "登录成功"
    return "失败", 401
```
JWT 版（用 `pyjwt`）：
```python
import jwt, datetime
def make_token(u):
    payload = {"user": u, "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1)}
    return jwt.encode(payload, app.secret_key, algorithm="HS256")
```
（仅演示结构；完整要用 HTTPS + 安全 cookie，FE8/BE23。）

### 🔵 部分三·原理层（底层发生了什么）
登录成功后，服务端把 `user` 写进 **session（服务端存储 + 客户端 cookie 只存 session_id）**，cookie 设 `HttpOnly`（JS 读不到，防 XSS 偷，FE8）+ `Secure`（仅 HTTPS）+ `SameSite=Lax`（防 CSRF，FE15/SEC16）。**JWT** 则是服务端用密钥签名一段 base64 JSON，客户端自己存（localStorage 或 cookie），之后每次请求在 `Authorization: Bearer <token>` 头带上，服务端验签名即可信，不用查库。两者核心差异：**状态在服务端 vs 在令牌里**。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么 JWT 流行又常被用错？因为它「无状态、易横向扩展」（呼应 BE1 无状态），适合微服务（BE16）/移动端。但**JWT 无法轻易吊销**（过期前一直有效），所以敏感操作仍需服务端黑名单或短过期+刷新令牌。OAuth2 是「授权第三方」协议（微信/谷歌登录），OIDC 在其上加「身份认证」层。顶级追问：session vs JWT 的抉择本质是「服务端状态成本 vs 吊销难度」的权衡。

### 🔴 部分五·顶级视角
认证授权是「零信任架构」的入口，连通 IAM（SEC85）、SSO（SEC5）、API 安全（SEC21）。顶级全栈懂得：① 密码绝明文存（BE6）；② 权限判定放**后端**（前端状态不可信，FE11 提过）；③ 用标准协议（OAuth2/OIDC）而非自创；④ 令牌最小权限 + 短生命周期。这是「身份即边界」思维。

### 🟠 部分六·安全/合规种子（白帽）——核心
- 密码明文、token 不签名、cookie 没 HttpOnly = 三大低级漏洞。
- 越权（IDOR，SEC11）：`/user?id=2` 必须校验「当前登录用户能否看 id=2」，不能只靠前端隐藏。
- 绝不写「万能 token / 后门账号」；授权内自查，漏洞走 SEC100 赏金流程上报。
- 提醒：OAuth client_secret 是**服务端机密**，绝不放前端代码（会泄露）。

### ✅ 验收
交更新 `app.py`：`/login` 正确凭据后 session 写入；用 `pyjwt` 生成可解析的 token（可贴 token 到 jwt.io 验证结构）；文字说明 session 与 JWT 差异。

### ⚠️ 常见坑
- `secret_key` 写死成 `"123"`：签名可伪造，立刻被攻破。用 `secrets.token_hex`。
- JWT 用 `none` 算法：历史漏洞，验证端必须拒绝 `alg=none`。
- cookie 没 HttpOnly：XSS 一打就丢 token。
- 把授权判定放前端：越权漏洞。

### ➡️ 下一步
**BE6 · 密码学应用（bcrypt / scrypt / argon2）**——把「密码」存成连自己都还原不了的密文。

### 🧪 实战 Lab（BE5）
写一个 `require_login` 装饰器（用 `@wraps`），保护 `/order`：没登录（无 session）返回 401。并用 `curl -b/-c` 或浏览器测登录前后访问差异。**验收点**：未登录访问 `/order` 被拒，登录后可访问。

---

## BE6 · 密码学应用（bcrypt / scrypt / argon2）

### 🎯 目标
学完这节，你能用 `bcrypt`（或 `argon2`）正确地「哈希存储密码」，理解「加盐」和「慢哈希」为什么能扛住彩虹表/暴力破解，绝不明文存密码。

### 📋 小白前置
- 方向1 编程基础
- 方向4 网络（NET9 TLS 概念）
- 本文件内：**BE5（认证）**
- 安全方向：SEC4 密码学基础（先练）

### 🟢 部分一·最浅层（生活比喻）
明文存密码像**把钥匙挂在门上**。普通哈希（如 MD5）像**把钥匙熔成铁块**——但坏人有一本「铁块→原钥匙」对照表（彩虹表），照样能反查。**加盐慢哈希（bcrypt）** 像：每次熔钥匙都先随机撒一把独家盐，再用很慢的炉子熔，坏人没法提前备表，且熔一次要老半天，暴力试几亿次不现实。

### 🟡 部分二·动手层（逐字操作）
安装：`pip install bcrypt`。复制：
```python
import bcrypt
def hash_pw(pwd: str) -> bytes:
    salt = bcrypt.gensalt(rounds=12)          # 加盐 + 成本因子
    return bcrypt.hashpw(pwd.encode(), salt)   # 返回 哈希(密码+盐)
def check_pw(pwd: str, hashed: bytes) -> bool:
    return bcrypt.checkpw(pwd.encode(), hashed)

# 演示
h = hash_pw("MyStrong@123")
print(h)                  # 每次都不同（因为盐随机）
print(check_pw("MyStrong@123", h))   # True
print(check_pw("wrong", h))          # False
```
把 `hash_pw` 接进 BE5 的注册/登录：存 `hash_pw` 结果，登录时 `check_pw`。

### 🔵 部分三·原理层（底层发生了什么）
`bcrypt` 把**随机盐**混进密码，再用基于 Blowfish 的**自适应慢哈希**反复迭代（默认 2^12 次）。「慢」是刻意的：让单次验证耗时 ~100ms，使暴力猜测成本极高。「盐」保证相同密码产生不同哈希，摧毁彩虹表。结果里**盐本身就存在哈希串中**（`$2b$12$<salt><hash>`），校验时取出即可，无需额外存盐。`checkpw` 用「常量时间比较」防时序攻击。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么不用 MD5/SHA？因为它们**快且未加盐**，专为校验设计而非抗破解。为什么有 scrypt/argon2？bcrypt 抗 CPU 但不抗 GPU/ASIC；scrypt 加「内存硬」使 GPU 难并行；**argon2（2015 密码哈希竞赛冠军）** 同时抗 GPU 和内存，是现代首选。顶级追问：「成本因子」要随硬件升级定期调高；「 pepper（全局密钥）」可再叠一层防护。

### 🔴 部分五·顶级视角
密码学应用是「纵深防御」的底层：它和 TLS（NET9，传输加密）、JWT 签名（BE5）、数据库加密（DB28）、密钥管理（OPS47 Vault）构成一条「数据保护链」。顶级全栈不是密码学专家，但必须**知道用什么、怎么用对、绝不自创算法**——错误用法比不用更糟。

### 🟠 部分六·安全/合规种子（白帽）——核心
- **明文/双向加密存密码 = 严重违规**（等保/GDPR 均罚）。必须单向慢哈希。
- 绝自创哈希组合（如 `md5(salt+password)` 多次）——对抗性不足。用成熟库。
- 不把 pepper/secret 写进代码提交；用环境变量/密钥库（OPS47）。
- 红线：绝不写「可还原用户密码」的接口（那是明文存储变种），也不碰他人账户。

### ✅ 验收
交：用 bcrypt 的 `hash_pw`/`check_pw` 演示代码 + 接入 BE5 登录的片段；文字说明「盐」和「慢」的作用。

### ⚠️ 常见坑
- 用 `==` 比较哈希：受时序攻击；用 `bcrypt.checkpw`（常量时间）。
- 成本因子设太低（rounds=4）：不抗暴力；太高：登录卡。12 是常见值。
- 把哈希当「加密」想还原：它是单向的，忘了密码只能重置。
- 盐写死：失去「每用户不同盐」的意义。

### ➡️ 下一步
**BE7 · 数据库对接 / 连接池（池化 / 泄漏）**——让后端「记住」套餐和订单。

### 🧪 实战 Lab（BE6）
做一个「注册接口 `/register`」：`POST` 用户名+密码，用 bcrypt 存哈希（先用内存字典 `users = {}` 模拟库）。`/login` 用 `check_pw` 比对。**验收点**：同一密码两次哈希串不同；登录正确才通过。

---

## BE7 · 数据库对接 / 连接池（池化 / 泄漏）

### 🎯 目标
学完这节，你能用 Flask 连上 SQLite（零配置、文件即库），把「套餐/订单」存进数据库并查出来，理解「连接池」为什么是高并发必备。

### 📋 小白前置
- 方向1 编程基础（PY9 文件读写）
- 方向5 数据库（DB1 概论、DB3 SQL CRUD、DB10 SQLite 实战）
- 本文件内：**BE2–BE6**

### 🟢 部分一·最浅层（生活比喻）
数据库像**带索引的档案柜**。每次「开柜取档」都要先「办张门禁卡（建立连接）」，办卡很慢。连接池像**提前办一批卡放前台**，谁要用拿一张，用完还回——不用每次现办，效率飞起。连接泄漏就是「借了卡不还」，最后前台没卡了，全员卡死。

### 🟡 部分二·动手层（逐字操作）
Flask 用 `sqlite3`（Python 标准库自带）。在 `app.py` 加：
```python
import sqlite3, os
DB = os.path.join(os.path.dirname(__file__), "shandian.db")

def get_db():
    conn = sqlite3.connect(DB)
    conn.row_factory = sqlite3.Row     # 让结果可按列名取
    return conn

# 初始化表（只跑一次）
def init_db():
    db = get_db()
    db.execute("""CREATE TABLE IF NOT EXISTS plans(
        id INTEGER PRIMARY KEY, name TEXT, price INTEGER, hot INTEGER)""")
    db.execute("INSERT OR IGNORE INTO plans(id,name,price,hot) VALUES(1,'闪电卡19',19,1),(2,'闪电卡39',39,0)")
    db.commit(); db.close()

@app.route("/db/plans")
def db_plans():
    db = get_db()
    rows = db.execute("SELECT * FROM plans").fetchall()
    db.close()
    return jsonify([dict(r) for r in rows])
```
终端先 `python -c "import app; app.init_db()"` 建表，再启动服务，访问 `/db/plans` 看到数据。

### 🔵 部分三·原理层（底层发生了什么）
`sqlite3.connect` 打开一个到数据库文件的连接（DB10：SQLite 是进程内引擎，文件即库，零服务）。SQL `SELECT` 经「解析→优化→执行」返回游标，`fetchall` 取全部行。`row_factory=Row` 让每行像字典。每次请求「开连接→查→关连接」在高并发会**频繁建连拖慢**——这正是连接池（如 `SQLAlchemy` 的 `QueuePool`、`DB7` 连接池）解决的事：预建 N 个连接循环复用。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么用 SQLite 起步？零配置、适合单机/嵌入式/练手；生产换 PostgreSQL/MySQL（DB11/DB12）几乎只改连接串。顶级追问：① **连接泄漏**——`open` 了忘了 `close` 或异常路径没关，连接耗尽→雪崩；要用 `try/finally` 或上下文管理器（PY15 `with`）。② 池大小怎么定？太小排队、太大压垮 DB。③ WAL 模式（DB10）提升并发读写。

### 🔴 部分五·顶级视角
「连接管理」是后端与数据层协作的第一道工程关，连通 DB7（MVCC/锁）、DB13（主从）、OPS 调优。顶级全栈把「数据库连接」当**稀缺资源**严管：池化、超时、健康检查、读写分离（DB13）。这思维也适用于 Redis 连接（BE13）、HTTP 客户端连接（BE16 网关）。

### 🟠 部分六·安全/合规种子（白帽）
- **SQL 注入（SEC10）**：绝用字符串拼接 SQL！上面用了参数化（`?` 占位），但注意我示例里 `execute` 直接拼值也没问题因为是常量。凡是**用户输入**进 SQL，必须用参数化（`?`/`%s`），绝不 f-string 拼。
- 数据库文件权限：SQLite 文件别放 Web 可下载目录（路径穿越）。
- 不把 DB 凭证提交进代码（用环境变量）。

### ✅ 验收
交更新 `app.py`：访问 `/db/plans` 返回 SQLite 里的套餐数据；说明「参数化查询」为何防注入。

### ⚠️ 常见坑
- 忘了 `commit()`：写操作不生效。
- 忘了 `close()`：连接泄漏（小例子不明显，生产爆炸）。
- 用 f-string 拼 SQL 带用户输入：注入漏洞（务必参数化）。
- 多次 `init_db` 重复插入：用 `INSERT OR IGNORE` 或先查。

### ➡️ 下一步
**BE8 · ORM（映射 / N+1 / 迁移）**——用「对象」操作数据库，少写 SQL。

### 🧪 实战 Lab（BE7）
加一个 `/db/order` POST 接口：接收 `plan_id`，把一条订单 `INSERT` 进新建的 `orders` 表，返回订单号。**验收点**：下单后能在数据库查到该订单（可再加 `/db/orders` 列表接口验证）。

---

## BE8 · ORM（映射 / N+1 / 迁移）

### 🎯 目标
学完这节，你能用 SQLAlchemy（ORM）把「Python 类」映射成「数据库表」，用面向对象的方式增删改查，并理解 N+1 查询问题和数据库迁移。

### 📋 小白前置
- 方向1 编程基础（PY11 面向对象）
- 方向5 数据库（DB26 ORM、DB8 索引）
- 本文件内：**BE7（原生 SQL）**

### 🟢 部分一·最浅层（生活比喻）
原生 SQL 像**用外语直接跟档案柜喊指令**。ORM 像**请个翻译**：你用母语（Python 对象）说「给我价格小于 30 的套餐」，翻译自动转成 SQL 去查。省事，但翻译有时啰嗦（多查几次），你要懂怎么让他「一次问完」。

### 🟡 部分二·动手层（逐字操作）
安装：`pip install flask-sqlalchemy`。改写 `app.py`：
```python
from flask_sqlalchemy import SQLAlchemy
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///" + os.path.join(os.path.dirname(__file__), "shandian.db")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
db = SQLAlchemy(app)

class Plan(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50))
    price = db.Column(db.Integer)
    hot = db.Column(db.Boolean, default=False)

with app.app_context():
    db.create_all()                      # 自动建表（迁移雏形）

@app.route("/orm/plans")
def orm_plans():
    plans = Plan.query.filter(Plan.price < 30).all()   # 像写 Python
    return jsonify([{"name": p.name, "price": p.price} for p in plans])
```
重启访问 `/orm/plans` 看到结果（若之前表结构不同，删旧 db 文件重来）。

### 🔵 部分三·原理层（底层发生了什么）
ORM（对象关系映射）在「类定义」和「表结构」间建立映射：`Plan` 类 → `plan` 表，类属性 → 列。`Plan.query.filter(...)` 被 ORM 翻译成 SQL 执行，结果再「装箱」回 Python 对象。它屏蔽了 DB 差异（换数据库只改 URI）。`db.create_all()` 是**自动建表**，但生产要用**迁移工具（Alembic/Flyway）**管理结构变更（DB26 迁移），不能靠 `create_all` 丢数据。

### 🟣 部分四·深挖层（为什么 & 延伸）
**N+1 问题**：查 10 个套餐，每个套餐又单独查它的「订单数」→ 1（查套餐）+ 10（各查订单）= 11 次 SQL。优化用「预加载（eager load / join）」一次查回。顶级追问：ORM 的「阻抗失配（impedance mismatch，DB26）」——对象图 ≠ 关系表，复杂查询 ORM 反而别扭，该手写 SQL 时就手写（顶级懂权衡）。还有「迁移」保证多环境 schema 一致。

### 🔴 部分五·顶级视角
ORM 是「生产力 vs 可控性」的永恒权衡。顶级全栈：简单 CRUD 用 ORM 提速；分析型/批量/复杂 join 用原生 SQL + 索引优化（DB8/DB9）；用迁移工具管 schema 演进；监控 N+1（BE21 链路追踪可发现）。这思维通 Go（GORM）、Java（Hibernate）、Rust（Diesel）。

### 🟠 部分六·安全/合规种子（白帽）
ORM 多数**默认参数化**（防注入，SEC10），但：① 用 `text()` 原生 SQL 仍要参数化；② 别用 `Model.query.get(request.args['id'])` 却不校验所有权（越权 IDOR，SEC11）；③ 迁移脚本勿含明文数据泄露。白帽：ORM 是防注入的好工具，但不是越权防护。

### ✅ 验收
交更新 `app.py`：用 SQLAlchemy 定义 `Plan` 并 `/orm/plans` 返回 `price<30` 的套餐；说明 N+1 是什么。

### ⚠️ 常见坑
- `db.create_all()` 不更新已存在的表结构：改模型后需删库或用迁移。
- 循环引用/上下文错误：`No application found`，用 `with app.app_context()`。
- 忘了 `SQLALCHEMY_TRACK_MODIFICATIONS=False`：警告+内存开销。
- 以为 ORM 一定安全：原生 `text()` 仍要参数化。

### ➡️ 下一步
**BE9 · REST API 设计（版本 / 幂等 / 状态码）**——把后端接口设计成「规范的好 API」。

### 🧪 实战 Lab（BE8）
用 ORM 定义 `Order` 模型（含 `plan_id`、`created_at`），写「下单」接口创建 Order 并返回；再写「我的订单」接口列出。`created_at` 用 `db.Column(db.DateTime, default=datetime.utcnow)`。**验收点**：下单落库、可列出。

---

## BE9 · REST API 设计（版本 / 幂等 / 状态码）

### 🎯 目标
学完这节，你能按 REST 规范设计「闪电号卡」的 API：合理用 URL/方法/状态码、做分页与错误格式、理解幂等性，并给所有接口做输入校验（防注入/越权的前置）。

### 📋 小白前置
- 方向1 编程基础（PY8 字典、PY16 正则）
- 本文件内：**BE2–BE8**、前端 **FE5/FE6**

### 🟢 部分一·最浅层（生活比喻）
REST API 像**图书馆规矩**：书按类别上架（URL 资源）、借/还/查各有动作（GET/POST/PUT/DELETE）、借不到有标准提示牌（状态码）、同一本书借多次结果一样（幂等）。乱写 API 像图书馆没规矩，前端（借书人）天天迷路。

### 🟡 部分二·动手层（逐字操作）
在 `app.py` 设计合规接口（复制）：
```python
from flask import request, abort
from pydantic import BaseModel, ValidationError   # 若装了 pydantic；否则用手动校验

@app.route("/api/v1/plans")
def api_plans():
    hot = request.args.get("hot")          # 可选过滤
    q = Plan.query
    if hot == "1": q = q.filter_by(hot=True)
    page = request.args.get("page", 1, type=int)
    items = q.paginate(page=page, per_page=10).items
    return jsonify({"data": [{"name":p.name,"price":p.price} for p in items], "page": page})

@app.route("/api/v1/orders", methods=["POST"])
def api_create_order():
    body = request.get_json(silent=True) or {}
    plan_id = body.get("plan_id")
    if not isinstance(plan_id, int):                 # 输入校验
        abort(400, description="plan_id 必须是数字")
    plan = Plan.query.get(plan_id)
    if not plan:
        abort(404, description="套餐不存在")
    # TODO: 校验当前登录用户（BE5）后才能下单
    o = Order(plan_id=plan_id); db.session.add(o); db.session.commit()
    return jsonify({"order_id": o.id}), 201
```
访问 `/api/v1/plans`、`POST /api/v1/orders` 验证。

### 🔵 部分三·原理层（底层发生了什么）
REST 用 **URL 表示资源**（`/plans`）、**HTTP 方法表示动作**（GET 查/POST 建/PUT 改/DELETE 删）、**状态码表示结果**（2xx 成功/4xx 客户端错/5xx 服务端错）。`abort(400/404)` 统一返回错误。分页（`paginate`）避免一次返回万条拖垮网络/前端。`request.get_json` 解析请求体。这一切建立在 BE1 的「请求-响应」之上，只是约定更严。

### 🟣 部分四·深挖层（为什么 & 延伸）
**幂等（idempotent）**：GET/PUT/DELETE 多次调用效果相同；POST 不幂等（多次下单建多个）。这让「网络重试安全」——客户端超时重试 GET 没事，重试 POST 要小心（用幂等键，BE20 支付）。顶级追问：API **版本**（`/api/v1`）为何必要？因为客户端会滞后升级，破坏式变更要新版本并行；还有 HATEOAS（超媒体驱动）、Cursor 分页 vs Offset 分页（大数据用 cursor 防深翻页性能塌）。

### 🔴 部分五·顶级视角
API 是「系统间的契约」，设计质量决定整个生态。顶级全栈把 API 当**产品**经营：一致的命名、稳定的版本策略、清晰的错误码、文档（FastAPI 自动出 OpenAPI）、限流（BE15）。这思维延伸到 gRPC（BE11 强类型契约）、GraphQL（BE10 按需取）、事件/Webhook（BE14/19）。契约先行（Contract-First）是顶级标志。

### 🟠 部分六·安全/合规种子（白帽）——核心
- **输入校验是第一道防线**：所有 `request` 数据先校验类型/范围（上面 `isinstance` 检查），再进 ORM/SQL（防注入 SEC10、防崩溃）。
- **越权**：`/orders` 必须只返回「当前用户」的（BE5 session/JWT 取 user_id 过滤），否则 IDOR（SEC11）。
- **状态码别乱用**：别用 200 包错误，客户端/监控会误判。
- 红线：绝不写「绕过校验/万能管理员」的后门接口。

### ✅ 验收
交更新 `app.py`：`/api/v1/plans` 支持 `?hot=1&page=2` 分页；`POST /api/v1/orders` 校验 `plan_id`、返回 201/400/404。文字说明幂等性。

### ⚠️ 常见坑
- 用 `request.json` 而非 `get_json(silent=True)`：无效 JSON 直接 400 而非可控报错。
- 分页没做：深翻页性能塌 + 前端卡。
- 错误返回 200 + `{error:...}`：违背 REST，监控/重试逻辑误判。
- 下单没校验用户：越权/刷单。

### ➡️ 下一步
**BE10 · GraphQL（模式 / 解析器 / N+1）**——让前端「要什么字段自己点」。

### 🧪 实战 Lab（BE9）
给 `/api/v1/orders` 加「当前用户过滤」（先用 BE5 的 session `user`，演示「只能看自己的订单」）。故意用别人 order_id 访问应被拒。**验收点**：越权访问被拦截（理解 IDOR 防护）。

---

## BE10 · GraphQL（模式 / 解析器 / N+1）

### 🎯 目标
学完这节，你能说清 GraphQL 与 REST 的差异，用 Python（strawberry/graphene）搭一个最小 GraphQL 端点查套餐，并理解「解析器」和「N+1」在 GraphQL 下更突出。

### 📋 小白前置
- 方向1 编程基础（PY11 对象、PY14 装饰器）
- 本文件内：**BE8（ORM）、BE9（REST）**

### 🟢 部分一·最浅层（生活比喻）
REST 像**固定套餐**：服务员端来「套餐 A（含这些字段）」，多要少要都不行。GraphQL 像**自助点菜**：前端写「我要套餐的名字和价格，不要描述」，后端就只给这两样。好处是「不多不少」，坏处是后端得按你的点单现做。

### 🟡 部分二·动手层（逐字操作）
安装：`pip install graphene`。最小示例（独立文件 `graphql_demo.py`）：
```python
import graphene
from graphene import ObjectType, String, Int, List, Field

class PlanType(ObjectType):
    id = Int()
    name = String()
    price = Int()

class Query(ObjectType):
    plans = List(PlanType)
    def resolve_plans(self, info):           # 解析器：怎么拿到 plans
        return [{"id":1,"name":"闪电卡19","price":19},
                {"id":2,"name":"闪电卡39","price":39}]

schema = graphene.Schema(query=Query)
# 测试查询：
res = schema.execute("{ plans { name price } }")
print(res.data)
```
运行 `python graphql_demo.py` 看到只返回 name/price（你点的字段）。

### 🔵 部分三·原理层（底层发生了什么）
GraphQL 核心是**类型化的 Schema（模式）** + **Resolver（解析器）**。客户端发一个「查询字符串」声明要哪些字段；服务端按 Schema 校验，然后为每个字段调用对应 resolver 取数据，最后拼成精确结构的 JSON 返回。`{ plans { name price } }` 里 `plans` 命中 `resolve_plans`，字段 `name/price` 决定输出形状。一个查询可能触发「父查列表 + 每子项再查」→ **N+1 比 REST 更易踩**（用 DataLoader 批处理解决）。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么 GraphQL 兴起？移动端/多端要「按需取字段」省流量；前端改需求不用等后端加接口。代价：① 缓存比 REST（URL 即缓存键）难；② 限流/配额复杂（一个查询可极重）；③ N+1 突出。顶级追问：**Schema 即契约 + 强类型**，可用它**自动生成前后端类型**（FE13 提过「共享类型」）。还有 Subscription（订阅）做实时（呼应 BE19 WebSocket）。

### 🔴 部分五·顶级视角
GraphQL 是「BFF（Backend For Frontend）」的宠儿：在「多后端微服务（BE16）」前放一层 GraphQL，把聚合逻辑收口，前端只跟一个网关对话。顶级全栈懂选型：内部服务用 gRPC（BE11 强类型高性能），对前端暴露 GraphQL 聚合，对第三方用 REST（BE9 简单稳定）。**按消费者选型**是架构顶级思维。

### 🟠 部分六·安全/合规种子（白帽）
GraphQL 的攻击面：① **查询过深/过宽（DoS）**：恶意客户端发嵌套千层的查询拖垮服务器——要限制查询深度/复杂度（白帽防护）；② **字段级越权**：Resolver 里必须校验当前用户能否看该字段（如 `salary` 仅 HR 可见）；③  introspection（自省）在生产应关闭防信息泄露。红线：不暴露未授权字段、不写绕过 resolver 校验的接口。

### ✅ 验收
交 `graphql_demo.py`：运行后返回只含所点字段的数据；文字说明「解析器」与「N+1」。

### ⚠️ 常见坑
- Resolver 里忘了返回数据：字段为 null。
- 把大量计算放 Resolver 且不缓存：重复执行拖慢（用 DataLoader）。
- 生产开着 introspection：泄露 schema 给攻击者。
- 以为 GraphQL 替代了数据库：它只是「查询语言层」，底层还是要 ORM/SQL。

### ➡️ 下一步
**BE11 · gRPC（Protobuf / 流）**——服务之间用「最快的二进制电话」通话。

### 🧪 实战 Lab（BE10）
把 BE9 的「订单」也用 GraphQL 暴露：定义 `OrderType` 和 `orders` 查询，resolver 从 ORM 取。前端（FE 任意）用 `{ orders { id planId } }` 查询。**验收点**：GraphQL 能查到订单数据。

---

## BE11 · gRPC（Protobuf / 流）

### 🎯 目标
学完这节，你能说清 gRPC 是什么、和 REST/GraphQL 的差别，理解 Protobuf（协议缓冲）为何比 JSON 快，并跑通一个最小 gRPC（Python）示例。

### 📋 小白前置
- 方向1 编程基础（PY6 函数、理念：接口/契约）
- 方向4 网络（NET6 TCP、NET19 RPC/gRPC 概念）
- 本文件内：**BE9（REST）、BE10（GraphQL）**

### 🟢 部分一·最浅层（生活比喻）
REST/GraphQL 像**寄信（人类可读的 JSON 文本，慢但谁都懂）**。gRPC 像**两台机器间的高效电报**：先把「电报格式（.proto）」双方约定好，发的是压缩二进制，又快又小，但人眼看不懂。适合「服务内部高频通话」。

### 🟡 部分二·动手层（逐字操作）
安装：`pip install grpcio grpcio-tools`。先写 `hello.proto`：
```proto
syntax = "proto3";
service PlanService {
  rpc GetPlan (PlanRequest) returns (PlanReply) {}
}
message PlanRequest { int32 id = 1; }
message PlanReply { string name = 1; int32 price = 2; }
```
生成代码（终端复制）：
```bash
python -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. hello.proto
```
写 `server.py`（实现服务）与 `client.py`（调用）。示意片段：
```python
# server.py
import grpc, hello_pb2, hello_pb2_grpc
class PlanServicer(hello_pb2_grpc.PlanServiceServicer):
    def GetPlan(self, request, context):
        return hello_pb2.PlanReply(name="闪电卡19", price=19)
server = grpc.server(futures.ThreadPoolExecutor())
hello_pb2_grpc.add_PlanServiceServicer_to_server(PlanServicer(), server)
server.add_insecure_port("[::]:50051"); server.start(); server.wait_for_termination()
```
（client 用 `stub.GetPlan(hello_pb2.PlanRequest(id=1))` 调用。）运行 server 再跑 client，看到返回。

### 🔵 部分三·原理层（底层发生了什么）
`.proto` 用 **Protobuf（协议缓冲）** 定义「消息结构 + 服务接口」。`protoc` 编译出**强类型 stub 代码**（服务端骨架 + 客户端桩）。运行时，数据按 Protobuf 二进制编码（比 JSON 小 3–10 倍、序列化快），走 **HTTP/2（NET8）** 多路复用传输。gRPC 默认用 **Protocol Buffers 作为 IDL**，也支持 JSON（调试用）。调用是「方法调用感」（像本地函数），底层是 RPC（NET19）。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么内部用 gRPC？① **强契约**：`.proto` 是接口真相源，前后端/多语言自动生成代码，避免 REST 的「文档漂移」；② **高性能**：二进制 + HTTP/2 流式 + 多路复用；③ **流式（stream）**：支持服务端流/客户端流/双向流（实时场景）。顶级追问：gRPC 的「缺点」——浏览器不能直接调（需 gRPC-Web 网关），所以「对外 REST/GraphQL，对内 gRPC」（BE16 微服务经典拓扑）。

### 🔴 部分五·顶级视角
gRPC 是「服务间通信」的高性能标准，与 Thrift、Cap'n Proto 同类，与 REST/GraphQL 互补（BE9/10）。顶级全栈设计系统时长这样分层：对外 API 网关（REST/GraphQL）→ 内部微服务 gRPC → 必要时事件（BE14 Kafka）。契约优先 + 多语言生成是「大型分布式系统的可维护命脉」。

### 🟠 部分六·安全/合规种子（白帽）
示例用 `add_insecure_port`（明文，仅本机练手）。生产 gRPC 必须 **TLS 加密 + 认证（mTLS/OAuth）**，否则内部流量被嗅探/中间人。白帽：① 不把内部 gRPC 端口暴露公网；② 服务间调用也要鉴权（零信任，BE5/SEC）；③ 不写「无鉴权内部接口」当后门。

### ✅ 验收
交 `hello.proto` + `server.py` + `client.py`：client 调用得到 `name=闪电卡19, price=19`。

### ⚠️ 常见坑
- 没生成 `_pb2_grpc` 文件：漏 `--grpc_python_out=.` 参数。
- 端口被占：换 50052。
- `insecure` 端口上生产：明文泄露，必须 TLS。
- 改了 proto 没重新 `protoc`：调用对不上。

### ➡️ 下一步
**BE12 · 表单 / 文件上传（校验 / 存储安全）**——安全地收用户「填的表」和「传的文件」。

### 🧪 实战 Lab（BE11）
把「套餐服务」做成 gRPC，再写一个 REST 网关（`/api/v1/plan/<id>`）内部转调 gRPC stub，对前端暴露 REST、内部用 gRPC。**验收点**：前端 REST 请求经后端转 gRPC 拿到数据（理解网关模式）。

---

## BE12 · 表单 / 文件上传（校验 / 存储安全）

### 🎯 目标
学完这节，你能用 Flask 接收表单字段和上传文件，做严格校验（类型/大小/内容），并把文件安全存到磁盘（避免路径穿越/覆盖/执行）。

### 📋 小白前置
- 方向1 编程基础（PY9 文件读写、PY16 正则）
- 本文件内：**BE5（认证）、BE9（校验）**、前端 **FE6（表单提交）**

### 🟢 部分一·最浅层（生活比喻）
文件上传像**快递寄件**：你得查「这是什么（类型）、多重（大小）、里面是不是违禁品（内容）」。胡乱收下不明包裹，可能收到一颗「炸弹」（恶意脚本被执行）。安全存储就是「把包裹放保险柜、改个无人能猜的名字、绝不当快递员去执行它」。

### 🟡 部分二·动手层（逐字操作）
在 `app.py` 加（复制）：
```python
import os, uuid, werkzeug
from flask import request
UPLOAD = os.path.join(os.path.dirname(__file__), "uploads")
os.makedirs(UPLOAD, exist_ok=True)
ALLOWED = {".jpg", ".png", ".pdf"}     # 白名单后缀

@app.route("/upload", methods=["POST"])
def upload():
    f = request.files.get("file")
    if not f: abort(400, "无文件")
    ext = os.path.splitext(f.filename)[1].lower()
    if ext not in ALLOWED: abort(400, "类型不允许")
    if f.content_length and f.content_length > 5*1024*1024: abort(400, "超过5MB")
    # 用随机名存，避免覆盖/路径穿越
    safe_name = uuid.uuid4().hex + ext
    f.save(os.path.join(UPLOAD, safe_name))
    return jsonify({"saved": safe_name})
```
用前端 FE 表单或 `curl -F "file=@a.png"` 测试；看 `uploads/` 出现随机名文件。

### 🔵 部分三·原理层（底层发生了什么）
`request.files` 是 Flask 对 `multipart/form-data`（NET8 HTTP 表单格式）的解析结果，文件内容在内存/临时文件中。我们做三道校验：**后缀白名单**（防 `.exe/.php`）、**大小上限**（防撑爆磁盘）、**随机文件名**（`uuid` 防「`../../etc/passwd`」路径穿越 + 防同名覆盖）。存入 `uploads/` 目录，绝不放在 Web 可直接执行脚本的位置，且文件名不可预测。

### 🟣 部分四·深挖层（为什么 & 延伸）
为什么「后缀白名单 > 黑名单」？黑名单永远漏新的危险类型；白名单只放行已知安全的。顶级追问：仅凭后缀/Content-Type 不可信（可伪造），**深度防御**还应：① 校验真实文件头（magic number）；② 图片用库重绘（去恶意元数据）；③ 云存储用预签名 URL + 独立域名（避免同源 XSS 升级为 RCE）。还有「病毒扫描」「限流防滥用（BE15）」。

### 🔴 部分五·顶级视角
上传安全是「不信任输入」原则的经典战场，连通对象存储（OPS15）、CDN（NET20）、异步处理（BE14 队列做转码/扫描）。顶级全栈把上传当「不可信边界」：校验→隔离存储→异步处理→授权访问，四步缺一不可。这与「任何外部输入都是威胁」的安全思维（SEC3 信任边界）一致。

### 🟠 部分六·安全/合规种子（白帽）——核心
- 路径穿越：`../../` 改写路径读/写任意文件（严重）。用 `secure_filename` + 随机名 + 只拼进固定目录。
- 上传即执行：把 `.php/.py` 存到可执行目录 = RCE。白名单 + 非执行目录 + 独立域名。
- 拒绝服务：不限大小/数量 = 撑爆磁盘。限大小 + 限频（BE15）。
- 绝不写「允许任意路径保存」的接口（后门/漏洞）。

### ✅ 验收
交更新 `app.py`：上传合法图片成功存随机名；上传 `.exe`/超大文件被拒；说明路径穿越防护。

### ⚠️ 常见坑
- 用 `f.filename` 直接拼路径：`../../` 穿越。用 `uuid` + 固定目录。
- 只看 Content-Type：可被伪造。结合后缀白名单。
- 忘了 `os.makedirs`：目录不存在 save 报错。
- 把 uploads 放 `static/` 且含脚本：可能被执行（取决于服务器配置）。

### ➡️ 下一步
**BE13 · 缓存（Redis / CDN / 浏览器 / 模式）**——把「常问的问题」先备好答案。

### 🧪 实战 Lab（BE12）
给上传接口加「登录才能传」（复用 BE5 的 `require_login` 装饰器），并给「我的上传列表」接口（只列当前用户文件）。**验收点**：未登录被拒；登录用户能列出自己文件。

---

## BE13 · 缓存（Redis / CDN / 浏览器 / 模式）

### 🎯 目标
学完这节，你能用 Redis 给「闪电号卡」加缓存（卡品列表、套餐详情），讲清「缓存穿透 / 击穿 / 雪崩」三兄弟，并知道 CDN 与浏览器缓存分别挡在哪一层。

### 📋 小白前置
- 方向5 数据库（DB1–DB6 基本 SQL、DB10 索引）
- 本文件内：**BE1（HTTP）、BE2（Flask）、BE5（认证）**
- 方向1 编程（PY6 函数、PY9 文件）

### 🟢 部分一·最浅层（生活比喻）
缓存像**便利店冷柜**：热销的矿泉水（高频读的数据）摆在手边，不用每次跑去总仓（数据库）拿。Redis 就是那个冷柜——内存里、极快。但冷柜空间小（贵），只放最热的；总仓（DB）才是全部库存。

### 🟡 部分二·动手层（逐字操作）
装 Redis（Windows 用 WSL 或 MSYS2 的 `mingw64` 包；或 Docker：`docker run -d -p 6379:6379 redis:7`）。Python 连：
```bash
pip install redis
```
```python
import redis, json
r = redis.Redis(host="127.0.0.1", port=6379, decode_responses=True)

def get_plan(pid):
    key = f"plan:{pid}"
    cached = r.get(key)
    if cached:                      # 命中
        return json.loads(cached)
    row = db_query_plan(pid)        # 未命中 → 查库
    r.setex(key, 60, json.dumps(row))   # 写回，60 秒过期
    return row
```
验证：第一次慢（查库），60 秒内第二次快（走 Redis）。用 `redis-cli get plan:1` 看内容。

### 🔵 部分三·原理层（底层发生了什么）
请求到后端 → 先查 Redis（内存，微秒级）→ 命中直接返回，未命中查 DB（磁盘，毫秒级）并回写。Cache 把「读多写少」的热点从慢存储卸载到快存储。TTL（`setex` 的 60）保证数据最终一致（过期后重新加载新值）。

### 🟣 部分四·深挖层（为什么 & 延伸）
三大坑：① **穿透**——查不存在的 key（如 `plan:-1`），每次都打 DB。解法：缓存空值（短 TTL）或布隆过滤器。② **击穿**——某个热点 key 刚好过期，瞬间大量请求打 DB。解法：互斥锁（只放一个请求重建）或逻辑过期。③ **雪崩**——大量 key 同一时刻过期 / Redis 宕机。解法：过期时间加随机抖动、Redis 高可用（主从+哨兵）。

### 🔴 部分五·顶级视角
缓存在「读链路」无处不在：浏览器（Cache-Control）、CDN（边缘节点挡静态）、Nginx（proxy_cache）、应用（Redis）、DB 自身（buffer pool）。顶级全栈按「离用户由近到远」逐层设缓存，并想清每层的失效策略与一致性边界。

### 🟠 部分六·安全/合规种子（白帽）
- 缓存不存敏感明文（密码、身份证、token）——Redis 默认无加密，别当保险柜。
- 不缓存「别人的私有数据」后用错用户返回（越权读）。
- 生产 Redis 设密码、绑本机/内网，不暴露 `0.0.0.0:6379`（历史上有未授权访问被挖矿）。

### ✅ 验收
交 `cache_demo.py`：用 Redis 缓存卡品详情，截图「首次查库日志 + 二次命中日志」，并指出 TTL 设置与穿透防护方案。

### ⚠️ 常见坑
- Redis 没启动就连：连接拒绝。先 `redis-cli ping` 应返回 `PONG`。
- `decode_responses=False` 时取出是 bytes，json 解析报错——设 `True` 或手动 `.decode()`。
- 缓存与 DB 双写不一致：先更 DB 再删缓存（Cache-Aside 标准顺序）。
- TTL 设 0 / 负数：永不/立即过期。

### ➡️ 下一步
**BE14 · 消息队列（Kafka / RabbitMQ / 削峰）**——把「慢活」扔到后台慢慢做。

### 🧪 实战 Lab（BE13）
给「卡品列表」接口加 Redis 缓存 30 秒；模拟「缓存穿透」：连续请求一个不存在的 `plan_id`，观察是否每次都打 DB，然后加「空值缓存 10 秒」修复，再观察。

---

## BE14 · 消息队列（Kafka / RabbitMQ / 削峰）

### 🎯 目标
学完这节，你能用消息队列把「下单成功发短信」「异步生成推广海报」等慢任务解耦，理解「生产者/消费者/削峰/异步」并跑通一个本地 RabbitMQ 例子。

### 📋 小白前置
- 本文件内：**BE2（Flask）、BE13（缓存）**
- 方向1 编程（PY6 函数、PY14 多线程/异步概念）
- 方向10 运维云（OPS 基础，可选）

### 🟢 部分一·最浅层（生活比喻）
消息队列像**餐厅叫号机**：你点完单（下单）拿到号（消息入队）就能先走，后厨（消费者）按号慢慢做，高峰期也不会乱。它把「点单」和「做菜」拆开——点单快、做菜慢也不堵。

### 🟡 部分二·动手层（逐字操作）
用 Docker 起 RabbitMQ：`docker run -d -p 5672:5672 -p 15672:15672 rabbitmq:3-management`，浏览器开 `http://127.0.0.1:15672`（guest/guest 看队列）。
```bash
pip install pika
```
生产者：
```python
import pika, json
conn = pika.BlockingConnection(pika.ConnectionParameters("127.0.0.1"))
ch = conn.channel(); ch.queue_declare(queue="sms")
ch.basic_publish(exchange="", routing_key="sms",
                 body=json.dumps({"phone":"138****0000","msg":"下单成功"}))
print("已入队")
```
消费者（另开终端）：
```python
import pika, json
conn = pika.BlockingConnection(pika.ConnectionParameters("127.0.0.1"))
ch = conn.channel(); ch.queue_declare(queue="sms")
def cb(ch, m, props, body):
    data = json.loads(body); print("发送短信给", data["phone"], data["msg"])
ch.basic_consume(queue="sms", on_message_callback=cb, auto_ack=True)
ch.start_consuming()
```
先跑生产者，再跑消费者，看到「发送短信给...」。

### 🔵 部分三·原理层（底层发生了什么）
生产者把消息推到 **Broker（RabbitMQ/Kafka）** 的队列/主题；Broker 持久化后立刻返回确认（生产者不必等消费完成）；消费者从队列拉/推消息并处理。这样「下单接口」只需把消息入队（毫秒）即可返回用户，重活异步做——**削峰**：瞬时 1 万单，Broker 缓冲，消费者按自己节奏（每秒 500）消化，不压垮下游。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **解耦**：下单服务不依赖短信服务，短信挂了不影响下单。
- **可靠**：Kafka 分区+副本，消息不丢；RabbitMQ 可开 `delivery_mode=2` 持久化 + 手动 ack（处理完再 ack，崩了重投）。
- **顺序/重复**：Kafka 分区内有序；网络重传可能重复，消费要**幂等**（同一条处理多次结果一致，呼应 BE20/BE25 幂等）。
- 与缓存区别：队列为「异步任务」，缓存为「快速读」。

### 🔴 部分五·顶级视角
消息队列是分布式系统的「减震器」。顶级全栈在「写后要做多件事」（发短信、记日志、更新统计、推 ES 索引）时一律异步化；并据此设计：重试、死信队列（处理失败进死信）、消费幂等、监控积压（lag）。Kafka 还承担「事件流/日志」角色（CDC、行为埋点）。

### 🟠 部分六·安全/合规种子（白帽）
- 队列里不塞明文密码/身份证——同缓存，Broker 多无默认加密。
- 不消费「来路不明的外部消息」执行业务敏感操作（防伪造消息触发发短信轰炸）。
- RabbitMQ/Kafka 设账号密码、绑内网，不裸奔公网。

### ✅ 验收
交生产者+消费者脚本：下单接口（Flask）收到请求后把「发短信」任务入队即返回 200，消费者终端打印出任务；说明削峰与幂等设计。

### ⚠️ 常见坑
- 只跑生产者没跑消费者：消息堆在队列（正常，但看不到效果）。
- 连接被墙/端口错：确认 `5672` 通、`15672` 是管理页。
- `auto_ack=True` 崩溃丢消息：重要任务改手动 ack。
- 消费者崩循环重投：加重试上限 + 死信队列。

### ➡️ 下一步
**BE15 · 限流/熔断/降级（令牌桶/舱壁）**——给系统装「保险丝」。

### 🧪 实战 Lab（BE14）
把「生成推广海报」做成队列任务：下单成功后入队，消费者（用 BE7 的思路）模拟耗时 2 秒「生成」，观察下单接口仍秒回。再加一个消费者进程，看任务被分摊。

---

## BE15 · 限流 / 熔断 / 降级（令牌桶 / 舱壁）

### 🎯 目标
学完这节，你能给「闪电号卡」接口加限流（防刷/防压垮），理解熔断（下游挂了快失败）与降级（返回兜底），用令牌桶算法实现。

### 📋 小白前置
- 本文件内：**BE2（Flask）、BE5（认证）、BE14（队列）**
- 方向1 编程（PY6 函数、PY16 装饰器）

### 🟢 部分一·最浅层（生活比喻）
限流像**地铁早高峰限流**：每分钟只放 60 人进，多了在外面等（或劝退），防止站台挤爆。熔断像**家里保险丝**：电器短路，保险丝自己断，保住房子不烧。降级像**餐厅没菜了先送免费小菜**：主菜做不出，给个能接受的替代品，别让客人干等。

### 🟡 部分二·动手层（逐字操作）
用 Flask 限流（装 `pip install flask-limiter`）：
```python
from flask import Flask
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
app = Flask(__name__)
limiter = Limiter(get_remote_address, app=app, default_limits=["200 per hour"])

@app.route("/plans")
@limiter.limit("10 per minute")     # 该接口每分钟最多 10 次
def plans(): return {"ok": True}
```
超频访问返回 `429 Too Many Requests`。也可手写令牌桶：
```python
import time
class TokenBucket:
    def __init__(self, rate, cap): self.rate, self.cap, self.tokens, self.ts = rate, cap, cap, time.time()
    def allow(self):
        now = time.time(); self.tokens = min(self.cap, self.tokens + (now-self.ts)*self.rate); self.ts = now
        if self.tokens >= 1: self.tokens -= 1; return True
        return False
```

### 🔵 部分三·原理层（底层发生了什么）
**令牌桶**：以固定速率往桶里丢令牌（如 10/分钟），请求来了取一个令牌才放行，桶空就拒绝。它允许短时突发（桶里攒的令牌）。**熔断**：监控下游错误率，超阈值（如 50%）就「开闸熔断」——后续请求直接失败/走降级，不给已挂的下游雪上加霜；过冷却期再试探恢复。**降级**：熔断或资源不足时返回缓存/静态/默认值。

### 🟣 部分四·深挖层（为什么 & 延伸）
- 限流维度：单 IP、单用户、单接口、全局；算法还有**漏桶**（严格匀速）、**滑动窗口**（更平滑）。
- 熔断三态：Closed（正常）→ Open（熔断）→ Half-Open（试探）。经典库：Hystrix（概念）、Sentinel、Resilience4j。
- **舱壁隔离**：像船舱隔板，一个舱进水不沉船——把不同业务/依赖的资源池隔开，A 接口被冲垮不影响 B。
- 与 BE14 队列配合：限流挡入口，队列削出口压力。

### 🔴 部分五·顶级视角
可用性三件套 = 限流（控流入）+ 熔断（断故障）+ 降级（保体验）。顶级全栈在「可能被刷/可能依赖会挂」的每处都预设这三者，并配监控告警。它们共同构成「系统韧性（resilience）」，是 SRE（方向10）的核心指标（错误预算、SLO）。

### 🟠 部分六·安全/合规种子（白帽）
- 限流也是**防滥用/防攻击**手段：挡住短信炸弹、撞库、爬虫狂刷——白帽用限流保护自己系统，属防御。
- 不因限流就记录用户隐私；限流计数可匿名（IP/用户ID 哈希）。
- 绝不写「绕过限流的后门参数」。

### ✅ 验收
交代码：给某接口加令牌桶限流，用 `curl` 连发 20 次看第 11 次起返回 429；说明熔断触发条件与降级返回值。

### ⚠️ 常见坑
- 限流 key 用错（全局 key 把所有用户一起限）：应区分用户/IP。
- 多进程下内存令牌桶各算各的：分布式用 Redis 计数（`redis.incr` + `expire`）。
- 熔断阈值太低误伤：结合错误率+请求量。
- 降级返回和正常返回结构差太多：前端崩溃，降级也要可解析。

### ➡️ 下一步
**BE16 · 微服务架构（拆分/网关/配置）**——一个变多个怎么管。

### 🧪 实战 Lab（BE15）
给「登录接口」加每分钟 5 次限流（防暴力破解）；模拟下游「短信服务」报错率超 50%，实现简易熔断：连续 3 次失败后 30 秒内直接返回「服务繁忙，请稍后」降级文案。

---

## BE16 · 微服务架构（拆分 / 网关 / 配置）

### 🎯 目标
学完这节，你能说清「什么时候该拆微服务、什么时候单体够用」，理解 API 网关、服务发现、配置中心的作用，并在本地用两个 Flask 服务 + 网关演示。

### 📋 小白前置
- 本文件内：**BE2（Flask）、BE9（REST）、BE11（gRPC）、BE15（熔断）**
- 方向10 运维云（OPS 容器基础，可选）

### 🟢 部分一·最浅层（生活比喻）
单体像**一人小餐馆**：老板又做菜又收银又打扫，人少挺快。微服务像**美食城**：川菜档、奶茶档、收银台各管各的，能各自扩摊、各自招人。但美食城要「总服务台（网关）」指路、要「统一排班（配置中心）」。

### 🟡 部分二·动手层（逐字操作）
起两个服务 + 一个网关（全用 Flask 演示）：
```python
# 服务A: 用户 端口 5001
from flask import Flask, jsonify
app = Flask(__name__)
@app.route("/user/<uid>")
def user(uid): return jsonify({"uid": uid, "name": "泽泽"})

# 服务B: 订单 端口 5002
@app.route("/order/<oid>")
def order(oid): return jsonify({"oid": oid, "amt": 19})

# 网关 端口 5000
import requests
gw = Flask(__name__)
@gw.route("/api/<svc>/<path:p>")
def proxy(svc, p):
    base = {"user": "http://127.0.0.1:5001", "order": "http://127.0.0.1:5002"}[svc]
    return requests.get(f"{base}/{p}").json()
```
跑三个进程，访问 `http://127.0.0.1:5000/api/user/1` 由网关转发到 A。

### 🔵 部分三·原理层（底层发生了什么）
网关（API Gateway）是**唯一对外入口**：统一鉴权（BE5）、限流（BE15）、路由（把 `/api/user/*` 转到用户服务）。服务间用 REST/gRPC（BE11）通信；**服务发现**让服务互相找到地址（开发期写死，生产用 Consul/Nacos/K8s DNS）；**配置中心**集中管理开关/参数，改了不用重新发版。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **拆分边界**：按业务域（DDD 限界上下文），别按技术层乱切。拆太细 = 分布式单体（更糟）。
- **代价**：网络调用变多（延迟、故障面）、数据一致性难（跨服务事务用 Saga/最终一致）、运维陡增。
- 单体→微服务的真实信号：团队大了、某模块要独立扩容、技术栈要分、部署互相拖累。否则**先单体，后演进**。
- 通信：同步 REST/gRPC + 异步消息（BE14）。

### 🔴 部分五·顶级视角
架构选型是「权衡」不是「追新」。顶级全栈先问：团队规模？迭代频率？扩展瓶颈在哪？再决定单体还是微服务。微服务配套「可观测三件套（日志/指标/链路 BE21）+ 容器编排（BE23）+ 服务网格」才完整，否则只是把复杂度从代码搬到运维。

### 🟠 部分六·安全/合规种子（白帽）
- 网关是**统一安全闸**：鉴权、限流、WAF 都放这，别让后端服务裸奔直连公网。
- 服务间调用也要鉴权（mTLS/内部 token），别信「内网就安全」（横向移动风险）。
- 配置中心别存明文密钥——用 Vault/环境变量（BE23）。

### ✅ 验收
交三个 Flask 文件：网关转发 user/order 两服务成功；口头说明「网关承担鉴权/限流」与「何时不该拆微服务」。

### ⚠️ 常见坑
- 网关用 `requests.get` 不带超时：后端卡死拖垮网关——加 `timeout=2`。
- 服务地址写死：扩成多实例就失效，需服务发现。
- 拆分过细：一次下单跨 8 个服务调用，延迟爆炸。
- 把密钥提交进代码仓库：用 `.env` + `.gitignore`。

### ➡️ 下一步
**BE17 · Serverless（函数/事件/冷启动）**——连服务器都不用管。

### 🧪 实战 Lab（BE16）
给网关加一层「统一鉴权」：只有带正确 `?token=xxx` 的才能转发，否则 401；再让 user 服务「故意延迟 3 秒」，观察网关加 `timeout` 后返回 504 的处理。

---

## BE17 · Serverless（函数 / 事件 / 冷启动）

### 🎯 目标
学完这节，你能说清 Serverless（FaaS）是什么、冷启动为何慢、适合什么场景（事件驱动小任务），并用本地工具或云函数写一个「上传图片自动缩略图」的函数。

### 📋 小白前置
- 本文件内：**BE2（Flask）、BE14（队列/事件）**
- 方向10 运维云（OPS 基础、Docker）

### 🟢 部分一·最浅层（生活比喻）
传统服务器像**包月出租车**（不管用不用都付钱、要自己保养）。Serverless 像**网约车按次计费**：来单了平台派辆车（临时起一个函数实例）送你，送完车收回去。没人叫车就没有车——省钱，但「叫车那一下」要等车来（冷启动）。

### 🟡 部分二·动手层（逐字操作）
概念演示（本地用 `python-lambda-local` 或 AWS SAM，云上用阿里云/腾讯云函数）。一个「缩略图函数」伪代码：
```python
def handler(event, context):
    # event 是触发事件（如 OSS 上传通知），含 bucket/key
    img = download(event["key"])
    thumb = resize(img, 200, 200)
    upload(thumb, "thumb-" + event["key"])
    return {"status": "ok"}
```
本地用 Docker 模拟事件触发：`docker run -e EVENT='{"key":"a.png"}' my-func`。云上绑定「对象存储上传」事件即自动触发。

### 🔵 部分三·原理层（底层发生了什么）
云厂商按**事件**（HTTP 请求、文件上传、定时、队列消息）拉起函数实例执行 `handler`，执行完冻结/回收。你只为「执行时长×内存」付费。**冷启动**：首次或闲置后调用，需下载代码、起运行时（如 Python 解释器）、初始化——几百毫秒到数秒；热实例复用则快。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **适合**：突发/低频/事件驱动（图片处理、Webhook、定时任务、IoT  ingestion）。
- **不适合**：长连接（WebSocket BE19）、常驻有状态、超低延迟高频——这时还是常驻服务/容器。
- 限制：执行时长上限（分钟级）、临时磁盘、无持久状态（状态放 DB/对象存储）。
- 厂商锁定：各家 API 不同，可用 Serverless Framework / 容器化减绑。

### 🔴 部分五·顶级视角
Serverless 把「运维服务器」彻底交给云厂，团队只写业务逻辑。顶级全栈把它当作「架构工具箱一格」：对合适的异步小任务用它降本，对核心常驻服务用容器（BE23）。关键认知——**不是没有服务器，是你不用管服务器**。

### 🟠 部分六·安全/合规种子（白帽）
- 函数权限遵循最小权限（别给函数「删库」权限）。
- 事件源要验真（防伪造事件触发你的函数干坏事/烧钱）。
- 函数日志可能含敏感数据，注意脱敏（呼应 BE21）。

### ✅ 验收
交一个 Serverless 函数示例（伪代码或云平台截图）：说明触发事件、冷启动成因、适合/不适合场景。

### ⚠️ 常见坑
- 把状态放函数内存：实例回收就没了——状态外置。
- 冷启动慢被用户感知：用「预置并发/常驻实例」缓解（要加钱）。
- 函数里写死密钥：用云厂商密钥管理。
- 无限递归触发（函数触发自己）：烧钱，设并发上限。

### ➡️ 下一步
**BE18 · 搜索集成 ES（索引/查询）**——商品怎么被搜到。

### 🧪 实战 Lab（BE17）
用本地一个 Python 函数模拟「上传即处理」：监听某目录（`watchdog` 库），新图片进来自动生成 200×200 缩略图存 `thumb/`。说明这和云函数事件触发的对应关系。

---

## BE18 · 搜索集成 ES（索引 / 查询）

### 🎯 目标
学完这节，你能用 Elasticsearch 给「闪电号卡」的卡品/文章做全文搜索（支持中文分词），理解倒排索引、mapping、查询 DSL。

### 📋 小白前置
- 方向5 数据库（DB1–DB6 SQL、DB10 索引概念）
- 本文件内：**BE2（Flask）、BE13（缓存）**

### 🟢 部分一·最浅层（生活比喻）
数据库 LIKE 搜索像**逐页翻书找词**——慢。ES 像**书末的索引页**：预先记下「每个词出现在哪几页」，你查「5G」，它直接翻到对应页。这个「索引页」就是**倒排索引**。

### 🟡 部分二·动手层（逐字操作）
起 ES（Docker：`docker run -d -p 9200:9200 -e "discovery.type=single-node" elasticsearch:8.13.4`，注意给够内存）。装客户端 `pip install elasticsearch`。
```python
from elasticsearch import Elasticsearch
es = Elasticsearch("http://127.0.0.1:9200")
# 建索引（中文用 ik 分词插件，或用 standard + 拼音）
es.indices.create(index="plans", ignore=400)
es.index(index="plans", id=1, document={"name": "闪电卡19元5G版", "desc": "月租19元含5G流量"})
# 搜索
res = es.search(index="plans", query={"match": {"name": "5G"}})
print([h["_source"] for h in res["hits"]["hits"]])
```
浏览器开 `http://127.0.0.1:9200/_search?q=5G` 也能查。

### 🔵 部分三·原理层（底层发生了什么）
ES 把文档分词（中文需 IK 分词器）成 term，建**倒排索引**：`5G -> [doc1, doc3]`。查询时先查索引拿到文档 ID，再取回原文。它分布式的本质（分片+副本）让它扛得住海量全文检索，比 `LIKE '%x%'` 的全表扫描快几个数量级。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **mapping**：字段类型定义（text 分词、keyword 不分词、date、nested），定错类型查不出。
- 查询丰富：match（分词）、term（精确）、bool（must/should/filter 组合）、range、聚合（facet 统计）。
- 与 DB 分工：DB 是「源头真值（CRUD）」，ES 是「搜索视图」——数据写 DB 后同步（BE14 队列）到 ES 建索引。
- 中文分词质量直接决定搜索好不好用（IK / jieba）。

### 🔴 部分五·顶级视角
搜索是「读体验」的高频刚需。顶级全栈把「写库→同步索引→查询走 ES」做成标准管线，并关注：索引重建策略、近实时（refresh interval）、聚合分析（运营看板）、与向量检索（方向9 embedding 相似搜）融合的趋势。

### 🟠 部分六·安全/合规种子（白帽）
- ES 默认无认证且曾大量裸奔公网导致数据泄露——**必须设密码/绑内网**。
- 搜索接口防「注入式查询」：用参数化 DSL，不拼用户输入进查询字符串。
- 不索引不该被搜到的私密字段（身份证、手机号）。

### ✅ 验收
交脚本：建 `plans` 索引、写入 3 条卡品、用中文关键词（如「5G」「流量」）搜出正确结果；说明倒排索引。

### ⚠️ 常见坑
- ES 8 默认开安全（需 username/password + https）：本地练手可 `xpack.security.enabled=false`（仅本机）。
- 中文不分词搜不出：装 IK 插件或换分词器。
- mapping 在索引建后不可改类型：先删再建或建新字段。
- 忘了同步：DB 改了 ES 还是旧的——用队列（BE14）保证最终一致。

### ➡️ 下一步
**BE19 · WebSocket 实时（推送/心跳）**——双向实时通信。

### 🧪 实战 Lab（BE18）
给「卡品搜索」做高亮：查询加 `highlight={"fields": {"name": {}}}`，返回时关键词被 `<em>` 包住，前端 FE 显示高亮。

---

## BE19 · WebSocket 实时（推送 / 心跳）

### 🎯 目标
学完这节，你能用 WebSocket 给「闪电号卡」做「订单状态实时推送」（下单后不用刷新，前端自动更新「已发货」），区分它与 HTTP 长轮询。

### 📋 小白前置
- 本文件内：**BE1（HTTP）、FE6（DOM/事件）、BE2（Flask）**
- 方向4 网络（NET6 TCP、NET8 HTTP 长连接）
- 方向1 编程（PY6 函数、PY14 并发）

### 🟢 部分一·最浅层（生活比喻）
HTTP 像**寄信**：你写一封问「发货没？」，对方回一封「发了」。想再问得再寄。WebSocket 像**打电话**：接通后两人一直在线，对方状态一变（「发啦！」）立刻说给你听，不用你反复打。

### 🟡 部分二·动手层（逐字操作）
Flask 用 `pip install flask-sock`：
```python
from flask import Flask, render_template_string
from flask_sock import Sock
app = Flask(__name__); sock = Sock(app)

@sock.route("/ws")
def echo(ws):
    while True:
        msg = ws.receive()            # 收到前端消息
        if msg == "ping": ws.send("pong")
        else: ws.send(f"服务器收到：{msg}")

@app.route("/")
def index():
    return render_template_string("""
    <script>
      const ws = new WebSocket("ws://"+location.host+"/ws");
      ws.onmessage = e => console.log("收到", e.data);
      ws.onopen = () => ws.send("你好");
    </script>""")
```
浏览器开页面，控制台看到「收到 服务器收到：你好」。

### 🔵 部分三·原理层（底层发生了什么）
HTTP 是「请求-响应」单向、无状态（BE1）。WebSocket 在 HTTP 握手后**升级协议**（Upgrade 头），变成一条**全双工 TCP 长连接**（NET6），之后客户端服务端随时互发帧，不必每次带 HTTP 头。服务端可主动推（订单状态变 → 推前端）。**心跳**：定期发小包（ping/pong）保活、探测断线。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **长轮询** vs **WebSocket**：轮询是「不断寄信问」，浪费带宽/延迟高；WS 是「一直在线」。但 WS 占连接（服务器并发连接数是资源）。
- **断线重连**：网络抖动画前端要自动重连 + 补拉状态。
- **水平扩展**：WS 连接绑在某台机器，多实例需「连接注册中心」（如 Redis 发布订阅 / BE14 消息）才能跨机推。
- 安全：WS 也要鉴权（握手时验 token）、`wss://`（TLS 加密，同 HTTPS）。

### 🔴 部分五·顶级视角
实时性需求分档：低频状态用轮询/Server-Sent Events 足够；高频双向（聊天、行情、协作）用 WebSocket；超大规模用专业消息中间件（BE14）。顶级全栈据「延迟要求/连接数/方向性」选协议，并默认 `wss` + 鉴权 + 心跳。

### 🟠 部分六·安全/合规种子（白帽）
- WS 握手也要鉴权，否则任何人能连上收推送（信息泄露）。
- 用 `wss://`（TLS），明文 `ws://` 在公网被窃听。
- 限制单连接消息频率（防利用 WS 做放大/耗尽）——呼应 BE15 限流。
- 不推送他人私有数据给错误连接（越权推送）。

### ✅ 验收
交代码：Flask + WS，前端连上后发消息收到回显；另写「服务端订单状态变化时推送」的伪代码逻辑。

### ⚠️ 常见坑
- 浏览器 `ws://` 在 `https` 页面被拦：混用协议报错，统一 `wss`。
- 忘了心跳：代理/NAT 超时断开，前端无感知——加重连+ping。
- 多 worker（gunicorn）下连接分散：推不到——用 Redis 广播。
- 前端没 `onopen` 就 `send`：连接未建立报错。

### ➡️ 下一步
**BE20 · 支付/第三方（回调/幂等/对账）**——钱的事最不能错。

### 🧪 实战 Lab（BE19）
把「订单状态推送」做实：下单（BE2 接口）后，模拟状态变为「已发货」，通过 WS 推给对应连接的前端，前端弹出提示（不用刷新页面）。

---

## BE20 · 支付 / 第三方（回调 / 幂等 / 对账）

### 🎯 目标
学完这节，你能设计「支付回调」接口，保证**幂等**（同一笔钱不会重复入账/发货），理解签名验真与每日对账，这是电商最不能出错的一环。

### 📋 小白前置
- 本文件内：**BE2（Flask）、BE5（认证）、BE9（REST）、BE19（WS）**
- 方向5 数据库（DB1–DB6 事务/唯一约束）

### 🟢 部分一·最浅层（生活比喻）
支付回调像**外卖小哥敲门说「钱收到啦」**。但小哥可能敲两次门（网络重试），或是个**假小哥**（伪造回调）。你得：① 认出是真小哥（**验签**）；② 同一个订单只发货一次（**幂等**）；③ 每晚对账，确认平台账和银行账一致。

### 🟡 部分二·动手层（逐字操作）
回调接口（伪代码，用真实支付需官方 SDK + 密钥，这里只讲结构）：
```python
import hashlib, hmac, json
@app.route("/pay/callback", methods=["POST"])
def pay_callback():
    data = request.get_json()
    # 1) 验签：用平台公钥/密钥校验 signature 字段，防伪造
    if not verify_sign(data, secret): return "sign error", 400
    order_id = data["out_trade_no"]; amount = data["total_fee"]
    # 2) 幂等：用订单号做唯一约束，重复回调不重复处理
    with db.transaction():
        if OrderPaid.exists(order_id):          # 已处理过
            return "success"                    # 直接返回成功，不重复发货
        mark_paid(order_id, amount)             # 记账 + 触发发货(WS/BE19)
    return "success"
```
签名验证（HMAC 示例）：`hmac.new(secret, canonical_str, sha256).hexdigest()` 与回调带的 `sign` 比对。

### 🔵 部分三·原理层（底层发生了什么）
用户支付后，支付平台**异步**向你配置的回调 URL `POST` 结果（不在用户浏览器同步流程里，所以不可被用户篡改）。你需：验签（确认确实来自平台、未被改）→ 查本地订单 → 用**数据库唯一约束/状态机**保证「同一 `out_trade_no` 只生效一次」→ 返回 `success` 让平台停止重试。若你返回非 success，平台会按策略**重试多次**，所以幂等是硬要求。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **幂等实现三法**：① 唯一索引（`out_trade_no` UNIQUE，插入失败即重复）；② 状态机（已支付不可再置已支付）；③ 去重表（记录已处理 ID）。本例用状态机+存在性判断。
- **对账**：每日拉平台账单，与本地订单逐笔比对，差异告警（少发的、多发的、金额不符的）。这是财务兜底。
- **退款/部分退款**：状态机要能表达，且退款也走幂等。
- 与安全：回调 URL 必须 HTTPS、必须验签、绝不信任回调里的「成功」字样而不验。

### 🔴 部分五·顶级视角
「钱」相关的系统，正确性与可审计性 > 性能。顶级全栈把支付当**状态机 + 幂等 + 对账 + 审计日志**四件套：任何一步都要能解释「这笔钱为什么这样动、谁动的、对不对得上」。这也正是你「闪电号卡」佣金结算（零扣量逐单对账）的同源思维。

### 🟠 部分六·安全/合规种子（白帽）——核心
- 回调**必须验签**：否则攻击者可伪造「支付成功」白嫖发货。
- 绝不信任客户端传的「已支付」状态——以服务端回调+验签为准。
- 金额以回调服务端返回为准，不以前端传的为准（防改价）。
- 支付密钥/证书存密钥管理（BE16），不进代码库。
- 只对接**持牌支付机构**；不碰任何二清/资金池灰产。

### ✅ 验收
交回调接口代码：含验签占位 + 幂等（重复回调第二次直接返回 success 不重复记账）；说明对账怎么做。

### ⚠️ 常见坑
- 没幂等：平台重试 → 重复发货/重复加钱。最致命。
- 只在前端标「支付成功」：被刷。
- 验签字符串拼接顺序错：一直验不过（按平台规范 canonical）。
- 回调处理超时平台判定失败重试：处理要快/异步（BE14 接队列）。

### ➡️ 下一步
**BE21 · 日志/监控/链路（结构化/追踪）**——系统病了怎么知道。

### 🧪 实战 Lab（BE20）
用 SQLite 建 `orders(out_trade_no UNIQUE, status, amount)`，写回调处理函数：第一次回调 `mark_paid` 成功，第二次同 `out_trade_no` 因唯一约束/状态判断直接返回 success；用 `curl` 连发两次验证不重复记账。

---

## BE21 · 日志 / 监控 / 链路（结构化 / 追踪）

### 🎯 目标
学完这节，你能给「闪电号卡」加结构化日志、基础指标（QPS/错误率/耗时）和链路追踪（一个请求跨服务怎么追），知道「系统出问题怎么定位」。

### 📋 小白前置
- 本文件内：**BE2（Flask）、BE16（微服务）**
- 方向10 运维云（OPS 监控基础）
- 方向1 编程（PY6 函数）

### 🟢 部分一·最浅层（生活比喻）
日志像**飞机的黑匣子**：出事了回放才知道哪步异常。监控像**汽车仪表盘**：时速/油量实时看，异常亮红灯。链路追踪像**快递单号**：一个包裹（请求）经过哪些分拣中心（服务），每个花了多久，一眼看清卡在哪。

### 🟡 部分二·动手层（逐字操作）
结构化日志（装 `pip install structlog`）：
```python
import structlog, time
log = structlog.get_logger()
def handle(uid):
    t0 = time.time()
    log.info("order.start", uid=uid, sku="plan19")   # 结构化：机器易解析
    # ...业务...
    log.info("order.done", uid=uid, cost_ms=int((time.time()-t0)*1000))
```
本地看文件；生产发到 Elasticsearch/Loki（BE18）+ Grafana。指标用 Prometheus 风格：在 Flask 用 `prometheus-client` 暴露 `/metrics`（请求数、耗时直方图）。链路追踪用 `opentelemetry` 给每个请求生成 `trace_id`，跨服务传递。

### 🔵 部分三·原理层（底层发生了什么）
**结构化日志**（JSON 而非纯文本）让机器能按字段检索（「查所有 uid=1 的 order.done」）。**指标**是聚合计数（QPS=每秒请求数、P99 耗时=99% 请求快于该值、错误率）。**链路追踪**：请求进网关生成 `trace_id`，每跳服务都带它，上报到 Jaeger/Tempo，拼出调用链瀑布图，定位慢在哪一环。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **SLI/SLO/SLA**：SLI 是指标（如可用性 99.9%），SLO 是目标，错误预算消耗完就停更（BE15 韧性同源）。
- **采样**：全量追踪太贵，按比例采样。
- **告警**：指标越阈值（错误率>1%、P99>1s）触发告警（钉钉/飞书/邮件），但避免告警疲劳（只告真紧急的）。
- **可观测性三支柱**：日志（发生了什么）+ 指标（多频繁/多严重）+ 追踪（卡在哪）。

### 🔴 部分五·顶级视角
「能跑」≠「能运维」。顶级全栈从第一天就埋可观测性：没有日志/指标的系统是黑盒，出问题只能瞎猜。它与 BE15 韧性、BE23 部署、方向10 SRE 构成「生产就绪（production-ready）」铁三角。

### 🟠 部分六·安全/合规种子（白帽）
- **日志脱敏**：绝不记明文密码、身份证、token、完整卡号——记哈希/后四位。
- 日志可能含用户隐私，受个保法/GDPR 约束，留存期限要合规、可删除。
- 监控面板别暴露到公网未授权（曾有误配泄露内部拓扑）。

### ✅ 验收
交脚本：用 structlog 输出结构化订单日志（含 `cost_ms`），并说明你要监控哪 3 个指标、出问题怎么用 trace_id 定位。

### ⚠️ 常见坑
- `print` 当日志：无法检索、无级别、无上下文。
- 记了明文密码：合规事故。
- 指标维度爆炸（每用户一个 series）：撑爆存储——聚合/采样。
- 告警太多没人看：只保留可行动的告警。

### ➡️ 下一步
**BE22 · 测试（单元/集成/e2e/TDD）**——怎么证明没写崩。

### 🧪 实战 Lab（BE21）
给 BE2 的 `app.py` 加一个 `/metrics` 接口统计「/plans 被访问次数」，用 `structlog` 在每次请求记一行 JSON 日志（脱敏后）；用 `curl` 打几次看计数与日志。

---

## BE22 · 测试（单元 / 集成 / e2e / TDD）

### 🎯 目标
学完这节，你能给「闪电号卡」写单元测试（pytest）、接口集成测试、端到端测试，理解 TDD（先写测试再写实现）与测试金字塔。

### 📋 小白前置
- 本文件内：**BE2（Flask）、BE5（认证）、BE9（REST）**
- 方向1 编程（PY6 函数、PY22 测试基础）

### 🟢 部分一·最浅层（生活比喻）
测试像**出厂质检**：零件自己合格（单元）、装一起能通电（集成）、整机按用户流程跑一遍（e2e）。TDD 像**先写验收标准再干活**——先列「这功能必须这样才算对」，再写代码去满足它。

### 🟡 部分二·动手层（逐字操作）
装 `pip install pytest`。单元测试（被测函数无 Flask 依赖时）：
```python
# test_calc.py
def discount(price, vip):
    return price * 0.9 if vip else price
def test_discount():
    assert discount(100, True) == 90
    assert discount(100, False) == 100
```
Flask 接口测试（用 `pytest` + `flask.test_client`）：
```python
def test_plans(client):
    r = client.get("/plans")
    assert r.status_code == 200
    assert "闪电" in r.get_json()["name"]   # 假设返回含字段
```
跑：`pytest -q`。TDD 流程：先写 `test_discount` 红（失败）→ 写 `discount` 绿（通过）→ 重构。

### 🔵 部分三·原理层（底层发生了什么）
**单元测试**测最小函数（快、多、隔离，可用 mock 替掉外部依赖如 DB/网络）。**集成测试**测多组件协作（如「请求经 Flask→查库→返回」）。**e2e** 用真实浏览器/HTTP 跑完整用户路径（慢、少、贵，如 Playwright 自动点页面）。`test_client` 是 Flask 不启真实端口的「内存请求」，快且接近真实。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **测试金字塔**：海量单元 + 适量集成 + 少量 e2e（倒三角），别反过来（e2e 太多慢且脆）。
- **覆盖率**：`pytest --cov` 看行覆盖，但高覆盖≠高正确（要测边界/异常，不只 happy path）。
- **Mock/打桩**：替掉慢/不可控依赖（时间、网络、支付 BE20 回调），专注被测逻辑。
- **CI**：测试自动跑（方向10 流水线），合代码前必须全绿。
- TDD 好处：逼你想清接口与边界，重构有安全网。

### 🔴 部分五·顶级视角
测试是「对变更的恐惧的解药」。顶级全栈把测试当**交付的一部分**（没测试的代码不算完成），用 CI 卡质量门禁，用 e2e 护核心链路（如下单/支付）。这与「零扣量逐单对账（闪电号卡 M5）」同属「用自动化保证正确性」的工程文化。

### 🟠 部分六·安全/合规种子（白帽）
- 测试别用**真实用户隐私/生产数据**（含身份证号等）——用脱敏假数据。
- 测试环境密钥与生产的隔离，别在测试里硬编码生产凭证。
- 测试账号只用于测试，不用来做真实业务（防越权/误操作）。

### ✅ 验收
交 `test_*.py`：至少一个纯函数单测 + 一个 Flask 接口测试（用 `test_client`），`pytest` 全绿；说明 TDD 顺序与测试金字塔。

### ⚠️ 常见坑
- 只测正常路径：边界/异常（空值、超长、负数）最易藏 bug。
- `test_client` 没建好 app/上下文：404/500——确保在 `@pytest.fixture` 里 `app.test_request_context`。
- 测试间互相污染（共享 DB 状态）：用 fixture 清空/回滚。
- 追求 100% 覆盖而写无意义测试：覆盖行为不是行数。

### ➡️ 下一步
**BE23 · 部署（Nginx / Docker / K8s / HTTPS）**——怎么上线给人用。

### 🧪 实战 Lab（BE22）
给「折扣计算」用 TDD：先写测试（VIP 9 折、非 VIP 不打折、负数价格抛异常），再写实现让全绿；再加一个 Flask `/checkout` 接口测试（下单返回 200 且含订单号）。

---

## BE23 · 部署（Nginx / Docker / K8s / HTTPS）

### 🎯 目标
学完这节，你能把「闪电号卡」后端打包成 Docker 镜像、用 Nginx 做反向代理 + HTTPS，说清 K8s 解决什么问题（不必亲手搭全套）。

### 📋 小白前置
- 本文件内：**BE2（Flask）、BE22（测试）**
- 方向10 运维云（OPS Docker/K8s 基础）
- 方向4 网络（NET8 HTTPS/TLS 概念）

### 🟢 部分一·最浅层（生活比喻）
部署像**开店营业**：代码是「菜谱」，Docker 是「标准化餐车」（到哪都能原样跑），Nginx 是「门口引路员+保安」（分流转给后厨、拦坏人、上 HTTPS 加密门），K8s 是「连锁店总调度」（哪店忙就加车、挂了自动换一家）。

### 🟡 部分二·动手层（逐字操作）
Dockerfile：
```dockerfile
FROM python:3.13-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "app:app"]
```
构建运行：`docker build -t lightning-be . && docker run -d -p 8000:8000 lightning-be`。
Nginx 反向代理（片段）：
```nginx
server {
    listen 443 ssl;
    ssl_certificate     /etc/nginx/cert/fullchain.pem;   # Let's Encrypt
    ssl_certificate_key /etc/nginx/cert/privkey.pem;
    location / { proxy_pass http://127.0.0.1:8000; }
}
```
HTTPS 证书用 `certbot`（Let's Encrypt）免费申请。

### 🔵 部分三·原理层（底层发生了什么）
**Docker** 把代码+依赖+运行环境打进镜像，保证「我机器能跑你机器也能跑」（消除环境差）。**Nginx** 在公网前：终止 TLS（HTTPS）、把请求 `proxy_pass` 给后端、还能做静态文件/负载均衡/限流。**HTTPS/TLS** 加密传输防窃听篡改（NET8）。**K8s** 编排容器：自动扩缩容、健康检查、滚动更新、故障自愈——解决「很多容器怎么管」。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **12 因子**：配置走环境变量（BE16 配置中心）、无状态进程、日志走 stdout——为云原生铺路。
- **CI/CD**：push 代码→自动测试(BE22)→构建镜像→部署（方向10 流水线）。
- **蓝绿/金丝雀发布**：先放一小部分流量验证再全量，出错秒回滚。
- **K8s 不是银弹**：小项目单机 Docker + Nginx 足够，别为了用而用（呼应 BE16 架构权衡）。

### 🔴 部分五·顶级视角
部署是「代码变成服务」的最后一公里，也是**安全边界**最集中处。顶级全栈把部署当作产品一部分：HTTPS 默认开、密钥不进镜像（用 Secret）、最小暴露面（只开 443/80，后端绑内网）、监控告警（BE21）跟上、回滚预案备好。

### 🟠 部分六·安全/合规种子（白帽）——核心
- **HTTPS 必须**：明文 HTTP 传密码/卡信息 = 被窃听。Let's Encrypt 免费。
- 镜像别 `COPY` 进 `.env` 密钥：用运行时 Secret/环境变量注入。
- Nginx 关多余模块、设安全头（HSTS、X-Frame-Options、CSP 呼应 SEC Web 安全）。
- 后端绑 `127.0.0.1`/内网，只让 Nginx 转发，绝不 `0.0.0.0` 裸奔公网。
- 只部署自己有权部署的服务；不碰他人服务器/账号（白帽红线）。

### ✅ 验收
交 Dockerfile + Nginx 配置片段：说明镜像如何保证环境一致、HTTPS 作用、K8s 解决的三件事（扩缩容/自愈/发布）。

### ⚠️ 常见坑
- 镜像里硬编码密钥：泄露风险——用 Secret。
- 后端 `0.0.0.0:8000` 直接暴露公网：绕过 Nginx 安全层。
- 证书过期没自动续（certbot 忘设定时）：网站变「不安全」。
- `gunicorn -w` 进程间状态不共享：会话/缓存用外部（Redis BE13）。

### ➡️ 下一步
**BE24 · 性能调优（剖析/数据库/缓存）**——慢了怎么快。

### 🧪 实战 Lab（BE23）
写 Dockerfile 把 BE2 的 `app.py` 打包；本地 `docker run` 起来，`curl` 访问 8000 端口返回正常；说明若上线，Nginx 该监听 443 并把 `/` 转发到这个容器。

---

## BE24 · 性能调优（剖析 / 数据库 / 缓存）

### 🎯 目标
学完这节，你能用剖析器定位「闪电号卡」慢在哪（CPU/IO/DB），用索引/缓存/并发把接口提速，理解「先量再优化」。

### 📋 小白前置
- 本文件内：**BE2（Flask）、BE13（缓存）、BE21（监控）**
- 方向5 数据库（DB10 索引、DB12 慢查询）
- 方向3 底层（COMP 性能/CPU 概念）

### 🟢 部分一·最浅层（生活比喻）
调优像**给车做体检**：先上测功机看哪缸无力（剖析定位瓶颈），别一上来就全车换件（乱优化）。多数系统慢在「反复跑仓库取同一批货」（DB 没索引/没缓存）——加上索引、放上缓存，立竿见影。

### 🟡 部分二·动手层（逐字操作）
Python 剖析（找慢函数）：
```python
import cProfile, pstats
def main(): ...
cProfile.run("main()", "prof.out")
p = pstats.Stats("prof.out"); p.sort_stats("cumtime").print_stats(10)
```
Web 接口层用 Flask 中间件记 `cost_ms`（BE21）。DB 慢查用 `EXPLAIN`（方向5 DB12）；加索引：
```sql
CREATE INDEX idx_plans_price ON plans(price);
```
缓存热点（BE13）：把「套餐列表」Redis 缓存 30 秒。并发压测：`pip install locust`，写脚本模拟 100 用户访问 `/plans` 看 QPS 与 P99。

### 🔵 部分三·原理层（底层发生了什么）
性能瓶颈通常三类：**CPU**（算法/序列化慢，靠剖析+算法优化）、**IO/网络**（等 DB/外部 API，靠缓存/连接池/异步 BE14）、**锁/竞争**（并发改写，靠减锁/无锁结构）。剖析器告诉你「时间花在哪一行」，避免凭感觉优化。**阿姆达尔定律**：优化占比小的地方收益有限，先打最热的 1%。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **测量优先**：没有 baseline 的优化是耍流氓；用 BE21 的指标看前后对比。
- DB 优化链：加索引→避免 N+1（ORM 预加载 BE8）→读写分离→分库分表（量大时）。
- **连接池**（BE7）：避免每次建连开销。
- **缓存击穿/雪崩**（BE13）是性能与正确性的交叉点。
- 前端也调优：首屏/懒加载（FE14）、CORE WEB VITALS。

### 🔴 部分五·顶级视角
「先让它对，再让它快，且只优化测得出的瓶颈」。顶级全栈把性能当**可量化目标**（P99<200ms、QPS>1000），用剖析+监控闭环优化，不被「听说 XX 快」带节奏。性能、正确性（BE20 幂等）、韧性（BE15）三者要一起看，不能为了快牺牲正确/稳。

### 🟠 部分六·安全/合规种子（白帽）
- 压测只对自己系统/授权环境，绝不对外面网站做压力测试（=DoS 攻击，违法）。
- 调优别为快而关安全（如关 HTTPS、关验签）。
- 缓存敏感数据需加密（BE13 合规）。

### ✅ 验收
交：用 cProfile 或 Flask 计时定位一个慢点；对「套餐列表」接口演示「加索引/加缓存前后」耗时对比（可用 `time` 测）。

### ⚠️ 常见坑
- 凭感觉优化：忙半天改了不热的地方，没用的。
- 加了索引但查询没走（函数包字段 `WHERE YEAR(t)=..` 索引失效）——看 `EXPLAIN`。
- 缓存后忘了失效：数据更新了页面还是旧的。
- 压测打挂自己机器：控制好并发数。

### ➡️ 下一步
**BE25 · 系统设计题（短链/feed/限流器设计）**——面试+实战都考的设计力。

### 🧪 实战 Lab（BE24）
对「卡品列表」接口：先无缓存测耗时（连查 DB），加 Redis 缓存（BE13）后重测，记录前后 `cost_ms` 对比；说明若 DB 慢查用 `EXPLAIN` 看是否走索引。

---

## BE25 · 系统设计题（短链 / feed / 限流器设计）

### 🎯 目标
学完这节，你能用前面所学（HTTP/BE1、DB/方向5、缓存/BE13、队列/BE14、限流/BE15、一致性/BE20）拆解经典系统设计题，给出「需求→组件→取舍」的思路，而不背答案。

### 📋 小白前置
- 本文件内：BE1/BE9/BE13/BE14/BE15/BE20/BE23 全部
- 方向5 数据库（DB 分库分表/索引）、方向4 网络、方向2 算法（哈希/布隆）

### 🟢 部分一·最浅层（生活比喻）
系统设计像**盖楼前的方案汇报**：先问清楚「多高、多少人住、预算多少」（需求与量级），再定「用啥材料、几部电梯、消防怎么走」（组件与取舍）。没有需求就画图 = 瞎设计。

### 🟡 部分二·动手层（逐字操作）
以「短链系统（t.cn/abc）」为例，现写核心：
```python
import hashlib, base64
def short_url(long_url):
    h = hashlib.md5(long_url.encode()).digest()[:6]
    return base64.urlsafe_b64encode(h).decode()[:8]   # 取前8字符
# 存储：short_code -> long_url（DB 或 Redis）
# 跳转：GET /<code> → 查 DB → 301 重定向到 long_url
```
讨论冲突（哈希碰撞）：加序号重试或 Base62 自增 ID。流量估算：1 亿短链 × 存储；QPS 峰值限流（BE15）。

### 🔵 部分三·原理层（底层发生了什么）
系统设计题考察**分解能力**：① 澄清需求（读多写少？量级？延迟？）；② 画高层架构（客户端→网关→服务→存储/缓存/队列）；③ 逐组件定方案（存储选型、缓存层、CDN、限流、幂等）；④ 算量级（QPS/存储/带宽）；⑤ 找瓶颈与取舍（一致性 vs 可用，CAP）。所有点都用前面 BE 章节的工具。

### 🟣 部分四·深挖层（为什么 & 延伸）
- **短链**：301（永久，缓存好但难统计）vs 302（临时，可统计点击）；存储用 KV/Redis；防滥用（限流+黑名单）。
- **Feed 流**（朋友圈）：推模式（发时推给所有粉丝，读快写慢）vs 拉模式（读时聚合，写快读慢）vs 推拉结合；超大粉丝用「热粉丝推+冷粉丝拉」。
- **限流器设计**（BE15 延伸）：分布式令牌桶用 Redis（`INCR`+`EXPIRE`）；滑动窗口用 ZSET 存时间戳。
- 一致性哈希（BE16 服务发现/缓存分片）、布隆过滤器（BE13 穿透防护）都是常客。

### 🔴 部分五·顶级视角
系统设计没有「标准答案」，只有「在约束下合理的权衡」。顶级全栈面对任何需求先问：规模？延迟？一致性与可用性谁优先（CAP）？成本？再选组件，且每个选择能解释「为什么不选另一个」。这是把方向1–11 全部串起来的综合能力。

### 🟠 部分六·安全/合规种子（白帽）
- 短链可被用于藏恶意网址（钓鱼）——做时要考虑「恶意链接检测/报备」，白帽立场不助长滥用。
- 系统设计题里的「限流/鉴权/加密」不是可选项，是默认项（呼应全案红线）。
- 真实系统涉及用户数据须合规（个保法），设计时就留「数据最小化/可删除」。

### ✅ 验收
交一份「短链系统」或「Feed 流」的**设计提纲**（不超过 1 页）：需求澄清、组件图（文字）、存储/缓存/限流选型与理由、量级估算。

### ⚠️ 常见坑
- 一上来就写代码：没澄清需求，设计跑偏。
- 忽略量级：用单体方案扛 10 万 QPS。
- 不考虑失败：只画 happy path，不问「DB 挂了怎么办」（应降级/BE15）。
- 过度设计：小项目上 K8s+微服务（呼应 BE16）。

### ➡️ 下一步
**BE26 · 毕业实战：闪电号卡（全栈贯通验收）**——把一切串起来。

### 🧪 实战 Lab（BE25）
选「限流器」动手：用 Redis 实现分布式滑动窗口限流（ZSET 存 `{user_id: [timestamps]}`，统计窗口内数量超阈拒绝），对比 BE15 单机令牌桶，说明分布式为何需要 Redis。

---

## BE26 · 毕业实战：闪电号卡（全栈贯通验收）

### 🎯 目标
学完这节，你能把**方向1–方向11 全栈所学**收敛成一个可运行的「闪电号卡」最小可用版（前端 FE + 后端 BE + 数据 + 安全 + 部署），并通过一份「毕业验收清单」。这是你全栈能力的综合毕业作。

### 📋 小白前置
- 本文件内：**FE1–FE18 全部 + BE1–BE25 全部**
- 方向5 数据库（DB 建表/事务）、方向7a Web 安全（SEC 系列）、方向10 部署（OPS）
- 闪电号卡平台 `portfolio/lightning-card`（Flask + SQLAlchemy，已落地 M0–M13）可作真实底座

### 🟢 部分一·最浅层（生活比喻）
毕业实战像**毕业设计答辩**：前面 43 节是各门课，这一节是把它们拼成「一个能跑、能给人用的产品」。不是学新东西，是把学过的「砖」（HTML/CSS/JS、Flask、SQL、缓存、安全、部署）垒成「房子」（闪电号卡）。

### 🟡 部分二·动手层（逐字操作）
最小闭环（本地即可跑，复用 `portfolio/lightning-card` 工程更省力）：
1. **前端 FE**：用 FE1–FE14 做一个「卡品列表页 + 下单表单」（Vue/React 或原生均可），调后端 REST。
2. **后端 BE**：Flask 提供 `GET /plans`（BE2+BE13 缓存）、`POST /order`（BE2+BE5 鉴权+BE20 幂等+BE14 异步发短信）、`WS /order/status`（BE19 推送发货状态）。
3. **数据**：SQLAlchemy 建 `plans / orders / users`（方向5 DB + BE8 ORM），订单用事务 + 唯一约束保证幂等（BE20）。
4. **安全**：登录用 session/JWT（BE5）、接口限流（BE15）、HTTPS（BE23）、输入校验（SEC Web 安全）、上传安全（BE12）。
5. **可观测**：结构化日志 + 关键指标（BE21）。
6. **部署**：Dockerfile + Nginx 反代 HTTPS（BE23）。

验收自测脚本（pytest，BE22）覆盖：未登录下单被拒、重复下单只成一单（幂等）、缓存命中变快、WS 能收到状态推送。

### 🔵 部分三·原理层（底层发生了什么）
一次「用户浏览→下单→收货通知」全流程：浏览器(FE) → HTTPS(Nginx) → Flask(BE) → 鉴权(BE5) → 查缓存/DB(BE13/方向5) → 写订单事务(BE20 幂等) → 入队异步(BE14) → WS 推送(BE19) → 前端更新。每一环都对应前面某节的知识点，这就是「全栈贯通」。

### 🟣 部分四·深挖层（为什么 & 延伸）
- 这是**最小可用**，真实「闪电号卡」还含：代理分级 RBAC（M3/M12）、零扣量逐单对账+秒返状态机（M5）、风控引擎（M9）、客户 CRM（M10）、裂变（M11）——都是方向7 安全 + 方向5 数据 + 方向10 运维的延伸。
- 工程化清单：测试(BE22)→CI(方向10)→监控(BE21)→灰度(BE23)→回滚。
- 下一步可深化：微服务(BE16)、Serverless 海报生成(BE17)、ES 搜索(BE18)、性能调优(BE24)、系统设计(BE25)。

### 🔴 部分五·顶级视角
一个能上线的小产品 > 一百个 demo。顶级全栈的里程碑不是「学过多少课」，而是「能独立把需求变成稳定运行的服务，并为其正确性、安全、韧性负责」。这恰是你「八大方向全主干」目标的第一次完整兑现。

### 🟠 部分六·安全/合规种子（白帽）——毕业总检
全部红线在此汇总：只本机/授权环境练；HTTPS 默认；密钥不进库；支付只接持牌机构且严格幂等验签；不攻击不破解不越权；用户隐私脱敏合规（个保法/GDPR）；上线只部署自己有权部署的服务。毕业作即白帽作品集的一张名片。

### ✅ 验收（毕业清单）
交「闪电号卡最小版」代码 + 一份验收报告，逐条打勾：
- [ ] 前端列表/下单页可跑（FE）
- [ ] 后端 REST + 鉴权 + 缓存（BE2/BE5/BE13）
- [ ] 下单幂等、重复请求只成一单（BE20）
- [ ] 异步任务/WS 推送状态（BE14/BE19）
- [ ] 限流 + HTTPS + 输入校验（BE15/BE23/SEC）
- [ ] 结构化日志 + 基础指标（BE21）
- [ ] pytest 覆盖核心链路（BE22）
- [ ] Dockerfile + Nginx 反代配置（BE23）
全部达成 = 方向6 毕业。

### ⚠️ 常见坑
- 只做前端不接后端：不算全栈，必须链路打通。
- 漏了幂等/限流/HTTPS：上线即风险，毕业清单强制覆盖。
- 把「能本地跑」当「能上线」：部署/监控/回滚缺一不可（BE23/BE21）。
- 一次性写完全堆一起：按 BE1→BE26 顺序小步验证，每节一个可验收点。

### ➡️ 下一步
**方向7 安全攻防 + 逆向（你最想成为的「黑客」主干）**——把全栈能力用于白帽攻防，从 SEC1 安全基础起步。

### 🧪 实战 Lab（BE26·毕业）
用 `portfolio/lightning-card` 工程（已含 M0–M13）作为底座，按上面清单补上「WS 订单推送(BE19) + 限流(BE15) + 结构化日志(BE21) + Dockerfile(BE23)」四处增强，提交一份毕业验收报告（逐条打勾 + 截图）。


