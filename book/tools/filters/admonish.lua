--[[ admonish.lua -- render mdbook-admonish blocks in the PDF.

     ```admonish danger title="Pitfall"
     body
     ```

     becomes the typst callout the template draws. The style maps to the book's own kinds,
     so the site and the PDF show the same box with the same heading.
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

function CodeBlock(el)
  local info = el.classes[1]
  if info ~= "admonish" then return nil end
  return nil        -- handled in Div/RawBlock form below
end

-- pandoc parses ```admonish <style> title="..." as a code block whose first class is
-- "admonish" and whose remaining words land in classes/attributes.
function Block(el) return nil end

function Pandoc(doc)
  local out = {}
  for _, b in ipairs(doc.blocks) do
    if b.t == "CodeBlock" and b.classes[1] == "admonish" then
      local style = b.classes[2] or "note"
      local title = b.attributes["title"] or TITLE[style] or "Note"
      local kind = KIND[style] or "note"
      out[#out + 1] = pandoc.RawBlock("typst", '#callout("' .. kind .. '", [' .. title .. '])[')
      -- the body is markdown inside the fence; parse it so it is typeset, not verbatim
      local inner = pandoc.read(b.text, "markdown").blocks
      for _, ib in ipairs(inner) do out[#out + 1] = ib end
      out[#out + 1] = pandoc.RawBlock("typst", "]")
    else
      out[#out + 1] = b
    end
  end
  doc.blocks = out
  return doc
end
