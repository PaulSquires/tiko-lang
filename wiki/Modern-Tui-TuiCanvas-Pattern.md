[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas.Pattern**

# TuiCanvas.Pattern

## Syntax

```freebasic
TuiCanvas.Pattern( byval cx as int32, byval cy as int32 ) as uint8
```

## Description

The raw 8-bit braille pattern for one cell -- the byte added to U+2800. The bit order is the HISTORICAL braille order, not raster order: bit 6 is the bottom-left dot, not the fourth in reading order. All 256 patterns are covered by the module's own tests.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiCanvas cv = TuiCanvas( 1, 1 )        '' one cell: 2 x 4 dots
cv.Dot( 0, 0, TuiWhite( ) )
print cv.Pattern( 0, 0 )          '' 1 -- the top-left dot is bit 0
cv.Clear( )
cv.Dot( 0, 3, TuiWhite( ) )
print cv.Pattern( 0, 0 )          '' 64 -- BOTTOM-left is bit 6, not bit 3
```

## See also

[TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiSeries](Modern-Tui-TuiSeries) · [TuiGraph](Modern-Tui-TuiGraph)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)