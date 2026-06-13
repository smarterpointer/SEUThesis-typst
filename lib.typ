// =============================================================================
// SEU Graduate Thesis Template for Typst (东南大学研究生学位论文 Typst 模板)
//
// A lightweight reimplementation of the official SEU LaTeX thesis class, following
// the format specification in `tmp/格式要求.pdf`. Requires Typst >= 0.12.
//
// Usage (see main.typ):
//   #import "lib.typ": *
//   #show: thesis.with(title: "...", author: "...", ...)
//   #cn-cover(); #cn-title-page(); #en-title-page(); #declaration()
//   #cn-abstract(("关键词",))[摘要正文]
//   #en-abstract(("keyword",))[abstract body]
//   #make-toc()
//   #mainmatter()
//   = 第一章标题 ...
// =============================================================================

// ---------------------------------------------------------------------------
// Fonts (字体). Ordered fallback: official Windows fonts first, then macOS, then
// the cross-platform Noto CJK family so the template compiles everywhere.
// ---------------------------------------------------------------------------
#let song = ("Times New Roman", "SimSun", "宋体", "Songti SC", "Noto Serif CJK SC") //  宋体
#let hei = ("Arial", "SimHei", "黑体", "Heiti SC", "Noto Sans CJK SC") //  黑体
#let kai = ("KaiTi", "楷体", "Kaiti SC", "STKaiti", "AR PL KaitiM GB") //  楷体
#let fang = ("FangSong", "仿宋", "FangSong SC", "STFangsong", "Noto Serif CJK SC") //  仿宋
#let zhongsong = ("STZhongsong", "华文中宋", "STSong", "SimSun", "宋体", "Songti SC", "Noto Serif CJK SC") //  华文中宋 (title-page masthead)
#let en-serif = ("Times New Roman", "SimHei", "黑体", "Noto Serif CJK SC") //  Latin-first (English cover)

// ---------------------------------------------------------------------------
// Font sizes (字号 → pt)
// ---------------------------------------------------------------------------
#let s-chu = 42pt //  初号
#let s-xchu = 36pt //  小初
#let s-1 = 26pt //  一号
#let s-s1 = 24pt //  小一
#let s-2 = 22pt //  二号  (thesis title)
#let s-s2 = 18pt //  小二
#let s-3 = 16pt //  三号  (chapter heading)
#let s-s3 = 15pt //  小三
#let s-4 = 14pt //  四号  (section heading)
#let s-s4 = 12pt //  小四  (body text, subsection)
#let s-5 = 10.5pt //  五号  (captions)
#let s-s5 = 9pt //  小五  (header / footer)

// ---------------------------------------------------------------------------
// Shared metadata state so helper functions (covers, headers) can read the
// values supplied to `thesis(...)` without re-passing every argument.
// ---------------------------------------------------------------------------
#let _meta = state("seu-thesis-meta", (:))

// Underlined fill-in box used on the cover / title pages.
#let _ul(body, width: 3cm) = box(
  width: width,
  stroke: (bottom: 0.6pt),
  outset: (bottom: 2pt),
  align(center, body),
)


// Heading numbering: 第一章 (Chinese numeral) for chapters; 1.1 / 1.1.1 (Arabic)
// for deeper levels so cross-references read naturally.
#let _heading-numbering(..nums) = {
  let n = nums.pos()
  if n.len() == 1 {
    "第" + numbering("一", n.first()) + "章"
  } else {
    numbering("1.1", ..n)
  }
}

// Centered 小五号宋体 running header with a 0.4pt rule beneath it.
#let _body-header() = context {
  let m = _meta.get()
  let pgno = here().page()
  let content = if calc.even(pgno) {
    // even page: 东南大学{硕士|博士}学位论文
    "东南大学" + m.degree-zh + "学位论文"
  } else {
    // odd page: 第X章  <current chapter title>
    let chs = query(heading.where(level: 1))
    let cur = none
    for h in chs {
      if h.location().page() <= pgno { cur = h }
    }
    if cur == none {
      []
    } else if cur.numbering != none {
      let lbl = numbering(cur.numbering, ..counter(heading).at(cur.location()))
      [#lbl#h(0.5em)#cur.body]
    } else {
      cur.body
    }
  }
  set text(font: song, size: s-s5)
  block(
    width: 100%,
    stroke: (bottom: 0.4pt),
    inset: (bottom: 2pt),
    align(center, content),
  )
}

