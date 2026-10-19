[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiBuffer.Count**

# TuiBuffer.Count

Returns the number of cells: columns times rows.

## Syntax

```freebasic
TuiBuffer.Count( ) as int32
```

## Description

cols * rows.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiBuffer b
b.Resize( 200, 50 )
print b.Count( )                  '' 10000 -- the size the benchmark diffs
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiCell](Modern-Tui-TuiCell) | [TuiCell.Equals](Modern-Tui-TuiCell-Equals) | [TuiBuffer](Modern-Tui-TuiBuffer) | [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) | [TuiBuffer.At](Modern-Tui-TuiBuffer-At) | [TuiFrame.Area](Modern-Tui-TuiFrame-Area) |
| [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) | [TuiCellBlank](Modern-Tui-TuiCellBlank) | [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) | [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) | [TuiFrame](Modern-Tui-TuiFrame) | [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)