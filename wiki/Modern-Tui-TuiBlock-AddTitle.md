[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiBlock.AddTitle**

# TuiBlock.AddTitle

## Syntax

```freebasic
TuiBlock.AddTitle( byref t as ustring, byval st as TuiStyle, byval side as TuiBorderSide = TUISIDE_TOP, byval align as TuiAlign = TUIALIGN_LEFT )
```

## Description

Adds a title to one side of the border. SEVERAL TITLES CAN SHARE ONE BORDER, each independently aligned -- which is how the btop-style header row puts a hotkey and a menu on the left and a clock hard against the right.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiScreen scr
scr.Resize( 40, 5 )
dim as TuiFrame ptr f = scr.BeginFrame( )
dim as TuiTheme th = TuiThemeDefault( )

dim as TuiBlock b
b.borderKind = TUIBORDER_ROUNDED
b.sides = TUISIDE_ALL
b.AddTitle( "1cpu",  th.accent, TUISIDE_TOP, TUIALIGN_LEFT )
b.AddTitle( "menu",  th.dim_,   TUISIDE_TOP, TUIALIGN_LEFT )
b.AddTitle( "12f",   th.normal, TUISIDE_TOP, TUIALIGN_RIGHT )
b.AddTitle( "q quit", th.dim_,  TUISIDE_BOTTOM, TUIALIGN_RIGHT )
b.Render( *f, f->Area( ) )
print b.titles.Count( )           '' 4
```

## See also

[TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitle](Modern-Tui-TuiTitle) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable) · [TuiTableState](Modern-Tui-TuiTableState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)