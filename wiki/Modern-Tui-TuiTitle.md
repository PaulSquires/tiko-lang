[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiTitle**

# TuiTitle

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type TuiTitle
    as ustring text
    as TuiStyle st
    as ubyte align
end type
```

## Description

One title on a block's border. Built for you by AddTitle; TuiTitleOf makes one directly.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiTitle t = TuiTitleOf( " log ", TuiStyleDefault( ), _
                                TUISIDE_TOP, TUIALIGN_CENTER )
print t.text                      '' " log "
print t.align = TUIALIGN_CENTER   '' -1 (true)
```

## See also

[TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable) · [TuiTableState](Modern-Tui-TuiTableState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)