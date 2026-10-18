[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiBorderGlyphs**

# TuiBorderGlyphs

## Syntax

```freebasic
TuiBorderGlyphs( byval k as TuiBorderKind ) as TuiBorderSet
```

## Description

The glyph set for a border kind. Use TUIBORDER_ASCII when TuiCaps reports the terminal cannot do Unicode -- box-drawing characters on a CP437 console are worse than plus signs.

## Example

```freebasic
#import "std/tui"
using tui

print TuiBorderGlyphs( TUIBORDER_ASCII ).h        '' -
print TuiBorderGlyphs( TUIBORDER_DOUBLE ).h <> "-" '' -1 (true)

dim as TuiTerminal term
dim as uint8 k = iif( term.DetectCaps( ).unicode, _
                      TUIBORDER_ROUNDED, TUIBORDER_ASCII )
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiBlock](Modern-Tui-TuiBlock) | [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) | [TuiTitle](Modern-Tui-TuiTitle) | [TuiParagraph](Modern-Tui-TuiParagraph) | [TuiListState](Modern-Tui-TuiListState) | [TuiTable](Modern-Tui-TuiTable) |
| [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) | [TuiBorderSet](Modern-Tui-TuiBorderSet) | [TuiTitleOf](Modern-Tui-TuiTitleOf) | [TuiList](Modern-Tui-TuiList) | [TuiRow](Modern-Tui-TuiRow) | [TuiTableState](Modern-Tui-TuiTableState) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)