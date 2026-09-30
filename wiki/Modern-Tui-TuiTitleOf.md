[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiTitleOf**

# TuiTitleOf

## Syntax

```freebasic
TuiTitleOf( byref text as ustring, byval st as TuiStyle, byval side as TuiBorderSide = TUISIDE_TOP, byval align as TuiAlign = TUIALIGN_LEFT ) as TuiTitle
```

## Description

Builds a title value. NOTE THE ARGUMENT ORDER: the SIDE comes before the alignment, so a three-argument call sets the side. Passing TUIALIGN_CENTER third silently sets a side instead of centring the title, and nothing complains -- both parameters are small integers.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiTitle t = TuiTitleOf( " log ", TuiStyleDefault( ), _
                                TUISIDE_TOP, TUIALIGN_CENTER )
print t.align = TUIALIGN_CENTER   '' -1 (true) -- FOUR arguments, centred

dim as TuiBlock b
b.titles.Push( t )
print b.titles.Count( )           '' 1
```

## See also

[TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitle](Modern-Tui-TuiTitle) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable) · [TuiTableState](Modern-Tui-TuiTableState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)