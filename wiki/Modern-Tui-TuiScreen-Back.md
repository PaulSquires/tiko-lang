[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiScreen.Back**

# TuiScreen.Back

Returns the buffer being drawn into, so a test can read its cells.

## Syntax

```freebasic
TuiScreen.Back( ) as TuiBuffer ptr
```

## Description

The buffer being drawn into. Reading cells out of it is how you assert what a View produced, with no terminal involved.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 20, 3 )
dim as TuiFrame ptr f = scr.BeginFrame( )
f->DrawText( 2, 1, "hi", TuiStyleOf( TuiRed( ), TuiDefaultColor( ) ) )

print scr.Back( )->At( 2, 1 )->st.fg.Index( )      '' 1 -- red, as asked
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiCell](Modern-Tui-TuiCell) | [TuiCell.Equals](Modern-Tui-TuiCell-Equals) | [TuiBuffer](Modern-Tui-TuiBuffer) | [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) | [TuiBuffer.At](Modern-Tui-TuiBuffer-At) | [TuiFrame](Modern-Tui-TuiFrame) |
| [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) | [TuiCellBlank](Modern-Tui-TuiCellBlank) | [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) | [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) | [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) | [TuiFrame.Area](Modern-Tui-TuiFrame-Area) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)