[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiPadAll**

# TuiPadAll

Returns a rectangle shrunk by the same amount on every side.

## Syntax

```freebasic
TuiPadAll( byval r as TuiRect, byval n as int32 ) as TuiRect
```

## Description

Shrinks by n on every side.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiRect r = TuiPadAll( TuiRectOf( 0, 0, 20, 10 ), 2 )
print r.x, r.y, r.w, r.h          '' 2 2 16 6
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiPercent](Modern-Tui-TuiPercent) | [TuiMin_](Modern-Tui-TuiMin) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPad](Modern-Tui-TuiPad) |
| [TuiLength](Modern-Tui-TuiLength) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiMax_](Modern-Tui-TuiMax) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)