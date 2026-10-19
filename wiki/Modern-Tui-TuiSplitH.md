[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiSplitH**

# TuiSplitH

Splits a rectangle into columns side by side, sized by constraints.

## Syntax

```freebasic
TuiSplitH( byval area as TuiRect, byref cs as TuiConstraintArray ) as TuiRectArray
```

## Description

Splits a rect into side-by-side columns. Nest freely: split a result again for a panel inside a column.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiConstraintArray cs
cs.Push( TuiPercent( 45 ) )
cs.Push( TuiFill( ) )

dim as TuiRectArray col = TuiSplitH( TuiRectOf( 0, 0, 100, 30 ), cs )
print col[0].x, col[0].w          '' 0 45
print col[1].x, col[1].w          '' 45 55
print col[0].h, col[1].h          '' 30 30 -- height is untouched
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiPercent](Modern-Tui-TuiPercent) | [TuiMin_](Modern-Tui-TuiMin) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiPadAll](Modern-Tui-TuiPadAll) |
| [TuiLength](Modern-Tui-TuiLength) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiMax_](Modern-Tui-TuiMax) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiPad](Modern-Tui-TuiPad) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)