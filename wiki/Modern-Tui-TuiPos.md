[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiPos**

# TuiPos

Holds a cell position: x and y.

## Syntax

```freebasic
type TuiPos
    as int32 x, y
end type
```

## Description

A cell coordinate. Returned by TuiFrame.CursorPos.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiPos p
p.x = 3 : p.y = 7
print p.x, p.y                    '' 3 7
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiRect](Modern-Tui-TuiRect) | [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) | [TuiRect.Contains](Modern-Tui-TuiRect-Contains) | [TuiRect.Inner](Modern-Tui-TuiRect-Inner) | [TuiRectOf](Modern-Tui-TuiRectOf) | [TuiSizeOf](Modern-Tui-TuiSizeOf) |
| [TuiRect.Right](Modern-Tui-TuiRect-Right) | [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) | [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) | [TuiRect.Equals](Modern-Tui-TuiRect-Equals) | [TuiSize](Modern-Tui-TuiSize) | [TuiMargin](Modern-Tui-TuiMargin) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)