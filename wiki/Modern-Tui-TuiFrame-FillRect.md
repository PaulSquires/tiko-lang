[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.FillRect**

# TuiFrame.FillRect

## Syntax

```freebasic
TuiFrame.FillRect( byval r as TuiRect, byref ch as ustring, byval st as TuiStyle )
```

## Description

Fills a rect with one character in one style. This is how a block paints its background.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiScreen scr
scr.Resize( 20, 6 )
dim as TuiFrame ptr f = scr.BeginFrame( )

f->FillRect( TuiRectOf( 2, 1, 6, 3 ), " ", TuiStyleOf( TuiWhite( ), TuiBlue( ) ) )
print scr.Back( )->At( 2, 1 )->st.bg.Index( )      '' 4
print scr.Back( )->At( 8, 1 )->st.bg.IsDefault( )  '' true -- outside the fill
```

## See also

[TuiCell](Modern-Tui-TuiCell) · [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) · [TuiCell.Equals](Modern-Tui-TuiCell-Equals) · [TuiCellBlank](Modern-Tui-TuiCellBlank) · [TuiBuffer](Modern-Tui-TuiBuffer) · [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) · [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) · [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) · [TuiBuffer.At](Modern-Tui-TuiBuffer-At) · [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) · [TuiFrame](Modern-Tui-TuiFrame) · [TuiFrame.Area](Modern-Tui-TuiFrame-Area)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)