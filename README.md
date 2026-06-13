# SEU Thesis Typst Template

东南大学研究生学位论文 Typst 模板。模板用于快速生成符合东南大学研究生学位论文常见格式要求的 PDF 文档，支持中文排版、封面、声明页、中英文摘要、目录、正文、图表、公式、参考文献等论文基本结构。

相比传统 LaTeX 模板，本项目更加轻量，适合希望快速编译、实时预览、低成本维护论文模板的用户。

## 功能特性

- 使用 Typst 编写，安装简单，编译速度快。
- 支持东南大学研究生学位论文常见页面结构。
- 支持硕士 / 博士模式。
- 支持盲审模式，可隐藏作者、导师、评阅人等信息。
- 支持中文封面、英文封面、独创性声明、中英文摘要、目录、正文、参考文献和致谢。
- 支持图、表、公式按章节自动编号。
- 支持 GB/T 7714 数字制参考文献格式。
- 支持基金资助信息可选显示。
- 支持多个评阅人，第二条评阅人横线可选显示。
- 针对部分中文字体无粗体的问题，内置伪加粗处理。

## 环境要求

需要安装 Typst：

```bash
typst --version
```

建议使用 Typst `0.12` 及以上版本。

### Windows 推荐方式

Windows 用户强烈推荐使用 **VS Code + Typst 插件**：

1. 安装 [Visual Studio Code](https://code.visualstudio.com/)；
2. 在 VS Code 扩展商店中安装 Typst 插件，例如 **Tinymist Typst**；
3. 安装 Typst CLI。推荐使用 `winget`：

```powershell
winget install --id Typst.Typst
```

安装完成后，重新打开 PowerShell 或 VS Code 终端，检查是否安装成功：

```powershell
typst --version
```

如果 `winget` 不可用，也可以从 Typst 官方 Release 页面下载 Windows 预编译版本，并将 `typst.exe` 所在目录加入系统 `Path`。

### macOS / Linux

```bash
# macOS
brew install typst

# Rust / Cargo，适用于 macOS / Linux / Windows
cargo install --locked typst-cli
```

也可以从 Typst 官方 Release 页面下载预编译二进制文件。

## 快速开始

克隆仓库后，在项目根目录运行：

```bash
typst compile main.typ
```

生成：

```text
main.pdf
```

实时预览可以使用：

```bash
typst watch main.typ
```

如果中文字体位于自定义目录，可以指定字体路径：

```bash
typst compile --font-path /path/to/fonts main.typ
```

## 项目结构

```text
seuthesis-typst/
├── main.typ                 # 论文入口文件：填写论文信息、组织章节内容
├── lib.typ                  # 模板核心文件：页面、字体、封面、标题、目录、页眉页脚等样式
├── refs.bib                 # 参考文献数据库
├── README.md                # 项目说明文档
├── .gitignore               
│
├── chapters/                # 正文章节
│   ├── intro.typ            # 示例章节：绪论
│   └── method.typ           # 示例章节：方法/正文示例
│
└── assets/                  # 模板资源文件
    ├── figures/             # 图片资源
    │   ├── seu-cover-banner.jpg       # 中文封面顶部校名图
    │   └── seu-title-calligraphy.png  # 中文题名页书法图
    │
    └── font/                # 随模板附带或自备字体
        └── STZhongsong.ttf  # 华文中宋字体，用于“硕士学位论文”等标题
```

一般情况下，你只需要修改 `main.typ`、`chapters/` 和 `refs.bib`。其中：
- `main.typ` 是主要编辑入口，用户一般只需要修改其中的论文信息、摘要、关键词和章节引用。
- `lib.typ` 是模板样式文件，包含封面、目录、页眉页脚、标题编号、图表编号、参考文献等排版规则。
- `chapters/` 用于存放各章正文，建议每一章单独一个 `.typ` 文件。

## 基本使用方式

在 `main.typ` 中通过 `#show: thesis.with(...)` 填写论文信息，例如：

```typst
#show: thesis.with(
  degree: "master",
  blind: false,

  title-zh: "基于 Typst 的东南大学研究生学位论文模板",
  title-en: "A Typst Template for Southeast University Graduate Thesis",

  author: "张三",
  advisor: "李四 教授",
  major: "计算机科学与技术",

  degree-category: "工学硕士",
  confer-unit: "东南大学",
  first-major: "计算机科学与技术",
  defense-date: "2026年06月01日",
  confer-date: "2026年06月30日",
  committee: "王五 教授",
  reviewer: "盲审",

  date: "二〇二六年六月",
)
```

正文可以按章节拆分：

```typst
#include "chapters/intro.typ"
#include "chapters/method.typ"
```

## 常用写法

### 章节标题

```typst
= 绪论
== 研究背景
=== 国内外研究现状
```

### 图片

```typst
#figure(
  image("figures/example.png", width: 80%),
  caption: [示例图片],
)
```

### 表格

```typst
#figure(
  table(
    columns: 3,
    [指标], [含义], [说明],
    [A], [准确率], [越高越好],
  ),
  caption: [示例表格],
)
```

### 公式

```typst
$ y = ax + b $ <eq:linear>
```

### 引用文献

```typst
已有研究表明该方法具有较好的效果 @example2024。
```

参考文献写在 `refs.bib` 中。

## 可选配置

### 硕士 / 博士

```typst
degree: "master"
```

或：

```typst
degree: "doctor"
```

### 盲审模式

```typst
blind: true
```

开启后，模板会隐藏部分个人信息，并省略不适合盲审提交的页面内容。

### 基金资助信息

如果有基金资助：

```typst
funding: "本论文获国家自然科学基金（编号：00000000）资助。"
```

如果没有基金资助：

```typst
funding: ""
```

当 `funding` 为空字符串时，该区域不会显示。

### 多个评阅人

一个评阅人：

```typst
reviewer: "盲审"
```

两个评阅人：

```typst
reviewer: ("盲审", "王五")
```

如果需要在只有一个评阅人时仍然保留第二条空横线，可以在模板函数中开启对应参数。

## 字体说明

模板默认使用中文论文中常见的宋体、黑体、楷体、仿宋等字体。为了获得更接近学校 Word 模板的效果，建议在 Windows 环境下使用：

- SimSun / 宋体
- SimHei / 黑体
- KaiTi / 楷体
- FangSong / 仿宋
- STZhongsong / 华文中宋
- Times New Roman

在 macOS 或 Linux 环境下，如果缺少中易字体，可以安装 Noto CJK 字体作为替代：

- Noto Serif CJK SC
- Noto Sans CJK SC

如果 Typst 找不到字体，可以使用：

```bash
typst fonts
```

查看当前可用字体。

## 编译输出

默认编译命令：

```bash
typst compile main.typ
```

输出文件：

```text
main.pdf
```

可以通过 `.gitignore` 忽略生成的 PDF、缓存文件和临时文件。

## 注意事项

本模板是一个非官方 Typst 模板，目标是尽可能贴近东南大学研究生学位论文格式要求。不同学院、不同年份的具体要求可能存在差异，正式提交前请务必以学院或研究生院发布的最新文件为准。

如果你发现格式问题，欢迎提交 Issue 或 Pull Request。


