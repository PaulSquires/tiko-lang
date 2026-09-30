[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Buffer and Frame](Category-Terminal-TUI-Library) › **TuiFrame.PopLayer**

# TuiFrame.PopLayer

## Syntax

```freebasic
TuiFrame.PopLayer( )
```

## Description

Ends the overlay started by PushLayer. Every PushLayer needs exactly one.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiScreen scr
scr.Resize( 10, 3 )
dim as TuiFrame ptr f = scr.BeginFrame( )
f->PushLayer( f->Area( ) )
f->PopLayer( )
print f->Clip( ).w                '' 10
```

## See also

[TuiCell](Modern-Tui-TuiCell) · [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) · [TuiCell.Equals](Modern-Tui-TuiCell-Equals) · [TuiCellBlank](Modern-Tui-TuiCellBlank) · [TuiBuffer](Modern-Tui-TuiBuffer) · [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) · [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) · [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) · [TuiBuffer.At](Modern-Tui-TuiBuffer-At) · [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) · [TuiFrame](Modern-Tui-TuiFrame) · [TuiFrame.Area](Modern-Tui-TuiFrame-Area)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Buffer and Frame  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)