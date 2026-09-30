[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiSplitV**

# TuiSplitV

## Syntax

```freebasic
TuiSplitV( byval area as TuiRect, byref cs as TuiConstraintArray ) as TuiRectArray
```

## Description

Splits a rect into stacked rows. The header/body/status-bar shape is one call.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiConstraintArray cs
cs.Push( TuiLength( 1 ) )         '' menu bar
cs.Push( TuiFill( ) )             '' body
cs.Push( TuiLength( 1 ) )         '' status bar

dim as TuiRectArray band = TuiSplitV( TuiRectOf( 0, 0, 80, 24 ), cs )
print band[0].y, band[0].h        '' 0 1
print band[1].y, band[1].h        '' 1 22
print band[2].y, band[2].h        '' 23 1
```

## See also

[TuiConstraint](Modern-Tui-TuiConstraint) · [TuiLength](Modern-Tui-TuiLength) · [TuiPercent](Modern-Tui-TuiPercent) · [TuiRatio](Modern-Tui-TuiRatio) · [TuiMin_](Modern-Tui-TuiMin) · [TuiMax_](Modern-Tui-TuiMax) · [TuiFill](Modern-Tui-TuiFill) · [TuiSolve](Modern-Tui-TuiSolve) · [TuiSplitH](Modern-Tui-TuiSplitH) · [TuiPad](Modern-Tui-TuiPad) · [TuiPadAll](Modern-Tui-TuiPadAll) · [TuiCenter](Modern-Tui-TuiCenter)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)