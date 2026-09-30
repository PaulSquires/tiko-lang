[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiMessageBox.Cancelled**

# TuiMessageBox.Cancelled

## Syntax

```freebasic
TuiMessageBox.Cancelled( ) as boolean
```

## Description

True once Esc was pressed -- dismissed rather than answered, which is a different thing from choosing the Cancel button.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiMessageBox mb
mb.buttons.Push( "Yes" ) : mb.buttons.Push( "No" )

dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_ESCAPE
mb.HandleEvent( e )
print mb.Cancelled( ), mb.Accepted( )  '' true false
```

## See also

[TuiPopup](Modern-Tui-TuiPopup) · [TuiMessageBox](Modern-Tui-TuiMessageBox) · [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) · [TuiMenu](Modern-Tui-TuiMenu) · [TuiMenuBar](Modern-Tui-TuiMenuBar) · [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) · [TuiStatusItem](Modern-Tui-TuiStatusItem) · [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) · [TuiStatusBar](Modern-Tui-TuiStatusBar) · [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) · [TuiTreeNode](Modern-Tui-TuiTreeNode) · [TuiTreeState](Modern-Tui-TuiTreeState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)