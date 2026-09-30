[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiScreen.Resize**

# TuiScreen.Resize

## Syntax

```freebasic
TuiScreen.Resize( byval ncols as int32, byval nrows as int32 )
```

## Description

Reshapes both buffers and invalidates. Call this on a resize event -- TuiRun already does.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiScreen scr
scr.Resize( 80, 24 )
print scr.Cols( ), scr.Rows( )    '' 80 24
scr.Resize( 120, 40 )
print scr.Cols( ), scr.Rows( )    '' 120 40
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