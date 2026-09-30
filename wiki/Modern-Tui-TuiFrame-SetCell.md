[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.SetCell**

# TuiFrame.SetCell

## Syntax

```freebasic
TuiFrame.SetCell( byval x as long, byval y as long, byref ch as ustring, byval st as TuiStyle )
```

## Description

Writes one cell. THE STYLE IS ASSIGNED, NOT MERGED -- to compose with what is underneath, patch first. Out-of-clip coordinates are dropped.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen scr
scr.Resize( 20, 4 )
dim as TuiFrame ptr f = scr.BeginFrame( )

f->SetCell( 1, 1, "*", TuiStyleOf( TuiWhite( ), TuiBlue( ) ) )
print scr.Back( )->At( 1, 1 )->st.bg.Index( )      '' 4

'' composing instead of replacing
dim as TuiStyle under = scr.Back( )->At( 1, 1 )->st
f->SetCell( 1, 1, "*", under.Patch( TuiStylePatch( TuiRed( ), TuiDefaultColor( ), _
                                                   0, 0 ) ) )
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