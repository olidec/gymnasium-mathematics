# Gymnasium Mathematics — Lecture Notes

Course materials for Gymnasium Mathematics, authored in [Quarto](https://quarto.org)
with [Typst](https://typst.app) as the rendering backend.

---

## Topics

| # | Topic | Lecture Notes | Exercises |
|---|-------|--------------|-----------|
| 01 | Algebra | [PDF](_output/topics/01-algebra/lecture.pdf) | [PDF](_output/topics/01-algebra/exercises.pdf) |
| 02 | Functions | [PDF](_output/topics/02-functions/lecture.pdf) | [PDF](_output/topics/02-functions/exercises.pdf) |
| 03 | Trigonometry & Geometry | [PDF](_output/topics/03-trigonometry/lecture.pdf) | [PDF](_output/topics/03-trigonometry/exercises.pdf) |
| 04 | Vectors & Linear Algebra | [PDF](_output/topics/04-vectors/lecture.pdf) | [PDF](_output/topics/04-vectors/exercises.pdf) |
| 05 | Calculus | [PDF](_output/topics/05-calculus/lecture.pdf) | [PDF](_output/topics/05-calculus/exercises.pdf) |
| 06 | Statistics | [PDF](_output/topics/06-statistics/lecture.pdf) | [PDF](_output/topics/06-statistics/exercises.pdf) |
| 07 | Probability & Combinatorics | [PDF](_output/topics/07-probability/lecture.pdf) | [PDF](_output/topics/07-probability/exercises.pdf) |
| 08 | Sequences & Series | [PDF](_output/topics/08-sequences/lecture.pdf) | [PDF](_output/topics/08-sequences/exercises.pdf) |
| 09 | Complex Numbers | [PDF](_output/topics/09-complex/lecture.pdf) | [PDF](_output/topics/09-complex/exercises.pdf) |

---

## Repository Structure

```
gymnasium-mathematics/
├── shared/
│   ├── styles/
│   │   ├── shared.typ        ← central style library (colour engine, all environments)
│   │   ├── lecture.typ       ← lecture notes page setup
│   │   └── exercises.typ     ← exercise sheet page setup
│   ├── filters/
│   │   ├── exercise-solutions.lua   ← links exercises to solutions
│   │   └── extract-exercises.lua    ← builds standalone exercise sheets
│   └── templates/            ← reference templates for new topics
├── topics/
│   └── 01-algebra/
│       ├── _metadata.yml     ← topic colour, title, shared settings
│       ├── lecture.qmd       ← lecture notes source
│       ├── exercises.qmd     ← exercise sheet (includes lecture.qmd)
│       └── images/
├── _quarto.yml               ← project build settings
└── .vscode/
    └── typst.code-snippets   ← authoring shortcuts
```

---

## Adding a New Topic

1. Add one line to the colour registry in `shared/styles/shared.typ`
2. Create a folder under `topics/` with `_metadata.yml`, `lecture.qmd`, `exercises.qmd`
3. Copy front matter from `shared/templates/`
4. Add a row to this README

---

## Local Rendering

```bash
# Install dependencies (once)
# https://quarto.org/docs/get-started/
# https://typst.app

# Render a single topic
quarto render topics/01-algebra/

# Render one file
quarto render topics/01-algebra/lecture.qmd

# Render the entire curriculum
quarto render
```

---

## Exercise Authoring

### Basic exercise with solution
```markdown
::: {.exercise}
Simplify $\frac{x^2 - 25}{x^2 + 10x + 25}$.

::: {.solution}
$\frac{x-5}{x+5}$
:::
:::
```

### Exercise with YouTube solution video
```markdown
::: {.exercise yt="dQw4w9WgXcQ"}
...
:::
```
The 11-character hash comes from the YouTube short URL `https://youtu.be/HASH`.
The QR code appears automatically alongside the solution.

### Sub-part videos
```markdown
::: {.exercise yt-a="HASH1" yt-b="HASH2"}
...
:::
```

### Solutions marker (place at end of section or chapter)
```markdown
::: {.solutions-list}
:::
```
