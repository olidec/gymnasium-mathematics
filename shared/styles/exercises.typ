// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  exercises.typ                                                           ║
// ║  Page setup for standalone exercise sheet output.                       ║
// ║                                                                          ║
// ║  Landscape by default (optimised for screens and tablets).              ║
// ║  Override with flipped: false in exercises.qmd for portrait.            ║
// ╚══════════════════════════════════════════════════════════════════════════╝

// NOTE: shared.typ is imported by the caller (.qmd file) before this file.
// Typst resolves imports relative to the importing file's location, so
// importing shared.typ here would fail when called from a topic subfolder.

#let setup-exercises(
  topic-key,
  topic-title,
  institution,
  landscape: true,
) = {
  let p = get-palette(topic-key)

  set page(
    paper:   "a4",
    flipped: landscape,
    margin:  (top: 2.5cm, bottom: 2cm, x: 2cm),
    header: {
      set text(size: font.small, fill: p.neutral)
      grid(
        columns: (1fr, auto),
        align:   (left, right),
        text(weight: "bold")[#topic-title — Exercise Sheet],
        context counter(page).display("1 / 1", both: true),
      )
      v(-6pt)
      line(length: 100%, stroke: 0.4pt + p.muted)
    },
    footer: {
      line(length: 100%, stroke: 0.3pt + p.muted)
      v(-4pt)
      text(size: font.small, fill: p.neutral)[#institution]
    },
  )

  set text(font: font.body, size: font.size, lang: "en")
  set par(justify: true)
  set heading(numbering: none)

  // Section dividers on the exercise sheet use the topic colour
  show heading.where(level: 1): h => {
    v(0.8em)
    block(
      width:  100%,
      fill:   p.dark,
      inset:  (x: 12pt, y: 7pt),
      radius: 4pt,
      below:  0.8em,
      text(fill: white, weight: "bold", size: font.large)[#h.body]
    )
  }

  show heading.where(level: 2): h => {
    v(0.6em)
    block(below: 0.4em,
      text(fill: p.base, weight: "bold")[#h.body]
    )
    line(length: 100%, stroke: 0.5pt + p.light)
    v(0.2em)
  }
}
