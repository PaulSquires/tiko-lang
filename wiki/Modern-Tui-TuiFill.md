[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiFill**

# TuiFill

## Syntax

```freebasic
TuiFill( byval weight as int32 = 1 ) as TuiConstraint
```

## Description

Share whatever is left, in proportion to the weight. Two TuiFill( 1 ) split the remainder evenly; TuiFill( 2 ) against TuiFill( 1 ) takes twice as much.

## Example

```freebasic
#import "std/containers"
#import "std/tui"
using tui, containers

dim as TuiConstraintArray cs
cs.Push( TuiFill( 2 ) )
cs.Push( TuiFill( 1 ) )
dim as Array( of int32 ) s = TuiSolve( 30, cs )
print s[0], s[1]                  '' 20 10
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiPercent](Modern-Tui-TuiPercent) | [TuiMin_](Modern-Tui-TuiMin) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiPadAll](Modern-Tui-TuiPadAll) |
| [TuiLength](Modern-Tui-TuiLength) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiMax_](Modern-Tui-TuiMax) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPad](Modern-Tui-TuiPad) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)