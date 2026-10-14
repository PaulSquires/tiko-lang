[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiBlock**

# TuiBlock

## Syntax

```freebasic
type TuiBlock extends TuiWidget
    as uint8 borderKind, sides
    as TuiStyle borderStyle, fillStyle
    as boolean fill
    as TuiTitleArray titles
end type
```

## Description

A border with titles, and the Inner( ) rect inside it. Almost every panel starts with one. `borderKind` carries the underscore-free awkwardness of this module's naming: plain `kind` collides with the abstract Kind( ) method.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 30, 8 )
dim as TuiFrame ptr f = scr.BeginFrame( )
dim as TuiTheme th = TuiThemeDefault( )

dim as TuiBlock b
b.borderKind = TUIBORDER_ROUNDED  '' NONE PLAIN ROUNDED DOUBLE THICK ASCII
b.sides = TUISIDE_ALL             '' or TUISIDE_TOP or TUISIDE_LEFT, bitwise
b.borderStyle = th.border
b.fill = TRUE
b.fillStyle = th.normal
b.AddTitle( " cpu ", th.accent, TUISIDE_TOP, TUIALIGN_LEFT )
b.Render( *f, f->Area( ) )

dim as TuiRect inner = b.Inner( f->Area( ) )
print inner.x, inner.y, inner.w, inner.h        '' 1 1 28 6
```

## See also

[TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitle](Modern-Tui-TuiTitle) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable) · [TuiTableState](Modern-Tui-TuiTableState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)