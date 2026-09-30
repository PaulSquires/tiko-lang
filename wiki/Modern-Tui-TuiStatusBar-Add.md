[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiStatusBar.Add**

# TuiStatusBar.Add

## Syntax

```freebasic
TuiStatusBar.Add( byref t as ustring, byval st as TuiStyle, byval a as TuiAlign = TUIALIGN_LEFT )
```

## Description

Appends an item. Include the padding spaces in the text -- the bar does not add any, so you decide exactly how it looks.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiStatusBar sb
sb.Add( " ready ", TuiStyleDefault( ), TUIALIGN_LEFT )
sb.Add( "100% ", TuiStyleDefault( ), TUIALIGN_RIGHT )
print sb.items.Count( )           '' 2
print sb.items[1].align = TUIALIGN_RIGHT '' -1 (true)
```

## See also

[TuiPopup](Modern-Tui-TuiPopup) · [TuiMessageBox](Modern-Tui-TuiMessageBox) · [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) · [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) · [TuiMenu](Modern-Tui-TuiMenu) · [TuiMenuBar](Modern-Tui-TuiMenuBar) · [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) · [TuiStatusItem](Modern-Tui-TuiStatusItem) · [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) · [TuiStatusBar](Modern-Tui-TuiStatusBar) · [TuiTreeNode](Modern-Tui-TuiTreeNode) · [TuiTreeState](Modern-Tui-TuiTreeState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)