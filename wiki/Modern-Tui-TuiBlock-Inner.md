[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiBlock.Inner**

# TuiBlock.Inner

## Syntax

```freebasic
TuiBlock.Inner( byval area as TuiRect ) as TuiRect
```

## Description

The space left inside the border, which depends on which sides are drawn. ALWAYS CHECK IsEmpty on the result -- a bordered block two cells wide has nothing inside it.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiBlock b
b.borderKind = TUIBORDER_PLAIN

b.sides = TUISIDE_ALL
print b.Inner( TuiRectOf( 0, 0, 20, 10 ) ).w    '' 18

b.sides = TUISIDE_TOP             '' only one side costs only one row
dim as TuiRect i = b.Inner( TuiRectOf( 0, 0, 20, 10 ) )
print i.w, i.h                                  '' 20 9

b.sides = TUISIDE_ALL
print b.Inner( TuiRectOf( 0, 0, 2, 2 ) ).IsEmpty( )      '' true
```

## See also

[TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitle](Modern-Tui-TuiTitle) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable) · [TuiTableState](Modern-Tui-TuiTableState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)