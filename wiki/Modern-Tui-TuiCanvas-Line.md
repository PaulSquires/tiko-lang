[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas.Line_**

# TuiCanvas.Line_

## Syntax

```freebasic
TuiCanvas.Line_( byval x0 as int32, byval y0 as int32, byval x1 as int32, byval y1 as int32, byval c as TuiColor )
```

## Description

A Bresenham line in dot coordinates. The underscore is because LINE is a statement. This is what joins consecutive samples in a braille graph, which is why the plot looks continuous rather than dotted.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiCanvas cv = TuiCanvas( 20, 5 )       '' 40 x 20 dots
cv.Line_( 0, 0, 39, 19, TuiRgb( 200, 80, 80 ) )
print cv.Pattern( 0, 0 ) <> 0      '' -1 (true)  -- it starts here
print cv.Pattern( 19, 4 ) <> 0     '' -1 (true)  -- and ends here
```

## See also

[TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiSeries](Modern-Tui-TuiSeries) · [TuiGraph](Modern-Tui-TuiGraph)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)