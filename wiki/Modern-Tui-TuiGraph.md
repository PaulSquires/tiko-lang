[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiGraph**

# TuiGraph

## Syntax

```freebasic
type TuiGraph extends TuiWidget
    as TuiSeriesArray series
    as ubyte graphKind
    as double minY, maxY
    as boolean autoScale, showAxes
end type
```

## Description

A line graph over one or more series. TUIGRAPH_BRAILLE gives the highest resolution; _BLOCK and _BAR are the coarser fallbacks for a terminal without a braille font. Turn autoScale off and set minY/maxY when the axis should be stable -- a percentage plot that rescales itself is unreadable.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen scr
scr.Resize( 40, 10 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as TuiGraph g
g.graphKind = TUIGRAPH_BRAILLE
g.autoScale = FALSE               '' a percentage axis should not move
g.minY = 0 : g.maxY = 100

dim as TuiSeries s
for i as long = 0 to 199
    s.data.Push( 50.0 + sin( i / 9.0 ) * 45.0 )
next
s.color = TuiRgb( 120, 220, 160 )
g.series.Push( s )
g.Render( *f, f->Area( ) )
print g.series.Count( )           '' 1
```

## See also

[TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiSeries](Modern-Tui-TuiSeries)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)