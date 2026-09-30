[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiSpinner.Advance**

# TuiSpinner.Advance

## Syntax

```freebasic
TuiSpinner.Advance( )
```

## Description

Steps to the next frame, wrapping at the end.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiSpinner s
TuiSpinnerDefaultFrames( s.frames )
dim as int32 n = s.frames.Count( )
for i as int32 = 1 to n : s.Advance( ) : next
print s.frame                     '' 0 -- a full cycle wrapped
```

## See also

[TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiTitle](Modern-Tui-TuiTitle) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiRow](Modern-Tui-TuiRow) · [TuiTable](Modern-Tui-TuiTable)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Core Widgets  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)