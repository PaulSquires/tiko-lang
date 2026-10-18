[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiMessageBox**

# TuiMessageBox

## Syntax

```freebasic
type TuiMessageBox extends TuiWidget
    as ustring title, message
    as TuiStringArray buttons
    as int32 selected
    as uint8 msgKind
    as TuiTheme theme
end type
```

## Description

A modal dialog with buttons. `msgKind` is TUIMSG_INFO, _WARNING, _ERROR_ or _QUESTION and picks the accent colour; ERROR_ carries the underscore because ERROR is an intrinsic. Ask Accepted or Cancelled after handing it an event.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

dim as TuiMessageBox mb
mb.title = "Confirm"
mb.message = "Submit the form?"
mb.buttons.Push( "Yes" )
mb.buttons.Push( "No" )
mb.selected = 0
mb.msgKind = TUIMSG_QUESTION
mb.theme = TuiThemeDefault( )

dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_ENTER
mb.HandleEvent( e )
print mb.Accepted( )              '' true -- "Yes" was selected
print mb.Cancelled( )             '' false
```

## See also

|   |   |   |   |
|---|---|---|---|
| [TuiPopup](Modern-Tui-TuiPopup) | [TuiMenu](Modern-Tui-TuiMenu) | [TuiStatusItem](Modern-Tui-TuiStatusItem) | [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) |
| [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) | [TuiMenuBar](Modern-Tui-TuiMenuBar) | [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) | [TuiTreeNode](Modern-Tui-TuiTreeNode) |
| [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) | [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) | [TuiStatusBar](Modern-Tui-TuiStatusBar) | [TuiTreeState](Modern-Tui-TuiTreeState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)