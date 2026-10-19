[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiMessageBox.Accepted**

# TuiMessageBox.Accepted

Returns true once Enter was pressed on a button; selected says which.

## Syntax

```freebasic
TuiMessageBox.Accepted( ) as boolean
```

## Description

True once Enter was pressed on a button. Read `selected` to find out WHICH.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

dim as TuiMessageBox mb
mb.buttons.Push( "OK" ) : mb.buttons.Push( "Cancel" )
mb.selected = 1

dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_ENTER
mb.HandleEvent( e )
print mb.Accepted( ), mb.selected      '' true 1 -- they chose Cancel
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiPopup](Modern-Tui-TuiPopup) | [TuiMenu](Modern-Tui-TuiMenu) | [TuiStatusItem](Modern-Tui-TuiStatusItem) | [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) |
| [TuiMessageBox](Modern-Tui-TuiMessageBox) | [TuiMenuBar](Modern-Tui-TuiMenuBar) | [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) | [TuiTreeNode](Modern-Tui-TuiTreeNode) |
| [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) | [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) | [TuiStatusBar](Modern-Tui-TuiStatusBar) | [TuiTreeState](Modern-Tui-TuiTreeState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)