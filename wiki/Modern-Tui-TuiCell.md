[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiCell**

# TuiCell

Holds one character cell: the character, its style and its width in columns.

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
using tui

dim as TuiCell c = TuiCellBlank( TuiStyleDefault( ) )
print c.width                     '' 1
c.SetChar( asc( "A" ) )
print c.width                     '' 1
c.SetChar( &h4E2D )               '' a CJK ideograph
print c.width                     '' 2
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) | [TuiCellBlank](Modern-Tui-TuiCellBlank) | [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) | [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) | [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) | [TuiFrame.Area](Modern-Tui-TuiFrame-Area) |
| [TuiCell.Equals](Modern-Tui-TuiCell-Equals) | [TuiBuffer](Modern-Tui-TuiBuffer) | [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) | [TuiBuffer.At](Modern-Tui-TuiBuffer-At) | [TuiFrame](Modern-Tui-TuiFrame) | [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)