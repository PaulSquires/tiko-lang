[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiTree.Add**

# TuiTree.Add

## Syntax

```freebasic
TuiTree.Add( byref label as ustring, byval depth as int32, byval hasChildren as boolean = FALSE, byval userId as int32 = 0 )
```

## Description

Appends a node. Order matters: a node's children are the nodes that follow it with a greater depth, so build the array in the order you want it drawn.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTree t
t.Add( "root", 0, TRUE, 1 )
t.Add( "child", 1, FALSE, 2 )     '' a child BECAUSE it follows at depth 1
t.Add( "sibling", 0, FALSE, 3 )
print t.nodes.Count( )            '' 3
print t.nodes[1].depth            '' 1
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiPopup](Modern-Tui-TuiPopup) | [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) | [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) | [TuiStatusBar](Modern-Tui-TuiStatusBar) |
| [TuiMessageBox](Modern-Tui-TuiMessageBox) | [TuiMenu](Modern-Tui-TuiMenu) | [TuiStatusItem](Modern-Tui-TuiStatusItem) | [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) |
| [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) | [TuiMenuBar](Modern-Tui-TuiMenuBar) | [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) | [TuiTreeNode](Modern-Tui-TuiTreeNode) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)