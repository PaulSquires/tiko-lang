[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiList**

# TuiList

Draws a scrolling list the user moves through with the arrow keys.

## Syntax

```freebasic
type TuiList extends TuiWidget
    as TuiStringArray items
    as TuiListState ptr state
    as TuiStyle normal, selected
    as ustring selectPrefix
    as boolean wrapSelection
end type
```

## Description

A scrolling selection list. The state is CALLER-OWNED so the widget can be a throwaway value while the scroll position survives. Keys: up, down, page up, page down, home, end.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

dim as TuiListState st
dim as TuiList lst
lst.items.Push( "alpha" ) : lst.items.Push( "beta" ) : lst.items.Push( "gamma" )
lst.state = @st
lst.selectPrefix = "> "
lst.wrapSelection = TRUE
lst.SetFocused( TRUE )

dim as TuiEvent e
e.kind = TUIEVENT_KEY : e.key.code = TUIKEY_END
lst.HandleEvent( e )
print st.selected                 '' 2

e.key.code = TUIKEY_DOWN          '' wrapSelection is on
lst.HandleEvent( e )
print st.selected                 '' 0
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiBlock](Modern-Tui-TuiBlock) | [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) | [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) | [TuiTitleOf](Modern-Tui-TuiTitleOf) | [TuiListState](Modern-Tui-TuiListState) | [TuiTable](Modern-Tui-TuiTable) |
| [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) | [TuiBorderSet](Modern-Tui-TuiBorderSet) | [TuiTitle](Modern-Tui-TuiTitle) | [TuiParagraph](Modern-Tui-TuiParagraph) | [TuiRow](Modern-Tui-TuiRow) | [TuiTableState](Modern-Tui-TuiTableState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)