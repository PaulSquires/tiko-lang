[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiBar**

# TuiBar

Holds one bar of a bar chart: its label, value and colour.

## Syntax

```freebasic
type TuiBar
    as ustring label
    as float64 value
    as TuiColor color
end type
```

## Description

One bar of a bar chart.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiBar b
b.label = "mon"
b.value = 42.0
b.color = TuiRgb( 90, 200, 90 )
print b.label, b.value            '' mon 42
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiCanvas](Modern-Tui-TuiCanvas) | [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) | [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) | [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) |
| [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) | [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) | [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) | [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) |
| [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) | [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) | [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) | [TuiSeries](Modern-Tui-TuiSeries) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)