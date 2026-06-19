#import "lib.typ": *
#import "@preview/gb7714-bilingual:0.2.3": gb7714-bibliography, init-gb7714, multicite

// =============================================================================
// SEU graduate-thesis driver. Fill in your metadata below, then write your
// content. Compile with:  typst compile main.typ
// =============================================================================

// ---- bibliography ----
// 参考文献采用 GB/T 7714 数字格式著录，支持中英文混排，该函数一定要放在所有引用开始之前
#show: init-gb7714.with(
  read("refs.bib"),
  style: "numeric",
  version: "2015",
)


#show: thesis.with(
  // ---- Chinese metadata ----
  title: "基于 Typst 的东南大学硕士学位论文模板",
  author: "张三",
  advisor: "李四 教授",
  major: "计算机科学与技术", //  二级学科 / 专业名称
  first-major: "计算机科学与技术", //  一级学科
  school: "计算机科学与工程学院",
  // ---- English metadata ----
  en-title: "An SEU Master's Thesis Template Based on Typst",
  en-author: "ZHANG San",
  en-advisor: "Prof. LI Si",
  en-school: "School of Computer Science and Engineering",
  en-degree-name: "Master of Engineering",
  // ---- cover details ----
  degree: "master", //  "master" | "doctor"
  student-id: "200000000",
  clc: "TP391",
  udc: "004",
  sec-level: "公开",
  degree-category: "工学硕士",
  confer-unit: "东南大学",
  defense-date: "2026年06月01日",
  confer-date: "2026年06月30日",
  committee: "王五 教授",
  reviewer: "盲审",
  funding: "本论文获国家自然科学基金（编号：00000000）资助。",
  date: "二〇二六年六月",
  en-date: "June 2026",
  // ---- mode ----
  blind: false, //  set true for 盲审 (anonymous) submission
)

// ---- front matter ----
#cn-cover()
#cn-title-page()
#en-title-page()
#declaration()

#cn-abstract(("Typst", "学位论文", "排版模板", "东南大学"))[
  本文给出一个基于 Typst 的东南大学研究生学位论文模板。相比 LaTeX 方案，Typst 为单一静态二进制文件，编译速度快，且原生支持中文排版，是一种轻量级的解决方案。本模板严格遵循《东南大学研究生学位论文格式规定》，实现了封面、中英文扉页、独创性声明、中英文摘要、目录、正文、参考文献等全部要素，并对图、表、公式按章自动编号，引用采用上标方括号形式，参考文献采用 GB/T 7714 数字格式著录。
]

#en-abstract(("Typst", "Dissertation", "Template", "Southeast University"))[
  This thesis presents a Typst-based template for graduate dissertations at
  Southeast University. Compared with the LaTeX solution, Typst ships as a single
  static binary, compiles in milliseconds, and supports Chinese typesetting
  natively, making it a lightweight alternative. The template strictly follows
  the official SEU formatting specification, covering the cover pages, Chinese
  and English title pages, the declaration of originality, abstracts, the table
  of contents, the main body, and the references, with automatic per-chapter
  numbering of figures, tables, and equations.
]

#make-toc()

// ---- main body ----
#mainmatter()

#include "chapters/intro.typ"
#include "chapters/method.typ"

// ---- back matter ----
#unnumbered-chapter[致谢]
感谢导师在本研究工作中给予的悉心指导，感谢实验室同学的帮助与支持。

#gb7714-bibliography(
  title: heading(level: 1, numbering: none, outlined: true)[参考文献],
)
