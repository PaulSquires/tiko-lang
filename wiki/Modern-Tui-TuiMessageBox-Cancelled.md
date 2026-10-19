[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiMessageBox.Cancelled**

# TuiMessageBox.Cancelled

Returns true once the dialog was dismissed with Esc.

## Syntax

```freebasic
TuiMessageBox.Cancelled( ) as boolean
```

## Description

True once Esc was pressed -- dismissed rather than answered, which is a different thing from choosing the Cancel button.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

dim as TuiMessageBox mb
mb.buttons.Push( "Yes" ) : mb.buttons.Push( "No" )

dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_ESCAPE
mb.HandleEvent( e )
print mb.Cancelled( ), mb.Accepted( )  '' true false
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiPopup](Modern-Tui-TuiPopup) | [TuiMenu](Modern-Tui-TuiMenu) | [TuiStatusItem](Modern-Tui-TuiStatusItem) | [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) |
| [TuiMessageBox](Modern-Tui-TuiMessageBox) | [TuiMenuBar](Modern-Tui-TuiMenuBar) | [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) | [TuiTreeNode](Modern-Tui-TuiTreeNode) |
| [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) | [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) | [TuiStatusBar](Modern-Tui-TuiStatusBar) | [TuiTreeState](Modern-Tui-TuiTreeState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)