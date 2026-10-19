[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiFocusRing.Next_**

# TuiFocusRing.Next_

Moves focus to the next widget, wrapping at the end, as Tab does.

## Syntax

```freebasic
TuiFocusRing.Next_( )
```

## Description

Moves focus forward, wrapping at the end. This is Tab. The underscore is because NEXT is a statement.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiCheckbox a, b
dim as boolean va, vb
a.checked = @va : b.checked = @vb

dim as TuiFocusRing ring
ring.Add( @a ) : ring.Add( @b )

ring.Next_( )
print ring.Current( ).Value( ) = @b '' -1 (true)
ring.Next_( )
print ring.Current( ).Value( ) = @a '' -1 (true)  -- it wrapped
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