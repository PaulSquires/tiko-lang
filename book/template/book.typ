$-- book.typ -- the pandoc template for the typst build. Variables it expects:
$--   draft    set in --draft builds: adds a watermark and shows chapter status
$--   trim     page size, e.g. "7in x 9.25in" (informational; the size is set below)
// What pandoc's typst output presupposes -- defined here rather than taken from pandoc's
// definitions.typst partial, which pandoc 3.4 ships and 3.12 (Homebrew, on macOS) does not.
#let horizontalrule = [
  #line(start: (25%, 0%), end: (75%, 0%))
]
#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

// ---------------------------------------------------------------- page and type
// The current chapter's number, for the running header; none in the preface and the
// appendices, whose titles name themselves. pdf.sh sets it after each level-1 heading.
#let chapter-number = state("chapter-number", none)

#set page(
  width: 7in,
  height: 9.25in,
  margin: (inside: 0.9in, outside: 0.75in, top: 0.9in, bottom: 0.85in),
  binding: left,
  numbering: "1",
  header: context {
    // No running header on a page where a chapter opens -- that page carries the
    // chapter title itself.
    let opens-here = query(heading.where(level: 1))
      .any(h => h.location().page() == here().page())
    if not opens-here {
      let before = query(selector(heading.where(level: 1)).before(here()))
      let chap = if before.len() > 0 { before.last().body } else { [] }
      let num = chapter-number.get()
      if num != none { chap = [Chapter #num: #chap] }
      let n = counter(page).get().first()
      set text(size: 8pt, style: "italic", fill: luma(40%))
      // The book title takes only its own width and the chapter side the rest: with two
      // equal columns 'Chapter 17: Errors: Optional, Result and Runtime Checks' wrapped.
      if calc.even(n) {
        grid(columns: (auto, 1fr), column-gutter: 1em,
          align(left)[$title$], align(right)[#chap])
      } else {
        grid(columns: (1fr, auto), column-gutter: 1em,
          align(left)[#chap], align(right)[$title$])
      }
      line(length: 100%, stroke: 0.4pt + luma(75%))
    }
  },
)

#set text(font: "New Computer Modern", size: 10.5pt, lang: "en", region: "ca")
#set par(justify: true, leading: 0.62em, first-line-indent: 0pt)
#set block(spacing: 0.9em)   // typst 0.11 has no par.spacing
#show link: set text(fill: rgb("#1a4f8a"))

#set heading(numbering: none)
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  block(above: 1.2em, below: 1.1em)[
    #set text(size: 20pt, weight: "bold")
    #it.body
  ]
}
#show heading.where(level: 2): it => block(above: 1.4em, below: 0.7em)[
  #set text(size: 13pt, weight: "bold"); #it.body
]
#show heading.where(level: 3): it => block(above: 1.1em, below: 0.5em)[
  #set text(size: 11pt, weight: "bold"); #it.body
]

// ---------------------------------------------------------------- tables
// Book style: no vertical rules, a rule under the header, hairlines between rows,
// left-aligned and unjustified (justification mangles short cells).
#set table(
  inset: (x: 6pt, y: 4.5pt),
  align: left + horizon,
  stroke: (_, y) => (
    bottom: if y == 0 { 0.7pt + luma(35%) } else { 0.3pt + luma(82%) },
  ),
)
#show table: set par(justify: false)
#show table: set text(size: 9.5pt)
#show table.cell: set align(left)          // pandoc centres cells by default
#show table.cell.where(y: 0): set text(weight: "bold")

// ---------------------------------------------------------------- code
// The path is written here, not passed in: pandoc 3.12 escapes a metadata value's leading
// "." when it substitutes it, and typst 0.15 refuses the backslash that leaves.
#set raw(syntaxes: "../template/tiko.sublime-syntax")
#show raw: set text(font: "DejaVu Sans Mono", size: 8.6pt)
#show raw.where(block: true): it => block(
  width: 100%,
  fill: luma(97%),
  stroke: (left: 2pt + luma(80%)),
  inset: (x: 8pt, y: 7pt),
  radius: 2pt,
  breakable: true,
  it,
)

#let listing-caption(body) = block(above: 1.0em, below: 0.35em)[
  #set text(size: 8pt, fill: luma(40%), font: "DejaVu Sans Mono")
  #body
]
#let output-caption(body) = block(above: 0.6em, below: 0.35em)[
  #set text(size: 8pt, fill: luma(40%), style: "italic")
  #body
]

// ---------------------------------------------------------------- callouts
#let callout-style = (
  "pitfall":          (rgb("#b3261e"), rgb("#fdf0ef")),
  "note":             (rgb("#1a4f8a"), rgb("#eef3fa")),
  "platform-windows": (rgb("#5b4b8a"), rgb("#f3f1fa")),
  "platform-linux":   (rgb("#5b4b8a"), rgb("#f3f1fa")),
  "fbcompat":         (rgb("#6b5b2a"), rgb("#faf6e9")),
  "tiko-status":      (rgb("#7a4a12"), rgb("#fbf2e8")),
  "chapter-status":   (rgb("#555555"), rgb("#f0f0f0")),
)

#let callout(kind, title, body) = {
  let (accent, bg) = callout-style.at(kind, default: (luma(40%), luma(95%)))
  block(
    width: 100%, fill: bg, stroke: (left: 2.5pt + accent),
    inset: (x: 9pt, y: 8pt), radius: 2pt, above: 1.1em, below: 1.1em, breakable: true,
  )[
    #block(below: 0.45em)[#text(size: 8.5pt, weight: "bold", fill: accent, upper(title))]
    #body
  ]
}

$if(draft)$
#set page(background: rotate(-38deg, text(74pt, fill: rgb(0, 0, 0, 18), weight: "bold")[DRAFT]))
$endif$

// ---------------------------------------------------------------- title page
#page(numbering: none, header: none)[
  #align(center)[
    #v(0.5in)
    #image("../src/brand/tiko-book-cover-spiral-sparse.svg", width: 4.2in)
    #v(0.45in)
    #v(0.35in)
    $if(author)$#text(size: 13pt)[$for(author)$$author.name$$author$$sep$, $endfor$]$endif$
    #v(0.15in)
    #text(size: 10pt, fill: luma(40%))[$if(date)$$date$$endif$]
    $if(draft)$#v(0.3in) #text(size: 10pt, fill: rgb("#b3261e"))[Draft -- not for distribution]$endif$
  ]
  #v(1fr)
  #align(center)[#text(size: 8.5pt, fill: luma(45%))[
    Text licensed CC BY-NC-SA 4.0. Example code licensed MIT.
  ]]
]

// ---------------------------------------------------------------- contents
#page(numbering: none, header: none)[
  #text(size: 17pt, weight: "bold")[Contents]
  #v(0.2in)
  #outline(title: none, depth: 2, indent: 1.2em)
]

#counter(page).update(1)

$body$
