[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiSpinner.Advance**

# TuiSpinner.Advance

Moves the spinner to its next frame, wrapping at the end.

## Syntax

```freebasic
TuiSpinner.Advance( )
```

## Description

Steps to the next frame, wrapping at the end.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiSpinner s
TuiSpinnerDefaultFrames( s.frames )
dim as int32 n = s.frames.Count( )
for i as int32 = 1 to n : s.Advance( ) : next
print s.frame                     '' 0 -- a full cycle wrapped
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