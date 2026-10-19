[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.PushClip**

# TuiFrame.PushClip

Limits drawing to a rectangle and returns the previous limit, to restore later.

## Syntax

```freebasic
TuiFrame.PushClip( byval r as TuiRect ) as TuiRect
```

## Description

Narrows the clip to the intersection of the current clip and r, and RETURNS THE OLD ONE so you can restore it. Widgets use this so a child cannot draw outside its area.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 30, 6 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as TuiRect saved = f->PushClip( TuiRectOf( 0, 0, 5, 6 ) )
f->DrawText( 0, 0, "0123456789", TuiStyleDefault( ) )
f->PopClip( saved )

'' only the first five columns landed
print scr.Back( )->At( 4, 0 )->width       '' 1
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