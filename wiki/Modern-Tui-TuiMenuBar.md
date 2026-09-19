[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiMenuBar**

# TuiMenuBar

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiMenuBar extends TuiWidget
    as TuiMenuArray menus
    as long highlight
    as TuiStyle normal, activeStyle, listStyle, highlightStyle
end type
```

## Description

A one-row menu bar with drop-downs. Left and right move between menus, Enter opens, Esc closes.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiMenuBar bar
dim as TuiMenu file_, help_
file_.label = "File" : file_.items.Push( "Quit" )
help_.label = "Help" : help_.items.Push( "About" )
bar.menus.Push( file_ )
bar.menus.Push( help_ )
bar.SetFocused( TRUE )

print bar.IsOpen( )               '' false
dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_ENTER
bar.HandleEvent( e )
print bar.IsOpen( )               '' true
```

## See also

[TuiPopup](Modern-Tui-TuiPopup) · [TuiMessageBox](Modern-Tui-TuiMessageBox) · [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) · [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) · [TuiMenu](Modern-Tui-TuiMenu) · [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) · [TuiStatusItem](Modern-Tui-TuiStatusItem) · [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) · [TuiStatusBar](Modern-Tui-TuiStatusBar) · [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) · [TuiTreeNode](Modern-Tui-TuiTreeNode) · [TuiTreeState](Modern-Tui-TuiTreeState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)