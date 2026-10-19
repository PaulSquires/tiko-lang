[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Layout](Category-Terminal-TUI-Library) › **TuiAlignIn**

# TuiAlignIn

Returns a rectangle of a given width at the left, centre or right of another.

## Syntax

```freebasic
TuiAlignIn( byval outer as TuiRect, byval w as int32, byval a as TuiAlign ) as TuiRect
```

## Description

A w-wide rect placed left, centre or right inside another, full height. What a status bar uses to put an item hard against the right edge.

## Example

```freebasic
#import "std/tui"
using tui

dim as TuiRect outer_ = TuiRectOf( 0, 0, 20, 3 )
print TuiAlignIn( outer_, 6, TUIALIGN_LEFT ).x     '' 0
print TuiAlignIn( outer_, 6, TUIALIGN_CENTER ).x   '' 7
print TuiAlignIn( outer_, 6, TUIALIGN_RIGHT ).x    '' 14
```

## See also

|   |   |   |   |   |   |
|---|---|---|---|---|---|
| [TuiConstraint](Modern-Tui-TuiConstraint) | [TuiPercent](Modern-Tui-TuiPercent) | [TuiMin_](Modern-Tui-TuiMin) | [TuiFill](Modern-Tui-TuiFill) | [TuiSplitH](Modern-Tui-TuiSplitH) | [TuiPad](Modern-Tui-TuiPad) |
| [TuiLength](Modern-Tui-TuiLength) | [TuiRatio](Modern-Tui-TuiRatio) | [TuiMax_](Modern-Tui-TuiMax) | [TuiSolve](Modern-Tui-TuiSolve) | [TuiSplitV](Modern-Tui-TuiSplitV) | [TuiPadAll](Modern-Tui-TuiPadAll) |

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Layout  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)