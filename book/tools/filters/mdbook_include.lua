--[[ mdbook_include.lua -- expand mdBook's {{#include}} for the PDF build.

     The book's markdown is mdBook-native (B23), so the PDF pipeline has to understand
     the same two forms mdBook does:

        {{#include ../examples/ch01/hello.tiko}}
        {{#include ../examples/ch01/hello.tiko:anchor}}

     An anchor is the region between  '' ANCHOR: name  and  '' ANCHOR_END: name .
     A missing file or unknown anchor is a hard error: the PDF must never print code
     that the harness did not compile.

     Paths are relative to the markdown file, exactly as in mdBook, so the two editions
     read the same source.
--]]

local src_dir = "src/"        -- where the chapter files live; {{#include ../x}} escapes it

local function read_file(path)
  local f = io.open(path, "rb")
  if not f then error("mdbook_include.lua: cannot open " .. path) end
  local s = f:read("a"); f:close()
  return (s:gsub("\r\n", "\n"))
end

local function take_anchor(text, name, path)
  local want_start = "^%s*''%s*ANCHOR:%s*" .. name:gsub("(%W)", "%%%1") .. "%s*$"
  local want_end   = "^%s*''%s*ANCHOR_END:%s*" .. name:gsub("(%W)", "%%%1") .. "%s*$"
  local inside, out = false, {}
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    if not inside and line:match(want_start) then
      inside = true
    elseif inside and line:match(want_end) then
      break
    elseif inside then
      out[#out + 1] = line
    end
  end
  if #out == 0 then
    error("mdbook_include.lua: anchor '" .. name .. "' not found in " .. path)
  end
  -- A region may contain other anchors -- a spanning "all" anchor contains every one of them.
  -- mdBook drops those marker lines from an anchored include, so this must too, or the PDF
  -- prints scaffolding that the site does not.
  local kept = {}
  for _, line in ipairs(out) do
    if not line:match("^%s*''%s*ANCHOR") then kept[#kept + 1] = line end
  end
  return table.concat(kept, "\n")
end

-- Whole-file includes drop the anchor comments; they are scaffolding, not code.
local function strip_anchors(text)
  local out = {}
  for line in (text .. "\n"):gmatch("([^\n]*)\n") do
    if not line:match("^%s*''%s*ANCHOR") then out[#out + 1] = line end
  end
  return (table.concat(out, "\n"):gsub("\n+$", ""))
end

function CodeBlock(el)
  local spec = el.text:match("^%s*{{#include%s+([^}]+)}}%s*$")
  if not spec then return nil end

  local path, anchor = spec:match("^(.-):([%w_%-]+)$")
  path = path or spec
  path = path:gsub("^%s+", ""):gsub("%s+$", "")

  -- mdBook resolves relative to the .md file, which lives in src/.
  local resolved = path:gsub("^%.%./", "")
  if resolved == path then resolved = src_dir .. path end

  local text = read_file(resolved)
  el.text = anchor and take_anchor(text, anchor, resolved) or strip_anchors(text)

  local caption = pandoc.RawBlock("typst", '#listing-caption[' .. resolved .. ']')
  return { caption, el }
end