// Centered 小五号宋体 page-number footer. Uses the active page numbering
// (Roman for front matter, Arabic for the body).
#let _page-footer(pat: "1") = context {
  align(center, text(
    font: song,
    size: s-s5,
    numbering(pat, ..counter(page).at(here())),
  ))
}

// ===========================================================================
// thesis(...) — the template show-rule. Wrap the whole document with
// `#show: thesis.with(...)`.
// ===========================================================================
#let thesis(
  // Chinese metadata
  title: "论文题目",
  author: "研究生姓名",
  advisor: "导师姓名",
  major: "二级学科名称", //  二级学科 / 专业名称
  first-major: "一级学科名称", //  一级学科
  school: "院系名称",
  // English metadata
  en-title: "English Title",
  en-author: "Author Name",
  en-advisor: "Advisor Name",
  en-school: "School of ...",
  en-degree-name: none, //  e.g. "Master of Engineering"; auto if none
  // cover details
  degree: "master", //  "master" | "doctor"
  student-id: "",
  clc: "", //  中图分类号 (分类号)
  udc: "", //  UDC
  sec-level: "", //  密级
  degree-category: "", //  申请学位类别
  confer-unit: "东南大学", //  学位授予单位
  defense-date: "", //  论文答辩日期
  confer-date: "", //  学位授予日期
  committee: "", //  答辩委员会主席
  reviewer: "", //  评阅人
  funding: "", //  资助项目
  date: "二〇二六年六月", //  中文日期
  en-date: "June 2026",
  // assets
  banner: "figures/seu-cover-banner.jpg",
  calligraphy: "figures/seu-title-calligraphy.png",
  // mode
  blind: false, //  盲审 / anonymous mode
  body,
) = {
  let degree-zh = if degree == "doctor" { "博士" } else { "硕士" }
  let en-marker = if degree == "doctor" { "A Dissertation Submitted to" } else {
    "A Thesis Submitted to"
  }
  let en-deg = if en-degree-name != none { en-degree-name } else if (
    degree == "doctor"
  ) { "Doctor of Philosophy" } else { "Master" }

  // Blank out identifying fields under blind review.
  let blank = "　　　　　　"
  let f(v) = if blind { blank } else { v }

  _meta.update((
    title: title,
    author: f(author),
    advisor: f(advisor),
    major: major,
    first-major: first-major,
    school: school,
    en-title: en-title,
    en-author: f(en-author),
    en-advisor: f(en-advisor),
    en-school: en-school,
    en-degree-name: en-deg,
    en-marker: en-marker,
    degree: degree,
    degree-zh: degree-zh,
    student-id: student-id,
    clc: clc,
    udc: udc,
    sec-level: sec-level,
    degree-category: degree-category,
    confer-unit: confer-unit,
    defense-date: defense-date,
    confer-date: confer-date,
    committee: f(committee),
    reviewer: f(reviewer),
    funding: funding,
    date: date,
    en-date: en-date,
    banner: banner,
    calligraphy: calligraphy,
    blind: blind,
  ))

  // ---- base text & paragraph (正文：小四号宋体，首行缩进 2 字，1.5 倍行距) ----
  set text(font: song, size: s-s4, lang: "zh", region: "cn")
  set par(
    first-line-indent: (amount: 2em, all: true),
    leading: 1em,
    justify: true,
  )
  set block(spacing: 1em)

  // ---- headings ----
  set heading(numbering: _heading-numbering)

  // 二级标题（章）：三号黑体居中；每章另起一页。
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    if it.numbering != none {
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(math.equation).update(0)
    }
    set align(center)
    set text(font: hei, size: s-3, weight: "bold")
    v(6pt)
    block(below: 18pt, {
      if it.numbering != none {
        numbering(it.numbering, ..counter(heading).at(it.location()))
        h(0.5em)
      }
      it.body
    })
  }

  // 三级标题（节）：四号宋体加粗居左。SimSun 无粗体字面，叠加细描边模拟加粗，
  // 使中文字形也呈现加粗效果（仅靠 weight:"bold" 时只有拉丁数字会变粗）。
  show heading.where(level: 2): it => {
    set text(font: song, size: s-4, weight: "bold", stroke: 0.022em)
    block(above: 14pt, below: 10pt, {
      numbering(it.numbering, ..counter(heading).at(it.location()))
      h(0.5em)
      it.body
    })
  }

  // 四级标题（节内小节）：小四号黑体居左。
  show heading.where(level: 3): it => {
    set text(font: hei, size: s-s4, weight: "regular")
    block(above: 12pt, below: 8pt, {
      numbering(it.numbering, ..counter(heading).at(it.location()))
      h(0.5em)
      it.body
    })
  }

  // ---- figures / tables (图3-1 below；表3-1 above；五号宋体) ----
  set figure(numbering: n => {
    let h = counter(heading).get()
    let ch = if h.len() >= 1 { h.first() } else { 1 }
    str(ch) + "-" + str(n)
  })
  show figure.where(kind: image): set figure(supplement: [图])
  show figure.where(kind: table): set figure(supplement: [表])
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: set text(font: song, size: s-5)
  set figure.caption(separator: "　") //  full-width space (≈ \quad)

  // ---- equations ((3.1)，按章编号) ----
  set math.equation(numbering: it => {
    let h = counter(heading).get()
    if h.len() == 0 { return numbering("(1)", it) }
    numbering("(1.1)", h.first(), it)
  })

  // ---- references: superscript bracketed citations (上标方括号) ----
  show cite: it => super(it)

  // ---- body page style: parity header + Arabic centered footer ----
  set page(
    paper: "a4",
    margin: (top: 2cm, bottom: 2cm, left: 2cm, right: 2cm),
    numbering: "1",
    header: _body-header(),
    footer: _page-footer(),
    header-ascent: 30%,
    footer-descent: 30%,
  )

  body
}

