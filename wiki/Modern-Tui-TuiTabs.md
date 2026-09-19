[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiTabs**

# TuiTabs

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiTabs extends TuiWidget
    as TuiStringArray titles
    as long selected
    as ustring divider
    as TuiStyle normal, active
end type
```

## Description

A one-row tab strip. It draws only the strip -- switching what is below it is your Update's job.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen scr
scr.Resize( 40, 3 )
dim as TuiFrame ptr f = scr.BeginFrame( )
dim as TuiTheme th = TuiThemeDefault( )

dim as TuiTabs tb
tb.titles.Push( "cpu" ) : tb.titles.Push( "mem" ) : tb.titles.Push( "net" )
tb.selected = 1
tb.divider = " | "
tb.normal = th.dim_ : tb.active = th.accent
tb.Render( *f, f->Area( ) )
print tb.titles.Count( )          '' 3
```

## See also

[TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitle](Modern-Tui-TuiTitle) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)