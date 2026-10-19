[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiMax_**

# TuiMax_

Returns a constraint for at most n cells.

## Syntax

```freebasic
TuiMax_( byval n as int32 ) as TuiConstraint
```

## Description

At most n cells. Use it to stop a sidebar growing absurdly wide on a big terminal.

## Example

```freebasic
#import "std/containers"
#import "std/tui"
using tui, containers

dim as TuiConstraintArray cs
cs.Push( TuiMax_( 30 ) )
cs.Push( TuiFill( ) )
dim as Array( of int32 ) s = TuiSolve( 200, cs )
print s[0] <= 30                   '' -1 (true)
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiPercent](Modern-Tui-TuiPercent) | [TuiMin_](Modern-Tui-TuiMin) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiPadAll](Modern-Tui-TuiPadAll) |
| [TuiLength](Modern-Tui-TuiLength) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPad](Modern-Tui-TuiPad) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)