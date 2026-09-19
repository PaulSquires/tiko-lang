[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiWidget.Render**

# TuiWidget.Render

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiWidget.Render( byref f as TuiFrame, byval area as TuiRect )
```

## Description

Draw yourself into `area`. It cannot fail and must not mutate application state -- that is Update's job, and the separation is what makes a frame reproducible. Guard against an empty area at the top; a border on a tiny rect leaves nothing inside.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen scr
scr.Resize( 30, 5 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as TuiParagraph p
p.text = "drawn through the protocol"
p.Render( *f, f->Area( ) )
print scr.Back( )->At( 0, 0 )->width      '' 1
```

## See also

[TuiWidget](Modern-Tui-TuiWidget) · [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) · [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) · [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) · [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) · [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) · [TuiFocusRing](Modern-Tui-TuiFocusRing) · [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) · [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) · [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) · [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) · [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)