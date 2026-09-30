[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiCenter**

# TuiCenter

## Syntax

```freebasic
TuiCenter( byval outer as TuiRect, byval w as int32, byval h as int32 ) as TuiRect
```

## Description

A w-by-h rect centred inside another. This is how a dialog is placed, and it re-centres itself on every resize because the layout is recomputed each frame.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiRect box = TuiCenter( TuiRectOf( 0, 0, 80, 24 ), 40, 8 )
print box.x, box.y, box.w, box.h  '' 20 8 40 8

'' larger than the outer rect: it clamps rather than going negative
dim as TuiRect big = TuiCenter( TuiRectOf( 0, 0, 10, 4 ), 40, 8 )
print big.x >= 0, big.y >= 0       '' -1 (true) -1 (true)
```

## See also

[TuiConstraint](Modern-Tui-TuiConstraint) · [TuiLength](Modern-Tui-TuiLength) · [TuiPercent](Modern-Tui-TuiPercent) · [TuiRatio](Modern-Tui-TuiRatio) · [TuiMin_](Modern-Tui-TuiMin) · [TuiMax_](Modern-Tui-TuiMax) · [TuiFill](Modern-Tui-TuiFill) · [TuiSolve](Modern-Tui-TuiSolve) · [TuiSplitH](Modern-Tui-TuiSplitH) · [TuiSplitV](Modern-Tui-TuiSplitV) · [TuiPad](Modern-Tui-TuiPad) · [TuiPadAll](Modern-Tui-TuiPadAll)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)