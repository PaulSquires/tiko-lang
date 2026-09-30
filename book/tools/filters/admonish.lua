--[[ admonish.lua -- render mdbook-admonish blocks in the PDF.

     ```admonish danger title="Pitfall"
     body
     ```

     becomes the typst callout the template draws. The style maps to the book's own kinds,
     so the site and the PDF show the same box with the same heading.

     pandoc cannot read that fence itself: an info string of more than one word is not a
     code-block class, so it is parsed as an inline code span and the admonition prints as raw
     text. build/pdf.sh therefore runs tools/prep_admonish.py first, which rewrites each fence
     into a fenced div,

         ::: {.admonish style="danger" title="Pitfall"}

     and this filter turns that div into the callout. The body stays markdown, so it is
     typeset rather than verbatim, and a div can sit anywhere a block can.
--]]

local TITLE = {
  danger  = "Pitfall",
  note    = "Note",
  info    = "Note",
  tip     = "Coming from FreeBASIC",
  warning = "Status in this version",
}

local KIND = {          -- typst callout name, per admonish style
  danger  = "pitfall",
  note    = "note",
  info    = "note",
  tip     = "fbcompat",
  warning = "tiko-status",
}

local function has_class(el, name)
  for _, c in ipairs(el.classes) do
    if c == name then return true end
  end
  return false
end

function Div(el)
  if not has_class(el, "admonish") then return nil end
  local style = el.attributes["style"] or "note"
  local title = el.attributes["title"] or TITLE[style] or "Note"
  local kind = KIND[style] or "note"
  local out = { pandoc.RawBlock("typst", '#callout("' .. kind .. '", [' .. title .. '])[') }
  for _, b in ipairs(el.content) do out[#out + 1] = b end
  out[#out + 1] = pandoc.RawBlock("typst", "]")
  return out
end
