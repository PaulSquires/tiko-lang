[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiSplitV**

# TuiSplitV

Splits a rectangle into rows stacked top to bottom, sized by constraints.

## Syntax

```freebasic
TuiSplitV( byval area as TuiRect, byref cs as TuiConstraintArray ) as TuiRectArray
```

## Description

Splits a rect into stacked rows. The header/body/status-bar shape is one call.

## Example

```freebasic
#import "std/tui"
using tui

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

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiPercent](Modern-Tui-TuiPercent) | [TuiMin_](Modern-Tui-TuiMin) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPadAll](Modern-Tui-TuiPadAll) |
| [TuiLength](Modern-Tui-TuiLength) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiMax_](Modern-Tui-TuiMax) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiPad](Modern-Tui-TuiPad) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)