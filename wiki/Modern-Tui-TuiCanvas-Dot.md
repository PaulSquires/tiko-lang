[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas.Dot**

# TuiCanvas.Dot

## Syntax

```freebasic
TuiCanvas.Dot( byval x as int32, byval y as int32, byval c as TuiColor )
```

## Description

Sets one dot in DOT coordinates, with a colour that tints the cell containing it. Out-of-range coordinates are dropped, like every other drawing call.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiCanvas cv = TuiCanvas( 4, 2 )        '' 8 x 8 dots
cv.Dot( 0, 0, TuiRgb( 90, 200, 90 ) )
cv.Dot( 7, 7, TuiRgb( 90, 200, 90 ) )
cv.Dot( 999, 999, TuiWhite( ) )                '' dropped, no error
print cv.Pattern( 0, 0 ) <> 0      '' -1 (true)
print cv.Pattern( 3, 1 ) <> 0      '' -1 (true)
```

## See also

[TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiSeries](Modern-Tui-TuiSeries) · [TuiGraph](Modern-Tui-TuiGraph)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)