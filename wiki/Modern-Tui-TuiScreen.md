[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiScreen**

# TuiScreen

## Syntax

```freebasic
type TuiScreen
    declare function BeginFrame( ) as TuiFrame ptr
    declare function Render( byval depth as TuiColorDepth ) as string
    ...
end type
```

## Description

Two buffers and the diff between them. Draw into the frame, call Render, and get back ONLY the bytes needed to turn what the terminal is showing into what you drew.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 20, 5 )

dim as TuiFrame ptr f = scr.BeginFrame( )
f->DrawText( 0, 0, "hello", TuiStyleDefault( ) )
print len( scr.Render( TUIDEPTH_ANSI16 ) ) > 0 '' -1 (true)  -- first frame

'' render the SAME thing again
f = scr.BeginFrame( )
f->DrawText( 0, 0, "hello", TuiStyleDefault( ) )
print len( scr.Render( TUIDEPTH_ANSI16 ) )         '' 0 -- nothing changed
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