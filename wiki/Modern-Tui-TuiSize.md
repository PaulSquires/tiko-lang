[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiSize**

# TuiSize

Holds a size in columns and rows.

## Syntax

```freebasic
type TuiSize
    as int32 cols, rows
end type
```

## Description

Columns and rows. Returned by TuiTerminal.Size, by SizeHint, and carried on a resize event.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

dim as TuiSize s = TuiSizeOf( 80, 24 )
print s.cols, s.rows              '' 80 24

dim as TuiEvent e
e.kind = TUIEVENT_RESIZE
e.size = TuiSizeOf( 120, 40 )
print e.size.cols                 '' 120
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiRect](Modern-Tui-TuiRect) | [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) | [TuiRect.Contains](Modern-Tui-TuiRect-Contains) | [TuiRect.Inner](Modern-Tui-TuiRect-Inner) | [TuiRectOf](Modern-Tui-TuiRectOf) | [TuiPos](Modern-Tui-TuiPos) |
| [TuiRect.Right](Modern-Tui-TuiRect-Right) | [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) | [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) | [TuiRect.Equals](Modern-Tui-TuiRect-Equals) | [TuiSizeOf](Modern-Tui-TuiSizeOf) | [TuiMargin](Modern-Tui-TuiMargin) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)