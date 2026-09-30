[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect.Equals**

# TuiRect.Equals

## Syntax

```freebasic
TuiRect.Equals( byval o as TuiRect ) as boolean
```

## Description

Field-by-field comparison. Useful for skipping work when a computed layout has not moved.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiRect a = TuiRectOf( 1, 2, 3, 4 )
print a.Equals( TuiRectOf( 1, 2, 3, 4 ) )    '' true
print a.Equals( TuiRectOf( 1, 2, 3, 5 ) )    '' false
```

## See also

[TuiRect](Modern-Tui-TuiRect) · [TuiRect.Right](Modern-Tui-TuiRect-Right) · [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) · [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) · [TuiRect.Contains](Modern-Tui-TuiRect-Contains) · [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) · [TuiRect.Inner](Modern-Tui-TuiRect-Inner) · [TuiRectOf](Modern-Tui-TuiRectOf) · [TuiSize](Modern-Tui-TuiSize) · [TuiSizeOf](Modern-Tui-TuiSizeOf) · [TuiPos](Modern-Tui-TuiPos) · [TuiMargin](Modern-Tui-TuiMargin)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)