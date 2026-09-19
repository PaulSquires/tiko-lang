[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Overlays and Chrome](Category-Terminal-TUI-Library) › **TuiStatusBar**

# TuiStatusBar

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiStatusBar extends TuiWidget
    as TuiStatusItemArray items
    as TuiStyle background
end type
```

## Description

One row of items, packed from the left and from the right. Left items run in the order added; right items sit hard against the right edge.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen scr
scr.Resize( 40, 1 )
dim as TuiFrame ptr f = scr.BeginFrame( )
dim as TuiTheme th = TuiThemeDefault( )

dim as TuiStatusBar sb
sb.background = th.dim_
sb.Add( " up/dn select ", th.normal, TUIALIGN_LEFT )
sb.Add( " q quit ", th.danger, TUIALIGN_LEFT )
sb.Add( "3/24 ", th.accent, TUIALIGN_RIGHT )       '' against the right edge
sb.Render( *f, f->Area( ) )
print sb.items.Count( )           '' 3
```

## See also

[TuiPopup](Modern-Tui-TuiPopup) · [TuiMessageBox](Modern-Tui-TuiMessageBox) · [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) · [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) · [TuiMenu](Modern-Tui-TuiMenu) · [TuiMenuBar](Modern-Tui-TuiMenuBar) · [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) · [TuiStatusItem](Modern-Tui-TuiStatusItem) · [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) · [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) · [TuiTreeNode](Modern-Tui-TuiTreeNode) · [TuiTreeState](Modern-Tui-TuiTreeState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Overlays and Chrome  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)