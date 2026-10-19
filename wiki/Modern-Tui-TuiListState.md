[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiListState**

# TuiListState

Holds a list's selected item and scroll position; -1 means nothing is selected.

## Syntax

```freebasic
type TuiListState
    as int32 selected   '' -1 = nothing selected
    as int32 offset     '' first visible row
end type
```

## Description

A list's selection and scroll, owned by you. Set `selected` directly if your application owns its own keymap -- the widget re-clamps and scrolls to it during Render, so the selection cannot walk off the bottom of the window.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiListState st
print st.selected, st.offset      '' 0 0

st.selected = -1                  '' nothing selected is a legal state
print st.selected

'' driving it from your own keymap is fine: Render clamps and follows
st.selected = 9999
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiBlock](Modern-Tui-TuiBlock) | [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) | [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) | [TuiTitleOf](Modern-Tui-TuiTitleOf) | [TuiList](Modern-Tui-TuiList) | [TuiTable](Modern-Tui-TuiTable) |
| [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) | [TuiBorderSet](Modern-Tui-TuiBorderSet) | [TuiTitle](Modern-Tui-TuiTitle) | [TuiParagraph](Modern-Tui-TuiParagraph) | [TuiRow](Modern-Tui-TuiRow) | [TuiTableState](Modern-Tui-TuiTableState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)