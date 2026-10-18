[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiGraph**

# TuiGraph

## Syntax

```freebasic
type TuiGraph extends TuiWidget
    as TuiSeriesArray series
    as uint8 graphKind
    as float64 minY, maxY
    as boolean autoScale, showAxes
end type
```

## Description

A line graph over one or more series. TUIGRAPH_BRAILLE gives the highest resolution; _BLOCK and _BAR are the coarser fallbacks for a terminal without a braille font. Turn autoScale off and set minY/maxY when the axis should be stable -- a percentage plot that rescales itself is unreadable.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 40, 10 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as TuiGraph g
g.graphKind = TUIGRAPH_BRAILLE
g.autoScale = FALSE               '' a percentage axis should not move
g.minY = 0 : g.maxY = 100

dim as TuiSeries s
for i as int32 = 0 to 199
    s.data.Push( 50.0 + sin( i / 9.0 ) * 45.0 )
next
s.color = TuiRgb( 120, 220, 160 )
g.series.Push( s )
g.Render( *f, f->Area( ) )
print g.series.Count( )           '' 1
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiCanvas](Modern-Tui-TuiCanvas) | [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) | [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) | [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) |
| [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) | [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) | [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) | [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) |
| [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) | [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) | [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) | [TuiSeries](Modern-Tui-TuiSeries) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)