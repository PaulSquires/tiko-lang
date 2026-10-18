[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiScrollbar**

# TuiScrollbar

## Syntax

```freebasic
type TuiScrollbar extends TuiWidget
    as int32 total, visible, position
    as boolean vertical
    as TuiStyle thumb, track
    as ustring thumbChar, trackChar
end type
```

## Description

A scrollbar drawn from three numbers. It is passive -- it reflects a list's or table's state and does not own it, so you feed it the same offset the list is using.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiScreen scr
scr.Resize( 20, 10 )
dim as TuiFrame ptr f = scr.BeginFrame( )
dim as TuiTheme th = TuiThemeDefault( )

dim as TuiTableState st
st.offset = 40

dim as TuiScrollbar sb
sb.vertical = TRUE
sb.total = 240                    '' rows in the data
sb.visible = 10                   '' rows on screen
sb.position = st.offset           '' the list's own offset
sb.thumb = th.accent : sb.track = th.dim_
sb.Render( *f, TuiRectOf( 19, 0, 1, 10 ) )
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