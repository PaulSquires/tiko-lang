[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Core Widgets](Category-Terminal-TUI-Library) › **TuiSpinner**

# TuiSpinner

Draws a busy indicator that moves on one step each time you call Advance.

## Syntax

```freebasic
type TuiSpinner extends TuiWidget
    as int32 frame
    as TuiStringArray frames
    as TuiStyle st
end type
```

## Description

A busy indicator. It does NOT animate itself -- call Advance on a tick, which keeps the module free of any timer of its own.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiSpinner s
TuiSpinnerDefaultFrames( s.frames )
print s.frames.Count( ) > 0        '' -1 (true)

print s.frame                     '' 0
s.Advance( )
print s.frame                     '' 1

'' in an app: Update returns TuiTick( 100 ), and the tick calls Advance
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