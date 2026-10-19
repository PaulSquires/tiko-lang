[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.Area**

# TuiFrame.Area

Returns the whole screen as a rectangle at 0, 0, the start of every layout.

## Syntax

```freebasic
TuiFrame.Area( ) as TuiRect
```

## Description

The whole buffer, as a rect at 0,0. This is the root of every layout.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 80, 24 )
dim as TuiFrame ptr f = scr.BeginFrame( )
dim as TuiRect a = f->Area( )
print a.x, a.y, a.w, a.h          '' 0 0 80 24
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiCell](Modern-Tui-TuiCell) | [TuiCell.Equals](Modern-Tui-TuiCell-Equals) | [TuiBuffer](Modern-Tui-TuiBuffer) | [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) | [TuiBuffer.At](Modern-Tui-TuiBuffer-At) | [TuiFrame](Modern-Tui-TuiFrame) |
| [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) | [TuiCellBlank](Modern-Tui-TuiCellBlank) | [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) | [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) | [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) | [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)