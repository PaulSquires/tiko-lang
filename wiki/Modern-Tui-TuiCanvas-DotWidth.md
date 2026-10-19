[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas.DotWidth**

# TuiCanvas.DotWidth

Returns the canvas width in dots, two per cell.

## Syntax

```freebasic
TuiCanvas.DotWidth( ) as int32
```

## Description

The canvas width in dots -- cells times 2.

## Example

```freebasic
#import "std/tui"
using tui

print TuiCanvas( 40, 10 ).DotWidth( )          '' 80
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiCanvas](Modern-Tui-TuiCanvas) | [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) | [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) | [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) | [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) | [TuiSeries](Modern-Tui-TuiSeries) |
| [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) | [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) | [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) | [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) | [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) | [TuiGraph](Modern-Tui-TuiGraph) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)