[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiPercent**

# TuiPercent

## Syntax

```freebasic
TuiPercent( byval n as int32 ) as TuiConstraint
```

## Description

n per cent of the TOTAL being split -- not of what is left over.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiConstraintArray cs
cs.Push( TuiPercent( 45 ) )
cs.Push( TuiFill( ) )
dim as Array( of int32 ) s = TuiSolve( 100, cs )
print s[0], s[1]                  '' 45 55
```

## See also

[TuiConstraint](Modern-Tui-TuiConstraint) · [TuiLength](Modern-Tui-TuiLength) · [TuiRatio](Modern-Tui-TuiRatio) · [TuiMin_](Modern-Tui-TuiMin) · [TuiMax_](Modern-Tui-TuiMax) · [TuiFill](Modern-Tui-TuiFill) · [TuiSolve](Modern-Tui-TuiSolve) · [TuiSplitH](Modern-Tui-TuiSplitH) · [TuiSplitV](Modern-Tui-TuiSplitV) · [TuiPad](Modern-Tui-TuiPad) · [TuiPadAll](Modern-Tui-TuiPadAll) · [TuiCenter](Modern-Tui-TuiCenter)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)