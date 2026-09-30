[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiPopup**

# TuiPopup

## Syntax

```freebasic
type TuiPopup extends TuiWidget
    as TuiBlock frame_
    as TuiRect area
    as boolean dimBackground, modal
    as TuiStyle dimStyle
end type
```

## Description

A floating panel. It ignores the area passed to Render and uses its own `area` field, because an overlay is positioned in screen space. `modal` makes it swallow every event, and `dimBackground` blends the style of everything behind it.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen scr
scr.Resize( 40, 12 )
dim as TuiFrame ptr f = scr.BeginFrame( )
dim as TuiTheme th = TuiThemeDefault( )

f->DrawText( 0, 0, "the application, behind", TuiStyleDefault( ) )

dim as TuiPopup p
p.area = TuiCenter( f->Area( ), 20, 5 )
p.modal = TRUE
p.dimBackground = TRUE
p.dimStyle = th.dim_
p.frame_.borderKind = TUIBORDER_DOUBLE
p.frame_.sides = TUISIDE_ALL
p.Render( *f, f->Area( ) )
```

## See also

[TuiMessageBox](Modern-Tui-TuiMessageBox) · [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) · [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) · [TuiMenu](Modern-Tui-TuiMenu) · [TuiMenuBar](Modern-Tui-TuiMenuBar) · [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) · [TuiStatusItem](Modern-Tui-TuiStatusItem) · [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) · [TuiStatusBar](Modern-Tui-TuiStatusBar) · [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) · [TuiTreeNode](Modern-Tui-TuiTreeNode) · [TuiTreeState](Modern-Tui-TuiTreeState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)