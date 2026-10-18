[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.SetCell**

# TuiFrame.SetCell

## Syntax

```freebasic
TuiFrame.SetCell( byval x as int32, byval y as int32, byref ch as ustring, byval st as TuiStyle )
```

## Description

Writes one cell. THE STYLE IS ASSIGNED, NOT MERGED -- to compose with what is underneath, patch first. Out-of-clip coordinates are dropped.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 20, 4 )
dim as TuiFrame ptr f = scr.BeginFrame( )

f->SetCell( 1, 1, "*", TuiStyleOf( TuiWhite( ), TuiBlue( ) ) )
print scr.Back( )->At( 1, 1 )->st.bg.Index( )      '' 4

'' composing instead of replacing
dim as TuiStyle under = scr.Back( )->At( 1, 1 )->st
f->SetCell( 1, 1, "*", under.Patch( TuiStylePatch( TuiRed( ), TuiDefaultColor( ), _
                                                   0, 0 ) ) )
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