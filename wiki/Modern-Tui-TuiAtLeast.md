[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiAtLeast**

# TuiAtLeast

Returns a constraint for at least n cells, more if there is room.

## Syntax

```freebasic
TuiAtLeast( byval n as int32 ) as TuiConstraint
```

## Description

At least n cells, more if there is room.

## Example

```freebasic
#import "std/containers"
#import "std/tui"
using tui, containers

dim as TuiConstraintArray cs
cs.Push( TuiAtLeast( 20 ) )
cs.Push( TuiFill( ) )
dim as Array( of int32 ) s = TuiSolve( 60, cs )
print s[0] >= 20                   '' -1 (true)
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiPercent](Modern-Tui-TuiPercent) | [TuiAtMost](Modern-Tui-TuiAtMost) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiPadAll](Modern-Tui-TuiPadAll) |
| [TuiLength](Modern-Tui-TuiLength) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPad](Modern-Tui-TuiPad) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)