[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiGauge**

# TuiGauge

## Syntax

```freebasic
type TuiGauge extends TuiWidget
    as float64 ratio
    as ustring label
    as TuiStyle bar, background
    as boolean useUnicode, showLabel
end type
```

## Description

A progress bar. `ratio` is 0.0 to 1.0 and is clamped, so a computed value that overshoots does not draw outside its area. An empty label shows the percentage.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 30, 3 )
dim as TuiFrame ptr f = scr.BeginFrame( )
dim as TuiTheme th = TuiThemeDefault( )

dim as TuiGauge g
g.ratio = 0.42
g.showLabel = TRUE
g.label = ""                      '' empty means "show 42%"
g.bar = th.accent : g.background = th.dim_
g.useUnicode = TRUE               '' partial blocks for sub-cell precision
g.Render( *f, f->Area( ) )

g.ratio = 2.5                     '' clamped, not an error
g.Render( *f, f->Area( ) )
```

## See also

[TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitle](Modern-Tui-TuiTitle) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)