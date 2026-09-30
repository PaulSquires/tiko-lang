[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiStack**

# TuiStack

## Syntax

```freebasic
type TuiStack extends TuiWidget
    as TuiWidgetPtrArray children
    as TuiConstraintArray constraints
    as boolean vertical
end type
```

## Description

A container that lays its children out with the constraint solver and forwards events to them. UNLIKE EVERY OTHER WIDGET IT OWNS ITS CHILDREN -- the destructor deletes them, so Add things you allocated with NEW.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiStack st
st.vertical = TRUE

dim as TuiParagraph ptr a = new TuiParagraph
a->text = "top"
st.Add( a, TuiLength( 1 ) )       '' the stack now owns `a`

dim as TuiParagraph ptr b = new TuiParagraph
b->text = "bottom"
st.Add( b, TuiFill( ) )

print st.children.Count( )        '' 2
'' no delete here: ~TuiStack does it
```

## See also

[TuiWidget](Modern-Tui-TuiWidget) · [TuiWidget.Render](Modern-Tui-TuiWidget-Render) · [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) · [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) · [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) · [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) · [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) · [TuiFocusRing](Modern-Tui-TuiFocusRing) · [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) · [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) · [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) · [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)