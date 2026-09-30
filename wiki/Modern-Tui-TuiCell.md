[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiCell**

# TuiCell

## Syntax

```freebasic
type TuiCell
    as TuiStyle st
    as uint8 width
    ...
end type
```

## Description

One character cell: a base codepoint, a short combining tail, a style and a column width. A WIDE glyph has width 2 and owns the following cell as a continuation -- the diff knows this and never splits a pair.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiCell c = TuiCellBlank( TuiStyleDefault( ) )
print c.width                     '' 1
c.SetChar( asc( "A" ) )
print c.width                     '' 1
c.SetChar( &h4E2D )               '' a CJK ideograph
print c.width                     '' 2
```

## See also

[TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) · [TuiCell.Equals](Modern-Tui-TuiCell-Equals) · [TuiCellBlank](Modern-Tui-TuiCellBlank) · [TuiBuffer](Modern-Tui-TuiBuffer) · [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) · [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) · [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) · [TuiBuffer.At](Modern-Tui-TuiBuffer-At) · [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) · [TuiFrame](Modern-Tui-TuiFrame) · [TuiFrame.Area](Modern-Tui-TuiFrame-Area) · [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)