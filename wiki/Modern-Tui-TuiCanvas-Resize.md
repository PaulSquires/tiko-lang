[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas.Resize**

# TuiCanvas.Resize

## Syntax

```freebasic
TuiCanvas.Resize( byval cols as int32, byval rows as int32 )
```

## Description

Reshapes the canvas in CELLS and clears it. A graph does this every frame when its area changes.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiCanvas cv = TuiCanvas( 10, 3 )
print cv.DotWidth( )              '' 20
cv.Resize( 40, 10 )
print cv.DotWidth( ), cv.DotHeight( )          '' 80 40
```

## See also

[TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiSeries](Modern-Tui-TuiSeries) · [TuiGraph](Modern-Tui-TuiGraph)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)