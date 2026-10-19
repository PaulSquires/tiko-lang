[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiBlock.Inner**

# TuiBlock.Inner

Returns the space inside the border, which is empty for a very small block.

## Syntax

```freebasic
TuiBlock.Inner( byval area as TuiRect ) as TuiRect
```

## Description

The space left inside the border, which depends on which sides are drawn. ALWAYS CHECK IsEmpty on the result -- a bordered block two cells wide has nothing inside it.

## Example

```freebasic
#import "std/tui"
using tui

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

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiBlock](Modern-Tui-TuiBlock) | [TuiBorderSet](Modern-Tui-TuiBorderSet) | [TuiTitle](Modern-Tui-TuiTitle) | [TuiParagraph](Modern-Tui-TuiParagraph) | [TuiListState](Modern-Tui-TuiListState) | [TuiTable](Modern-Tui-TuiTable) |
| [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) | [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) | [TuiTitleOf](Modern-Tui-TuiTitleOf) | [TuiList](Modern-Tui-TuiList) | [TuiRow](Modern-Tui-TuiRow) | [TuiTableState](Modern-Tui-TuiTableState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)