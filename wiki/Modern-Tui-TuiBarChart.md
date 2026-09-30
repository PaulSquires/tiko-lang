[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiBarChart**

# TuiBarChart

## Syntax

```freebasic
type TuiBarChart extends TuiWidget
    as TuiBarArray bars
    as int32 barWidth, barGap
    as boolean horizontal, showLabels
    as TuiStyle labelStyle
end type
```

## Description

Labelled bars, vertical or horizontal. Scaled to the largest value present.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiScreen scr
scr.Resize( 30, 8 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as TuiBarChart bc
for i as int32 = 0 to 3
    dim as TuiBar b
    b.label = chr( asc( "a" ) + i )
    b.value = ( i + 1 ) * 10.0
    b.color = TuiRgb( 90, 200, 90 )
    bc.bars.Push( b )
next
bc.barWidth = 3 : bc.barGap = 1
bc.showLabels = TRUE
bc.Render( *f, f->Area( ) )
print bc.bars.Count( )            '' 4
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