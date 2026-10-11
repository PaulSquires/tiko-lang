[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect.Intersect**

# TuiRect.Intersect

## Syntax

```freebasic
TuiRect.Intersect( byval o as TuiRect ) as TuiRect
```

## Description

The overlap of two rects, or an empty rect when they do not touch. This is what clipping is built out of.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiRect a = TuiRectOf( 0, 0, 20, 10 )
dim as TuiRect b = TuiRectOf( 15, 5, 20, 10 )
dim as TuiRect hit = a.Intersect( b )
print hit.x, hit.y, hit.w, hit.h        '' 15 5 5 5

dim as TuiRect miss = a.Intersect( TuiRectOf( 50, 50, 4, 4 ) )
print miss.IsEmpty( )                   '' true -- ALWAYS check
```

## See also

[TuiRect](Modern-Tui-TuiRect) · [TuiRect.Right](Modern-Tui-TuiRect-Right) · [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) · [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) · [TuiRect.Contains](Modern-Tui-TuiRect-Contains) · [TuiRect.Inner](Modern-Tui-TuiRect-Inner) · [TuiRect.Equals](Modern-Tui-TuiRect-Equals) · [TuiRectOf](Modern-Tui-TuiRectOf) · [TuiSize](Modern-Tui-TuiSize) · [TuiSizeOf](Modern-Tui-TuiSizeOf) · [TuiPos](Modern-Tui-TuiPos) · [TuiMargin](Modern-Tui-TuiMargin)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)