// ===========================================================================
// Front-matter helpers (each emits its own isolated page(s)).
// ===========================================================================

// 中文封面（封面）
#let cn-cover() = context {
  let m = _meta.get()
  page(numbering: none, header: none, footer: none)[
    // top-left metadata box (9pt; order: 学校代码 / 分类号 / 密级 / U D C / 学号)
    #place(top + left, {
      set text(font: song, size: s-s5)
      grid(
        columns: (auto, 1fr),
        row-gutter: 0.7em,
        column-gutter: 0.6em,
        [学校代码], _ul[10286],
        [分#h(0.5em)类#h(0.5em)号], _ul(m.clc, width: 3cm),
        [密#h(2em)级], _ul(m.sec-level, width: 3cm),
        [U#h(0.9em)D#h(0.9em)C], _ul(m.udc, width: 3cm),
        [学#h(2em)号], _ul(m.student-id, width: 3cm),
      )
    })
    #v(2.3cm)
    #align(center, {
      if m.banner != none { image(m.banner, width: 17cm) }
      v(0.6em)
      text(font: zhongsong, size: s-xchu, weight: "bold", stroke: 0.022em, m.degree-zh + "学位论文")
      v(1.4em)
      text(font: hei, size: s-1, m.title)
      v(2.4em)
      set text(font: song, size: s-s2)
      grid(
        columns: (auto, auto),
        row-gutter: 1.2em,
        align: (right, left),
        [研究生姓名：], _ul(m.author, width: 5cm),
        [导#h(0.33em)师#h(0.33em)姓#h(0.33em)名：], _ul(m.advisor, width: 5cm),
      )
    })
    #v(1fr)
    // bottom information — only the fill-in value carries an underline (not the label).
    #set text(font: song, size: s-5)
    #let reviewer-block(reviewers, width: 4.2cm, show-empty-line: false) = {
      let rs = if type(reviewers) == array {
        reviewers
      } else {
        (reviewers,)
      }

      let r1 = if rs.len() >= 1 { rs.at(0) } else { "" }
      let r2 = if rs.len() >= 2 { rs.at(1) } else { "" }

      if r2 != "" or show-empty-line {
        grid(
          columns: (auto, auto),
          row-gutter: 1.4em,
          column-gutter: 0.6em,
          align: left,

          [评#h(1.5em)阅#h(1.5em)人：], _ul(r1, width: width),
          [], _ul(r2, width: width),
        )
      } else {
        grid(
          columns: (auto, auto),
          column-gutter: 0.6em,
          align: left,

          [评#h(1.5em)阅#h(1.5em)人：], _ul(r1, width: width),
        )
      }
    }
    #align(center, grid(
      columns: (auto, auto),
      row-gutter: 1.4em,
      column-gutter: 1.6em,
      align: left,
      [申请学位类别：#_ul(m.degree-category, width: 4.2cm)], [学位授予单位：#_ul(m.confer-unit, width: 4.2cm)],
      [一级学科名称：#_ul(m.first-major, width: 4.2cm)], [论文答辩日期：#_ul(m.defense-date, width: 4.2cm)],
      [二级学科名称：#_ul(m.major, width: 4.2cm)], [学位授予日期：#_ul(m.confer-date, width: 4.2cm)],
      [答辩委员会主席：#_ul(m.committee, width: 3.8cm)], reviewer-block(m.reviewer, width: 4.2cm),
    ))
    #v(1.6em)
    #align(center, text(font: song, size: s-4, m.date))
  ]
}

// 中文扉页（中文页面）
#let cn-title-page() = context {
  let m = _meta.get()
  // Underlined fill-in box with a uniform width, for the centered group below.
  let _row(label, value) = (
    text(font: hei, size: s-3, weight: "bold", label + "："),
    box(
      width: 6cm,
      stroke: (bottom: 0.6pt),
      outset: (bottom: 2pt),
      align(center, text(font: hei, size: s-3, weight: "bold", value)),
    ),
  )
  page(numbering: none, header: none, footer: none)[
    #v(1.2cm)
    #align(center, {
      if m.calligraphy != none { image(m.calligraphy, width: 5cm) }
      v(1.2em)
      text(font: zhongsong, size: s-xchu, weight: "bold", stroke: 0.022em, m.degree-zh + "学位论文")
      v(2em)
      text(font: hei, size: s-s1, weight: "bold", m.title)
      v(12em)
      // three rows centered as a fixed-width group (generous inter-row spacing)
      grid(
        columns: (auto, auto),
        row-gutter: 4.5em,
        align: (right + horizon, left + horizon),
        .._row("专 业 名 称", m.major),
        .._row("研究生姓名", m.author),
        .._row("导 师 姓 名", m.advisor),
      )
    })
    #v(1fr)
    // blank underline above the funding sentence; both flush-left and aligned.
    #let funding-block(funding) = {
      if funding != "" {
        block[
          #set par(first-line-indent: 0pt)

          #box(
            width: 6cm,
            stroke: (bottom: 0.6pt),
            outset: (bottom: 2pt),
          )[#h(1em)]

          #linebreak()

          #text(font: song, size: s-5, funding)
        ]
      }
    }
    #funding-block(m.funding)
  ]
}

