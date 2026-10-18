[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiScreen.Render**

# TuiScreen.Render

## Syntax

```freebasic
TuiScreen.Render( byval depth as TuiColorDepth ) as string
```

## Description

Diffs back against front, emits the bytes, and swaps. The style is carried ACROSS frames as well as within one -- a stuck highlight was a real defect here, where a deselected row emitted no SGR because its style matched an assumed default the terminal was no longer in.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 16, 3 )

dim as TuiFrame ptr f = scr.BeginFrame( )
f->DrawText( 0, 0, "abc", TuiStyleDefault( ) )
dim as string first_ = scr.Render( TUIDEPTH_TRUECOLOR )

f = scr.BeginFrame( )
f->DrawText( 0, 0, "abd", TuiStyleDefault( ) )     '' one character differs
dim as string second_ = scr.Render( TUIDEPTH_TRUECOLOR )

print len( second_ ) < len( first_ ) '' -1 (true)  -- only the diff
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