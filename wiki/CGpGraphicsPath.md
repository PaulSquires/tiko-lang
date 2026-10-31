[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gdiplus](SysWin-GdiPlus) › **Graphics paths**

# Graphics paths
Builds shapes from lines, curves and text, and walks the points they are made of.

<!-- scope: CGpGraphicsPath -->
<!-- scope: CGpGraphicsPathIterator -->

Builds shapes from lines, curves and text, and walks the points they are made of.

A **path** is a list of points, each with a type byte, grouped into **figures** (also called
subpaths). `CGpGraphicsPath` wraps one GDI+ `GraphicsPath`: you add lines, arcs, Bézier and
cardinal splines, rectangles, ellipses, pies, polygons and the outlines of text to it, then draw
it with [CGpGraphics](CGpGraphics) `DrawPath`, fill it with `FillPath`, turn it into a
[CGpRegion](CGpRegion), clip to it, or ask whether a point is inside it. A
`CGpGraphicsPathIterator` walks an existing path figure by figure, marker by marker.

**Figures.** Lines, arcs, Béziers and open curves go into the current figure, and each one is
joined to the end of the previous one by a straight line. Rectangles, ellipses, pies, polygons
and closed curves are complete shapes: each becomes a closed figure of its own.
[StartFigure](#startfigure) begins a new figure without closing the current one;
[CloseFigure](#closefigure) closes it with a line back to its first point.

**Points and types.** Curves are stored as cubic Bézier points, so a path usually holds more
points than you passed: an ellipse is 13 points. Each point has a type byte: `PathPointTypeStart`
(0) for the first point of a figure, otherwise `PathPointTypeLine` (1) or `PathPointTypeBezier`
(3), with the flag `PathPointTypeCloseSubpath` (&h80) added on the last point of a closed figure
and `PathPointTypePathMarker` (&h20) on a marked point. The type arrays are `byte`, which is signed, so a closing line point
(&h81) reads back as -127.

**Fill mode.** Where figures overlap or cross themselves, `FillModeAlternate` (the default) fills
a point when a ray from it crosses the outline an odd number of times; `FillModeWinding` also
fills it when the crossings in each direction do not cancel out.

**Coordinates.** The methods take `single` coordinates, `GpPointF` and `GpRectF`, or `GpPoint`
and `GpRect` (whole numbers) where an overload says so. There are no overloads with four whole
numbers: integer values are converted to `single`. Angles are in degrees, clockwise from the
x-axis.

**Lifetime.** Never copy a `CGpGraphicsPath` or an iterator by value (`dim b as CGpGraphicsPath
= a`, or a `byval` parameter): the copy holds the same GDI+ object and deletes it when it goes.
Copy a path with `dim b as CGpGraphicsPath = @a` or [Clone](#clone); pass it to your own
procedures `byref` or by pointer. An iterator copies the path's points when it is created and
does not see points added afterwards.

**Status.** The methods that change a path return a `GpStatus`: `Ok` (0) on success, otherwise
the reason. The status is also stored and `GetLastStatus()`, inherited by every `CGp*` class,
returns it; getters and the iterator's methods store theirs too. Pointer arguments are not
checked for `NULL` unless an entry says so.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus
```

## Example

A window that fills and outlines a rounded rectangle made of four arcs, and says in its caption
whether a click landed inside the shape:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/gdiplus"
using win, gui, gdiplus

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

' Four quarter arcs; the path joins them with straight lines.
sub BuildRoundRect( byref path as CGpGraphicsPath, byval x as single, byval y as single, byval w as single, byval h as single, byval r as single )
    path.Reset()
    path.AddArc( x, y, r * 2, r * 2, 180, 90 )
    path.AddArc( x + w - r * 2, y, r * 2, r * 2, 270, 90 )
    path.AddArc( x + w - r * 2, y + h - r * 2, r * 2, r * 2, 0, 90 )
    path.AddArc( x, y + h - r * 2, r * 2, r * 2, 90, 90 )
    path.CloseFigure()
end sub

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim token as ULONG_PTR = gdiplus.Init()
    dim pWindow as CWindow = "PathDemo"
    pWindow.Create( NULL, "Click inside or outside the shape", @WndProc )
    pWindow.SetClientSize( 360, 220 )
    pWindow.Center()
    dim nResult as long = pWindow.DoEvents( SW_NORMAL )
    gdiplus.Uninit( token )
    return nResult
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_PAINT
            dim ps as PAINTSTRUCT
            dim hdc as HDC = BeginPaint( hwnd, @ps )
            scope
                dim graphics as CGpGraphics = hdc
                graphics.SetSmoothingMode( SmoothingModeAntiAlias )
                graphics.ScaleTransformForDpi()
                graphics.Clear( ARGB_WHITE )
                dim path as CGpGraphicsPath
                BuildRoundRect( path, 40, 40, 280, 140, 30 )
                dim brush as CGpSolidBrush = ARGB_LIGHTSKYBLUE
                dim pen as CGpPen = CGpPen( ARGB_NAVY, 3 )
                graphics.FillPath( @brush, @path )
                graphics.DrawPath( @pen, @path )
            end scope
            EndPaint( hwnd, @ps )
            return 0
        case WM_LBUTTONDOWN
            ' Hit-test in 96-DPI units, the units the shape was built in.
            dim ratio as single = GetLogPixelsX() / 96
            dim path as CGpGraphicsPath
            BuildRoundRect( path, 40, 40, 280, 140, 30 )
            dim inside as boolean = path.IsVisible( GET_X_LPARAM( lParam ) / ratio, GET_Y_LPARAM( lParam ) / ratio )
            SetWindowText( hwnd, iif( inside, "Inside the shape", "Outside the shape" ) )
            return 0
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

## Members

| Member | Does |
| --- | --- |
| **CGpGraphicsPath** | |
| [Constructor](#constructor) | Creates an empty path, a copy, or a path from points and types. |
| [Destructor](#destructor) | Deletes the GDI+ path. |
| [Clone](#clone) | Copies this path into another `CGpGraphicsPath`. |
| [Reset](#reset) | Empties the path. |
| [GetFillMode](#getfillmode) | Returns the fill mode. |
| [SetFillMode](#setfillmode) | Sets the fill mode. |
| [GetPathData](#getpathdata) | Copies the points and types into a `GpPathData`. |
| [StartFigure](#startfigure) | Begins a new figure. |
| [CloseFigure](#closefigure) | Closes the current figure. |
| [CloseAllFigures](#closeallfigures) | Closes every open figure. |
| [SetMarker](#setmarker) | Marks the last point. |
| [ClearMarkers](#clearmarkers) | Removes every marker. |
| [Reverse](#reverse) | Reverses the order of the points. |
| [GetLastPoint](#getlastpoint) | Returns the last point. |
| [AddLine](#addline) | Adds a line. |
| [AddLines](#addlines) | Adds a series of connected lines. |
| [AddArc](#addarc) | Adds an elliptical arc. |
| [AddBezier](#addbezier) | Adds a Bézier spline. |
| [AddBeziers](#addbeziers) | Adds a series of connected Bézier splines. |
| [AddCurve](#addcurve) | Adds a cardinal spline through points. |
| [AddClosedCurve](#addclosedcurve) | Adds a closed cardinal spline. |
| [AddRectangle](#addrectangle) | Adds a rectangle. |
| [AddRectangles](#addrectangles) | Adds several rectangles. |
| [AddEllipse](#addellipse) | Adds an ellipse. |
| [AddPie](#addpie) | Adds a pie slice. |
| [AddPolygon](#addpolygon) | Adds a polygon. |
| [AddPath](#addpath) | Adds the figures of another path. |
| [AddString](#addstring) | Adds the outlines of a string of text. |
| [TransForm](#transform) | Applies a matrix to every point. |
| [GetBounds](#getbounds) | Reads the rectangle that encloses the path. |
| [Flatten](#flatten) | Turns the curves into straight lines. |
| [Widen](#widen) | Replaces the path with the outline of its stroke. |
| [Outline](#outline) | Replaces the path with the outline of its filled area. |
| [Warp](#warp) | Maps the path onto a parallelogram or a quadrilateral. |
| [GetPointCount](#getpointcount) | Returns the number of points. |
| [GetPathTypes](#getpathtypes) | Copies the point types. |
| [GetPathPoints](#getpathpoints) | Copies the points. |
| [IsVisible](#isvisible) | Tells whether a point is in the filled area. |
| [IsOutlineVisible](#isoutlinevisible) | Tells whether a point is on the stroked outline. |
| **CGpGraphicsPathIterator** | |
| [Constructor](#constructor-1) | Creates an iterator over a path. |
| [Destructor](#destructor-1) | Deletes the GDI+ iterator. |
| [NextSubpath](#nextsubpath) | Returns the index range of the next figure. |
| [NextSubpathPath](#nextsubpathpath) | Copies the next figure into a path. |
| [NextPathType](#nextpathtype) | Returns the next run of points of one type in the current figure. |
| [NextMarker](#nextmarker) | Returns or copies the next marker-delimited section. |
| [GetCount](#getcount) | Returns the number of points. |
| [GetSubpathCount](#getsubpathcount) | Returns the number of figures. |
| [HasCurve](#hascurve) | Tells whether the path holds Bézier points. |
| [Rewind](#rewind) | Goes back to the start of the path. |
| [Enumerate](#enumerate) | Copies all points and types. |
| [CopyData](#copydata) | Copies a range of points and types. |
| [IsValid](#isvalid) | Tells whether the iterator was created properly. |

## Reference

## CGpGraphicsPath

### Constructor

```freebasic
constructor( byval pGraphicsPath as CGpGraphicsPath ptr )
constructor( byval nFillMode as FillMode = FillModeAlternate )
constructor( byval pts as GpPointF ptr, byval types as byte ptr, byval nCount as long, byval nFillMode as FillMode = FillModeAlternate )
constructor( byval pts as GpPoint ptr, byval types as byte ptr, byval nCount as long, byval nFillMode as FillMode = FillModeAlternate )
```

Creates the GDI+ path.

- With no argument, or only a fill mode, it is empty.
- With another path's address it is an independent copy; the pointer must not be `NULL`.
- With arrays of `nCount` points and `nCount` type bytes it holds exactly those points; the
  first type must be `PathPointTypeStart`.

`GetLastStatus()` tells whether the path was created.

| Parameter | Meaning |
| --- | --- |
| `pGraphicsPath` | The path to copy. |
| `nFillMode` | `FillModeAlternate` (the default) or `FillModeWinding`. |
| `pts` | The first point of the array. |
| `types` | The first type byte of the array. |
| `nCount` | How many points and types. |

**Example**

```freebasic
dim pts(0 to 2) as GpPointF = { (0, 0), (10, 0), (10, 10) }
dim types(0 to 2) as byte = { PathPointTypeStart, PathPointTypeLine, PathPointTypeLine or PathPointTypeCloseSubpath }
dim triangle as CGpGraphicsPath = CGpGraphicsPath( @pts(0), @types(0), 3 )
print triangle.GetPointCount()              ' 3
```

Microsoft Learn: [GraphicsPath::GraphicsPath](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-graphicspath%28constpointf_constbyte_int_fillmode%29)

### Destructor

```freebasic
destructor
```

Deletes the GDI+ path. A [region](CGpRegion) made from it holds its own copy and is not
affected.

**Example**

```freebasic
dim pPath as CGpGraphicsPath ptr = new CGpGraphicsPath( FillModeWinding )
pPath->AddEllipse( 0, 0, 40, 40 )
delete pPath
```

### Clone

```freebasic
function Clone( byval pCloneGraphicsPath as CGpGraphicsPath ptr ) as GpStatus
```

Copies this path, fill mode included, into the existing `CGpGraphicsPath` that
`pCloneGraphicsPath` points to. The GDI+ path the target held is deleted first.

| Parameter | Meaning |
| --- | --- |
| `pCloneGraphicsPath` | The object that receives the copy. |

**Returns** `Ok` on success; `InvalidParameter` when the pointer is `NULL`.

**Example**

```freebasic
dim a as CGpGraphicsPath
a.AddRectangle( 0, 0, 10, 10 )
dim b as CGpGraphicsPath
if a.Clone( @b ) = Ok then print b.GetPointCount()   ' 4
```

Microsoft Learn: [GraphicsPath::Clone](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-clone)

### Reset

```freebasic
function Reset() as GpStatus
```

Removes every point and figure and sets the fill mode back to `FillModeAlternate`.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath = CGpGraphicsPath( FillModeWinding )
p.AddEllipse( 0, 0, 50, 50 )
p.Reset()
print p.GetPointCount(); p.GetFillMode()    ' 0 0
```

Microsoft Learn: [GraphicsPath::Reset](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-reset)

### GetFillMode

```freebasic
function GetFillMode() as FillMode
```

Returns how overlapping parts of the path are filled.

**Returns** `FillModeAlternate` (0) or `FillModeWinding` (1).

**Example**

```freebasic
dim p as CGpGraphicsPath
print p.GetFillMode()                       ' 0, FillModeAlternate
```

Microsoft Learn: [GraphicsPath::GetFillMode](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-getfillmode)

### SetFillMode

```freebasic
function SetFillMode( byval nFillmode as FillMode ) as GpStatus
```

Sets how overlapping parts of the path are filled.

| Parameter | Meaning |
| --- | --- |
| `nFillmode` | `FillModeAlternate` or `FillModeWinding`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.SetFillMode( FillModeWinding )
```

Microsoft Learn: [GraphicsPath::SetFillMode](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-setfillmode)

### GetPathData

```freebasic
function GetPathData( byval pPathData as any ptr ) as GpStatus
```

Copies the path's points and types into the arrays of a `GpPathData`. You provide the arrays:
set `Count` to [GetPointCount](#getpointcount) and point `Points` and `Types` at arrays of
that many `GpPointF` and `byte`. A `GpPathData` left empty fails with `InvalidParameter`.

| Parameter | Meaning |
| --- | --- |
| `pPathData` | The address of a `GpPathData`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
dim n as long = p.GetPointCount()
dim pts(0 to n - 1) as GpPointF
dim types(0 to n - 1) as byte
dim pd as GpPathData
pd.Count = n : pd.Points = @pts(0) : pd.Types = @types(0)
p.GetPathData( @pd )
```

Microsoft Learn: [GraphicsPath::GetPathData](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-getpathdata)

### StartFigure

```freebasic
function StartFigure() as GpStatus
```

Begins a new figure. The current figure is left open, and the next line or curve is not joined
to it.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 10, 0 )
p.StartFigure()
p.AddLine( 20, 0, 30, 0 )                   ' two open figures
```

Microsoft Learn: [GraphicsPath::StartFigure](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-startfigure)

### CloseFigure

```freebasic
function CloseFigure() as GpStatus
```

Closes the current figure with a line from its last point to its first, and begins a new one.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 10, 0 )
p.AddLine( 10, 0, 10, 10 )
p.CloseFigure()                             ' a closed triangle
```

Microsoft Learn: [GraphicsPath::CloseFigure](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-closefigure)

### CloseAllFigures

```freebasic
function CloseAllFigures() as GpStatus
```

Closes every figure of the path that is still open.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 10, 0 )
p.AddLine( 10, 0, 10, 10 )
p.StartFigure()
p.AddLine( 20, 0, 30, 0 )
p.CloseAllFigures()
```

Microsoft Learn: [GraphicsPath::CloseAllFigures](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-closeallfigures)

### SetMarker

```freebasic
function SetMarker() as GpStatus
```

Marks the last point of the path. Markers split a path into sections that
[NextMarker](#nextmarker) returns one at a time.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 10, 0 )
p.SetMarker()
p.AddRectangle( 20, 20, 5, 5 )              ' a second section
```

Microsoft Learn: [GraphicsPath::SetMarker](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-setmarker)

### ClearMarkers

```freebasic
function ClearMarkers() as GpStatus
```

Removes every marker from the path.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 10, 0 )
p.SetMarker()
p.ClearMarkers()
```

Microsoft Learn: [GraphicsPath::ClearMarkers](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-clearmarkers)

### Reverse

```freebasic
function Reverse() as GpStatus
```

Reverses the order of the path's points, so the last point comes first.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 10, 10 )
p.Reverse()                                 ' now from (10, 10) to (0, 0)
```

