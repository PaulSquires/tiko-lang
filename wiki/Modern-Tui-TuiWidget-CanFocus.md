[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiWidget.CanFocus**

# TuiWidget.CanFocus

Returns true if the widget can take focus; false unless it is interactive.

## Syntax

```freebasic
TuiWidget.CanFocus( ) as boolean
```

## Description

Whether this widget can take focus. False by default, so decoration is skipped by the focus ring automatically.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiParagraph p
dim as TuiCheckbox c
print p.CanFocus( )               '' false -- decoration
print c.CanFocus( )               '' true  -- interactive
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiWidget](Modern-Tui-TuiWidget) | [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) | [TuiFocusRing](Modern-Tui-TuiFocusRing) | [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) |
| [TuiWidget.Render](Modern-Tui-TuiWidget-Render) | [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) | [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) | [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) |
| [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) | [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) | [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) | [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)