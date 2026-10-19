[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiScreen.BeginFrame**

# TuiScreen.BeginFrame

Clears the back buffer and returns the frame to draw into.

## Syntax

```freebasic
TuiScreen.BeginFrame( ) as TuiFrame ptr
```

## Description

Clears the back buffer and returns the frame to draw into. Everything you want on screen must be drawn again -- that is the immediate-mode bargain.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 12, 3 )
dim as TuiFrame ptr f = scr.BeginFrame( )
f->DrawText( 0, 0, "one", TuiStyleDefault( ) )
scr.Render( TUIDEPTH_ANSI16 )

'' a NEW frame starts blank: "one" is gone unless drawn again
f = scr.BeginFrame( )
print len( scr.Render( TUIDEPTH_ANSI16 ) ) > 0 '' -1 (true)  -- it was erased
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiCell](Modern-Tui-TuiCell) | [TuiCell.Equals](Modern-Tui-TuiCell-Equals) | [TuiBuffer](Modern-Tui-TuiBuffer) | [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) | [TuiBuffer.At](Modern-Tui-TuiBuffer-At) | [TuiFrame](Modern-Tui-TuiFrame) |
| [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) | [TuiCellBlank](Modern-Tui-TuiCellBlank) | [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) | [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) | [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) | [TuiFrame.Area](Modern-Tui-TuiFrame-Area) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)