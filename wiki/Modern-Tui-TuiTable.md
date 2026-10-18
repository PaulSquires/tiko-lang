[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiTable**

# TuiTable

## Syntax

```freebasic
type TuiTable extends TuiWidget
    as TuiStringArray headers
    as TuiRowArray rows
    as TuiConstraintArray widths
    as TuiTableState ptr state
    as boolean showHeader
end type
```

## Description

A scrolling table whose columns are sized by the SAME constraint solver as the layout -- so a column can be a fixed 7 cells, a percentage, or Fill. Like TuiList and TuiTree it clamps in Render, not only in HandleEvent, so an application driving the selection itself cannot scroll past the end.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiTableState st
dim as TuiTable t
t.headers.Push( "Pid" )     : t.widths.Push( TuiLength( 7 ) )
t.headers.Push( "Program" ) : t.widths.Push( TuiFill( ) )
t.headers.Push( "Cpu%" )    : t.widths.Push( TuiLength( 6 ) )

dim as TuiRow r
r.cells.Push( "25513" ) : r.cells.Push( "zed" ) : r.cells.Push( "3.4" )
t.rows.Push( r )

t.state = @st
t.showHeader = TRUE
print t.rows.Count( ), t.widths.Count( )        '' 1 3
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiBlock](Modern-Tui-TuiBlock) | [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) | [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) | [TuiTitleOf](Modern-Tui-TuiTitleOf) | [TuiList](Modern-Tui-TuiList) | [TuiRow](Modern-Tui-TuiRow) |
| [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) | [TuiBorderSet](Modern-Tui-TuiBorderSet) | [TuiTitle](Modern-Tui-TuiTitle) | [TuiParagraph](Modern-Tui-TuiParagraph) | [TuiListState](Modern-Tui-TuiListState) | [TuiTableState](Modern-Tui-TuiTableState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)