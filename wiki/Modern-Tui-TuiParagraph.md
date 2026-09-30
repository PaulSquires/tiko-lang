[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiParagraph**

# TuiParagraph

## Syntax

```freebasic
type TuiParagraph extends TuiWidget
    as ustring text
    as TuiStyle st
    as boolean wrap
    as ubyte align
    as long scrollY
end type
```

## Description

Text: wrapped or not, left/centre/right, scrollable. Embedded chr(10) starts a new line. Wrapping goes through TuiWrap, so it is column-correct for CJK.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiScreen scr
scr.Resize( 12, 5 )
dim as TuiFrame ptr f = scr.BeginFrame( )

dim as TuiParagraph p
p.text = "the quick brown fox"
p.wrap = TRUE
p.align = TUIALIGN_LEFT
p.Render( *f, f->Area( ) )

print p.SizeHint( f->Area( ) ).rows >= 2 '' -1 (true)  -- it wrapped
```

## See also

[TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitle](Modern-Tui-TuiTitle) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable) · [TuiTableState](Modern-Tui-TuiTableState)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)