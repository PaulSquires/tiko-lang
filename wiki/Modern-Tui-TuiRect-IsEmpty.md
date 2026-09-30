[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect.IsEmpty**

# TuiRect.IsEmpty

## Syntax

```freebasic
TuiRect.IsEmpty( ) as boolean
```

## Description

True when the rect has no area. Test it after every Intersect and after taking the Inner( ) of a small block -- a border on a 1x1 area leaves nothing inside, and drawing into an empty rect is a silent no-op rather than an error.

## Example

```freebasic
#import "std/tui"
using FB

print TuiRectOf( 0, 0, 10, 4 ).IsEmpty( )     '' false
print TuiRectOf( 0, 0, 0, 4 ).IsEmpty( )      '' true
print TuiRectOf( 0, 0, 10, -1 ).IsEmpty( )    '' true -- negative counts too

'' the usual guard, straight out of every widget in the module
dim as TuiRect inner = TuiRectOf( 0, 0, 2, 2 ).Inner( TuiMarginAll( 1 ) )
if( inner.IsEmpty( ) ) then print "nothing to draw"
```

## See also

[TuiRect](Modern-Tui-TuiRect) · [TuiRect.Right](Modern-Tui-TuiRect-Right) · [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) · [TuiRect.Contains](Modern-Tui-TuiRect-Contains) · [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) · [TuiRect.Inner](Modern-Tui-TuiRect-Inner) · [TuiRect.Equals](Modern-Tui-TuiRect-Equals) · [TuiRectOf](Modern-Tui-TuiRectOf) · [TuiSize](Modern-Tui-TuiSize) · [TuiSizeOf](Modern-Tui-TuiSizeOf) · [TuiPos](Modern-Tui-TuiPos) · [TuiMargin](Modern-Tui-TuiMargin)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.bas](Modern-Tui-Example-Hello) · [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)  
**Source:** `docs/tui/tui.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)