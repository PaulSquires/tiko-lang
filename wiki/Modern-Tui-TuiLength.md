[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiLength**

# TuiLength

Returns a constraint for exactly n cells.

## Syntax

```freebasic
TuiLength( byval n as int32 ) as TuiConstraint
```

## Description

Exactly n cells. Fixed constraints are satisfied before anything is shared out.

## Example

```freebasic
#import "std/containers"
#import "std/tui"
using tui, containers

dim as TuiConstraintArray cs
cs.Push( TuiLength( 10 ) )
cs.Push( TuiFill( ) )
dim as Array( of int32 ) s = TuiSolve( 40, cs )
print s[0], s[1]                  '' 10 30
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiMax_](Modern-Tui-TuiMax) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiPadAll](Modern-Tui-TuiPadAll) |
| [TuiPercent](Modern-Tui-TuiPercent) | [TuiMin_](Modern-Tui-TuiMin) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPad](Modern-Tui-TuiPad) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)