Microsoft Learn: [GraphicsPath::Reverse](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-reverse)

### GetLastPoint

```freebasic
function GetLastPoint( byval lastPoint as GpPointF ptr ) as GpStatus
function GetLastPoint() as GpPointF
```

Reads the last point of the path. The first form writes it to `lastPoint` and returns the
status; the second returns the point. An empty path has no last point: the status is
`InvalidParameter` and the second form returns (0, 0).

| Parameter | Meaning |
| --- | --- |
| `lastPoint` | Receives the point. |

**Returns** the status, or the point.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddBezier( 0, 0, 10, 20, 30, 20, 40, 0 )
dim pt as GpPointF = p.GetLastPoint()
print pt.x; pt.y                            ' 40 0
```

Microsoft Learn: [GraphicsPath::GetLastPoint](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-getlastpoint)

### AddLine

```freebasic
function AddLine( byval x1 as single, byval y1 as single, byval x2 as single, byval y2 as single ) as GpStatus
function AddLine( byval pt1 as GpPointF ptr, byval pt2 as GpPointF ptr ) as GpStatus
function AddLine( byval pt1 as GpPoint ptr, byval pt2 as GpPoint ptr ) as GpStatus
```

Adds a line from (`x1`, `y1`) to (`x2`, `y2`) to the current figure. If the figure already has
points, a line from its last point to the start of the new one is added too.

| Parameter | Meaning |
| --- | --- |
| `x1`, `y1`, `pt1` | The start of the line. |
| `x2`, `y2`, `pt2` | The end of the line. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 5, 5 )
p.AddLine( 10, 10, 20, 20 )                 ' joined to the first: one figure, 4 points
```

