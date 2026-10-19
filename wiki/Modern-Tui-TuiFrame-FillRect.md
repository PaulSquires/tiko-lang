[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.FillRect**

# TuiFrame.FillRect

Fills a rectangle with one character in one style.

## Syntax

```freebasic
TuiFrame.FillRect( byval r as TuiRect, byref ch as ustring, byval st as TuiStyle )
```

## Description

Fills a rect with one character in one style. This is how a block paints its background.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 20, 6 )
dim as TuiFrame ptr f = scr.BeginFrame( )

f->FillRect( TuiRectOf( 2, 1, 6, 3 ), " ", TuiStyleOf( TuiWhite( ), TuiBlue( ) ) )
print scr.Back( )->At( 2, 1 )->st.bg.Index( )      '' 4
print scr.Back( )->At( 8, 1 )->st.bg.IsDefault( )  '' true -- outside the fill
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