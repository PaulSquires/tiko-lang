[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas**

# TuiCanvas

Holds a braille drawing surface with a grid of 2 by 4 dots in every cell.

## Syntax

```freebasic
type TuiCanvas
    declare constructor( byval cols as int32, byval rows as int32 )
    declare sub Dot( byval x as int32, byval y as int32, byval c as TuiColor )
    ...
end type
```

## Description

A braille sub-cell drawing surface. Each terminal cell holds a 2x4 dot grid, so a canvas sized in CELLS gives you four times the vertical resolution. The block uses the HISTORICAL braille dot order, which is not raster order -- Pattern exposes the byte if you want to check.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiCanvas cv = TuiCanvas( 40, 10 )      '' CELLS
print cv.CellCols( ), cv.CellRows( )           '' 40 10
print cv.DotWidth( ), cv.DotHeight( )          '' 80 40 -- 2x and 4x

cv.Dot( 12, 7, TuiRgb( 120, 220, 160 ) )
cv.Line_( 0, 0, 79, 39, TuiRgb( 200, 80, 80 ) )
print cv.Pattern( 0, 0 ) <> 0      '' -1 (true)  -- something is set
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) | [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) | [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) | [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) |
| [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) | [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) | [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) | [TuiSeries](Modern-Tui-TuiSeries) |
| [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) | [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) | [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) | [TuiGraph](Modern-Tui-TuiGraph) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)