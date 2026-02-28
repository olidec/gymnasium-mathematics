// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  lecture.typ                                                             ║
// ║  Page setup and show rules for lecture notes output.                    ║
// ║                                                                          ║
// ║  Called via include-before-body in each topic's lecture.qmd.            ║
// ║  The topic passes its key and display title; everything else is         ║
// ║  derived automatically from shared.typ.                                 ║
// ╚══════════════════════════════════════════════════════════════════════════╝

#import "shared.typ": *

// setup-lecture is called once at the top of every lecture notes document.
// topic-key    : must match a key in topic-colours  e.g. "algebra"
// topic-title  : display name shown in header       e.g. "Algebra"
// institution  : shown in footer left               e.g. "Gymnasium — Mathematics"
#let setup-lecture(topic-key, topic-title, institution) = {
  let p = get-palette(topic-key)

  // ── Page geometry ───────────────────────────────────────────────────────
  set page(
    paper:   "a4",
    flipped: false,
    margin:  (top: 3cm, bottom: 2.5cm, x: 2.5cm),
    header:  make-header(p, topic-title, context {
      // Automatically tracks the current level-2 heading
      let h = query(selector(heading.where(level: 2)).before(here()))
      if h.len() > 0 { h.last().body } else { [] }
    }),
    footer: make-footer(p, institution),
  )

  // ── Base typography ─────────────────────────────────────────────────────
  set text(font: font.body, size: font.size, lang: "en")
  set par(justify: true, leading: 0.65em)
  set math.equation(numbering: none)

  // ── Heading styles ───────────────────────────────────────────────────────

  // Level 1 — Chapter: full-width coloured bar, page break before
  show heading.where(level: 1): h => {
    pagebreak(weak: true)
    v(0.5em)
    block(
      width:  100%,
      fill:   p.dark,
      inset:  (x: 14pt, y: 11pt),
      radius: 5pt,
      below:  1.2em,
      stack(
        dir:     ltr,
        spacing: 0.6em,
        text(
          fill:   p.on-dark,
          size:   font.xlarge,
          weight: "bold",
          counter(heading).display("1.")
        ),
        text(
          fill:   p.on-dark,
          size:   font.xlarge,
          weight: "bold",
          h.body
        ),
      )
    )
  }

  // Level 2 — Section: coloured rule + text
  show heading.where(level: 2): h => {
    v(1.2em)
    block(below: 0.5em, {
      text(fill: p.base, weight: "bold", size: font.large)[
        #counter(heading).display("1.1") #h.body
      ]
      v(-0.4em)
      line(length: 100%, stroke: 1pt + p.light)
    })
  }

  // Level 3 — Subsection: simple bold in neutral colour
  show heading.where(level: 3): h => {
    v(0.9em)
    block(below: 0.3em,
      text(fill: p.neutral, weight: "bold", size: font.size)[
        #counter(heading).display("1.1.1") #h.body
      ]
    )
  }

  set heading(numbering: "1.1.1")
}
