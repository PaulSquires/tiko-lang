[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect**

# TuiRect

## Syntax

```freebasic
type TuiRect
    as int32 x, y, w, h
end type
```

## Description

The only rectangle in the module. Everything is 0-based: VT coordinates are 1-based and the conversion happens inside the renderer, where you never see it.

## Example

```freebasic
#import "std/tui"
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

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)