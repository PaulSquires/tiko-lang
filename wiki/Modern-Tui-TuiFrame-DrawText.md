[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.DrawText**

# TuiFrame.DrawText

## Syntax

```freebasic
TuiFrame.DrawText( byval x as int32, byval y as int32, byref s as ustring, byval st as TuiStyle ) as int32
```

## Description

Draws a string and returns the COLUMNS it advanced -- not the character count, which is what you add to x to place the next thing. A wide glyph advances 2 and a combining mark advances 0.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 40, 4 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as int32 adv = f->DrawText( 0, 0, "hello", TuiStyleDefault( ) )
print adv                         '' 5

'' the shape for laying out a row of pieces
dim as int32 x = 0
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
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)