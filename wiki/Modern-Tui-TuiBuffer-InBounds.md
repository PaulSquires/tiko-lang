[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiBuffer.InBounds**

# TuiBuffer.InBounds

## Syntax

```freebasic
TuiBuffer.InBounds( byval x as int32, byval y as int32 ) as boolean
```

## Description

Bounds check. At( ) does not check for you, so this is the guard when you index a buffer directly.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiBuffer b
b.Resize( 10, 4 )
print b.InBounds( 9, 3 )          '' true
print b.InBounds( 10, 3 )         '' false
print b.InBounds( -1, 0 )         '' false
```

## See also

[TuiCell](Modern-Tui-TuiCell) · [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) · [TuiCell.Equals](Modern-Tui-TuiCell-Equals) · [TuiCellBlank](Modern-Tui-TuiCellBlank) · [TuiBuffer](Modern-Tui-TuiBuffer) · [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) · [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) · [TuiBuffer.At](Modern-Tui-TuiBuffer-At) · [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) · [TuiFrame](Modern-Tui-TuiFrame) · [TuiFrame.Area](Modern-Tui-TuiFrame-Area) · [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)