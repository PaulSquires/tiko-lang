[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiMarginAll**

# TuiMarginAll

## Syntax

```freebasic
TuiMarginAll( byval n as int32 ) as TuiMargin
```

## Description

A margin of n on every side. This is what a one-cell border costs.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiRect r = TuiRectOf( 0, 0, 30, 10 )
dim as TuiRect inside = r.Inner( TuiMarginAll( 1 ) )
print inside.w, inside.h          '' 28 8
```

## See also

[TuiRect](Modern-Tui-TuiRect) · [TuiRect.Right](Modern-Tui-TuiRect-Right) · [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) · [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) · [TuiRect.Contains](Modern-Tui-TuiRect-Contains) · [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) · [TuiRect.Inner](Modern-Tui-TuiRect-Inner) · [TuiRect.Equals](Modern-Tui-TuiRect-Equals) · [TuiRectOf](Modern-Tui-TuiRectOf) · [TuiSize](Modern-Tui-TuiSize) · [TuiSizeOf](Modern-Tui-TuiSizeOf) · [TuiPos](Modern-Tui-TuiPos)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)