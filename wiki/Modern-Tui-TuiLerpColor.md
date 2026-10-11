[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiLerpColor**

# TuiLerpColor

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

[TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiSeries](Modern-Tui-TuiSeries)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)