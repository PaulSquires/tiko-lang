[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiPad**

# TuiPad

Returns a rectangle shrunk by a margin.

## Syntax

```freebasic
TuiPad( byval r as TuiRect, byval m as TuiMargin ) as TuiRect
```

## Description

Shrinks a rect by a margin -- the free-function form of TuiRect.Inner.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiRect r = TuiPad( TuiRectOf( 0, 0, 20, 10 ), TuiMarginOf( 2, 1, 2, 1 ) )
print r.x, r.y, r.w, r.h          '' 2 1 16 8
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiPercent](Modern-Tui-TuiPercent) | [TuiAtLeast](Modern-Tui-TuiAtLeast) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPadAll](Modern-Tui-TuiPadAll) |
| [TuiLength](Modern-Tui-TuiLength) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiAtMost](Modern-Tui-TuiAtMost) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiCenter](Modern-Tui-TuiCenter) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)