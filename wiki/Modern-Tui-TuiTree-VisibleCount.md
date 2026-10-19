[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiTree.VisibleCount**

# TuiTree.VisibleCount

Counts the nodes currently shown, leaving out those inside collapsed nodes.

## Syntax

```freebasic
TuiTree.VisibleCount( ) as int32
```

## Description

How many nodes are currently visible -- children of a collapsed node do not count. This is the number a scrollbar wants, not nodes.Count.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTreeState st
dim as TuiTree t
t.Add( "root", 0, TRUE, 1 )
t.Add( "hidden child", 1, FALSE, 2 )
t.state = @st
print t.nodes.Count( )            '' 2
print t.VisibleCount( ) <= t.nodes.Count( ) '' -1 (true)
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