[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiTree**

# TuiTree

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

A collapsible tree with guides and its own scroll. Left collapses, right expands, and only visible nodes are counted for scrolling. Like TuiList and TuiTable it clamps in Render -- its earlier version clamped the offset downward only, so it could scroll up to reveal a selection but never down.

## Example

```freebasic
#import "std/tui"
using FB

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

[TuiPopup](Modern-Tui-TuiPopup) · [TuiMessageBox](Modern-Tui-TuiMessageBox) · [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) · [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) · [TuiMenu](Modern-Tui-TuiMenu) · [TuiMenuBar](Modern-Tui-TuiMenuBar) · [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) · [TuiStatusItem](Modern-Tui-TuiStatusItem) · [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) · [TuiStatusBar](Modern-Tui-TuiStatusBar) · [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) · [TuiTreeNode](Modern-Tui-TuiTreeNode)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)