// English title page（英文页面）— Times New Roman, non-bold throughout.
#let en-title-page() = context {
  let m = _meta.get()
  page(numbering: none, header: none, footer: none)[
    #set text(font: en-serif, lang: "en")
    #v(1cm)
    #align(center, {
      text(size: 24pt, m.en-title)
      v(1em)
      stack(
        spacing: 1.4em,
        text(size: s-s3, m.en-marker),
        text(size: s-s3, [Southeast University]),
        text(size: s-s3, [For the Academic Degree of #m.en-degree-name]),
        v(6em),
        text(size: s-3, [BY]),
        text(size: s-3, m.en-author),
        v(6em),
        text(size: s-3, [Supervised by]),
        text(size: s-3, m.en-advisor),
        v(6em),
        text(size: s-s3, m.en-school),
        text(size: s-3, [Southeast University]),
        text(size: s-s3, m.en-date),
      )
    })
  ]
}

// 独创性声明 + 使用授权声明（盲审模式下省略）
#let declaration() = context {
  let m = _meta.get()
  if m.blind { return }
  page(numbering: none, header: none, footer: none)[
    #set text(font: song, size: s-5)
    #set par(first-line-indent: (amount: 2em, all: true), leading: 1em, justify: true)
    #align(center, text(font: hei, size: s-s3, weight: "bold")[东南大学学位论文独创性声明])
    #v(1.5em)
    本人声明所呈交的学位论文是我个人在导师指导下进行的研究工作及取得的研究成果。尽我所知，除了文中特别加以标注和致谢的地方外，论文中不包含其他人已经发表或撰写过的研究成果，也不包含为获得东南大学或其它教育机构的学位或证书而使用过的材料。与我一同工作的同志对本研究所做的任何贡献均已在论文中作了明确的说明并表示了谢意。
    #v(2em)
    #align(center)[研究生签名：#_ul[]#h(2em)日期：#_ul[]]
    #v(3em)
    #align(center, text(font: hei, size: s-s3, weight: "bold")[东南大学学位论文使用授权声明])
    #v(1.5em)
    东南大学、中国科学技术信息研究所、国家图书馆、《中国学术期刊（光盘版）》电子杂志社有限公司、万方数据电子出版社、北京万方数据股份有限公司有权保留本人所送交学位论文的复印件和电子文档，可以采用影印、缩印或其他复制手段保存论文。本人电子文档的内容和纸质论文的内容相一致。除在保密期内的保密论文外，允许论文被查阅和借阅，可以公布（包括以电子信息形式刊登）论文的全部内容或中、英文摘要等部分内容。论文的公布（包括以电子信息形式刊登）授权东南大学研究生院办理。
    #v(2em)
    #align(center)[研究生签名：#_ul[]#h(1.5em)导师签名：#_ul[]#h(1.5em)日期：#_ul[]]
  ]
}

