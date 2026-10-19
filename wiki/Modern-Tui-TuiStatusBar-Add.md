[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiStatusBar.Add**

# TuiStatusBar.Add

Adds an item at the left or right; include any padding spaces in the text.

## Syntax

```freebasic
TuiStatusBar.Add( byref t as ustring, byval st as TuiStyle, byval a as TuiAlign = TUIALIGN_LEFT )
```

## Description

Appends an item. Include the padding spaces in the text -- the bar does not add any, so you decide exactly how it looks.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiStatusBar sb
sb.Add( " ready ", TuiStyleDefault( ), TUIALIGN_LEFT )
sb.Add( "100% ", TuiStyleDefault( ), TUIALIGN_RIGHT )
print sb.items.Count( )           '' 2
print sb.items[1].align = TUIALIGN_RIGHT '' -1 (true)
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiPopup](Modern-Tui-TuiPopup) | [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) | [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) | [TuiStatusBar](Modern-Tui-TuiStatusBar) |
| [TuiMessageBox](Modern-Tui-TuiMessageBox) | [TuiMenu](Modern-Tui-TuiMenu) | [TuiStatusItem](Modern-Tui-TuiStatusItem) | [TuiTreeNode](Modern-Tui-TuiTreeNode) |
| [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) | [TuiMenuBar](Modern-Tui-TuiMenuBar) | [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) | [TuiTreeState](Modern-Tui-TuiTreeState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)