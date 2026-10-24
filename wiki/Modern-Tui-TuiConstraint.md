[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiConstraint**

# TuiConstraint

Holds one sizing rule for a split, such as a fixed length or a share of the rest.

## Syntax

```freebasic
type TuiConstraint
    as uint8 kind      '' TuiConstraintKind
    as int32 a, b
end type
```

## Description

One rule in a split: Length, Percent, Ratio, Min, Max or Fill. Build them with the helper functions rather than by hand.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiConstraintArray cs
cs.Push( TuiLength( 3 ) )
cs.Push( TuiFill( ) )
print cs.Count( )                 '' 2
print cs[0].kind = TUICON_LENGTH   '' -1 (true)
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiLength](Modern-Tui-TuiLength) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiAtMost](Modern-Tui-TuiAtMost) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiPadAll](Modern-Tui-TuiPadAll) |
| [TuiPercent](Modern-Tui-TuiPercent) | [TuiAtLeast](Modern-Tui-TuiAtLeast) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPad](Modern-Tui-TuiPad) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)