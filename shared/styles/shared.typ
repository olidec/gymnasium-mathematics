// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  shared.typ                                                              ║
// ║  Central style library — Gymnasium Mathematics                          ║
// ║                                                                          ║
// ║  All topic templates import this file.                                  ║
// ║  Topics pass their key to get-palette() to receive their full           ║
// ║  colour palette. Everything visual derives from that one colour.        ║
// ║                                                                          ║
// ║  CONTENTS                                                                ║
// ║    1. External package imports                                           ║
// ║    2. Colour palette engine                                              ║
// ║    3. Topic colour registry                                              ║
// ║    4. Typography constants                                               ║
// ║    5. Math shorthands                                                    ║
// ║    6. Box environments                                                   ║
// ║    7. Exercise environments                                              ║
// ║    8. Figure helpers                                                     ║
// ║    9. Column helpers                                                     ║
// ║   10. Graph/plot helpers                                                 ║
// ║   11. Page header / footer builders                                      ║
// ╚══════════════════════════════════════════════════════════════════════════╝


// ── 1. EXTERNAL PACKAGES ─────────────────────────────────────────────────────

#import "@preview/tiaoma:0.2.1": qrcode
#import "@preview/cetz:0.3.1": canvas, draw
#import "@preview/cetz-plot:0.1.0": plot


// ── 2. COLOUR PALETTE ENGINE ─────────────────────────────────────────────────
// Each topic passes its single base colour. The engine derives every
// tint, shade and accent automatically. No topic ever hard-codes a colour.

#let make-palette(base) = (
  base:        base,
  dark:        base.darken(25%),
  darker:      base.darken(45%),
  light:       base.lighten(60%),
  ultralight:  base.lighten(88%),
  muted:       base.lighten(35%).desaturate(25%),
  neutral:     rgb("475569"),   // slate — borders, muted text, always the same
  on-dark:     white,
  page-bg:     white,
)


// ── 3. TOPIC COLOUR REGISTRY ──────────────────────────────────────────────────
// To add a topic: one line here, one folder in topics/.

#let topic-colours = (
  algebra:       rgb("2563eb"),   // steel blue
  functions:     rgb("7c3aed"),   // violet
  trigonometry:  rgb("0891b2"),   // teal
  vectors:       rgb("e11d48"),   // rose
  calculus:      rgb("4338ca"),   // indigo
  statistics:    rgb("d97706"),   // amber
  probability:   rgb("059669"),   // emerald
  sequences:     rgb("ea580c"),   // orange
  complex:       rgb("a21caf"),   // fuchsia
)

#let get-palette(topic-key) = make-palette(topic-colours.at(topic-key))


// ── 4. TYPOGRAPHY CONSTANTS ───────────────────────────────────────────────────

#let font = (
  // System-safe fonts available on macOS, Windows, and Linux.
  // macOS: "Georgia" (serif), "Helvetica Neue" (sans), "Menlo" (mono)
  // Override these in your topic file if you have other fonts installed.
  body:   "Georgia",
  sans:   "Helvetica Neue",
  mono:   "Menlo",
  size:   11pt,
  small:  8.5pt,
  large:  13pt,
  xlarge: 16pt,
)


// ── 5. MATH SHORTHANDS ───────────────────────────────────────────────────────
// These are Typst-side definitions. Matching VSCode snippets are in
// .vscode/typst.code-snippets for fast authoring.

// Number sets (blackboard bold)
#let NN = $bb(N)$
#let ZZ = $bb(Z)$
#let QQ = $bb(Q)$
#let RR = $bb(R)$
#let CC = $bb(C)$

// Complex number notation — bold instead of script
#let iu   = $bold(i)$             // imaginary unit
#let RE   = $op("Re")$            // real part operator
#let IM   = $op("Im")$            // imaginary part operator

// Common arrows
#let qrq  = $quad arrow.r.double quad$   // therefore / implies (from \qrq)
#let impl = $arrow.r.double$             // short implies

// Degree symbol (used in trigonometry)
#let dg = $degree$


// ── 6. BOX ENVIRONMENTS ───────────────────────────────────────────────────────
// All environments accept the palette as their first argument so they
// automatically reflect the topic colour. Content authors never specify
// colours directly — they call e.g. #definition-box(p)[...] where p is
// the palette set up by the topic template.

// ── Definition ────────────────────────────────────────────────────────────────
#let definition-box(palette, body) = block(
  width:  100%,
  fill:   palette.ultralight,
  stroke: (left: 3.5pt + palette.base),
  inset:  (left: 14pt, rest: 10pt),
  radius: (right: 3pt),
  above:  1em,
  below:  0.8em,
  {
    text(weight: "bold", fill: palette.dark, size: font.size)[Definition]
    linebreak()
    body
  }
)

