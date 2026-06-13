= 绪论

本章给出研究背景与意义，并交代论文的组织结构。正文一律采用小四号宋体，首行缩进两个汉字，行距为 1.5 倍。

== 研究背景

学位论文的排版长期以 LaTeX 与 Word 为主。LaTeX 排版质量高，但依赖庞大的 TeX 发行版；Word 则难以保证编号与样式的一致性。Typst 作为新一代标记式排版系统，兼顾二者优点 #cite(<knuth1984>)。

=== 研究意义

轻量化的模板能够显著降低撰写门槛。本节通过一个示例图说明插图的排版方式，如@fig-arch 所示。

#figure(
  rect(width: 6cm, height: 3cm, stroke: 0.6pt)[#align(center + horizon)[系统结构示意图]],
  caption: [系统总体结构],
) <fig-arch>

如@fig-arch 所示，图题位于图的下方，并按章编号（图1-1）。

== 公式与表格

行内公式如 $E = m c^2$ 不编号；独立公式按章编号，例如质能方程

$ E = m c^2 $ <eq-emc>

参见@eq-emc。表格的表题位于表的上方，按章编号（表1-1），如@tab-cmp 所示。

#figure(
  table(
    columns: 3,
    stroke: none,
    table.hline(stroke: 1pt),
    table.header[方案][编译速度][依赖体积],
    table.hline(stroke: 0.6pt),
    [LaTeX], [慢], [大],
    [Word], [中], [中],
    [Typst], [快], [小],
    table.hline(stroke: 1pt),
  ),
  caption: [三种排版方案对比],
) <tab-cmp>
