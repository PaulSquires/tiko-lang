[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiBuffer.At**

# TuiBuffer.At

## Syntax

```freebasic
TuiBuffer.At( byval x as int32, byval y as int32 ) as TuiCell ptr
```

## Description

A pointer to one cell. It returns a POINTER rather than a byref because taking the address of a byref-returning function yields the address of the PROCEDURE instead, silently -- a trap this module hit and now avoids everywhere.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiBuffer b
b.Resize( 8, 2 )
b.Clear( TuiStyleDefault( ) )

dim as TuiCell ptr c = b.At( 2, 1 )
c->SetChar( asc( "Z" ) )
print b.At( 2, 1 )->width         '' 1 -- the write landed in the buffer
```

## See also

[TuiCell](Modern-Tui-TuiCell) · [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) · [TuiCell.Equals](Modern-Tui-TuiCell-Equals) · [TuiCellBlank](Modern-Tui-TuiCellBlank) · [TuiBuffer](Modern-Tui-TuiBuffer) · [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) · [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) · [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) · [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) · [TuiFrame](Modern-Tui-TuiFrame) · [TuiFrame.Area](Modern-Tui-TuiFrame-Area) · [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)