--[[
  exercise-solutions.lua
  ======================
  Links exercises to their solutions in lecture notes.

  Features:
  - Strips {.solution} from exercise flow; re-emits at {.solutions-list} marker
  - Automatic sequential numbering
  - Named exercises via title= attribute
  - Per-chapter counter reset via exercise-reset-per-chapter metadata
  - YouTube QR codes on solutions via yt= attribute (or yt-a=, yt-b= for sub-parts)
  - Section-scoped solution lists via section= attribute on {.solutions-list}

  SYNTAX
  ------
  Basic exercise:
    ::: {.exercise}
    Content
    ::: {.solution}
    Answer
    :::
    :::

  Named exercise with YouTube solution video:
    ::: {.exercise title="Rope Trick" yt="dQw4w9WgXcQ"}
    Content
    ::: {.solution}
    Answer
    :::
    :::

  Exercise with per-subpart videos:
    ::: {.exercise yt-a="HASH1" yt-b="HASH2"}
    ...
    :::

  Solutions list marker (place anywhere — end of section or chapter):
    ::: {.solutions-list}
    :::

  Section-scoped solutions list:
    ::: {.solutions-list section="Solving Equations"}
    :::
--]]

local YT_BASE = "https://youtu.be/"

local all_exercises     = {}
local exercise_count    = 0
local current_section   = ""
local reset_per_chapter = false

-- ── Helpers ───────────────────────────────────────────────────────────────────

local function yt_url(hash)
  return YT_BASE .. hash
end

-- Build a list of QR blocks from yt attributes on an exercise element
local function make_qr_blocks(attrs)
  local blocks = {}

  -- Single video: yt="HASH"
  if attrs["yt"] and attrs["yt"] ~= "" then
    table.insert(blocks,
      pandoc.RawBlock("typst",
        '#sol-qr("' .. yt_url(attrs["yt"]) .. '")'
      )
    )
  end

  -- Sub-part videos: yt-a="HASH" yt-b="HASH" ...
  for _, letter in ipairs({"a","b","c","d","e","f"}) do
    local key = "yt-" .. letter
    if attrs[key] and attrs[key] ~= "" then
      table.insert(blocks,
        pandoc.RawBlock("typst",
          '#sol-qr("' .. yt_url(attrs[key]) .. '", label: "' .. letter .. ')")'
        )
      )
    end
  end

  return blocks
end

-- ── Metadata ──────────────────────────────────────────────────────────────────

function Meta(meta)
  if meta["exercise-reset-per-chapter"] then
    reset_per_chapter = pandoc.utils.stringify(
      meta["exercise-reset-per-chapter"]) ~= "false"
  end
  return meta
end

-- ── Heading tracker ───────────────────────────────────────────────────────────

function Header(el)
  current_section = pandoc.utils.stringify(el)
  if reset_per_chapter and el.level == 1 then
    exercise_count = 0
  end
  return el
end

-- ── Exercise / solution processor ─────────────────────────────────────────────

function Div(el)

  -- ── {.exercise} ───────────────────────────────────────────────────────────
  if el.classes:includes("exercise") then
    exercise_count = exercise_count + 1
    local n     = exercise_count
    local title = el.attributes["title"] or nil
    local attrs = el.attributes

    local exercise_blocks = {}
    local solution_blocks = nil

    for _, block in ipairs(el.content) do
      if block.t == "Div" and block.classes:includes("solution") then
        solution_blocks = block.content
      else
        table.insert(exercise_blocks, block)
      end
    end

    -- Store record
    table.insert(all_exercises, {
      number           = n,
      title            = title,
      section          = current_section,
      has_solution     = (solution_blocks ~= nil),
      solution_content = solution_blocks or {},
      attrs            = attrs,
    })

    -- Emit exercise with header bar and body wrapper
    local title_arg = title and ('"' .. title .. '"') or "none"
    local out = {}
    table.insert(out,
      pandoc.RawBlock("typst",
        "#ex-header(p, " .. tostring(n) .. ", " .. title_arg .. ")"
      )
    )
    table.insert(out,
      pandoc.RawBlock("typst", "#ex-body(p, [")
    )
    for _, b in ipairs(exercise_blocks) do
      table.insert(out, b)
    end
    table.insert(out, pandoc.RawBlock("typst", "])"))

    return pandoc.Div(out)
  end

  -- ── {.solutions-list} ─────────────────────────────────────────────────────
  if el.classes:includes("solutions-list") then
    local section_filter = el.attributes["section"] or nil
    local result = {}

    -- Heading
    table.insert(result,
      pandoc.Header(3, {pandoc.Str("Solutions")},
        pandoc.Attr("", {"solutions-heading"}, {}))
    )

    local found_any = false

    for _, ex in ipairs(all_exercises) do
      local include = true
      if section_filter and section_filter ~= "" then
        include = (ex.section == section_filter)
      end

      if include and ex.has_solution then
        found_any = true
        local title_arg = ex.title and ('"' .. ex.title .. '"') or "none"

        -- Solution header
        table.insert(result,
          pandoc.RawBlock("typst",
            "#sol-header(p, " .. tostring(ex.number) .. ", " .. title_arg .. ")"
          )
        )
        -- Solution body open
        table.insert(result,
          pandoc.RawBlock("typst", "#sol-body(p, [")
        )
        -- Solution content
        for _, b in ipairs(ex.solution_content) do
          table.insert(result, b)
        end
        -- QR codes for YouTube solution videos
        for _, qr in ipairs(make_qr_blocks(ex.attrs)) do
          table.insert(result, qr)
        end
        -- Solution body close
        table.insert(result,
          pandoc.RawBlock("typst", "])")
        )
      end
    end

    if not found_any then
      table.insert(result,
        pandoc.Para({pandoc.Emph({pandoc.Str("No solutions available.")})}))
    end

    return pandoc.Div(result)
  end

end
