[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiFocusRing.Current**

# TuiFocusRing.Current

## Syntax

```freebasic
TuiFocusRing.Current( ) as Optional( of TuiWidget ptr )
```

## Description

The focused widget, or nothing when the ring is empty. It returns an Optional rather than a null pointer so the empty case has to be handled.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiCheckbox a
dim as boolean v
a.checked = @v

dim as TuiFocusRing ring
print ring.Current( ).HasValue( ) '' false -- empty ring

ring.Add( @a )
dim as Optional( of TuiWidget ptr ) cur = ring.Current( )
print cur.HasValue( )             '' true
print cur.Value( )->Kind( )       '' Checkbox
```

## See also

[TuiWidget](Modern-Tui-TuiWidget) · [TuiWidget.Render](Modern-Tui-TuiWidget-Render) · [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) · [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) · [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) · [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) · [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) · [TuiFocusRing](Modern-Tui-TuiFocusRing) · [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) · [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) · [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) · [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)