[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect.Equals**

# TuiRect.Equals

Returns true if two rectangles have the same position and size.

## Syntax

```freebasic
TuiRect.Equals( byval o as TuiRect ) as boolean
```

## Description

Field-by-field comparison. Useful for skipping work when a computed layout has not moved.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiRect a = TuiRectOf( 1, 2, 3, 4 )
print a.Equals( TuiRectOf( 1, 2, 3, 4 ) )    '' true
print a.Equals( TuiRectOf( 1, 2, 3, 5 ) )    '' false
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiRect](Modern-Tui-TuiRect) | [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) | [TuiRect.Contains](Modern-Tui-TuiRect-Contains) | [TuiRect.Inner](Modern-Tui-TuiRect-Inner) | [TuiSize](Modern-Tui-TuiSize) | [TuiPos](Modern-Tui-TuiPos) |
| [TuiRect.Right](Modern-Tui-TuiRect-Right) | [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) | [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) | [TuiRectOf](Modern-Tui-TuiRectOf) | [TuiSizeOf](Modern-Tui-TuiSizeOf) | [TuiMargin](Modern-Tui-TuiMargin) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)