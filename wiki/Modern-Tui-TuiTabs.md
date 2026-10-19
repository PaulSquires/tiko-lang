[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiTabs**

# TuiTabs

Draws a one-row strip of tab titles with the selected one highlighted.

## Syntax

```freebasic
type TuiTabs extends TuiWidget
    as TuiStringArray titles
    as int32 selected
    as ustring divider
    as TuiStyle normal, active
end type
```

## Description

A one-row tab strip. It draws only the strip -- switching what is below it is your Update's job.

## Example

```freebasic
#import "std/tui"
using tui

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

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiBlock](Modern-Tui-TuiBlock) | [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) | [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) | [TuiTitleOf](Modern-Tui-TuiTitleOf) | [TuiList](Modern-Tui-TuiList) | [TuiRow](Modern-Tui-TuiRow) |
| [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) | [TuiBorderSet](Modern-Tui-TuiBorderSet) | [TuiTitle](Modern-Tui-TuiTitle) | [TuiParagraph](Modern-Tui-TuiParagraph) | [TuiListState](Modern-Tui-TuiListState) | [TuiTable](Modern-Tui-TuiTable) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)