[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiTreeState**

# TuiTreeState

Holds a tree's selected node and scroll position.

## Syntax

```freebasic
type TuiTreeState
    as int32 selected, offset
end type
```

## Description

A tree's selection and scroll, owned by you. Expansion state lives in the tree itself.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTreeState st
print st.selected, st.offset      '' 0 0
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