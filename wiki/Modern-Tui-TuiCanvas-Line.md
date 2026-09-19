[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas.Line_**

# TuiCanvas.Line_

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiCanvas.Line_( byval x0 as long, byval y0 as long, byval x1 as long, byval y1 as long, byval c as TuiColor )
```

## Description

A Bresenham line in dot coordinates. The underscore is because LINE is a statement. This is what joins consecutive samples in a braille graph, which is why the plot looks continuous rather than dotted.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiCanvas cv = TuiCanvas( 20, 5 )       '' 40 x 20 dots
cv.Line_( 0, 0, 39, 19, TuiRgb( 200, 80, 80 ) )
print cv.Pattern( 0, 0 ) <> 0      '' -1 (true)  -- it starts here
print cv.Pattern( 19, 4 ) <> 0     '' -1 (true)  -- and ends here
```

## See also

[TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiSeries](Modern-Tui-TuiSeries) · [TuiGraph](Modern-Tui-TuiGraph)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)