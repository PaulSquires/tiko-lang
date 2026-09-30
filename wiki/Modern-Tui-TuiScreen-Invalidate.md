[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiScreen.Invalidate**

# TuiScreen.Invalidate

## Syntax

```freebasic
TuiScreen.Invalidate( )
```

## Description

Forgets what the terminal is showing, so the next Render is a full repaint including a clear. Use it after anything that changed the screen behind the module's back -- a resize, a suspend, a shell-out.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiScreen scr
scr.Resize( 10, 3 )
scr.BeginFrame( )
scr.Render( TUIDEPTH_ANSI16 )

scr.BeginFrame( )
print len( scr.Render( TUIDEPTH_ANSI16 ) )         '' 0 -- unchanged

scr.Invalidate( )
scr.BeginFrame( )
print len( scr.Render( TUIDEPTH_ANSI16 ) ) > 0 '' -1 (true)  -- full repaint
```

## See also

[TuiCell](Modern-Tui-TuiCell) · [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) · [TuiCell.Equals](Modern-Tui-TuiCell-Equals) · [TuiCellBlank](Modern-Tui-TuiCellBlank) · [TuiBuffer](Modern-Tui-TuiBuffer) · [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) · [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) · [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) · [TuiBuffer.At](Modern-Tui-TuiBuffer-At) · [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) · [TuiFrame](Modern-Tui-TuiFrame) · [TuiFrame.Area](Modern-Tui-TuiFrame-Area)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)