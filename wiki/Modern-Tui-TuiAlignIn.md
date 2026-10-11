[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiAlignIn**

# TuiAlignIn

## Syntax

```freebasic
TuiAlignIn( byval outer as TuiRect, byval w as int32, byval a as TuiAlign ) as TuiRect
```

## Description

A w-wide rect placed left, centre or right inside another, full height. What a status bar uses to put an item hard against the right edge.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiRect outer_ = TuiRectOf( 0, 0, 20, 3 )
print TuiAlignIn( outer_, 6, TUIALIGN_LEFT ).x     '' 0
print TuiAlignIn( outer_, 6, TUIALIGN_CENTER ).x   '' 7
print TuiAlignIn( outer_, 6, TUIALIGN_RIGHT ).x    '' 14
```

## See also

[TuiConstraint](Modern-Tui-TuiConstraint) · [TuiLength](Modern-Tui-TuiLength) · [TuiPercent](Modern-Tui-TuiPercent) · [TuiRatio](Modern-Tui-TuiRatio) · [TuiMin_](Modern-Tui-TuiMin) · [TuiMax_](Modern-Tui-TuiMax) · [TuiFill](Modern-Tui-TuiFill) · [TuiSolve](Modern-Tui-TuiSolve) · [TuiSplitH](Modern-Tui-TuiSplitH) · [TuiSplitV](Modern-Tui-TuiSplitV) · [TuiPad](Modern-Tui-TuiPad) · [TuiPadAll](Modern-Tui-TuiPadAll)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)