[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiCell.SetChar**

# TuiCell.SetChar

## Syntax

```freebasic
TuiCell.SetChar( byval cp as uint32 )
```

## Description

Sets the base codepoint and recomputes the cell's column width from the Unicode table.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiCell c = TuiCellBlank( TuiStyleDefault( ) )
c.SetChar( &h3042 )               '' HIRAGANA A -- East Asian Wide
print c.width                     '' 2
c.SetChar( asc( "x" ) )
print c.width                     '' 1
```

## See also

[TuiCell](Modern-Tui-TuiCell) · [TuiCell.Equals](Modern-Tui-TuiCell-Equals) · [TuiCellBlank](Modern-Tui-TuiCellBlank) · [TuiBuffer](Modern-Tui-TuiBuffer) · [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) · [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) · [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) · [TuiBuffer.At](Modern-Tui-TuiBuffer-At) · [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) · [TuiFrame](Modern-Tui-TuiFrame) · [TuiFrame.Area](Modern-Tui-TuiFrame-Area) · [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)