[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiLerpColor**

# TuiLerpColor

Returns a colour part of the way between two others, for t from 0 to 1.

## Syntax

```freebasic
TuiLerpColor( byval a as TuiColor, byval b as TuiColor, byval t as float64 ) as TuiColor
```

## Description

Linear interpolation between two colours, t from 0 to 1. What a meter's gradient is made of, exposed because it is useful for a heat map or a threshold colour of your own.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiColor green_ = TuiRgb( 0, 255, 0 )
dim as TuiColor red_ = TuiRgb( 255, 0, 0 )
print TuiLerpColor( green_, red_, 0.0 ).g      '' 255
print TuiLerpColor( green_, red_, 1.0 ).r      '' 255
print TuiLerpColor( green_, red_, 0.5 ).r '' 128
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