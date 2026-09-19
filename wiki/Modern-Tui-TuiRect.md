[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect**

# TuiRect

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiRect
    as long x, y, w, h
end type
```

## Description

The only rectangle in the module. Everything is 0-based: VT coordinates are 1-based and the conversion happens inside the renderer, where you never see it.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiRect r = TuiRectOf( 4, 2, 20, 6 )
print r.x, r.y, r.w, r.h          '' 4 2 20 6
print r.Right( ), r.Bottom( )     '' 24 8  -- x+w and y+h, one PAST the edge

'' A rect is a value. Passing one copies it; there is nothing to free.
dim as TuiRect copy_ = r
copy_.w = 1
print r.w                         '' 20 -- unchanged
```

## See also

[TuiRect.Right](Modern-Tui-TuiRect-Right) · [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) · [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) · [TuiRect.Contains](Modern-Tui-TuiRect-Contains) · [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) · [TuiRect.Inner](Modern-Tui-TuiRect-Inner) · [TuiRect.Equals](Modern-Tui-TuiRect-Equals) · [TuiRectOf](Modern-Tui-TuiRectOf) · [TuiSize](Modern-Tui-TuiSize) · [TuiSizeOf](Modern-Tui-TuiSizeOf) · [TuiPos](Modern-Tui-TuiPos) · [TuiMargin](Modern-Tui-TuiMargin)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)