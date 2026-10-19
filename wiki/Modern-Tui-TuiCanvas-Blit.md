[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Charts](Category-Terminal-TUI-Library) › **TuiCanvas.Blit**

# TuiCanvas.Blit

Draws the canvas into an area of the frame as braille characters.

## Syntax

```freebasic
TuiCanvas.Blit( byref f as TuiFrame, byval area as TuiRect )
```

## Description

Draws the canvas into a frame as braille characters, one per cell, each tinted by the dots inside it.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 20, 5 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as TuiCanvas cv = TuiCanvas( 20, 5 )
cv.Line_( 0, 19, 39, 0, TuiRgb( 120, 220, 160 ) )
cv.Blit( *f, f->Area( ) )
print len( scr.Render( TUIDEPTH_TRUECOLOR ) ) > 0 '' -1 (true)
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiCanvas](Modern-Tui-TuiCanvas) | [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) | [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) | [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) |
| [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) | [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) | [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) | [TuiSeries](Modern-Tui-TuiSeries) |
| [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) | [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) | [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) | [TuiGraph](Modern-Tui-TuiGraph) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Charts  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)