[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiTreeNode**

# TuiTreeNode

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiTreeNode
    as ustring label
    as long depth
    as boolean hasChildren
    as long userId
end type
```

## Description

One node of a tree, held in a FLAT array with a depth rather than as a linked structure -- which is what makes scrolling and hit-testing simple. `userId` is yours: put a file id or a row key in it.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiTree t
t.Add( "src", 0, TRUE, 100 )
t.Add( "main.tko", 1, FALSE, 101 )
print t.nodes.Count( )            '' 2
print t.nodes[1].depth, t.nodes[1].userId      '' 1 101
```

## See also

[TuiPopup](Modern-Tui-TuiPopup) · [TuiMessageBox](Modern-Tui-TuiMessageBox) · [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) · [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) · [TuiMenu](Modern-Tui-TuiMenu) · [TuiMenuBar](Modern-Tui-TuiMenuBar) · [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) · [TuiStatusItem](Modern-Tui-TuiStatusItem) · [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) · [TuiStatusBar](Modern-Tui-TuiStatusBar) · [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) · [TuiTreeState](Modern-Tui-TuiTreeState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)