// ── Theorem ───────────────────────────────────────────────────────────────────
#let theorem-box(palette, body) = block(
  width:  100%,
  fill:   palette.ultralight,
  stroke: (
    left:   3.5pt + palette.dark,
    top:    0.5pt + palette.muted,
    right:  0.5pt + palette.muted,
    bottom: 0.5pt + palette.muted,
  ),
  inset:  (left: 14pt, rest: 10pt),
  radius: 3pt,
  above:  1em,
  below:  0.8em,
  {
    text(weight: "bold", fill: palette.darker, size: font.size)[Theorem]
    linebreak()
    body
  }
)

// ── Proof ─────────────────────────────────────────────────────────────────────
#let proof-box(body) = block(
  width:  100%,
  inset:  (left: 14pt, rest: 10pt),
  stroke: (left: 1.5pt + rgb("d1d5db")),
  above:  0.4em,
  below:  1em,
  {
    text(style: "italic", fill: rgb("6b7280"))[Proof.#h(0.5em)]
    body
    h(1fr)
    $square$
  }
)

// ── Attention / Warning ───────────────────────────────────────────────────────
// Attention boxes are always amber — this is intentional. Colour-coding
// warnings consistently across topics is more useful than topic theming here.
#let attention-box(body) = block(
  width:  100%,
  fill:   rgb("fffbeb"),
  stroke: (left: 3.5pt + rgb("f59e0b")),
  inset:  (left: 14pt, rest: 10pt),
  radius: (right: 3pt),
  above:  1em,
  below:  0.8em,
  {
    text(weight: "bold", fill: rgb("b45309"), size: font.size)[Attention]
    linebreak()
    body
  }
)

// ── Example ───────────────────────────────────────────────────────────────────
#let example-box(palette, body) = block(
  width:  100%,
  fill:   color.mix((palette.ultralight, 60%), (white, 40%)),
  stroke: (left: 2pt + palette.muted),
  inset:  (left: 14pt, rest: 10pt),
  radius: (right: 3pt),
  above:  1em,
  below:  0.8em,
  {
    text(style: "italic", fill: palette.neutral, size: font.size)[Example]
    linebreak()
    body
  }
)


// ── 7. EXERCISE ENVIRONMENTS ──────────────────────────────────────────────────
// Exercises are intentionally lightweight — a bold numbered label followed
// by content with a thin left rule. No box, no fill, no clutter.

// Bold numbered label: "Exercise 3." or "Exercise 3. — Title"
#let ex-label(palette, n, title) = {
  v(0.9em)
  text(weight: "bold", fill: palette.dark)[
    Exercise #n.#if title != none [#h(0.3em)---#h(0.3em)#title]
  ]
}

// Content block: subtle left rule for visual grouping, no fill
#let ex-content(body) = block(
  width:  100%,
  inset:  (left: 10pt, rest: 0pt),
  stroke: (left: 1.5pt + rgb("e2e8f0")),
  above:  0.3em,
  below:  0.8em,
  body
)

// Solution header — appears in the solutions list
#let sol-header(palette, n, title) = block(
  width:  100%,
  fill:   palette.light,
  radius: (top: 3pt),
  inset:  (x: 12pt, y: 6pt),
  above:  0.8em,
  below:  0pt,
  text(fill: palette.darker, weight: "bold", size: font.size)[
    Solution #n#if title != none [#h(0.4em)---#h(0.4em)#title]
  ]
)

// Solution body wrapper
#let sol-body(palette, body) = block(
  width:  100%,
  fill:   white,
  stroke: (
    left:   1.5pt + palette.light,
    right:  1pt + palette.muted.lighten(30%),
    bottom: 1pt + palette.muted.lighten(30%),
  ),
  radius: (bottom: 3pt),
  inset:  12pt,
  above:  0pt,
  below:  0.6em,
  body
)

// QR code for YouTube solution video — appears in the solution block
#let sol-qr(url, label: none) = align(right,
  block(
    inset: 6pt,
    {
      if label != none {
        text(size: font.small, fill: rgb("6b7280"))[#label \ ]
      }
      qrcode(url, width: 1.8cm)
    }
  )
)

// Section divider used in exercise sheets
#let section-divider(palette, label) = {
  v(10pt)
  stack(
    dir: ltr,
    block(
      fill:   palette.dark,
      inset:  (x: 10pt, y: 5pt),
      radius: (left: 3pt),
      text(fill: white, weight: "bold", size: font.small)[#label]
    ),
    line(
      length: 100%,
      stroke: 0.5pt + palette.muted
    )
  )
  v(4pt)
}

// ── 8. FIGURE HELPERS ─────────────────────────────────────────────────────────

// Centred image at a given fraction of column width
// Usage: #cent-fig(0.7, "images/myimage.png")
#let cent-fig(width-frac, path, caption: none) = {
  align(center,
    block({
      image(path, width: width-frac * 100%)
      if caption != none {
        v(4pt)
        text(size: font.small, style: "italic", fill: rgb("6b7280"))[#caption]
      }
    })
  )
}

