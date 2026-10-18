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
#import "std/tui"
using tui

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

|   |   |   |   |
|---|---|---|---|
| [TuiMessageBox](Modern-Tui-TuiMessageBox) | [TuiMenu](Modern-Tui-TuiMenu) | [TuiStatusItem](Modern-Tui-TuiStatusItem) | [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) |
| [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) | [TuiMenuBar](Modern-Tui-TuiMenuBar) | [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) | [TuiTreeNode](Modern-Tui-TuiTreeNode) |
| [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) | [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) | [TuiStatusBar](Modern-Tui-TuiStatusBar) | [TuiTreeState](Modern-Tui-TuiTreeState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)