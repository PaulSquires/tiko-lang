[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiWidget.SizeHint**

# TuiWidget.SizeHint

## Syntax

```freebasic
TuiWidget.SizeHint( byval avail as TuiRect ) as TuiSize
```

## Description

How big this widget would like to be, given the space available. Advisory: nothing is obliged to honour it, and the constraint solver does not consult it.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiParagraph p
p.text = "one" & chr( 10 ) & "two" & chr( 10 ) & "three"

print p.SizeHint( TuiRectOf( 0, 0, 40, 10 ) ).rows   '' 1 -- wrap is OFF, so the
                                  '' hint does not lay the text out
p.wrap = TRUE
print p.SizeHint( TuiRectOf( 0, 0, 40, 10 ) ).rows   '' 3 -- now it does
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiWidget](Modern-Tui-TuiWidget) | [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) | [TuiFocusRing](Modern-Tui-TuiFocusRing) | [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) |
| [TuiWidget.Render](Modern-Tui-TuiWidget-Render) | [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) | [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) | [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) |
| [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) | [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) | [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) | [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)