// Source note — informal attribution below a figure
// Usage: #source("https://example.com")
#let source(url) = align(right,
  text(size: font.small, style: "italic", fill: rgb("9ca3af"))[
    Source: #link(url)[#url]
  ]
)


// ── 9. COLUMN HELPERS ─────────────────────────────────────────────────────────

#let cols2(gutter: 1.5em, body) = columns(2, gutter: gutter, body)
#let cols3(gutter: 1.2em, body) = columns(3, gutter: gutter, body)
#let cols4(gutter: 1.0em, body) = columns(4, gutter: gutter, body)

// Lettered sub-exercise list:  a)  b)  c) ...
#let subex(..items) = enum(
  numbering: "a)",
  ..items
)

// Multi-column lettered sub-exercise list
#let subex-cols(cols: 2, gutter: 1.2em, ..items) = columns(
  cols,
  gutter: gutter,
  enum(numbering: "a)", ..items)
)

// Nested sub-sub-exercise list:  (i)  (ii)  (iii) ...
#let subsubex(..items) = enum(
  numbering: "(i)",
  ..items
)


// ── 10. GRAPH / PLOT HELPERS ─────────────────────────────────────────────────
// Wrappers around CeTZ-Plot that enforce square grids and sensible defaults.
// Authors provide functions, ranges, labels and styling; layout is handled here.

// Single-function plot
// Usage:
//   #math-plot(
//     x-min: -3, x-max: 3, y-min: -2, y-max: 5,
//     x-label: $x$, y-label: $f(x)$,
//     curves: (
//       (fn: x => x * x, label: $f(x) = x^2$, stroke: blue + 1.5pt),
//     )
//   )
#let math-plot(
  size:       8,           // single number → square canvas
  x-min:      -5,
  x-max:      5,
  y-min:      -5,
  y-max:      5,
  x-label:    $x$,
  y-label:    $y$,
  x-tick-step: auto,
  y-tick-step: auto,
  x-ticks:    none,
  y-ticks:    none,
  grid:       true,
  curves:     (),          // array of (fn, label, stroke, domain?) dicts
  points:     (),          // array of (coord, label, anchor?) dicts
  fills:      (),          // array of (fn, x-min?, x-max?, fill?) dicts
) = canvas({
  plot.plot(
    size:        (size, size),
    x-min:       x-min,
    x-max:       x-max,
    y-min:       y-min,
    y-max:       y-max,
    x-label:     x-label,
    y-label:     y-label,
    x-tick-step: x-tick-step,
    y-tick-step: y-tick-step,
    x-ticks:     if x-ticks != none { x-ticks },
    y-ticks:     if y-ticks != none { y-ticks },
    x-grid:      grid,
    y-grid:      grid,
    {
      // Draw filled regions first (so curves render on top)
      for f in fills {
        plot.add-fill(
          f.fn,
          domain:  (f.at("x-min", default: x-min),
                    f.at("x-max", default: x-max)),
          fill:    f.at("fill", default: blue.lighten(70%)),
          style:   (stroke: none),
        )
      }

      // Draw curves
      for c in curves {
        plot.add(
          c.fn,
          domain: (c.at("domain-min", default: x-min),
                   c.at("domain-max", default: x-max)),
          label:  c.at("label", default: none),
          style:  (stroke: c.at("stroke", default: blue + 1.5pt)),
        )
      }

      // Register named anchors for point annotations
      for (i, pt) in points.enumerate() {
        plot.add-anchor("pt-" + str(i), pt.coord)
      }
    }
  )

  // Annotate points after the plot is drawn
  for (i, pt) in points.enumerate() {
    draw.circle(
      "pt-" + str(i),
      radius: 0.07,
      fill:   black,
      stroke: none,
    )
    draw.content(
      "pt-" + str(i),
      anchor:  pt.at("anchor", default: "south-west"),
      padding: 4pt,
      pt.at("label", default: []),
    )
  }
})


// ── 11. PAGE HEADER / FOOTER BUILDERS ────────────────────────────────────────
// Called from lecture.typ and exercises.typ with the resolved palette
// and document metadata.

#let make-header(palette, topic-title, section-title) = context {
  set text(size: font.small, fill: palette.neutral)
  grid(
    columns: (1fr, 1fr),
    align:   (left, right),
    text(weight: "bold")[#topic-title],
    text(style: "italic")[#section-title],
  )
  v(-6pt)
  line(length: 100%, stroke: 0.4pt + palette.muted)
}

#let make-footer(palette, institution) = context {
  line(length: 100%, stroke: 0.3pt + palette.muted)
  v(-4pt)
  set text(size: font.small, fill: palette.neutral)
  grid(
    columns: (1fr, auto),
    align:   (left, right),
    institution,
    counter(page).display("1 / 1", both: true),
  )
}
