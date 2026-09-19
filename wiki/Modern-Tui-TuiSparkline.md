[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiSparkline**

# TuiSparkline

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiSparkline extends TuiWidget
    as TuiDoubleArray data
    as TuiColor color
end type
```

## Description

A single row of block characters -- one value per cell, eight height steps. For a trend beside a number, where a full graph would be too much.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen scr
scr.Resize( 20, 1 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as TuiSparkline sl
for i as long = 0 to 19
    sl.data.Push( cdbl( i ) )     '' TuiDoubleArray: push a double
next
sl.color = TuiRgb( 120, 220, 160 )
sl.Render( *f, f->Area( ) )
print sl.data.Count( )            '' 20
```

## See also

[TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiSeries](Modern-Tui-TuiSeries)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)