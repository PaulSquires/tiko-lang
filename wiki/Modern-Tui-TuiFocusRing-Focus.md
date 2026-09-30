[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiFocusRing.Focus**

# TuiFocusRing.Focus

## Syntax

```freebasic
TuiFocusRing.Focus( byval w as TuiWidget ptr ) as boolean
```

## Description

Focuses a specific widget, returning false when it is not in the ring. This is what a mouse click calls.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiCheckbox a, b, stranger
dim as boolean va, vb, vs
a.checked = @va : b.checked = @vb : stranger.checked = @vs

dim as TuiFocusRing ring
ring.Add( @a ) : ring.Add( @b )
print ring.Focus( @b )            '' true
print ring.Focus( @stranger )     '' false -- never added
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