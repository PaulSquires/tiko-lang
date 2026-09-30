[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiSeries**

# TuiSeries

## Syntax

```freebasic
type TuiSeries
    as TuiDoubleArray data
    as TuiColor color
    as ustring name
end type
```

## Description

One line on a graph. THE RIGHTMOST SAMPLE IS THE NEWEST -- a history plot pushes on the end and drops from the front.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiSeries s
for i as int32 = 0 to 99
    s.data.Push( 50.0 + sin( i / 7.0 ) * 40.0 )
next
s.color = TuiRgb( 120, 220, 160 )
s.name = "cpu"
print s.data.Count( )             '' 100
```

## See also

[TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiGraph](Modern-Tui-TuiGraph)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)