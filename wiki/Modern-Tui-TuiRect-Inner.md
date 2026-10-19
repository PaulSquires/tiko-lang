[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect.Inner**

# TuiRect.Inner

Returns the rectangle shrunk by a margin, empty rather than negative.

## Syntax

```freebasic
TuiRect.Inner( byval m as TuiMargin ) as TuiRect
```

## Description

The rect shrunk by a margin. It never goes negative -- a margin larger than the rect gives an empty rect, not an inverted one.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiRect r = TuiRectOf( 0, 0, 20, 10 )
dim as TuiRect i = r.Inner( TuiMarginOf( 2, 1, 2, 1 ) )
print i.x, i.y, i.w, i.h          '' 2 1 16 8

'' over-shrinking clamps rather than inverting
print r.Inner( TuiMarginAll( 40 ) ).IsEmpty( )     '' true
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiRect](Modern-Tui-TuiRect) | [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) | [TuiRect.Contains](Modern-Tui-TuiRect-Contains) | [TuiRect.Equals](Modern-Tui-TuiRect-Equals) | [TuiSize](Modern-Tui-TuiSize) | [TuiPos](Modern-Tui-TuiPos) |
| [TuiRect.Right](Modern-Tui-TuiRect-Right) | [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) | [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) | [TuiRectOf](Modern-Tui-TuiRectOf) | [TuiSizeOf](Modern-Tui-TuiSizeOf) | [TuiMargin](Modern-Tui-TuiMargin) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)