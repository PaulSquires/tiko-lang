[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiTree**

# TuiTree

Draws a tree of nodes that the user expands and collapses with the arrow keys.

## Syntax

```freebasic
type TuiTree extends TuiWidget
    as TuiTreeNodeArray nodes
    as TuiTreeState ptr state
    as TuiStyle normal, selectedStyle
    as boolean useUnicode
end type
```

## Description

A collapsible tree with guides and its own scroll. Left collapses, right expands, and only visible nodes are counted for scrolling. Like TuiList and TuiTable it clamps the offset in Render, in both directions, so it scrolls up or down to reveal a selection.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTreeState st
dim as TuiTree t
t.Add( "src", 0, TRUE, 1 )
t.Add( "fb", 1, TRUE, 2 )
t.Add( "tui.bi", 2, FALSE, 3 )
t.Add( "docs", 0, TRUE, 4 )
t.state = @st
t.useUnicode = TRUE

print t.nodes.Count( )            '' 4
print t.VisibleCount( ) <= 4       '' -1 (true)  -- collapsed nodes hide children
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