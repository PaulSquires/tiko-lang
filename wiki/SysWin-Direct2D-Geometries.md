[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **Direct2D geometries**

# Direct2D geometries
Builds Direct2D shapes from rectangles, ellipses, lines, curves and arcs.

<!-- scope: CID2D1RectangleGeometry -->
<!-- scope: CID2D1RoundedRectangleGeometry -->
<!-- scope: CID2D1EllipseGeometry -->
<!-- scope: CID2D1PathGeometry -->
<!-- scope: CID2D1PathGeometry1 -->
<!-- scope: CID2D1TransformedGeometry -->
<!-- scope: CID2D1GeometryGroup -->
<!-- scope: CID2D1GeometrySink -->
<!-- scope: CID2D1SimplifiedGeometrySink -->

Builds Direct2D shapes from rectangles, ellipses, lines, curves and arcs.

A geometry is a shape that Direct2D can fill, outline, measure and hit-test. It is made by a
[CD2D1Factory](CD2D1Factory), belongs to that factory rather than to a render target, and can be
drawn on any render target the factory made with `FillGeometry` and `DrawGeometry` of
[CID2D1RenderTarget](CID2D1RenderTarget). Each kind has a class here, and every one of them
extends [CID2D1Geometry](CID2D1Geometry), so all of them can be measured, hit-tested, combined
and outlined:

| Class | Holds | Made by |
| --- | --- | --- |
| [CID2D1RectangleGeometry](#cid2d1rectanglegeometry) | a rectangle | `factory.CreateRectangleGeometry` |
| [CID2D1RoundedRectangleGeometry](#cid2d1roundedrectanglegeometry) | a rectangle with rounded corners | `factory.CreateRoundedRectangleGeometry` |
| [CID2D1EllipseGeometry](#cid2d1ellipsegeometry) | an ellipse or a circle | `factory.CreateEllipseGeometry` |
| [CID2D1PathGeometry](#cid2d1pathgeometry) | figures of lines, Béziers and arcs, built through a sink | `factory.CreatePathGeometry` |
| [CID2D1PathGeometry1](#cid2d1pathgeometry1) | a path that can also tell which segment a point is on | `CreatePathGeometry1` of `CD2D1Factory1` |
| [CID2D1TransformedGeometry](#cid2d1transformedgeometry) | another geometry, moved, scaled, turned or skewed | `factory.CreateTransformedGeometry` |
| [CID2D1GeometryGroup](#cid2d1geometrygroup) | several geometries treated as one | `factory.CreateGeometryGroup` |

Rectangles, ellipses, transformed geometries and groups are fixed once made. A path starts empty
and is filled in once: [Open](#open) hands out a [CID2D1GeometrySink](#cid2d1geometrysink), you
describe the figures through it, and [Close](#close) seals the path. The sink classes,
[CID2D1GeometrySink](#cid2d1geometrysink) and its base
[CID2D1SimplifiedGeometrySink](#cid2d1simplifiedgeometrysink), are also what the reshaping
members of `CID2D1Geometry` (`Simplify`, `Outline`, `Widen`, `CombineWithGeometry`) write into.

**A figure** begins with `BeginFigure` at a start point; each `AddLine`, `AddBezier` or `AddArc`
then draws a segment from where the last one ended; `EndFigure` finishes it, open or closed. A
closed figure gets a straight segment back to its start. A sink can describe any number of
figures before `Close`.

**Lifetime.** Every class here takes over the reference it is given and releases it when the
object is destroyed, exactly as `CID2D1Geometry` does: hand a `Create…` result straight to the
constructor and do not release it yourself. Internally the derived constructor adds a reference
because both its own destructor and the `CID2D1Geometry` destructor release the interface.
[CID2D1PathGeometry1](#cid2d1pathgeometry1) is the exception: it releases one reference more than
it adopts. Never copy one of these objects by value (`dim b as CID2D1PathGeometry = a`, or a
`byval` parameter); use a pointer or `dim byref`.

**Passing them on.** Each class has its own `cast`, `@` and `*` for its own interface type. To
pass an object where Direct2D wants an `ID2D1Geometry ptr` or an `ID2D1SimplifiedGeometrySink
ptr`, write `*shape` or `*sink`: the pointer that gives converts to the base interface by itself.
The `CID2D1Geometry` pointer of any of them is also in the public field `m_pGeometry`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A window that builds a five-pointed star as a path, fills and outlines it, and draws a smaller
copy of it through a transformed geometry. The geometries are made once, before the window opens;
the render target is made on each `WM_PAINT`:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/direct2d"
using win, gui, direct2d

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

dim shared pFactory as CD2D1Factory ptr
dim shared pStar as CID2D1PathGeometry ptr
dim shared pSmallStar as CID2D1TransformedGeometry ptr

' A five-pointed star centred on (110, 110): ten corners, alternately 90 and 36 DIPs out.
sub BuildStar()
    pStar = new CID2D1PathGeometry( pFactory->CreatePathGeometry() )
    dim sink as CID2D1GeometrySink = pStar->Open()
    for i as long = 0 to 9
        dim r as single = iif( i mod 2 = 0, 90, 36 )
        dim a as single = -1.5707963 + i * 0.6283185
        dim x as single = 110 + r * cos( a ), y as single = 110 + r * sin( a )
        if i = 0 then sink.BeginFigure( x, y, D2D1_FIGURE_BEGIN_FILLED ) else sink.AddLine( x, y )
    next
    sink.EndFigure( D2D1_FIGURE_END_CLOSED )
    sink.Close()
    ' a copy at 40 %, moved to the right
    dim m as D2D1_MATRIX_3X2_F = D2D1_MatrixScale( D2D1_SizeF( 0.4, 0.4 ) )
    m.m31 = 220 : m.m32 = 40
    pSmallStar = new CID2D1TransformedGeometry( pFactory->CreateTransformedGeometry( **pStar, m ) )
end sub

sub Render( byval hwnd as HWND )
    var (l, t, r, b) = GetWindowClientRect( hwnd )
    dim rt as CID2D1HwndRenderTarget = pFactory->CreateHwndRenderTarget( D2D1_RenderTargetProperties(), _
                                       D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( r, b ) ) )
    dim gold as D2D1_COLOR_F = D2D1_ColorF( D2D1_Gold )
    dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
    dim fill as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @gold )
    dim pen as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
    rt.BeginDraw()
    rt.Clear( D2D1_White )
    rt.FillGeometry( **pStar, fill )
    rt.DrawGeometry( **pStar, pen, 3 )
    rt.FillGeometry( **pSmallStar, pen )
    rt.EndDraw()
end sub

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    pFactory = new CD2D1Factory( D2D1_FACTORY_TYPE_SINGLE_THREADED )
    BuildStar()

    dim pWindow as CWindow = "D2DGeometries"
    pWindow.Create( NULL, "Direct2D geometries", @WndProc )
    pWindow.SetClientSize( 320, 220 )
    pWindow.Center()
    dim nResult as long = pWindow.DoEvents( SW_NORMAL )

    delete pSmallStar
    delete pStar
    delete pFactory
    return nResult
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_PAINT
            dim ps as PAINTSTRUCT
            BeginPaint( hwnd, @ps )
            Render( hwnd )
            EndPaint( hwnd, @ps )
            return 0
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

`pStar` points to a wrapper object, so `*pStar` is the object and `**pStar` its interface
pointer. The sink is a local object in `BuildStar`: it is released when the sub returns, after
`Close` has sealed the path. The transformed geometry keeps its own reference to the star.

## Members

| Member | Does |
| --- | --- |
| **CID2D1RectangleGeometry** | |
| [Constructor](#constructor) | Makes an empty object, or one that takes over a rectangle geometry. |
| [Destructor](#destructor) | Releases the rectangle. |
| [Cast, Operator @, Operator *](#cast-operator--operator-) | Give the interface pointer or its address. |
| [GetRect](#getrect) | Reads the rectangle. |
| **CID2D1RoundedRectangleGeometry** | |
| [Constructor](#constructor-1) | Makes an empty object, or one that takes over a rounded rectangle geometry. |
| [Destructor](#destructor-1) | Releases the rounded rectangle. |
| [Cast, Operator @, Operator *](#cast-operator--operator--1) | Give the interface pointer or its address. |
| [GetRoundedRect](#getroundedrect) | Reads the rectangle and the corner radii. |
| **CID2D1EllipseGeometry** | |
| [Constructor](#constructor-2) | Makes an empty object, or one that takes over an ellipse geometry. |
| [Destructor](#destructor-2) | Releases the ellipse. |
| [Cast, Operator @, Operator *](#cast-operator--operator--2) | Give the interface pointer or its address. |
| [GetEllipse](#getellipse) | Reads the centre and the radii. |
| **CID2D1PathGeometry** | |
| [Constructor](#constructor-3) | Makes an empty object, or one that takes over a path geometry. |
| [Destructor](#destructor-3) | Releases the path. |
| [Cast, Operator @, Operator *](#cast-operator--operator--3) | Give the interface pointer, as a path or a geometry, or its address. |
| [Open](#open) | Hands out the sink that fills the path. |
| [Stream](#stream) | Is meant to copy the path into another sink. |
| [GetSegmentCount](#getsegmentcount) | Counts the segments. |
| [GetFigureCount](#getfigurecount) | Counts the figures. |
| **CID2D1PathGeometry1** | |
| [Constructor](#constructor-4) | Makes an empty object, or one that wraps an `ID2D1PathGeometry1`. |
| [Destructor](#destructor-4) | Releases the path, three times. |
| [Cast, Operator @, Operator *](#cast-operator--operator--4) | Give the interface pointer or its address. |
| [ComputePointAndSegmentAtLength](#computepointandsegmentatlength) | Finds the point at a distance along the path and the segment it is on. |
| **CID2D1TransformedGeometry** | |
| [Constructor](#constructor-5) | Makes an empty object, or one that takes over a transformed geometry. |
| [Destructor](#destructor-5) | Releases the transformed geometry. |
| [Cast, Operator @, Operator *](#cast-operator--operator--5) | Give the interface pointer or its address. |
| [GetSourceGeometry](#getsourcegeometry) | Returns the geometry it was made from. |
| [GetTransform](#gettransform) | Reads the matrix. |
| **CID2D1GeometryGroup** | |
| [Constructor](#constructor-6) | Makes an empty object, or one that takes over a geometry group. |
| [Destructor](#destructor-6) | Releases the group. |
| [Cast, Operator @, Operator *](#cast-operator--operator--6) | Give the interface pointer or its address. |
| [GetFillMode](#getfillmode) | Tells how overlapping members are filled. |
| [GetSourceGeometryCount](#getsourcegeometrycount) | Counts the geometries in the group. |
| [GetSourceGeometries](#getsourcegeometries) | Fills an array with the geometries in the group. |
| **CID2D1GeometrySink** | |
| [Constructor](#constructor-7) | Makes an empty object, or one that takes over a geometry sink. |
| [Destructor](#destructor-7) | Releases the sink. |
| [Cast, Operator @, Operator *](#cast-operator--operator--7) | Give the interface pointer or its address. |
| [AddLine](#addline) | Adds a straight segment. |
| [AddBezier](#addbezier) | Adds a cubic Bézier curve. |
| [AddQuadraticBezier](#addquadraticbezier) | Adds a quadratic Bézier curve. |
| [AddQuadraticBeziers](#addquadraticbeziers) | Adds several quadratic Bézier curves. |
| [AddArc](#addarc) | Adds an elliptical arc. |
| **CID2D1SimplifiedGeometrySink** | |
| [Constructor](#constructor-8) | Makes an empty object, or one that takes over a simplified geometry sink. |
| [Destructor](#destructor-8) | Releases the sink. |
| [Cast, Operator @, Operator *](#cast-operator--operator--8) | Give the interface pointer or its address. |
| [SetFillMode](#setfillmode) | Sets how overlapping figures are filled. |
| [SetSegmentFlags](#setsegmentflags) | Sets whether the next segments are stroked, and how they join. |
| [BeginFigure](#beginfigure) | Starts a figure at a point. |
| [AddLines](#addlines) | Adds straight segments through an array of points. |
| [AddBeziers](#addbeziers) | Adds several cubic Bézier curves. |
| [EndFigure](#endfigure) | Ends the figure, open or closed. |
| [Close](#close) | Finishes the sink and seals the path. |

## Reference

## CID2D1RectangleGeometry

An axis-aligned rectangle, made with `CreateRectangleGeometry` of [CD2D1Factory](CD2D1Factory)
from a `D2D1_RECT_F` (`D2D1_RectF( left, top, right, bottom )`). To draw a rectangle once,
`FillRectangle` of the render target is simpler; a geometry is for a rectangle you also want to
measure, hit-test, combine or keep.

### Constructor

```freebasic
constructor
constructor( byval pRectangleGeometry as ID2D1RectangleGeometry ptr )
```

The first form makes an object that holds no geometry. The second takes over
`pRectangleGeometry` and also stores it as the object's `ID2D1Geometry`, so every
[CID2D1Geometry](CID2D1Geometry) member works on it.

| Parameter | Meaning |
| --- | --- |
| `pRectangleGeometry` | The rectangle to wrap, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim box as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) )
print box.ComputeArea( D2D1_IdentityMatrix() )      ' 5000
```

Microsoft Learn: [ID2D1RectangleGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1rectanglegeometry)

### Destructor

```freebasic
destructor
```

Releases the rectangle, if the object holds one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pBox as CID2D1RectangleGeometry ptr = new CID2D1RectangleGeometry( factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) ) )
delete pBox   ' releases the rectangle
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1RectangleGeometry ptr
operator @() as ID2D1RectangleGeometry ptr ptr
operator *( byref geometry as CID2D1RectangleGeometry ) as ID2D1RectangleGeometry ptr
```

`cast` and `*` return the wrapped `ID2D1RectangleGeometry` pointer; it still belongs to the
object. `@` returns the address of the stored pointer, `m_pRectangleGeometry`. A pointer written
through it is not copied to `m_pGeometry`, so the `CID2D1Geometry` members of that object then
return `E_POINTER`; prefer the constructor.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim box as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) )
dim pGeo as ID2D1Geometry ptr = *box
print "same object:"; pGeo = box.m_pGeometry
```

### GetRect

```freebasic
sub GetRect( byref rc as D2D1_RECT_F )
sub GetRect( byval rc as D2D1_RECT_F ptr )
function GetRect() as D2D1_RECT_F
```

Reads the rectangle the geometry was made from. On an object that holds no rectangle it leaves
`rc` as it was, or returns an all-zero rectangle, and sets `GetLastError()` to `E_POINTER`.

| Parameter | Meaning |
| --- | --- |
| `rc` | Receives the rectangle. |

**Returns** the rectangle (the function form).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim box as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) )
dim rc as D2D1_RECT_F = box.GetRect()
print rc.left; rc.top; rc.right; rc.bottom      ' 0 0 100 50
```

Microsoft Learn: [ID2D1RectangleGeometry::GetRect](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rectanglegeometry-getrect)

## CID2D1RoundedRectangleGeometry

A rectangle whose corners are quarter ellipses, made with `CreateRoundedRectangleGeometry` of
[CD2D1Factory](CD2D1Factory) from a `D2D1_ROUNDED_RECT`
(`D2D1_RoundedRect( left, top, right, bottom, radiusX, radiusY )`).

### Constructor

```freebasic
constructor
constructor( byval pRectangleGeometry as ID2D1RoundedRectangleGeometry ptr )
```

The first form makes an object that holds no geometry. The second takes over the pointer and
also stores it as the object's `ID2D1Geometry`.

| Parameter | Meaning |
| --- | --- |
| `pRectangleGeometry` | The rounded rectangle to wrap, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim card as CID2D1RoundedRectangleGeometry = factory.CreateRoundedRectangleGeometry( D2D1_RoundedRect( 0, 0, 100, 50, 10, 10 ) )
print card.ComputeArea( D2D1_IdentityMatrix() )      ' 4909.39
```

Microsoft Learn: [ID2D1RoundedRectangleGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1roundedrectanglegeometry)

### Destructor

```freebasic
destructor
```

Releases the rounded rectangle, if the object holds one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pCard as CID2D1RoundedRectangleGeometry ptr = new CID2D1RoundedRectangleGeometry( factory.CreateRoundedRectangleGeometry( D2D1_RoundedRect( 0, 0, 100, 50, 10, 10 ) ) )
delete pCard
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1RoundedRectangleGeometry ptr
operator @() as ID2D1RoundedRectangleGeometry ptr ptr
operator *( byref geometry as CID2D1RoundedRectangleGeometry ) as ID2D1RoundedRectangleGeometry ptr
```

`cast` and `*` return the wrapped `ID2D1RoundedRectangleGeometry` pointer; `@` the address of
`m_pRoundedRectangleGeometry`, with the same limit as for
[CID2D1RectangleGeometry](#cast-operator--operator-).

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim card as CID2D1RoundedRectangleGeometry = factory.CreateRoundedRectangleGeometry( D2D1_RoundedRect( 0, 0, 100, 50, 10, 10 ) )
dim pRound as ID2D1RoundedRectangleGeometry ptr = card
print "same object:"; pRound = *card
```

### GetRoundedRect

```freebasic
sub GetRoundedRect( byref roundedRect as D2D1_ROUNDED_RECT )
sub GetRoundedRect( byval roundedRect as D2D1_ROUNDED_RECT ptr )
function GetRoundedRect() as D2D1_ROUNDED_RECT
```

Reads the rectangle and corner radii the geometry was made from. On an object that holds no
geometry it sets `GetLastError()` to `E_POINTER`.

| Parameter | Meaning |
| --- | --- |
| `roundedRect` | Receives the rectangle (`.rect`) and the radii (`.radiusX`, `.radiusY`). |

**Returns** the rounded rectangle (the function form).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim card as CID2D1RoundedRectangleGeometry = factory.CreateRoundedRectangleGeometry( D2D1_RoundedRect( 0, 0, 100, 50, 10, 10 ) )
dim rr as D2D1_ROUNDED_RECT = card.GetRoundedRect()
print rr.rect.right; rr.rect.bottom; rr.radiusX; rr.radiusY      ' 100 50 10 10
```

Microsoft Learn: [ID2D1RoundedRectangleGeometry::GetRoundedRect](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1roundedrectanglegeometry-getroundedrect)

## CID2D1EllipseGeometry

An ellipse, made with `CreateEllipseGeometry` of [CD2D1Factory](CD2D1Factory) from a
`D2D1_ELLIPSE`: a centre and two radii (`D2D1_EllipseF( x, y, radiusX, radiusY )`). Equal radii
give a circle.

### Constructor

```freebasic
constructor
constructor( byval pEllipseGeometry as ID2D1EllipseGeometry ptr )
```

The first form makes an object that holds no geometry. The second takes over the pointer and
also stores it as the object's `ID2D1Geometry`; given `NULL`, it sets `GetLastError()` to
`E_POINTER`.

| Parameter | Meaning |
| --- | --- |
| `pEllipseGeometry` | The ellipse to wrap, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim disc as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
print disc.FillContainsPoint( D2D1_Point2F( 50, 50 ), D2D1_IdentityMatrix() )      ' true
```

Microsoft Learn: [ID2D1EllipseGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1ellipsegeometry)

### Destructor

```freebasic
destructor
```

Releases the ellipse, if the object holds one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pDisc as CID2D1EllipseGeometry ptr = new CID2D1EllipseGeometry( factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) ) )
delete pDisc
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1EllipseGeometry ptr
operator @() as ID2D1EllipseGeometry ptr ptr
operator *( byref geometry as CID2D1EllipseGeometry ) as ID2D1EllipseGeometry ptr
```

`cast` and `*` return the wrapped `ID2D1EllipseGeometry` pointer; `@` the address of
`m_pEllipseGeometry`, with the same limit as for
[CID2D1RectangleGeometry](#cast-operator--operator-).

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim disc as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
dim pEllipse as ID2D1EllipseGeometry ptr = disc
print "same object:"; pEllipse = *disc
```

### GetEllipse

```freebasic
sub GetEllipse( byref tEllipse as D2D1_ELLIPSE )
sub GetEllipse( byval tEllipse as D2D1_ELLIPSE ptr )
function GetEllipse() as D2D1_ELLIPSE
```

Reads the centre and radii the geometry was made from. On an object that holds no ellipse it
sets `GetLastError()` to `E_POINTER`.

| Parameter | Meaning |
| --- | --- |
| `tEllipse` | Receives the centre (`.point`) and the radii (`.radiusX`, `.radiusY`). |

**Returns** the ellipse (the function form).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim disc as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 100, 100, 50, 30 ) )
dim e as D2D1_ELLIPSE = disc.GetEllipse()
print e.point.x; e.point.y; e.radiusX; e.radiusY      ' 100 100 50 30
```

Microsoft Learn: [ID2D1EllipseGeometry::GetEllipse](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1ellipsegeometry-getellipse)

## CID2D1PathGeometry

A shape of any number of figures, each a run of straight lines, cubic and quadratic Béziers and
elliptical arcs, made with `CreatePathGeometry` of [CD2D1Factory](CD2D1Factory). A new path is
empty. [Open](#open) it once, describe the figures through the sink, and [Close](#close) the
sink: from then on the path is fixed and can be drawn and measured. A second `Open` fails.

### Constructor

```freebasic
constructor
constructor( byval pPathGeometry as ID2D1PathGeometry ptr )
```

The first form makes an object that holds no path. The second takes over the pointer and also
stores it as the object's `ID2D1Geometry`; given `NULL`, it sets `GetLastError()` to
`E_POINTER`.

| Parameter | Meaning |
| --- | --- |
| `pPathGeometry` | The path to wrap, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim tri as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = tri.Open()
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_FILLED )
sink.AddLine( 100, 0 ) : sink.AddLine( 50, 80 )
sink.EndFigure( D2D1_FIGURE_END_CLOSED ) : sink.Close()
print tri.ComputeArea( D2D1_IdentityMatrix() )      ' 4000
```

Microsoft Learn: [ID2D1PathGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1pathgeometry)

### Destructor

```freebasic
destructor
```

Releases the path, if the object holds one. A sink still open on it keeps the path alive until
the sink is released too.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pPath as CID2D1PathGeometry ptr = new CID2D1PathGeometry( factory.CreatePathGeometry() )
delete pPath
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1PathGeometry ptr
operator cast() as ID2D1Geometry ptr
operator @() as ID2D1PathGeometry ptr ptr
operator *( byref geometry as CID2D1PathGeometry ) as ID2D1PathGeometry ptr
```

The two `cast`s return the wrapped path as an `ID2D1PathGeometry ptr` or as an
`ID2D1Geometry ptr`; `*` returns the `ID2D1PathGeometry ptr`. The pointer still belongs to the
object. `@` returns the address of `m_pPathGeometry`, with the same limit as for
[CID2D1RectangleGeometry](#cast-operator--operator-).

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim pPath as ID2D1PathGeometry ptr = *path
print "same object:"; cast( ID2D1Geometry ptr, pPath ) = path.m_pGeometry
```

### Open

```freebasic
function Open( byref geometrySink as ID2D1GeometrySink ptr ) as HRESULT
function Open() as ID2D1GeometrySink ptr
```

Hands out the sink that fills the path. The sink comes with a reference of its own: put it in a
[CID2D1GeometrySink](#cid2d1geometrysink) object, which releases it, or release it yourself once
it is closed. A path can be opened once; a second call fails with `D2DERR_WRONG_STATE`
(`&h88990001`) and gives no sink.

| Parameter | Meaning |
| --- | --- |
| `geometrySink` | Receives the sink. |

**Returns** `S_OK` or the failing `HRESULT`, or the sink (`NULL` on failure, with the
`HRESULT` in `GetLastError()`).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.BeginFigure( 10, 10, D2D1_FIGURE_BEGIN_HOLLOW )
sink.AddLine( 200, 10 )
sink.EndFigure( D2D1_FIGURE_END_OPEN )
sink.Close()
```

Microsoft Learn: [ID2D1PathGeometry::Open](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1pathgeometry-open)

### Stream

```freebasic
function Stream( byval geometrySink as ID2D1GeometrySink ptr ) as HRESULT
```

Meant to copy the figures of a closed path into another sink. The interface declaration it calls
passes the address of the `geometrySink` argument rather than the sink itself, and Direct2D ends
the program with an access violation. To copy a path, simplify it into the new path's sink with
`D2D1_GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES` instead: lines and cubic Béziers come out
as they are, quadratic Béziers and arcs as cubic Béziers.

| Parameter | Meaning |
| --- | --- |
| `geometrySink` | The sink to copy into. |

**Returns** the `HRESULT` of the call, when it returns.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim src as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
dim copy as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = copy.Open()
src.Simplify( D2D1_GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES, D2D1_IdentityMatrix(), *sink )   ' not Stream
sink.Close()
```

Microsoft Learn: [ID2D1PathGeometry::Stream](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1pathgeometry-stream)

### GetSegmentCount

```freebasic
function GetSegmentCount() as UINT32
```

Counts the segments of every figure in the path, the closing segment of a closed figure
included. The path must be closed; the `HRESULT` is in `GetLastError()`.

**Returns** the number of segments, or 0.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim tri as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = tri.Open()
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_FILLED )
sink.AddLine( 100, 0 ) : sink.AddLine( 50, 80 )
sink.EndFigure( D2D1_FIGURE_END_CLOSED ) : sink.Close()
print tri.GetSegmentCount()      ' 3
```

Microsoft Learn: [ID2D1PathGeometry::GetSegmentCount](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1pathgeometry-getsegmentcount)

### GetFigureCount

```freebasic
function GetFigureCount() as UINT32
```

Counts the figures in the path, one per `BeginFigure`. The path must be closed; the `HRESULT` is
in `GetLastError()`.

**Returns** the number of figures, or 0.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim marks as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = marks.Open()
for i as long = 0 to 2
    sink.BeginFigure( i * 20, 0, D2D1_FIGURE_BEGIN_HOLLOW ) : sink.AddLine( i * 20, 10 ) : sink.EndFigure( D2D1_FIGURE_END_OPEN )
next
sink.Close()
print marks.GetFigureCount()      ' 3
```

Microsoft Learn: [ID2D1PathGeometry::GetFigureCount](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1pathgeometry-getfigurecount)

## CID2D1PathGeometry1

A path that can also report which segment a point at a given distance lies on. It is made with
`CreatePathGeometry1` of `CD2D1Factory1` (see [CD2D1Factory](CD2D1Factory)), extends
[CID2D1PathGeometry](#cid2d1pathgeometry), and is built and measured the same way.

### Constructor

```freebasic
constructor
constructor( byval pPathGeometry1 as ID2D1PathGeometry1 ptr )
```

The first form makes an object that holds no path. The second adds one reference to
`pPathGeometry1` and stores it as the object's `ID2D1PathGeometry1`, `ID2D1PathGeometry` and
`ID2D1Geometry`. When the object is destroyed, its own destructor and those of
`CID2D1PathGeometry` and `CID2D1Geometry` each release the interface: three releases against the
one reference added. Add a reference of your own before you hand over a fresh pointer, as below,
so the count comes out even.

| Parameter | Meaning |
| --- | --- |
| `pPathGeometry1` | The path to wrap. |

**Example**

```freebasic
dim factory1 as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pPath1 as ID2D1PathGeometry1 ptr = factory1.CreatePathGeometry1()
pPath1->AddRef()      ' the object releases two references
dim path1 as CID2D1PathGeometry1 = pPath1
print "wrapped:"; path1.m_pPathGeometry1 <> NULL
```

Microsoft Learn: [ID2D1PathGeometry1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1pathgeometry1)

### Destructor

```freebasic
destructor
```

Releases the interface, and the `CID2D1PathGeometry` and `CID2D1Geometry` destructors that run
after it release it twice more; see the [constructor](#constructor-4).

**Example**

```freebasic
dim factory1 as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pPath1 as ID2D1PathGeometry1 ptr = factory1.CreatePathGeometry1()
pPath1->AddRef()
dim pObj as CID2D1PathGeometry1 ptr = new CID2D1PathGeometry1( pPath1 )
delete pObj   ' the path is gone now
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1PathGeometry1 ptr
operator @() as ID2D1PathGeometry1 ptr ptr
operator *( byref geometry as CID2D1PathGeometry1 ) as ID2D1PathGeometry1 ptr
```

`cast` and `*` return the wrapped `ID2D1PathGeometry1` pointer; `@` the address of
`m_pPathGeometry1`, which is not copied to `m_pPathGeometry` or `m_pGeometry`.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory1 as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pPath1 as ID2D1PathGeometry1 ptr = factory1.CreatePathGeometry1()
pPath1->AddRef()
dim path1 as CID2D1PathGeometry1 = pPath1
print "same object:"; *path1 = pPath1
```

### ComputePointAndSegmentAtLength

```freebasic
function ComputePointAndSegmentAtLength( byval length as FLOAT, byval startSegment as UINT32, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byref pointDescription as D2D1_POINT_DESCRIPTION ) as HRESULT
function ComputePointAndSegmentAtLength( byval length as FLOAT, byval startSegment as UINT32, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval pointDescription as D2D1_POINT_DESCRIPTION ptr ) as HRESULT
function ComputePointAndSegmentAtLength( byval length as FLOAT, byval startSegment as UINT32, byref worldTransform as const D2D1_MATRIX_3X2_F, byref pointDescription as D2D1_POINT_DESCRIPTION ) as HRESULT
function ComputePointAndSegmentAtLength( byval length as FLOAT, byval startSegment as UINT32, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval pointDescription as D2D1_POINT_DESCRIPTION ptr ) as HRESULT
```

Walks `length` DIPs along the transformed path, starting at segment `startSegment`, like
`ComputePointAtLength` of [CID2D1Geometry](CID2D1Geometry), and also says where the point is in
the path. The `D2D1_POINT_DESCRIPTION` it fills holds:

| Field | Meaning |
| --- | --- |
| `point` | The point reached. |
| `unitTangentVector` | The direction of travel there, a vector of length 1. |
| `endSegment` | The index of the segment the point is on, counted from 0 across the whole path. |
| `endFigure` | The index of the figure the point is on. |
| `lengthToEndSegment` | The distance walked before that segment began. |

| Parameter | Meaning |
| --- | --- |
| `length` | The distance to walk. |
| `startSegment` | The segment to start from; 0 for the start of the path. |
| `worldTransform` | The transform applied to the path first. |
| `flatteningTolerance` | How closely curves are followed; the forms without it use 0.25. |
| `pointDescription` | Receives the result. |

**Returns** `S_OK` or the failing `HRESULT`.

**Example**

```freebasic
dim factory1 as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pPath1 as ID2D1PathGeometry1 ptr = factory1.CreatePathGeometry1()
pPath1->AddRef()
dim path1 as CID2D1PathGeometry1 = pPath1
dim sink as CID2D1GeometrySink = path1.Open()
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_HOLLOW ) : sink.AddLine( 100, 0 ) : sink.AddLine( 100, 100 )
sink.EndFigure( D2D1_FIGURE_END_OPEN ) : sink.Close()
dim pd as D2D1_POINT_DESCRIPTION
path1.ComputePointAndSegmentAtLength( 150, 0, D2D1_IdentityMatrix(), pd )
print pd.point.x; pd.point.y; " segment"; pd.endSegment; " after"; pd.lengthToEndSegment      ' 100 50 segment 1 after 100
```

Microsoft Learn: [ID2D1PathGeometry1::ComputePointAndSegmentAtLength](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1pathgeometry1-computepointandsegmentatlength%28float_uint32_constd2d1_matrix_3x2_f_float_d2d1_point_description%29)

## CID2D1TransformedGeometry

Another geometry seen through a transform: moved, scaled, rotated or skewed. Make it with
`CreateTransformedGeometry` of [CD2D1Factory](CD2D1Factory) from the source geometry and a
`D2D1_MATRIX_3X2_F` (`D2D1_MatrixScale`, `D2D1_MatrixRotation`, `D2D1_MatrixTranslation` …). It
keeps a reference to the source, which can be released or go out of scope. Drawn with
`DrawGeometry`, its outline keeps the width of the pen; a transform set on the render target would
scale the pen too.

### Constructor

```freebasic
constructor
constructor( byval pTransformedGeometry as ID2D1TransformedGeometry ptr )
```

The first form makes an object that holds no geometry. The second takes over the pointer and
also stores it as the object's `ID2D1Geometry`.

| Parameter | Meaning |
| --- | --- |
| `pTransformedGeometry` | The transformed geometry to wrap, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim tall as CID2D1TransformedGeometry = factory.CreateTransformedGeometry( *square, D2D1_MatrixScale( D2D1_SizeF( 2, 3 ) ) )
print tall.ComputeArea( D2D1_IdentityMatrix() )      ' 60000
```

Microsoft Learn: [ID2D1TransformedGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1transformedgeometry)

### Destructor

```freebasic
destructor
```

Releases the transformed geometry, if the object holds one; it releases its source when it goes.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim pMoved as CID2D1TransformedGeometry ptr = new CID2D1TransformedGeometry( factory.CreateTransformedGeometry( *square, D2D1_MatrixTranslation( 50, 0 ) ) )
delete pMoved
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1TransformedGeometry ptr
operator @() as ID2D1TransformedGeometry ptr ptr
operator *( byref geometry as CID2D1TransformedGeometry ) as ID2D1TransformedGeometry ptr
```

`cast` and `*` return the wrapped `ID2D1TransformedGeometry` pointer; `@` the address of
`m_pTransformedGeometry`, with the same limit as for
[CID2D1RectangleGeometry](#cast-operator--operator-).

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim moved as CID2D1TransformedGeometry = factory.CreateTransformedGeometry( *square, D2D1_MatrixTranslation( 50, 0 ) )
dim pMoved as ID2D1TransformedGeometry ptr = moved
print "same object:"; pMoved = *moved
```

### GetSourceGeometry

```freebasic
sub GetSourceGeometry( byref sourceGeometry as ID2D1Geometry ptr )
sub GetSourceGeometry( byval sourceGeometry as ID2D1Geometry ptr ptr )
function GetSourceGeometry() as ID2D1Geometry ptr
```

Returns the geometry this one was made from, untransformed, with a reference added for you:
release it when done. On an object that holds no geometry it returns `NULL` and leaves
`sourceGeometry` as it was.

| Parameter | Meaning |
| --- | --- |
| `sourceGeometry` | Receives the source geometry. |

**Returns** the source geometry (the function form).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim moved as CID2D1TransformedGeometry = factory.CreateTransformedGeometry( *square, D2D1_MatrixTranslation( 50, 0 ) )
dim pSource as ID2D1Geometry ptr = moved.GetSourceGeometry()
print "the square:"; pSource = square.m_pGeometry
pSource->Release()
```

Microsoft Learn: [ID2D1TransformedGeometry::GetSourceGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1transformedgeometry-getsourcegeometry)

### GetTransform

```freebasic
sub GetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub GetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
function GetTransform() as D2D1_MATRIX_3X2_F
```

Reads the matrix the geometry was made with. On an object that holds no geometry it returns an
all-zero matrix and leaves `transform` as it was.

| Parameter | Meaning |
| --- | --- |
| `transform` | Receives the matrix. |

**Returns** the matrix (the function form).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim tall as CID2D1TransformedGeometry = factory.CreateTransformedGeometry( *square, D2D1_MatrixScale( D2D1_SizeF( 2, 3 ) ) )
dim m as D2D1_MATRIX_3X2_F = tall.GetTransform()
print m.m11; m.m22      ' 2 3
```

Microsoft Learn: [ID2D1TransformedGeometry::GetTransform](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1transformedgeometry-gettransform)

## CID2D1GeometryGroup

Several geometries held together and filled, outlined and measured as one. Make it with
`CreateGeometryGroup` of [CD2D1Factory](CD2D1Factory), which takes a fill mode and an array of
`ID2D1Geometry` pointers. That method declares the array parameter as `ID2D1Geometry ptr`, so
pass the address of the first element through `any ptr`, as the examples do. The group keeps a
reference to each member. Where members overlap, the fill mode decides:
`D2D1_FILL_MODE_ALTERNATE` (0) leaves areas covered an even number of times empty,
`D2D1_FILL_MODE_WINDING` (1) fills them.

### Constructor

```freebasic
constructor
constructor( byval pEllipseGeometry as ID2D1GeometryGroup ptr )
```

The first form makes an object that holds no group. The second takes over the pointer and also
stores it as the object's `ID2D1Geometry`.

| Parameter | Meaning |
| --- | --- |
| `pEllipseGeometry` | The group to wrap, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim disc as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 100, 100, 50, 50 ) )
dim parts(1) as ID2D1Geometry ptr = { *square, *disc }
dim group as CID2D1GeometryGroup = factory.CreateGeometryGroup( D2D1_FILL_MODE_ALTERNATE, cast( ID2D1Geometry ptr, cast( any ptr, @parts(0) ) ), 2 )
print group.ComputeArea( D2D1_IdentityMatrix() )      ' 13917.37
```

Microsoft Learn: [ID2D1GeometryGroup](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1geometrygroup)

### Destructor

```freebasic
destructor
```

Releases the group, if the object holds one; the group releases its members when it goes.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim parts(0) as ID2D1Geometry ptr = { *square }
dim pGroup as CID2D1GeometryGroup ptr = new CID2D1GeometryGroup( factory.CreateGeometryGroup( D2D1_FILL_MODE_WINDING, cast( ID2D1Geometry ptr, cast( any ptr, @parts(0) ) ), 1 ) )
delete pGroup
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1GeometryGroup ptr
operator @() as ID2D1GeometryGroup ptr ptr
operator *( byref geometry as CID2D1GeometryGroup ) as ID2D1GeometryGroup ptr
```

`cast` and `*` return the wrapped `ID2D1GeometryGroup` pointer; `@` the address of
`m_pGeometryGroup`, with the same limit as for
[CID2D1RectangleGeometry](#cast-operator--operator-).

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim parts(0) as ID2D1Geometry ptr = { *square }
dim group as CID2D1GeometryGroup = factory.CreateGeometryGroup( D2D1_FILL_MODE_WINDING, cast( ID2D1Geometry ptr, cast( any ptr, @parts(0) ) ), 1 )
dim pGroup as ID2D1GeometryGroup ptr = group
print "same object:"; pGroup = *group
```

### GetFillMode

```freebasic
function GetFillMode() as D2D1_FILL_MODE
```

Tells how overlapping members are filled.

**Returns** `D2D1_FILL_MODE_ALTERNATE` (0) or `D2D1_FILL_MODE_WINDING` (1); 0 on an object that
holds no group.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim parts(0) as ID2D1Geometry ptr = { *square }
dim group as CID2D1GeometryGroup = factory.CreateGeometryGroup( D2D1_FILL_MODE_WINDING, cast( ID2D1Geometry ptr, cast( any ptr, @parts(0) ) ), 1 )
print group.GetFillMode()      ' 1
```

Microsoft Learn: [ID2D1GeometryGroup::GetFillMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometrygroup-getfillmode)

### GetSourceGeometryCount

```freebasic
function GetSourceGeometryCount() as UINT32
```

Counts the geometries in the group, for sizing the array [GetSourceGeometries](#getsourcegeometries)
fills.

**Returns** the number of geometries; 0 on an object that holds no group.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim disc as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 100, 100, 50, 50 ) )
dim parts(1) as ID2D1Geometry ptr = { *square, *disc }
dim group as CID2D1GeometryGroup = factory.CreateGeometryGroup( D2D1_FILL_MODE_ALTERNATE, cast( ID2D1Geometry ptr, cast( any ptr, @parts(0) ) ), 2 )
print group.GetSourceGeometryCount()      ' 2
```

Microsoft Learn: [ID2D1GeometryGroup::GetSourceGeometryCount](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometrygroup-getsourcegeometrycount)

### GetSourceGeometries

```freebasic
function GetSourceGeometries( byref geometries as ID2D1Geometry ptr, byval geometriesCount as UINT32 ) as HRESULT
function GetSourceGeometries( byval geometries as ID2D1Geometry ptr ptr, byval geometriesCount as UINT32 ) as HRESULT
```

Fills an array with the geometries of the group, in the order they were given, up to
`geometriesCount` of them. Each comes with a reference added for you: release every one when
done. Direct2D's method returns nothing, so the value returned is not meaningful; on an object
that holds no group it is 0 and the array is left as it was.

| Parameter | Meaning |
| --- | --- |
| `geometries` | The first element of the array, or its address. |
| `geometriesCount` | The number of elements the array has room for. |

**Returns** a value with no meaning; see above.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim parts(0) as ID2D1Geometry ptr = { *square }
dim group as CID2D1GeometryGroup = factory.CreateGeometryGroup( D2D1_FILL_MODE_WINDING, cast( ID2D1Geometry ptr, cast( any ptr, @parts(0) ) ), 1 )
dim back(0) as ID2D1Geometry ptr
group.GetSourceGeometries( back(0), 1 )
print "the square:"; back(0) = square.m_pGeometry
back(0)->Release()
```

Microsoft Learn: [ID2D1GeometryGroup::GetSourceGeometries](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometrygroup-getsourcegeometries)

## CID2D1GeometrySink

The sink that fills a path: [Open](#open) of [CID2D1PathGeometry](#cid2d1pathgeometry) returns
one. It extends [CID2D1SimplifiedGeometrySink](#cid2d1simplifiedgeometrysink), which has
`BeginFigure`, `AddLines`, `AddBeziers`, `EndFigure` and `Close`, and adds single lines,
quadratic Béziers and arcs. All the drawing members are subs: a mistake, such as a segment
outside a figure, puts the sink in an error state that `Close` reports. On an object that holds
no sink they do nothing.

### Constructor

```freebasic
constructor
constructor( byval pGeometrySink as ID2D1GeometrySink ptr )
```

The first form makes an object that holds no sink. The second takes over the pointer and also
stores it as the object's `ID2D1SimplifiedGeometrySink`; given `NULL`, it sets `GetLastError()`
to `E_POINTER`.

| Parameter | Meaning |
| --- | --- |
| `pGeometrySink` | The sink to wrap, usually the result of `Open`, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
print "have a sink:"; sink.m_pGeometrySink <> NULL
sink.Close()
```

Microsoft Learn: [ID2D1GeometrySink](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1geometrysink)

### Destructor

```freebasic
destructor
```

Releases the sink, if the object holds one. Close the sink first: a path whose sink is released
unclosed is left unusable, and its members fail with `D2DERR_WRONG_STATE` (`&h88990001`).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim pSink as CID2D1GeometrySink ptr = new CID2D1GeometrySink( path.Open() )
pSink->Close()
delete pSink
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1GeometrySink ptr
operator @() as ID2D1GeometrySink ptr ptr
operator *( byref geometry as CID2D1GeometrySink ) as ID2D1GeometrySink ptr
```

`cast` and `*` return the wrapped `ID2D1GeometrySink` pointer; it still belongs to the object.
Pass `*sink` to the reshaping members of [CID2D1Geometry](CID2D1Geometry), which want an
`ID2D1SimplifiedGeometrySink ptr`. `@` returns the address of `m_pGeometrySink`, which is not
copied to `m_pSimplifiedGeometrySink`, so the inherited members would then do nothing.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim disc as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
disc.Outline( D2D1_IdentityMatrix(), *sink )
sink.Close()
```

### AddLine

```freebasic
sub AddLine( byval pt as D2D1_POINT_2F )
sub AddLine( byval endPointX as single, byval endPointY as single )
```

Adds a straight segment from the current point to the point given, which becomes the current
point.

| Parameter | Meaning |
| --- | --- |
| `pt` | The end point. |
| `endPointX`, `endPointY` | The end point, as two numbers. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_HOLLOW )
sink.AddLine( 100, 0 ) : sink.AddLine( D2D1_Point2F( 100, 100 ) )
sink.EndFigure( D2D1_FIGURE_END_OPEN ) : sink.Close()
```

Microsoft Learn: [ID2D1GeometrySink::AddLine](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometrysink-addline)

### AddBezier

```freebasic
sub AddBezier( byref bezier as D2D1_BEZIER_SEGMENT )
sub AddBezier( byval bezier as D2D1_BEZIER_SEGMENT ptr )
sub AddBezier( byval pt1X as single, byval pt1Y as single, byval pt2X as single, byval pt2Y as single, byval pt3X as single, byval pt3Y as single )
```

Adds a cubic Bézier curve from the current point to its end point. The curve leaves towards the
first control point and arrives from the direction of the second; it passes through neither.

| Parameter | Meaning |
| --- | --- |
| `bezier` | The two control points and the end point (`.point1`, `.point2`, `.point3`); `D2D1_BezierSegment` makes one. |
| `pt1X`, `pt1Y` | The first control point. |
| `pt2X`, `pt2Y` | The second control point. |
| `pt3X`, `pt3Y` | The end point. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.BeginFigure( 0, 100, D2D1_FIGURE_BEGIN_HOLLOW )
sink.AddBezier( 30, 0, 70, 0, 100, 100 )      ' an arch
sink.EndFigure( D2D1_FIGURE_END_OPEN ) : sink.Close()
```

Microsoft Learn: [ID2D1GeometrySink::AddBezier](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometrysink-addbezier%28constd2d1_bezier_segment%29)

### AddQuadraticBezier

```freebasic
sub AddQuadraticBezier( byref bezier as D2D1_QUADRATIC_BEZIER_SEGMENT )
sub AddQuadraticBezier( byval bezier as D2D1_QUADRATIC_BEZIER_SEGMENT ptr )
sub AddQuadraticBezier( byval pt1X as single, byval pt1Y as single, byval pt2X as single, byval pt2Y as single )
```

Adds a quadratic Bézier curve, with one control point, from the current point to its end point.

| Parameter | Meaning |
| --- | --- |
| `bezier` | The control point and the end point (`.point1`, `.point2`); `D2D1_QuadraticBezierSegment` makes one. |
| `pt1X`, `pt1Y` | The control point. |
| `pt2X`, `pt2Y` | The end point. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.BeginFigure( 0, 100, D2D1_FIGURE_BEGIN_HOLLOW )
sink.AddQuadraticBezier( 50, 0, 100, 100 )
sink.EndFigure( D2D1_FIGURE_END_OPEN ) : sink.Close()
```

Microsoft Learn: [ID2D1GeometrySink::AddQuadraticBezier](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometrysink-addquadraticbezier%28constd2d1_quadratic_bezier_segment%29)

### AddQuadraticBeziers

```freebasic
sub AddQuadraticBeziers( byref beziers as D2D1_QUADRATIC_BEZIER_SEGMENT, byval beziersCount as UINT32 )
sub AddQuadraticBeziers( byval beziers as D2D1_QUADRATIC_BEZIER_SEGMENT ptr, byval beziersCount as UINT32 )
```

Adds several quadratic Bézier curves in one call, each starting where the one before ends.

| Parameter | Meaning |
| --- | --- |
| `beziers` | The first element of an array of segments, or its address. |
| `beziersCount` | The number of segments. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
dim wave(1) as D2D1_QUADRATIC_BEZIER_SEGMENT = { D2D1_QuadraticBezierSegment( D2D1_Point2F( 25, -25 ), D2D1_Point2F( 50, 0 ) ), D2D1_QuadraticBezierSegment( D2D1_Point2F( 75, 25 ), D2D1_Point2F( 100, 0 ) ) }
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_HOLLOW )
sink.AddQuadraticBeziers( wave(0), 2 )
sink.EndFigure( D2D1_FIGURE_END_OPEN ) : sink.Close()
```

Microsoft Learn: [ID2D1GeometrySink::AddQuadraticBeziers](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometrysink-addquadraticbeziers)

### AddArc

```freebasic
sub AddArc( byref arc as D2D1_ARC_SEGMENT )
sub AddArc( byval arc as D2D1_ARC_SEGMENT ptr )
sub AddArc( byval ptX as single, byval ptY as single, byval nWidth as single, byval nHeight as single, byval rotationAngle as single, byval sweepDirection as D2D1_SWEEP_DIRECTION, byval arcSize as D2D1_ARC_SIZE )
```

Adds a piece of an ellipse from the current point to an end point. An ellipse of the given radii
can pass through two points in up to two places and be travelled either way round, so the sweep
direction and the arc size pick one of the four possible arcs. When the radii are too small to
reach, the ellipse is scaled up until they do.

| Parameter | Meaning |
| --- | --- |
| `arc` | All of the values below in one `D2D1_ARC_SEGMENT`; `D2D1_ArcSegment` makes one. |
| `ptX`, `ptY` | The end point. |
| `nWidth`, `nHeight` | The x and y radii of the ellipse. |
| `rotationAngle` | How far the ellipse is turned, in degrees clockwise. |
| `sweepDirection` | `D2D1_SWEEP_DIRECTION_COUNTER_CLOCKWISE` (0) or `D2D1_SWEEP_DIRECTION_CLOCKWISE` (1). |
| `arcSize` | `D2D1_ARC_SIZE_SMALL` (0) for the arc of 180 degrees or less, `D2D1_ARC_SIZE_LARGE` (1) for the longer one. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.BeginFigure( 0, 50, D2D1_FIGURE_BEGIN_HOLLOW )
sink.AddArc( 100, 50, 50, 50, 0, D2D1_SWEEP_DIRECTION_CLOCKWISE, D2D1_ARC_SIZE_SMALL )   ' a half circle over the top
sink.EndFigure( D2D1_FIGURE_END_OPEN ) : sink.Close()
```

Microsoft Learn: [ID2D1GeometrySink::AddArc](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometrysink-addarc%28constd2d1_arc_segment%29)

## CID2D1SimplifiedGeometrySink

The part of a sink that handles figures, straight lines and cubic Béziers only. It is the base of
[CID2D1GeometrySink](#cid2d1geometrysink), so a path's sink has all of these members, and it is
the kind of sink the reshaping members of [CID2D1Geometry](CID2D1Geometry) write into. Wrap an
`ID2D1SimplifiedGeometrySink` in it directly only when some other code hands you one. On an
object that holds no sink every member does nothing, and `Close` returns 0.

### Constructor

```freebasic
constructor
constructor( byval pSimplifiedGeometrySink as ID2D1SimplifiedGeometrySink ptr )
```

The first form makes an object that holds no sink. The second takes over the pointer without
adding a reference; given `NULL`, it sets `GetLastError()` to `E_POINTER`.

| Parameter | Meaning |
| --- | --- |
| `pSimplifiedGeometrySink` | The sink to wrap, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1SimplifiedGeometrySink = cast( ID2D1SimplifiedGeometrySink ptr, path.Open() )
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_FILLED )
sink.EndFigure( D2D1_FIGURE_END_CLOSED ) : sink.Close()
```

Microsoft Learn: [ID2D1SimplifiedGeometrySink](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1simplifiedgeometrysink)

### Destructor

```freebasic
destructor
```

Releases the sink, if the object holds one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim pSink as CID2D1SimplifiedGeometrySink ptr = new CID2D1SimplifiedGeometrySink( cast( ID2D1SimplifiedGeometrySink ptr, path.Open() ) )
pSink->Close()
delete pSink
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1SimplifiedGeometrySink ptr
operator @() as ID2D1SimplifiedGeometrySink ptr ptr
operator *( byref geometry as CID2D1SimplifiedGeometrySink ) as ID2D1SimplifiedGeometrySink ptr
```

`cast` and `*` return the wrapped `ID2D1SimplifiedGeometrySink` pointer; it still belongs to the
object. `@` returns the address of `m_pSimplifiedGeometrySink`, for a function that writes a sink
into it.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1SimplifiedGeometrySink = cast( ID2D1SimplifiedGeometrySink ptr, path.Open() )
dim pSink as ID2D1SimplifiedGeometrySink ptr = sink
print "same object:"; pSink = *sink
sink.Close()
```

### SetFillMode

```freebasic
sub SetFillMode( byval fillMode as D2D1_FILL_MODE )
```

Sets how the path decides what is inside where its figures overlap or cross themselves:
`D2D1_FILL_MODE_ALTERNATE` (0, the default) leaves areas crossed an even number of times empty,
`D2D1_FILL_MODE_WINDING` (1) fills every area the figures go round. Call it before the first
`BeginFigure`.

| Parameter | Meaning |
| --- | --- |
| `fillMode` | The fill mode. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.SetFillMode( D2D1_FILL_MODE_WINDING )
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_FILLED ) : sink.AddLine( 100, 0 ) : sink.AddLine( 50, 80 )
sink.EndFigure( D2D1_FIGURE_END_CLOSED ) : sink.Close()
```

Microsoft Learn: [ID2D1SimplifiedGeometrySink::SetFillMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1simplifiedgeometrysink-setfillmode)

### SetSegmentFlags

```freebasic
sub SetSegmentFlags( byval vertexFlags as D2D1_PATH_SEGMENT )
```

Sets how the segments added from now on are stroked, until the next call:
`D2D1_PATH_SEGMENT_NONE` (0) draws them normally, `D2D1_PATH_SEGMENT_FORCE_UNSTROKED` (1) leaves
them out of the outline `DrawGeometry` draws (they still bound the fill), and
`D2D1_PATH_SEGMENT_FORCE_ROUND_LINE_JOIN` (2) rounds the corners between them whatever the
stroke style says.

| Parameter | Meaning |
| --- | --- |
| `vertexFlags` | The flags, combined with `or`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_FILLED ) : sink.AddLine( 100, 0 )
sink.SetSegmentFlags( D2D1_PATH_SEGMENT_FORCE_UNSTROKED )      ' no outline on the last two sides
sink.AddLine( 50, 80 ) : sink.EndFigure( D2D1_FIGURE_END_CLOSED ) : sink.Close()
```

Microsoft Learn: [ID2D1SimplifiedGeometrySink::SetSegmentFlags](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1simplifiedgeometrysink-setsegmentflags)

### BeginFigure

```freebasic
sub BeginFigure( byval startPoint as D2D1_POINT_2F, byval figureBegin as D2D1_FIGURE_BEGIN )
sub BeginFigure( byval startPointX as single, byval startPointY as single, byval figureBegin as D2D1_FIGURE_BEGIN )
```

Starts a new figure at a point, which becomes the current point. Each figure must be ended with
[EndFigure](#endfigure) before the next begins.

| Parameter | Meaning |
| --- | --- |
| `startPoint` | The first point of the figure. |
| `startPointX`, `startPointY` | The first point, as two numbers. |
| `figureBegin` | `D2D1_FIGURE_BEGIN_FILLED` (0) for a figure that is part of the filled area, `D2D1_FIGURE_BEGIN_HOLLOW` (1) for an outline only. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.BeginFigure( D2D1_Point2F( 10, 10 ), D2D1_FIGURE_BEGIN_HOLLOW )
sink.AddLine( 90, 90 ) : sink.EndFigure( D2D1_FIGURE_END_OPEN ) : sink.Close()
```

Microsoft Learn: [ID2D1SimplifiedGeometrySink::BeginFigure](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1simplifiedgeometrysink-beginfigure)

### AddLines

```freebasic
sub AddLines( byref points as D2D1_POINT_2F, byval pointsCount as UINT32 )
sub AddLines( byval points as D2D1_POINT_2F ptr, byval pointsCount as UINT32 )
```

Adds a straight segment to each point of an array in turn, starting at the current point: a
polyline in one call.

| Parameter | Meaning |
| --- | --- |
| `points` | The first element of the array, or its address. |
| `pointsCount` | The number of points. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
dim corners(2) as D2D1_POINT_2F = { D2D1_Point2F( 50, 0 ), D2D1_Point2F( 50, 50 ), D2D1_Point2F( 0, 50 ) }
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_FILLED )
sink.AddLines( corners(0), 3 )
sink.EndFigure( D2D1_FIGURE_END_CLOSED ) : sink.Close()
print path.ComputeArea( D2D1_IdentityMatrix() )      ' 2500
```

Microsoft Learn: [ID2D1SimplifiedGeometrySink::AddLines](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1simplifiedgeometrysink-addlines)

### AddBeziers

```freebasic
sub AddBeziers( byref beziers as const D2D1_BEZIER_SEGMENT, byval beziersCount as UINT32 )
sub AddBeziers( byval beziers as const D2D1_BEZIER_SEGMENT ptr, byval beziersCount as UINT32 )
```

Adds several cubic Bézier curves in one call, each starting where the one before ends.

| Parameter | Meaning |
| --- | --- |
| `beziers` | The first element of an array of segments, or its address. |
| `beziersCount` | The number of segments. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
dim curve as D2D1_BEZIER_SEGMENT = D2D1_BezierSegment( D2D1_Point2F( 30, 0 ), D2D1_Point2F( 70, 0 ), D2D1_Point2F( 100, 100 ) )
sink.BeginFigure( 0, 100, D2D1_FIGURE_BEGIN_HOLLOW )
sink.AddBeziers( curve, 1 )
sink.EndFigure( D2D1_FIGURE_END_OPEN ) : sink.Close()
```

Microsoft Learn: [ID2D1SimplifiedGeometrySink::AddBeziers](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1simplifiedgeometrysink-addbeziers)

### EndFigure

```freebasic
sub EndFigure( byval figureEnd as D2D1_FIGURE_END )
```

Ends the current figure. A closed figure gets a straight segment back to its start point, and its
outline joins there instead of ending in two caps.

| Parameter | Meaning |
| --- | --- |
| `figureEnd` | `D2D1_FIGURE_END_OPEN` (0) or `D2D1_FIGURE_END_CLOSED` (1). |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_FILLED ) : sink.AddLine( 100, 0 ) : sink.AddLine( 100, 100 )
sink.EndFigure( D2D1_FIGURE_END_CLOSED ) : sink.Close()
print path.GetSegmentCount()      ' 3, the closing side included
```

Microsoft Learn: [ID2D1SimplifiedGeometrySink::EndFigure](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1simplifiedgeometrysink-endfigure)

### Close

```freebasic
function Close() as HRESULT
```

Finishes the sink and seals the path it was filling. Call it once every figure is ended; nothing
can be added afterwards. A second `Close` returns `D2DERR_WRONG_STATE` (`&h88990001`).

**Returns** `S_OK` when everything given to the sink was valid, otherwise the first error it met;
0 on an object that holds no sink.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim path as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = path.Open()
sink.BeginFigure( 0, 0, D2D1_FIGURE_BEGIN_HOLLOW ) : sink.AddLine( 50, 50 ) : sink.EndFigure( D2D1_FIGURE_END_OPEN )
print hex( sink.Close() ); " "; hex( sink.Close() )      ' 0 88990001
```

Microsoft Learn: [ID2D1SimplifiedGeometrySink::Close](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1simplifiedgeometrysink-close)

## See also

- [CID2D1Geometry](CID2D1Geometry) for the members every geometry has: bounds, hit-testing, area, length, combining and widening
- [CD2D1Factory](CD2D1Factory), which makes the geometries
- [CID2D1RenderTarget](CID2D1RenderTarget) for `FillGeometry` and `DrawGeometry`
- [Direct2D helpers](SysWin-Direct2D-Helpers) for `D2D1_RectF`, `D2D1_EllipseF`, `D2D1_BezierSegment`, `D2D1_ArcSegment` and the matrix functions
- [Direct2D stroke styles](SysWin-Direct2D-Stroke-Styles) for dashed and capped outlines
- [sys/win/direct2d](SysWin-Direct2D)
