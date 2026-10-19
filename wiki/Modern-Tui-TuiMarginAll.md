[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiMarginAll**

# TuiMarginAll

Returns a margin of the same size on every side.

## Syntax

```freebasic
TuiMarginAll( byval n as int32 ) as TuiMargin
```

## Description

A margin of n on every side. This is what a one-cell border costs.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiRect r = TuiRectOf( 0, 0, 30, 10 )
dim as TuiRect inside = r.Inner( TuiMarginAll( 1 ) )
print inside.w, inside.h          '' 28 8
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiRect](Modern-Tui-TuiRect) | [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) | [TuiRect.Contains](Modern-Tui-TuiRect-Contains) | [TuiRect.Inner](Modern-Tui-TuiRect-Inner) | [TuiRectOf](Modern-Tui-TuiRectOf) | [TuiSizeOf](Modern-Tui-TuiSizeOf) |
| [TuiRect.Right](Modern-Tui-TuiRect-Right) | [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) | [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) | [TuiRect.Equals](Modern-Tui-TuiRect-Equals) | [TuiSize](Modern-Tui-TuiSize) | [TuiPos](Modern-Tui-TuiPos) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)