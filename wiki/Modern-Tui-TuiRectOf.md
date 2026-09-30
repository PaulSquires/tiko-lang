[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRectOf**

# TuiRectOf

## Syntax

```freebasic
TuiRectOf( byval x as int32, byval y as int32, byval w as int32, byval h as int32 ) as TuiRect
```

## Description

Builds a TuiRect. There is no constructor, so this is how you make one in an expression.

## Example

```freebasic
#import "std/tui"
using FB

dim as TuiRect full = TuiRectOf( 0, 0, 80, 24 )
dim as TuiRect pane = TuiRectOf( 0, 0, 40, 24 )
print full.w, pane.w              '' 80 40
```

## See also

[TuiRect](Modern-Tui-TuiRect) · [TuiRect.Right](Modern-Tui-TuiRect-Right) · [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) · [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) · [TuiRect.Contains](Modern-Tui-TuiRect-Contains) · [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) · [TuiRect.Inner](Modern-Tui-TuiRect-Inner) · [TuiRect.Equals](Modern-Tui-TuiRect-Equals) · [TuiSize](Modern-Tui-TuiSize) · [TuiSizeOf](Modern-Tui-TuiSizeOf) · [TuiPos](Modern-Tui-TuiPos) · [TuiMargin](Modern-Tui-TuiMargin)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)