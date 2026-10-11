[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiTitle**

# TuiTitle

## Syntax

```freebasic
type TuiTitle
    as ustring text
    as TuiStyle st
    as uint8 align
end type
```

## Description

One title on a block's border. Built for you by AddTitle; TuiTitleOf makes one directly.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTitle t = TuiTitleOf( " log ", TuiStyleDefault( ), _
                                TUISIDE_TOP, TUIALIGN_CENTER )
print t.text                      '' " log "
print t.align = TUIALIGN_CENTER   '' -1 (true)
```

## See also

[TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable) · [TuiTableState](Modern-Tui-TuiTableState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)