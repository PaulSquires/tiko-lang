[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiMenuBar.IsOpen**

# TuiMenuBar.IsOpen

## Syntax

```freebasic
TuiMenuBar.IsOpen( ) as boolean
```

## Description

Whether a drop-down is showing.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiMenuBar bar
dim as TuiMenu m
m.label = "File" : m.items.Push( "Quit" )
bar.menus.Push( m )
print bar.IsOpen( )               '' false
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiPopup](Modern-Tui-TuiPopup) | [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) | [TuiStatusItem](Modern-Tui-TuiStatusItem) | [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) |
| [TuiMessageBox](Modern-Tui-TuiMessageBox) | [TuiMenu](Modern-Tui-TuiMenu) | [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) | [TuiTreeNode](Modern-Tui-TuiTreeNode) |
| [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) | [TuiMenuBar](Modern-Tui-TuiMenuBar) | [TuiStatusBar](Modern-Tui-TuiStatusBar) | [TuiTreeState](Modern-Tui-TuiTreeState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)