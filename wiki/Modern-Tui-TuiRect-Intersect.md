[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect.Intersect**

# TuiRect.Intersect

Returns the overlap of two rectangles, or an empty one if they do not touch.

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

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiRect](Modern-Tui-TuiRect) | [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) | [TuiRect.Contains](Modern-Tui-TuiRect-Contains) | [TuiRect.Equals](Modern-Tui-TuiRect-Equals) | [TuiSize](Modern-Tui-TuiSize) | [TuiPos](Modern-Tui-TuiPos) |
| [TuiRect.Right](Modern-Tui-TuiRect-Right) | [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) | [TuiRect.Inner](Modern-Tui-TuiRect-Inner) | [TuiRectOf](Modern-Tui-TuiRectOf) | [TuiSizeOf](Modern-Tui-TuiSizeOf) | [TuiMargin](Modern-Tui-TuiMargin) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)