[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiParagraph**

# TuiParagraph

## Syntax

```freebasic
type TuiParagraph extends TuiWidget
    as ustring text
    as TuiStyle st
    as boolean wrap
    as uint8 align
    as int32 scrollY
end type
```

## Description

Text: wrapped or not, left/centre/right, scrollable. Embedded chr(10) starts a new line. Wrapping goes through TuiWrap, so it is column-correct for CJK.

## Example

```freebasic
#import "std/tui"
using tui

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

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiBlock](Modern-Tui-TuiBlock) | [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) | [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) | [TuiTitleOf](Modern-Tui-TuiTitleOf) | [TuiListState](Modern-Tui-TuiListState) | [TuiTable](Modern-Tui-TuiTable) |
| [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) | [TuiBorderSet](Modern-Tui-TuiBorderSet) | [TuiTitle](Modern-Tui-TuiTitle) | [TuiList](Modern-Tui-TuiList) | [TuiRow](Modern-Tui-TuiRow) | [TuiTableState](Modern-Tui-TuiTableState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)