[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Geometry](Category-Terminal-TUI-Library) › **TuiRect.Contains**

# TuiRect.Contains

## Syntax

```freebasic
TuiRect.Contains( byval px as int32, byval py as int32 ) as boolean
```

## Description

Point-in-rect, half-open on the right and bottom. This is the hit test for mouse events -- remember the mouse reports 0-based cell coordinates, in the same space.

## Example

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

dim as TuiRect body = TuiRectOf( 10, 5, 30, 12 )
print body.Contains( 10, 5 )      '' true  -- the top-left corner is inside
print body.Contains( 40, 5 )      '' false -- Right( ) is not

'' hit-testing a mouse event, the shape used in examples/dashboard.tiko
dim as TuiEvent e
e.kind = TUIEVENT_MOUSE
e.mouse.kind = TUIMOUSE_PRESS
e.mouse.x = 12 : e.mouse.y = 8
if( body.Contains( e.mouse.x, e.mouse.y ) ) then
    dim as int32 row = e.mouse.y - body.y
    print "clicked row"; row      '' 3
end if
```

## See also

[TuiRect](Modern-Tui-TuiRect) · [TuiRect.Right](Modern-Tui-TuiRect-Right) · [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) · [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) · [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) · [TuiRect.Inner](Modern-Tui-TuiRect-Inner) · [TuiRect.Equals](Modern-Tui-TuiRect-Equals) · [TuiRectOf](Modern-Tui-TuiRectOf) · [TuiSize](Modern-Tui-TuiSize) · [TuiSizeOf](Modern-Tui-TuiSizeOf) · [TuiPos](Modern-Tui-TuiPos) · [TuiMargin](Modern-Tui-TuiMargin)

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Category:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Documented under:** Geometry  
**Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard)


---

[Home](Home) · [Keyword Index](Keyword-Index)