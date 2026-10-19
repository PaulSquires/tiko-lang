[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas.DotHeight**

# TuiCanvas.DotHeight

Returns the canvas height in dots, four per cell.

## Syntax

```freebasic
TuiCanvas.DotHeight( ) as int32
```

## Description

The canvas height in dots -- cells times 4. Four times the vertical resolution is the whole reason to use braille.

## Example

```freebasic
#import "std/tui"
using tui

print TuiCanvas( 40, 10 ).DotHeight( )         '' 40
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiCanvas](Modern-Tui-TuiCanvas) | [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) | [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) | [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) | [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) | [TuiSeries](Modern-Tui-TuiSeries) |
| [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) | [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) | [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) | [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) | [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) | [TuiGraph](Modern-Tui-TuiGraph) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)