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
using tui

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