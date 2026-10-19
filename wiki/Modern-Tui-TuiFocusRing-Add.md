[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiFocusRing.Add**

# TuiFocusRing.Add

Adds a widget to the end of the Tab order; the widget must outlive the frame.

## Syntax

```freebasic
TuiFocusRing.Add( byval w as TuiWidget ptr )
```

## Description

Appends a widget to the tab order. The ring stores the pointer and nothing else -- no ownership, no copy.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiCheckbox a, b
dim as boolean va, vb
a.checked = @va : b.checked = @vb

dim as TuiFocusRing ring
ring.Add( @a )
ring.Add( @b )
print ring.Count( )               '' 2
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiWidget](Modern-Tui-TuiWidget) | [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) | [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) | [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) |
| [TuiWidget.Render](Modern-Tui-TuiWidget-Render) | [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) | [TuiFocusRing](Modern-Tui-TuiFocusRing) | [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) |
| [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) | [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) | [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) | [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)