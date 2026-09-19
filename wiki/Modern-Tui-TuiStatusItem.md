[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiStatusItem**

# TuiStatusItem

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiStatusItem
    as ustring text
    as TuiStyle st
    as ubyte align
end type
```

## Description

One piece of a status bar.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiStatusItem i = TuiStatusItemOf( " q quit ", TuiStyleDefault( ), TUIALIGN_LEFT )
print i.text                      '' " q quit "
```

## See also

[TuiPopup](Modern-Tui-TuiPopup) · [TuiMessageBox](Modern-Tui-TuiMessageBox) · [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) · [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) · [TuiMenu](Modern-Tui-TuiMenu) · [TuiMenuBar](Modern-Tui-TuiMenuBar) · [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) · [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) · [TuiStatusBar](Modern-Tui-TuiStatusBar) · [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) · [TuiTreeNode](Modern-Tui-TuiTreeNode) · [TuiTreeState](Modern-Tui-TuiTreeState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)