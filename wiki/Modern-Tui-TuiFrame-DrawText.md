[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.DrawText**

# TuiFrame.DrawText

## Syntax

```freebasic
TuiFrame.DrawText( byval x as long, byval y as long, byref s as ustring, byval st as TuiStyle ) as long
```

## Description

Draws a string and returns the COLUMNS it advanced -- not the character count, which is what you add to x to place the next thing. A wide glyph advances 2 and a combining mark advances 0.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen scr
scr.Resize( 40, 4 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as long adv = f->DrawText( 0, 0, "hello", TuiStyleDefault( ) )
print adv                         '' 5

'' the shape for laying out a row of pieces
dim as long x = 0
x += f->DrawText( x, 1, "name: ", TuiStyleDefault( ) )
x += f->DrawText( x, 1, "quinn",  TuiStyleDefault( ) )
print x                           '' 11
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