--[[
  extract-exercises.lua
  =====================
  Builds a standalone exercise sheet from the same .qmd source
  as the lecture notes. Everything except exercises is suppressed.

  Each exercise appears with:
  - A section divider when the section changes
  - The exercise header and body
  - A blank dot-grid working page (unless exercise-blank-pages: false)

  YAML options (in exercises.qmd front matter):
    exercise-blank-pages: true        # default: true
    exercise-show-sections: true      # default: true
    exercise-reset-per-chapter: false # default: false
--]]

local exercises          = {}
local exercise_count     = 0
local current_chapter    = nil
local current_section    = nil
local reset_per_chapter  = false
local show_sections      = true
local blank_pages        = true

-- ── Metadata ──────────────────────────────────────────────────────────────────

function Meta(meta)
  local function getbool(key, default)
    if meta[key] ~= nil then
      return pandoc.utils.stringify(meta[key]) ~= "false"
    end
    return default
  end
  blank_pages        = getbool("exercise-blank-pages",      true)
  show_sections      = getbool("exercise-show-sections",    true)
  reset_per_chapter  = getbool("exercise-reset-per-chapter", false)
  return meta
end

-- ── Suppress everything except exercises ─────────────────────────────────────

function Header(el)
  local text = pandoc.utils.stringify(el)
  if el.level == 1 then
    current_chapter = text
    current_section = nil
    if reset_per_chapter then exercise_count = 0 end
  else
    current_section = text
  end
  return {}
end

function Div(el)
  if el.classes:includes("exercise") then
    exercise_count = exercise_count + 1

    -- Strip solution
    local content = {}
    for _, block in ipairs(el.content) do
      if not (block.t == "Div" and block.classes:includes("solution")) then
        table.insert(content, block)
      end
    end

    table.insert(exercises, {
      number  = exercise_count,
      title   = el.attributes["title"] or nil,
      chapter = current_chapter,
      section = current_section,
      content = content,
    })
    return {}
  end
  return {}
end

function Para()          return {} end
function Plain()         return {} end
function Table()         return {} end
function BulletList()    return {} end
function OrderedList()   return {} end
function BlockQuote()    return {} end
function CodeBlock()     return {} end
function RawBlock()      return {} end
function HorizontalRule() return {} end

-- ── Document rebuilder ────────────────────────────────────────────────────────

function Pandoc(doc)
  local function typst(code)
    return pandoc.RawBlock("typst", code)
  end

  local output = {}

  if #exercises == 0 then
    table.insert(output,
      pandoc.Para({pandoc.Str("No exercises found in source document.")}))
    return pandoc.Pandoc(output, doc.meta)
  end

  local prev = nil

  for _, ex in ipairs(exercises) do

    -- Section divider when chapter or section changes
    if show_sections then
      local chapter_changed = (prev == nil)
        or (ex.chapter ~= prev.chapter)
      local section_changed = (prev == nil)
        or (ex.section ~= prev.section)
        or chapter_changed

      if section_changed then
        local label = ""
        if ex.chapter then label = ex.chapter end
        if ex.section then
          label = label .. (label ~= "" and " › " or "") .. ex.section
        end
        if label ~= "" then
          table.insert(output,
            typst('#section-divider(p, "' .. label .. '")')
          )
        end
      end
    end

    -- Exercise header bar
    local title_arg = ex.title and ('"' .. ex.title .. '"') or "none"
    table.insert(output,
      typst("#ex-header(p, " .. tostring(ex.number) .. ", " .. title_arg .. ")")
    )

    -- Exercise body
    table.insert(output, typst("#ex-body(p, ["))
    for _, b in ipairs(ex.content) do
      table.insert(output, b)
    end
    table.insert(output, typst("])"))

    -- Blank dot-grid working page
    if blank_pages then
      table.insert(output, typst("#pagebreak()"))
      table.insert(output, typst([[
#page(
  header: [
    #set text(size: 8pt, fill: rgb("94a3b8"))
    #h(1fr) _Working space_
  ],
  margin: (top: 2cm, bottom: 1.5cm, x: 1.5cm),
  {
    let spacing = 0.7cm
    let dot-color = rgb("d1d5db")
    style(styles => {
      let w = measure(line(length: 100%), styles).width
      let h = 18cm
      let cols = int(w / spacing)
      let rows = int(h / spacing)
      for r in range(rows) {
        for c in range(cols) {
          place(
            dx: c * spacing,
            dy: r * spacing,
            circle(radius: 0.5pt, fill: dot-color)
          )
        }
      }
    })
  }
)]]))
    else
      table.insert(output, typst("#pagebreak()"))
    end

    prev = ex
  end

  return pandoc.Pandoc(output, doc.meta)
end
