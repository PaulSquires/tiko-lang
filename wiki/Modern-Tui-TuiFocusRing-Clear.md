[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Widgets](Category-Terminal-TUI-Library) › **TuiFocusRing.Clear**

# TuiFocusRing.Clear

Empties the Tab order; the widgets themselves are left alone.

## Syntax

```freebasic
TuiFocusRing.Clear( )
```

## Description

Empties the ring. Nothing is deleted -- the widgets are yours.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiCheckbox a
dim as boolean v
a.checked = @v
dim as TuiFocusRing ring
ring.Add( @a )
ring.Clear( )
print ring.Count( )               '' 0
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiWidget](Modern-Tui-TuiWidget) | [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) | [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) | [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) |
| [TuiWidget.Render](Modern-Tui-TuiWidget-Render) | [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) | [TuiFocusRing](Modern-Tui-TuiFocusRing) | [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) |
| [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) | [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) | [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) | [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)