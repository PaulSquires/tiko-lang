[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiStack**

# TuiStack

Holds child widgets laid out in a row or column; it deletes them when it goes.

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
using tui

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

|   |   |   |   |
|---|---|---|---|
| [TuiWidget](Modern-Tui-TuiWidget) | [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) | [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) | [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) |
| [TuiWidget.Render](Modern-Tui-TuiWidget-Render) | [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) | [TuiFocusRing](Modern-Tui-TuiFocusRing) | [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) |
| [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) | [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) | [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) | [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)