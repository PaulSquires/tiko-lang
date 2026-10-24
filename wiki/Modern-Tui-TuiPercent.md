[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiPercent**

# TuiPercent

Returns a constraint for a percentage of the whole space being split.

## Syntax

```freebasic
TuiPercent( byval n as int32 ) as TuiConstraint
```

## Description

n per cent of the TOTAL being split -- not of what is left over.

## Example

```freebasic
#import "std/containers"
#import "std/tui"
using tui, containers

dim as TuiConstraintArray cs
cs.Push( TuiPercent( 45 ) )
cs.Push( TuiFill( ) )
dim as Array( of int32 ) s = TuiSolve( 100, cs )
print s[0], s[1]                  '' 45 55
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiAtMost](Modern-Tui-TuiAtMost) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiPadAll](Modern-Tui-TuiPadAll) |
| [TuiLength](Modern-Tui-TuiLength) | [TuiAtLeast](Modern-Tui-TuiAtLeast) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPad](Modern-Tui-TuiPad) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)