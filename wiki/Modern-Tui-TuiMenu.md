[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiMenu**

# TuiMenu

Holds one menu of a menu bar: its label and its items.

## Syntax

```freebasic
type TuiMenu
    as ustring label
    as TuiStringArray items
end type
```

## Description

One menu on a menu bar: its label and its drop-down items.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiMenu m
m.label = "File"
m.items.Push( "New" )
m.items.Push( "Open" )
m.items.Push( "Quit" )
print m.label, m.items.Count( )   '' File 3
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiPopup](Modern-Tui-TuiPopup) | [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) | [TuiStatusItem](Modern-Tui-TuiStatusItem) | [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) |
| [TuiMessageBox](Modern-Tui-TuiMessageBox) | [TuiMenuBar](Modern-Tui-TuiMenuBar) | [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) | [TuiTreeNode](Modern-Tui-TuiTreeNode) |
| [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) | [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) | [TuiStatusBar](Modern-Tui-TuiStatusBar) | [TuiTreeState](Modern-Tui-TuiTreeState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)