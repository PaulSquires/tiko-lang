[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas**

# TuiCanvas

## Syntax

```freebasic
type TuiCanvas
    declare constructor( byval cols as long, byval rows as long )
    declare sub Dot( byval x as long, byval y as long, byval c as TuiColor )
    ...
end type
```

## Description

A braille sub-cell drawing surface. Each terminal cell holds a 2x4 dot grid, so a canvas sized in CELLS gives you four times the vertical resolution. The block uses the HISTORICAL braille dot order, which is not raster order -- Pattern exposes the byte if you want to check.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiCanvas cv = TuiCanvas( 40, 10 )      '' CELLS
print cv.CellCols( ), cv.CellRows( )           '' 40 10
print cv.DotWidth( ), cv.DotHeight( )          '' 80 40 -- 2x and 4x

cv.Dot( 12, 7, TuiRgb( 120, 220, 160 ) )
cv.Line_( 0, 0, 79, 39, TuiRgb( 200, 80, 80 ) )
print cv.Pattern( 0, 0 ) <> 0      '' -1 (true)  -- something is set
```

## See also

[TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiSeries](Modern-Tui-TuiSeries) · [TuiGraph](Modern-Tui-TuiGraph)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)