Microsoft Learn: [GraphicsPath::AddLine](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addline%28real_real_real_real%29)

### AddLines

```freebasic
function AddLines( byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function AddLines( byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
```

Adds lines that join `nCount` points one after another to the current figure.

| Parameter | Meaning |
| --- | --- |
| `pts` | The first point of the array. |
| `nCount` | How many points. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim pts(0 to 3) as GpPointF = { (0, 0), (10, 10), (20, 0), (30, 10) }
dim p as CGpGraphicsPath
p.AddLines( @pts(0), 4 )                    ' a zigzag of three lines
```

Microsoft Learn: [GraphicsPath::AddLines](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addlines%28constpointf_int%29)

### AddArc

```freebasic
function AddArc( byval x as single, byval y as single, byval width_ as single, byval height_ as single, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function AddArc( byval rcf as GpRectF ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function AddArc( byval rc as GpRect ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
```

Adds part of the ellipse that fits the rectangle to the current figure, starting `startAngle`
degrees clockwise from the x-axis and running for `sweepAngle` degrees (negative runs
anticlockwise).

| Parameter | Meaning |
| --- | --- |
| `x`, `y`, `width_`, `height_`, `rcf`, `rc` | The rectangle that bounds the ellipse. |
| `startAngle` | Where the arc begins, in degrees. |
| `sweepAngle` | How far it runs, in degrees. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddArc( 0, 0, 100, 100, 0, 90 )           ' the bottom-right quarter
```

Microsoft Learn: [GraphicsPath::AddArc](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addarc%28real_real_real_real_real_real%29)

### AddBezier

```freebasic
function AddBezier( byval x1 as single, byval y1 as single, byval x2 as single, byval y2 as single, byval x3 as single, byval y3 as single, byval x4 as single, byval y4 as single ) as GpStatus
function AddBezier( byval pt1 as GpPointF ptr, byval pt2 as GpPointF ptr, byval pt3 as GpPointF ptr, byval pt4 as GpPointF ptr ) as GpStatus
function AddBezier( byval pt1 as GpPoint ptr, byval pt2 as GpPoint ptr, byval pt3 as GpPoint ptr, byval pt4 as GpPoint ptr ) as GpStatus
```

Adds a cubic Bézier spline to the current figure: it starts at the first point, ends at the
fourth, and is pulled towards the second and third (the control points).

| Parameter | Meaning |
| --- | --- |
| `x1`, `y1`, `pt1` | The start point. |
| `x2`, `y2`, `pt2`, `x3`, `y3`, `pt3` | The two control points. |
| `x4`, `y4`, `pt4` | The end point. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddBezier( 0, 0, 10, 20, 30, 20, 40, 0 )  ' an arch
```

Microsoft Learn: [GraphicsPath::AddBezier](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addbezier%28real_real_real_real_real_real_real_real%29)

### AddBeziers

```freebasic
function AddBeziers( byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function AddBeziers( byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
```

Adds connected Bézier splines to the current figure. The first spline takes four points; each
further one takes three more and starts where the previous one ended, so `nCount` is 4, 7,
10 …

| Parameter | Meaning |
| --- | --- |
| `pts` | The first point of the array. |
| `nCount` | How many points. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim pts(0 to 6) as GpPointF = { (0, 0), (10, 20), (20, 20), (30, 0), (40, -20), (50, -20), (60, 0) }
dim p as CGpGraphicsPath
p.AddBeziers( @pts(0), 7 )                  ' an S of two splines
```

Microsoft Learn: [GraphicsPath::AddBeziers](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addbeziers%28constpointf_int%29)

### AddCurve

```freebasic
function AddCurve( byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function AddCurve( byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
function AddCurve( byval pts as GpPointF ptr, byval nCount as INT_, byval tension as single ) as GpStatus
function AddCurve( byval pts as GpPoint ptr, byval nCount as INT_, byval tension as single ) as GpStatus
function AddCurve( byval pts as GpPointF ptr, byval nCount as INT_, byval offset as INT_, byval numberOfSegments as INT_, byval tension as single ) as GpStatus
function AddCurve( byval pts as GpPoint ptr, byval nCount as INT_, byval offset as INT_, byval numberOfSegments as INT_, byval tension as single ) as GpStatus
```

Adds a cardinal spline, a smooth curve that passes through every point, to the current figure.
It is stored as Bézier points, so four points become ten.

| Parameter | Meaning |
| --- | --- |
| `pts` | The first point of the array. |
| `nCount` | How many points. |
| `tension` | How tightly the curve bends: 0 gives straight lines, 0.5 (used when it is left out) a natural curve, larger values a looser one. |
| `offset` | The index of the point the curve starts at; the earlier points only shape it. |
| `numberOfSegments` | How many segments to add after `offset`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim pts(0 to 3) as GpPointF = { (0, 0), (10, 10), (20, 0), (30, 10) }
dim p as CGpGraphicsPath
p.AddCurve( @pts(0), 4 )
print p.GetPointCount()                     ' 10
```

Microsoft Learn: [GraphicsPath::AddCurve](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addcurve%28constpointf_int_real%29)

### AddClosedCurve

```freebasic
function AddClosedCurve( byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function AddClosedCurve( byval pts as GpPointF ptr, byval nCount as INT_, byval tension as single ) as GpStatus
function AddClosedCurve( byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
function AddClosedCurve( byval pts as GpPoint ptr, byval nCount as INT_, byval tension as single ) as GpStatus
```

Adds a closed cardinal spline through the points, as a figure of its own: the curve runs on
from the last point back to the first.

| Parameter | Meaning |
| --- | --- |
| `pts` | The first point of the array. |
| `nCount` | How many points. |
| `tension` | How tightly the curve bends; 0.5 when it is left out. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim pts(0 to 3) as GpPointF = { (0, 0), (40, 0), (40, 40), (0, 40) }
dim blob as CGpGraphicsPath
blob.AddClosedCurve( @pts(0), 4 )
```

Microsoft Learn: [GraphicsPath::AddClosedCurve](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addclosedcurve%28constpointf_int_real%29)

### AddRectangle

```freebasic
function AddRectangle( byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as GpStatus
function AddRectangle( byval rcr as GpRectF ptr ) as GpStatus
function AddRectangle( byval rcr as GpRect ptr ) as GpStatus
```

Adds a rectangle as a closed figure of four points.

| Parameter | Meaning |
| --- | --- |
| `x`, `y`, `nWidth`, `nHeight`, `rcr` | The rectangle. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 10, 10, 100, 50 )
print p.GetPointCount()                     ' 4
```

Microsoft Learn: [GraphicsPath::AddRectangle](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addrectangle%28constrectf_%29)

### AddRectangles

```freebasic
function AddRectangles( byval rects as GpRectF ptr, byval nCount as INT_ ) as GpStatus
function AddRectangles( byval rects as GpRect ptr, byval nCount as INT_ ) as GpStatus
```

Adds `nCount` rectangles, each as a closed figure.

| Parameter | Meaning |
| --- | --- |
| `rects` | The first rectangle of the array. |
| `nCount` | How many rectangles. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim rects(0 to 1) as GpRectF = { (0, 0, 10, 10), (20, 20, 10, 10) }
dim p as CGpGraphicsPath
p.AddRectangles( @rects(0), 2 )
print p.GetPointCount()                     ' 8
```

Microsoft Learn: [GraphicsPath::AddRectangles](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addrectangles%28constrectf_int%29)

### AddEllipse

```freebasic
function AddEllipse( byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as GpStatus
function AddEllipse( byval rcf as GpRectF ptr ) as GpStatus
function AddEllipse( byval rc as GpRect ptr ) as GpStatus
```

Adds the ellipse that fits the rectangle, as a closed figure of 13 Bézier points.

| Parameter | Meaning |
| --- | --- |
| `x`, `y`, `nWidth`, `nHeight`, `rcf`, `rc` | The bounding rectangle. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim disc as CGpGraphicsPath
disc.AddEllipse( 0, 0, 100, 100 )
print disc.GetPointCount()                  ' 13
```

Microsoft Learn: [GraphicsPath::AddEllipse](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addellipse%28real_real_real_real%29)

### AddPie

```freebasic
function AddPie( byval x as single, byval y as single, byval nWidth as single, byval nHeight as single, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function AddPie( byval rcf as GpRectF ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function AddPie( byval rcf as GpRect ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
```

Adds a pie slice as a closed figure: an arc of the ellipse that fits the rectangle, plus the two
lines from its ends to the ellipse's centre.

| Parameter | Meaning |
| --- | --- |
| `x`, `y`, `nWidth`, `nHeight`, `rcf` | The rectangle that bounds the ellipse. |
| `startAngle` | Where the arc begins, in degrees clockwise from the x-axis. |
| `sweepAngle` | How far it runs, in degrees. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim slice as CGpGraphicsPath
slice.AddPie( 0, 0, 100, 100, 0, 90 )
```

Microsoft Learn: [GraphicsPath::AddPie](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addpie%28real_real_real_real_real_real%29)

### AddPolygon

```freebasic
function AddPolygon( byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function AddPolygon( byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
```

Adds a polygon through `nCount` points as a closed figure.

| Parameter | Meaning |
| --- | --- |
| `pts` | The first point of the array. |
| `nCount` | How many points. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim pts(0 to 2) as GpPoint = { (50, 0), (100, 80), (0, 80) }
dim p as CGpGraphicsPath
p.AddPolygon( @pts(0), 3 )
```

Microsoft Learn: [GraphicsPath::AddPolygon](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addpolygon%28constpointf_int%29)

### AddPath

```freebasic
function AddPath( byval pAddingPath as CGpGraphicsPath ptr, byval bConnect as BOOL ) as GpStatus
```

Adds the figures of another path. With `bConnect` true the first figure of the other path is
joined to the current figure when that one is open; with `FALSE` it stays a figure of its own.

| Parameter | Meaning |
| --- | --- |
| `pAddingPath` | The path to add. |
| `bConnect` | `TRUE` to join the first added figure to the current one. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim a as CGpGraphicsPath
a.AddLine( 0, 0, 5, 5 )
dim b as CGpGraphicsPath
b.AddLine( 10, 10, 20, 20 )
a.AddPath( @b, FALSE )                      ' two figures
```

Microsoft Learn: [GraphicsPath::AddPath](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addpath)

### AddString

```freebasic
function AddString( byval pString as wstring ptr, byval length as INT_, byval pFamily as CGpFontFamily_ ptr, byval nStyle as INT_, byval emSize as single, byval layoutRect as GpRectF ptr, byval pFormat as CGpStringFormat_ ptr ) as GpStatus
function AddString( byval pString as wstring ptr, byval length as INT_, byval pFamily as CGpFontFamily_ ptr, byval nStyle as INT_, byval emSize as single, byval layoutRect as GpRect ptr, byval pFormat as CGpStringFormat_ ptr ) as GpStatus
function AddString( byval pString as wstring ptr, byval length as INT_, byval pFamily as CGpFontFamily_ ptr, byval nStyle as INT_, byval emSize as single, byval origin as GpPointF ptr, byval pFormat as CGpStringFormat_ ptr ) as GpStatus
function AddString( byval pString as wstring ptr, byval length as INT_, byval pFamily as CGpFontFamily_ ptr, byval nStyle as INT_, byval emSize as single, byval origin as GpPoint ptr, byval pFormat as CGpStringFormat_ ptr ) as GpStatus
```

Adds the outlines of the characters of a string, each glyph as one or more closed figures. Fill
the path to draw solid text, draw it to outline the text, or use it as a clip.

The text is laid out in a rectangle (wrapped and aligned as `pFormat` says) or starting at an
`origin` point. `CGpFontFamily_` and `CGpStringFormat_` are other names for
[CGpFontFamily](SysWin-GdiPlus-Fonts) and [CGpStringFormat](CGpStringFormat).

| Parameter | Meaning |
| --- | --- |
| `pString` | The text. |
| `length` | The number of characters, or -1 for the whole null-terminated string. |
| `pFamily` | The font family; `NULL` fails with `InvalidParameter`. |
| `nStyle` | `FontStyleRegular`, `FontStyleBold`, `FontStyleItalic`, `FontStyleUnderline`, `FontStyleStrikeout`, combined with `or`. |
| `emSize` | The height of the em square in world units. |
| `layoutRect` | The rectangle to lay the text out in. |
| `origin` | The top-left corner of the text. |
| `pFormat` | Layout options, or `NULL` for the defaults. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim family as CGpFontFamily = "Arial"
dim origin as GpPointF = type<GpPointF>( 10, 10 )
dim text as CGpGraphicsPath
text.AddString( "tiko", -1, @family, FontStyleBold, 48, @origin, NULL )
```

Microsoft Learn: [GraphicsPath::AddString](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-addstring%28constwchar_int_constfontfamily_int_real_constpointf__conststringformat%29)

### TransForm

```freebasic
function TransForm( byval pMatrix as CGpMatrix ptr ) as GpStatus
```

Applies a [matrix](CGpMatrix) to every point of the path. `Transform`, in any capitals, calls
the same method. `pMatrix` must not be `NULL`.

| Parameter | Meaning |
| --- | --- |
| `pMatrix` | The transformation. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 10, 10, 100, 50 )
dim m as CGpMatrix
m.Translate( 5, 5 )
p.Transform( @m )                           ' now starts at 15, 15
```

Microsoft Learn: [GraphicsPath::Transform](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-transform)

### GetBounds

```freebasic
function GetBounds( byval bounds as GpRectF ptr, byval pMatrix as CGpMatrix ptr, byval pPen as CGpPen ptr ) as GpStatus
function GetBounds( byval bounds as GpRect ptr, byval pMatrix as CGpMatrix ptr, byval pPen as CGpPen ptr ) as GpStatus
```

Reads a rectangle that encloses the path. With `pMatrix` the path is measured as if that matrix
had been applied; with `pPen` the rectangle also takes in the width of the stroke, generously:
GDI+ allows for joins and caps, so the result can be much larger than the line drawn. Both may
be `NULL`. The `GpRect` form rounds outwards, so a 10 × 10 rectangle at (0, 0) gives 11 × 11.

| Parameter | Meaning |
| --- | --- |
| `bounds` | Receives the rectangle. |
| `pMatrix` | A transformation to measure with, or `NULL`. |
| `pPen` | The pen the path would be drawn with, or `NULL`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddEllipse( 0, 0, 50, 50 )
p.AddRectangle( 10, 10, 100, 50 )
dim rc as GpRectF
p.GetBounds( @rc, NULL, NULL )
print rc.Width; rc.Height                   ' 110 60
```

Microsoft Learn: [GraphicsPath::GetBounds](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-getbounds%28rectf_constmatrix_constpen%29)

### Flatten

```freebasic
function Flatten( byval pMatrix as CGpMatrix ptr = NULL, byval flatness as single = FlatnessDefault ) as GpStatus
```

Applies `pMatrix`, if given, and replaces every curve with a series of short straight lines.

| Parameter | Meaning |
| --- | --- |
| `pMatrix` | A transformation to apply first, or `NULL` (the default). |
| `flatness` | The largest distance allowed between a curve and its lines; `FlatnessDefault` is 0.25. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddEllipse( 0, 0, 100, 100 )
p.Flatten()
print p.GetPointCount()                     ' 57 instead of 13
```

Microsoft Learn: [GraphicsPath::Flatten](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-flatten)

### Widen

```freebasic
function Widen( byval pPen as CGpPen ptr, byval pMatrix as CGpMatrix ptr = NULL, byval flatness as single = FlatnessDefault ) as GpStatus
```

Replaces the path with the outline of the area that drawing it with `pPen` would cover, and
flattens it. Filling the widened path paints what drawing the original would. `pPen` must not
be `NULL`.

| Parameter | Meaning |
| --- | --- |
| `pPen` | The pen whose width, joins and caps are used. |
| `pMatrix` | A transformation to apply first, or `NULL` (the default). |
| `flatness` | How closely lines follow curves; `FlatnessDefault` is 0.25. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 100, 0 )
dim pen as CGpPen = CGpPen( ARGB_BLACK, 10 )
p.Widen( @pen )                             ' a 100 x 10 rectangle
```

Microsoft Learn: [GraphicsPath::Widen](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-widen)

### Outline

```freebasic
function Outline( byval pMatrix as CGpMatrix ptr = NULL, byval flatness as single = FlatnessDefault ) as GpStatus
```

Applies `pMatrix`, if given, flattens the path and replaces it with the outline of its filled
area: overlapping figures merge and inner edges disappear.

| Parameter | Meaning |
| --- | --- |
| `pMatrix` | A transformation to apply first, or `NULL` (the default). |
| `flatness` | How closely lines follow curves; `FlatnessDefault` is 0.25. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
p.AddRectangle( 5, 5, 10, 10 )
p.Outline()
print p.GetPointCount()                     ' 8: one merged outline
```

Microsoft Learn: [GraphicsPath::Outline](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-outline)

### Warp

```freebasic
function Warp( byval destPoints as GpPointF ptr, byval nCount as INT_, byval srcRect as GpRectF ptr, byval pMatrix as CGpMatrix ptr = NULL, byval nWarpMode as WarpMode = WarpModePerspective, byval Flatness as single = FlatnessDefault ) as GpStatus
```

Maps the rectangle `srcRect` onto the shape that `destPoints` describe and moves the path's
points with it, then flattens the path. Three points give a parallelogram (the images of the
top-left, top-right and bottom-left corners); four give any quadrilateral (top-left, top-right,
bottom-left, bottom-right).

| Parameter | Meaning |
| --- | --- |
| `destPoints` | The first of three or four destination points. |
| `nCount` | 3 or 4. |
| `srcRect` | The source rectangle. |
| `pMatrix` | A transformation to apply first, or `NULL` (the default). |
| `nWarpMode` | `WarpModePerspective` (the default) or `WarpModeBilinear`. |
| `Flatness` | How closely lines follow curves; `FlatnessDefault` is 0.25. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
dim src as GpRectF = type<GpRectF>( 0, 0, 10, 10 )
dim dst(0 to 3) as GpPointF = { (0, 0), (20, 0), (0, 20), (20, 20) }
p.Warp( @dst(0), 4, @src )                  ' now 20 x 20
```

Microsoft Learn: [GraphicsPath::Warp](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-warp)

### GetPointCount

```freebasic
function GetPointCount() as INT_
```

Returns the number of points in the path, which is also the number of type bytes.

**Returns** the count; 0 for an empty path.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 10, 10, 100, 50 )
p.AddEllipse( 0, 0, 50, 50 )
print p.GetPointCount()                     ' 17
```

Microsoft Learn: [GraphicsPath::GetPointCount](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-getpointcount)

### GetPathTypes

```freebasic
function GetPathTypes( byval types as byte ptr, byval nCount as INT_ ) as GpStatus
```

Copies the type byte of every point into an array. `nCount` must be at least
[GetPointCount](#getpointcount); a smaller array is not filled and the status is
`InsufficientBuffer` (5).

| Parameter | Meaning |
| --- | --- |
| `types` | The first element of the array. |
| `nCount` | The size of the array. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
dim types(0 to 3) as byte
p.GetPathTypes( @types(0), 4 )
print types(0); types(1); types(3)          ' 0 1-127
```

Microsoft Learn: [GraphicsPath::GetPathTypes](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-getpathtypes)

### GetPathPoints

```freebasic
function GetPathPoints( byref pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
```

Copies every point of the path into an array. `nCount` must be at least
[GetPointCount](#getpointcount); a smaller array is not filled and the status is
`InsufficientBuffer` (5). The pointer parameter is `byref`, but passing the address of the
first element, `@pts(0)`, works as usual.

| Parameter | Meaning |
| --- | --- |
| `pts` | The first element of the array. |
| `nCount` | The size of the array. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 10, 10, 100, 50 )
dim pts(0 to 3) as GpPointF
p.GetPathPoints( @pts(0), 4 )
print pts(2).x; pts(2).y                    ' 110 60
```

Microsoft Learn: [GraphicsPath::GetPathPoints](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-getpathpoints%28pointf_int%29)

### IsVisible

```freebasic
function IsVisible( byval x as single, byval y as single, byval pGraphics as CGpGraphics_ ptr = NULL ) as boolean
function IsVisible( byval pt as GpPointF ptr, byval pGraphics as CGpGraphics_ ptr = NULL ) as boolean
function IsVisible( byval pt as GpPoint ptr, byval pGraphics as CGpGraphics_ ptr = NULL ) as boolean
```

Tells whether a point lies in the area that filling the path would paint, by the path's fill
mode. Open figures count as if they were closed. Without `pGraphics` the point is in the path's
own coordinates; with one, its world transformation applies.

| Parameter | Meaning |
| --- | --- |
| `x`, `y`, `pt` | The point. |
| `pGraphics` | A graphics object, or `NULL` (the default). |

**Returns** `true` if the point is inside.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 10, 10, 100, 50 )
print p.IsVisible( 50, 30 ); p.IsVisible( 200, 200 )   ' true false
```

Microsoft Learn: [GraphicsPath::IsVisible](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-isvisible%28real_real_constgraphics%29)

### IsOutlineVisible

```freebasic
function IsOutlineVisible( byval x as single, byval y as single, byval pPen as CGpPen ptr, byval pGraphics as CGpGraphics_ ptr = NULL ) as boolean
function IsOutlineVisible( byval pt as GpPointF ptr, byval pPen as CGpPen ptr, byval pGraphics as CGpGraphics_ ptr = NULL ) as boolean
function IsOutlineVisible( byval pt as GpPoint ptr, byval pPen as CGpPen ptr, byval pGraphics as CGpGraphics_ ptr = NULL ) as boolean
```

Tells whether a point lies on the line that drawing the path with `pPen` would paint. Use it to
hit-test the edge of a shape. With `pPen` `NULL` it fails with `InvalidParameter` and returns
`false`.

| Parameter | Meaning |
| --- | --- |
| `x`, `y`, `pt` | The point. |
| `pPen` | The pen the path would be drawn with. |
| `pGraphics` | A graphics object, or `NULL` (the default). |

**Returns** `true` if the point is on the outline.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 10, 10, 100, 50 )
dim pen as CGpPen = CGpPen( ARGB_BLACK, 4 )
print p.IsOutlineVisible( 10, 30, @pen )    ' true: on the left edge
```

Microsoft Learn: [GraphicsPath::IsOutlineVisible](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspath-isoutlinevisible%28real_real_constpen_constgraphics%29)

## CGpGraphicsPathIterator

An iterator reads a path's figures, runs of point types and marker sections in order. Each
`Next…` method moves on and returns how many points it covered, and 0 when there is nothing
more; [Rewind](#rewind) starts again. Index ranges are inclusive: a range of 0 to 3 is four
points.

### Constructor

```freebasic
constructor( byval pPath as CGpGraphicsPath ptr )
```

Creates an iterator over the path that `pPath` points to, positioned before its first figure.
The iterator takes a copy of the path's points: points added to the path later are not seen.
`pPath` must not be `NULL`.

| Parameter | Meaning |
| --- | --- |
| `pPath` | The path to walk. |

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
p.AddEllipse( 20, 0, 10, 10 )
dim it as CGpGraphicsPathIterator = @p
print it.GetSubpathCount()                  ' 2
```

Microsoft Learn: [GraphicsPathIterator::GraphicsPathIterator](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-graphicspathiterator%28constgraphicspath%29)

### Destructor

```freebasic
destructor
```

Deletes the GDI+ iterator. The path is not affected.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 10, 10 )
dim pIt as CGpGraphicsPathIterator ptr = new CGpGraphicsPathIterator( @p )
print pIt->GetCount()                       ' 2
delete pIt
```

### NextSubpath

```freebasic
function NextSubpath( byval startIndex as INT_ ptr, byval endIndex as INT_ ptr, byval isClosed as BOOL ptr ) as INT_
```

Moves to the next figure and reads the indexes of its first and last points and whether it is
closed.

| Parameter | Meaning |
| --- | --- |
| `startIndex` | Receives the index of the figure's first point. |
| `endIndex` | Receives the index of its last point. |
| `isClosed` | Receives nonzero if the figure is closed. |

**Returns** the number of points in the figure, or 0 after the last one.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
p.AddEllipse( 20, 0, 10, 10 )
dim it as CGpGraphicsPathIterator = @p
dim as INT_ first, last
dim closed as BOOL
while it.NextSubpath( @first, @last, @closed ) > 0
    print first; " to"; last                ' 0 to 3, then 4 to 16
wend
```

Microsoft Learn: [GraphicsPathIterator::NextSubpath](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-nextsubpath%28int_int_bool%29)

### NextSubpathPath

```freebasic
function NextSubpathPath( byval pPath as CGpGraphicsPath ptr, byval isClosed as BOOL ptr ) as INT_
```

Moves to the next figure and copies it into the path that `pPath` points to, replacing what that
path held.

| Parameter | Meaning |
| --- | --- |
| `pPath` | The path that receives the figure. |
| `isClosed` | Receives nonzero if the figure is closed. |

**Returns** the number of points in the figure, or 0 after the last one.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
p.AddEllipse( 20, 0, 10, 10 )
dim it as CGpGraphicsPathIterator = @p
dim figure as CGpGraphicsPath
dim closed as BOOL
it.NextSubpathPath( @figure, @closed )      ' figure holds the rectangle
```

Microsoft Learn: [GraphicsPathIterator::NextSubpath](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-nextsubpath%28constgraphicspath_bool%29)

### NextPathType

```freebasic
function NextPathType( byval pathType as byte ptr, byval startIndex as INT_ ptr, byval endIndex as INT_ ptr ) as INT_
```

Reads the next run of points of one type (lines or Bézier points) **within the current figure**.
Call [NextSubpath](#nextsubpath) first: before it, and after the last run of the figure, it
returns 0.

| Parameter | Meaning |
| --- | --- |
| `pathType` | Receives the type of the run: `PathPointTypeLine` or `PathPointTypeBezier`. |
| `startIndex` | Receives the index of the run's first point. |
| `endIndex` | Receives the index of its last point. |

**Returns** the number of points in the run, or 0 when there are no more in this figure.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
dim it as CGpGraphicsPathIterator = @p
dim as INT_ first, last
dim closed as BOOL
dim kind as byte
it.NextSubpath( @first, @last, @closed )
print it.NextPathType( @kind, @first, @last ); kind   ' 4 1
```

Microsoft Learn: [GraphicsPathIterator::NextPathType](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-nextpathtype)

### NextMarker

```freebasic
function NextMarker( byval startIndex as INT_ ptr, byval endIndex as INT_ ptr ) as INT_
function NextMarker( byval pPath as CGpGraphicsPath ptr ) as INT_
```

Moves to the next section of the path that [SetMarker](#setmarker) delimits. The first form
reads the indexes of the section's first and last points; the second copies the section into
the path that `pPath` points to. A path without markers is one section.

| Parameter | Meaning |
| --- | --- |
| `startIndex` | Receives the index of the section's first point. |
| `endIndex` | Receives the index of its last point. |
| `pPath` | The path that receives the section. |

**Returns** the number of points in the section, or 0 after the last one.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 10, 0 )
p.SetMarker()
p.AddRectangle( 20, 20, 5, 5 )
dim it as CGpGraphicsPathIterator = @p
dim part as CGpGraphicsPath
print it.NextMarker( @part ); it.NextMarker( @part )  ' 2 4
```

Microsoft Learn: [GraphicsPathIterator::NextMarker](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-nextmarker%28int_int%29)

### GetCount

```freebasic
function GetCount() as INT_
```

Returns the number of points in the iterator's copy of the path.

**Returns** the count.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddEllipse( 0, 0, 50, 50 )
dim it as CGpGraphicsPathIterator = @p
print it.GetCount()                         ' 13
```

Microsoft Learn: [GraphicsPathIterator::GetCount](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-getcount)

### GetSubpathCount

```freebasic
function GetSubpathCount() as INT_
```

Returns the number of figures in the path.

**Returns** the count.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddLine( 0, 0, 10, 0 )
p.StartFigure()
p.AddLine( 20, 0, 30, 0 )
dim it as CGpGraphicsPathIterator = @p
print it.GetSubpathCount()                  ' 2
```

Microsoft Learn: [GraphicsPathIterator::GetSubpathCount](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-getsubpathcount)

### HasCurve

```freebasic
function HasCurve() as boolean
```

Tells whether any point of the path is a Bézier point. A path made only of lines, or one that
has been [flattened](#flatten), has none.

**Returns** `true` if the path holds curves.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddEllipse( 0, 0, 50, 50 )
dim it as CGpGraphicsPathIterator = @p
print it.HasCurve()                         ' true
```

Microsoft Learn: [GraphicsPathIterator::HasCurve](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-hascurve)

### Rewind

```freebasic
sub Rewind
```

Moves the iterator back before the first figure, so the `Next…` methods start again. It does
not update the stored status.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
dim it as CGpGraphicsPathIterator = @p
dim as INT_ first, last
dim closed as BOOL
it.NextSubpath( @first, @last, @closed )
it.Rewind()                                 ' the next call returns the rectangle again
```

Microsoft Learn: [GraphicsPathIterator::Rewind](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-rewind)

### Enumerate

```freebasic
function Enumerate( byval pts as GpPointF ptr, byval types as byte ptr, byval nCount as INT_ ) as INT_
```

Copies the path's points and their type bytes into two arrays, from the start of the path. At
most `nCount` points are copied; size the arrays with [GetCount](#getcount) to get them all.

| Parameter | Meaning |
| --- | --- |
| `pts` | The first element of the points array. |
| `types` | The first element of the types array. |
| `nCount` | The size of the arrays. |

**Returns** the number of points copied.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
dim it as CGpGraphicsPathIterator = @p
dim pts(0 to 3) as GpPointF
dim types(0 to 3) as byte
print it.Enumerate( @pts(0), @types(0), 4 ) ' 4
```

Microsoft Learn: [GraphicsPathIterator::Enumerate](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-enumerate)

### CopyData

```freebasic
function CopyData( byval pts as GpPointF ptr, byval types as byte ptr, byval startIndex as INT_, byval endIndex as INT_ ) as INT_
```

Copies the points from `startIndex` to `endIndex`, both included, and their type bytes into two
arrays large enough for them. The indexes typically come from [NextSubpath](#nextsubpath) or
[NextMarker](#nextmarker).

| Parameter | Meaning |
| --- | --- |
| `pts` | The first element of the points array. |
| `types` | The first element of the types array. |
| `startIndex` | The index of the first point to copy. |
| `endIndex` | The index of the last point to copy. |

**Returns** the number of points copied.

**Example**

```freebasic
dim p as CGpGraphicsPath
p.AddRectangle( 0, 0, 10, 10 )
p.AddRectangle( 20, 0, 10, 10 )
dim it as CGpGraphicsPathIterator = @p
dim pts(0 to 3) as GpPointF
dim types(0 to 3) as byte
print it.CopyData( @pts(0), @types(0), 4, 7 ); pts(0).x   ' 4 20
```

Microsoft Learn: [GraphicsPathIterator::CopyData](https://learn.microsoft.com/en-us/windows/win32/api/gdipluspath/nf-gdipluspath-graphicspathiterator-copydata)

### IsValid

```freebasic
function IsValid() as boolean
```

Tells whether the iterator holds a usable GDI+ iterator. It is `true` for an iterator made from a
real path, even an empty one.

**Returns** `true` if the iterator is valid.

**Example**

```freebasic
dim p as CGpGraphicsPath
dim it as CGpGraphicsPathIterator = @p
print it.IsValid()                          ' true
```

## See also

- [CGpGraphics](CGpGraphics) for `DrawPath`, `FillPath` and clipping to a path
- [CGpRegion](CGpRegion) for areas built from paths
- [CGpMatrix](CGpMatrix) for [TransForm](#transform), [Flatten](#flatten) and the other
  transformations
- [CGpPen](CGpPen) for [Widen](#widen) and [IsOutlineVisible](#isoutlinevisible)
- [Brushes](SysWin-GdiPlus-Brushes) for the path gradient brush made from a path
- [sys/win/gdiplus](SysWin-GdiPlus)