// 中文摘要（前置部分起，页码用大写罗马数字）
#let cn-abstract(keywords, body) = {
  counter(page).update(1)
  page(numbering: "I", header: none, footer: _page-footer(pat: "I"))[
    #heading(level: 1, numbering: none, outlined: true)[摘　要]
    #body
    #v(1em)
    #par(first-line-indent: 0pt)[#text(font: hei, weight: "bold", stroke: 0.022em)[关键词：]#keywords.join("；")]
  ]
}

// 英文摘要
#let en-abstract(keywords, body) = {
  page(numbering: "I", header: none, footer: _page-footer(pat: "I"))[
    #heading(level: 1, numbering: none, outlined: true)[Abstract]
    #body
    #v(1em)
    #par(first-line-indent: 0pt)[#text(
        font: "Times New Roman",
        weight: "bold",
        stroke: 0.022em,
      )[Key words: ]#keywords.join("; ")]
  ]
}

// 目录 + 表格目录（List of Tables）+ 插图目录（List of Figures）
#let make-toc() = {
  page(numbering: "I", header: none, footer: _page-footer(pat: "I"))[
    #heading(level: 1, numbering: none, outlined: false)[目　录]
    #outline(title: none, target: heading, depth: 3, indent: 1.2em)
    #heading(level: 1, numbering: none, outlined: false)[表格目录]
    #outline(title: none, target: figure.where(kind: table))
    #heading(level: 1, numbering: none, outlined: false)[插图目录]
    #outline(title: none, target: figure.where(kind: image))
  ]
}

// Switch to the main body: restart Arabic page numbering at 1.
#let mainmatter() = {
  counter(page).update(1)
}

// Unnumbered body/back-matter chapter (致谢、附录 等) — 三号黑体居中，不编号。
#let unnumbered-chapter(title) = heading(level: 1, numbering: none)[#title]
