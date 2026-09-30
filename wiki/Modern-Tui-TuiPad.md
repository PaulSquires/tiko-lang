[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiPad**

# TuiPad

## Syntax

```freebasic
TuiPad( byval r as TuiRect, byval m as TuiMargin ) as TuiRect
```

## Description

Shrinks a rect by a margin -- the free-function form of TuiRect.Inner.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiRect r = TuiPad( TuiRectOf( 0, 0, 20, 10 ), TuiMarginOf( 2, 1, 2, 1 ) )
print r.x, r.y, r.w, r.h          '' 2 1 16 8
```

## See also

[TuiConstraint](Modern-Tui-TuiConstraint) · [TuiLength](Modern-Tui-TuiLength) · [TuiPercent](Modern-Tui-TuiPercent) · [TuiRatio](Modern-Tui-TuiRatio) · [TuiMin_](Modern-Tui-TuiMin) · [TuiMax_](Modern-Tui-TuiMax) · [TuiFill](Modern-Tui-TuiFill) · [TuiSolve](Modern-Tui-TuiSolve) · [TuiSplitH](Modern-Tui-TuiSplitH) · [TuiSplitV](Modern-Tui-TuiSplitV) · [TuiPadAll](Modern-Tui-TuiPadAll) · [TuiCenter](Modern-Tui-TuiCenter)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)