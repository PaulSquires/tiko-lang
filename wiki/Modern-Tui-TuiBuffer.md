[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiBuffer**

# TuiBuffer

Holds a grid of character cells, stored row by row.

## Syntax

```freebasic
type TuiBuffer
    as TuiCellArray cells
    as int32 cols, rows
    ...
end type
```

## Description

A flat grid of cells, row-major. TuiScreen owns two of these -- front and back -- and the diff is the comparison between them.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiBuffer b
b.Resize( 20, 5 )
print b.cols, b.rows, b.Count( )       '' 20 5 100

b.Clear( TuiStyleDefault( ) )
print b.At( 0, 0 )->width              '' 1 -- a blank
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiCell](Modern-Tui-TuiCell) | [TuiCell.Equals](Modern-Tui-TuiCell-Equals) | [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) | [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) | [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) | [TuiFrame.Area](Modern-Tui-TuiFrame-Area) |
| [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) | [TuiCellBlank](Modern-Tui-TuiCellBlank) | [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) | [TuiBuffer.At](Modern-Tui-TuiBuffer-At) | [TuiFrame](Modern-Tui-TuiFrame) | [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)