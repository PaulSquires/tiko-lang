[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiSolve**

# TuiSolve

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Terminal TUI Library](Category-Terminal-TUI-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TuiSolve( byval total as long, byref cs as TuiConstraintArray ) as Array( of long )
```

## Description

The raw sizes, if you want to lay something out yourself. The rule is stated exactly so the result is deterministic: fixed constraints first, FILL shares the remainder by weight, odd cells go to the earlier slots, and over-subscription shrinks right to left. The same input always gives the same answer, on both platforms.

## Example

```freebasic
#include once "fb/tui.bi"
using FB

dim as TuiConstraintArray cs
cs.Push( TuiLength( 3 ) )
cs.Push( TuiFill( ) )
cs.Push( TuiLength( 1 ) )

dim as Array( of long ) s = TuiSolve( 24, cs )
print s[0], s[1], s[2]            '' 3 20 1

dim as long total_ = 0
for i as long = 0 to s.Count( ) - 1 : total_ += s[i] : next
print total_                      '' 24 -- always exactly the total
```

## See also

[TuiConstraint](Modern-Tui-TuiConstraint) · [TuiLength](Modern-Tui-TuiLength) · [TuiPercent](Modern-Tui-TuiPercent) · [TuiRatio](Modern-Tui-TuiRatio) · [TuiMin_](Modern-Tui-TuiMin) · [TuiMax_](Modern-Tui-TuiMax) · [TuiFill](Modern-Tui-TuiFill) · [TuiSplitH](Modern-Tui-TuiSplitH) · [TuiSplitV](Modern-Tui-TuiSplitV) · [TuiPad](Modern-Tui-TuiPad) · [TuiPadAll](Modern-Tui-TuiPadAll) · [TuiCenter](Modern-Tui-TuiCenter)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library) ✨  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)