[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas.Clear**

# TuiCanvas.Clear

Turns every dot off.

## Syntax

```freebasic
TuiCanvas.Clear( )
```

## Description

Turns every dot off.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiCanvas cv = TuiCanvas( 4, 2 )
cv.Dot( 0, 0, TuiWhite( ) )
print cv.Pattern( 0, 0 ) <> 0      '' -1 (true)
cv.Clear( )
print cv.Pattern( 0, 0 )          '' 0
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiCanvas](Modern-Tui-TuiCanvas) | [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) | [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) | [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) |
| [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) | [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) | [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) | [TuiSeries](Modern-Tui-TuiSeries) |
| [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) | [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) | [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) | [TuiGraph](Modern-Tui-TuiGraph) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)