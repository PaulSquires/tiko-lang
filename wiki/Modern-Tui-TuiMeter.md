[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiMeter**

# TuiMeter

## Syntax

```freebasic
type TuiMeter extends TuiWidget
    as float64 ratio
    as TuiColor from_, to_
    as TuiColor trackColor
    as boolean partialCells
    as uint8 meterStyle
    as int32 segmentEvery
end type
```

## Description

A gradient bar: the colour interpolates from `from_` to `to_` ALONG THE BAR, so a meter reads green at the left and red at the right regardless of how full it is. `partialCells` uses eighth-blocks for sub-cell precision. `from_` and `to_` carry underscores because FROM and TO are keywords.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 30, 1 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as TuiMeter m
m.ratio = 0.62
m.from_ = TuiRgb( 80, 220, 120 )
m.to_ = TuiRgb( 235, 80, 80 )
m.trackColor = TuiRgb( 60, 60, 60 )
m.partialCells = TRUE
m.meterStyle = TUIMETER_SEGMENTED       '' SOLID HATCHED SEGMENTED
m.segmentEvery = 3
m.Render( *f, f->Area( ) )
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