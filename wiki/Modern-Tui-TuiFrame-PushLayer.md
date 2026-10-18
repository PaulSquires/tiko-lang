[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.PushLayer**

# TuiFrame.PushLayer

## Syntax

```freebasic
TuiFrame.PushLayer( byval r as TuiRect )
```

## Description

Starts an overlay. A popup or an open dropdown draws inside a layer, which is what makes the cells beneath it restorable when it closes -- and the reason an overlay may legitimately draw OUTSIDE the area it was given.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 30, 8 )
dim as TuiFrame ptr f = scr.BeginFrame( )

f->DrawText( 0, 0, "behind", TuiStyleDefault( ) )
f->PushLayer( TuiRectOf( 2, 0, 10, 3 ) )
f->FillRect( TuiRectOf( 2, 0, 10, 3 ), " ", TuiStyleOf( TuiWhite( ), TuiBlue( ) ) )
f->PopLayer( )
print scr.Back( )->At( 2, 0 )->st.bg.Index( )      '' 4
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