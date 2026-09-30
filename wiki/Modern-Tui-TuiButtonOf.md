[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiButtonOf**

# TuiButtonOf

## Syntax

```freebasic
type TuiButtonOf( of F ) extends TuiWidget
    as ustring label
    as int32 id
    as F handler
end type
```

## Description

A button whose handler is a CAPTURING lambda. It exists because of two hard compiler limits: a capturing lambda cannot become a procptr (error 355), and one stored in a TYPE field cannot be called through field access (error 10). A generic widget extending the non-generic base solves both -- the lambda's anonymous type becomes the type parameter, and the body copies it to a local before calling it.

## Example

```freebasic
#import "std/tui"
using FB

dim as int32 clicks = 0

'' the lambda CAPTURES clicks, so a plain TuiButton could not hold it
var handler = sub( byval id as int32 )
    clicks += 1
end sub

dim as TuiButtonOf( of typeof( handler ) ) b
b.label = "Count"
b.handler = handler
b.SetFocused( TRUE )

dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_ENTER
b.HandleEvent( e )
print clicks                      '' 1
```

## See also

[TuiWidget](Modern-Tui-TuiWidget) · [TuiWidget.Render](Modern-Tui-TuiWidget-Render) · [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) · [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) · [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) · [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) · [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) · [TuiFocusRing](Modern-Tui-TuiFocusRing) · [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) · [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) · [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) · [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)