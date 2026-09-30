[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiStack.Add**

# TuiStack.Add

## Syntax

```freebasic
TuiStack.Add( byval w as TuiWidget ptr, byval c as TuiConstraint )
```

## Description

Appends a child and the constraint that sizes it. OWNERSHIP TRANSFERS -- the stack deletes it.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiStack st
dim as TuiParagraph ptr p = new TuiParagraph
p->text = "hello"
st.Add( p, TuiFill( ) )
print st.constraints.Count( )     '' 1
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