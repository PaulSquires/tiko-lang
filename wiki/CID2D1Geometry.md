[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **CID2D1Geometry**

# CID2D1Geometry

Measures, hit-tests and reshapes Direct2D geometries; the base class of every shape.

`CID2D1Geometry` wraps the `ID2D1Geometry` interface that every Direct2D shape implements. The
shape classes on [Direct2D geometries](SysWin-Direct2D-Geometries) (`CID2D1RectangleGeometry`,
`CID2D1EllipseGeometry`, `CID2D1PathGeometry` …) extend it, so every member here is theirs too.
Declare a `CID2D1Geometry` yourself when the kind of shape does not matter.

**Where geometries come from.** A [CD2D1Factory](CD2D1Factory) makes them:
`CreateRectangleGeometry`, `CreateRoundedRectangleGeometry`, `CreateEllipseGeometry`,
`CreatePathGeometry`, `CreateGeometryGroup` and `CreateTransformedGeometry`. A geometry belongs
to the factory, not to a render target: it can be drawn on any target made by the same factory,
with `FillGeometry` and `DrawGeometry` of [CID2D1RenderTarget](CID2D1RenderTarget), and it can be
measured with no window and no render target at all, as the example below does.

**Lifetime.** The constructor takes over the reference it is given and the destructor releases
it: do not release that pointer yourself, and never copy a geometry object by value
(`dim b as CID2D1Geometry = a`, or a `byval` parameter), because the copy releases the same
interface again. To pass the object where an `ID2D1Geometry ptr` is wanted, such as
`CompareWithGeometry` or `FillGeometry`, write `*shape`. The pointer is also in the public field
`m_pGeometry`.

**Transform and tolerance.** Every measuring member takes a `worldTransform`, a
`D2D1_MATRIX_3X2_F` applied to the geometry before it is measured; pass `D2D1_IdentityMatrix()`
to measure the shape as it is. Curves are measured by cutting them into straight lines that stay
within `flatteningTolerance` DIPs of the curve. The forms without that parameter use
`D2D1_DEFAULT_FLATTENING_TOLERANCE` (0.25). Results for curved shapes are therefore close, not
exact: a circle of radius 40 has an area of 5008.434 at the default tolerance and 5027.45 at
0.01, against 5026.55 exactly.

**The overloads.** Each member comes in the same set of forms:

| Form | Result | `HRESULT` |
| --- | --- | --- |
| `GetBounds( m, bounds )` | written into the last argument | returned |
| `GetBounds( @m, @bounds )` | the same, with pointers | returned |
| `b = GetBounds( m )`, `b = GetBounds( @m )` | returned | in `GetLastError()`; read it before the next `print` |

Most members have the same forms again with a `flatteningTolerance` before the result. Two
exceptions: the value forms of [ComputeArea](#computearea) and [ComputeLength](#computelength)
that take the matrix by pointer return the `HRESULT`, not the measurement, and there is no value
form that takes the matrix by reference and a tolerance. Use the forms that write into a variable.

**Sinks.** [Simplify](#simplify), [Outline](#outline), [Widen](#widen) and
[CombineWithGeometry](#combinewithgeometry) produce a new shape and write it into an
`ID2D1SimplifiedGeometrySink`. Pass the sink of a new, empty path geometry
([CID2D1PathGeometry](SysWin-Direct2D-Geometries#cid2d1pathgeometry) `Open`) and close it
afterwards: the path then holds the result. [Tessellate](#tessellate) writes triangles into an
`ID2D1TessellationSink`, which a mesh provides. Each of these members also has forms that take no
sink and return one: those hand Direct2D a null sink, and the call ends the program with an access
violation. Always pass a sink.

**An empty object.** On an object that holds no geometry the members that return an `HRESULT`
return `E_POINTER`, except `Simplify`, which returns `S_OK` (0) and writes nothing; the value
forms return 0, `false` or `NULL`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A console program that measures a circle and tests points against it. No window is needed:

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d

function main() as long
    dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
    dim disc as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
    dim box as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 60, 60 ) )
    dim identity as D2D1_MATRIX_3X2_F = D2D1_IdentityMatrix()

    dim b as D2D1_RECT_F = disc.GetBounds( identity )
    print "bounds:"; b.left; b.top; b.right; b.bottom

    dim area as single, perimeter as single
    disc.ComputeArea( identity, 0.01, area )
    disc.ComputeLength( identity, 0.01, perimeter )
    print "area:"; area; "  perimeter:"; perimeter

    print "(50, 50) inside:"; disc.FillContainsPoint( D2D1_Point2F( 50, 50 ), identity )
    print "(12, 12) inside:"; disc.FillContainsPoint( D2D1_Point2F( 12, 12 ), identity )
    print "(90, 50) on a 2-DIP outline:"; disc.StrokeContainsPoint( D2D1_Point2F( 90, 50 ), 2, NULL, identity )

    ' the same disc drawn at twice the size
    print "area at 200 %:"; disc.ComputeArea( D2D1_MatrixScale( D2D1_SizeF( 2, 2 ) ) )

    if disc.CompareWithGeometry( *box, identity ) = D2D1_GEOMETRY_RELATION_OVERLAP then
        print "the disc and the box overlap"
    end if
    return 0
end function

end main()
```

It prints:

```text
bounds: 10 10 90 90
area: 5027.45  perimeter: 251.3564
(50, 50) inside:true
(12, 12) inside:false
(90, 50) on a 2-DIP outline:true
area at 200 %: 20079.49
the disc and the box overlap
```

The corner (12, 12) is inside the bounding box but outside the circle.

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Makes an empty object, or one that takes over an `ID2D1Geometry` pointer. |
| [Destructor](#destructor) | Releases the geometry. |
| [Cast, Operator @, Operator *](#cast-operator--operator-) | Give the interface pointer or its address. |
| [GetFactory](#getfactory) | Returns the factory that made the geometry. |
| [GetBounds](#getbounds) | Returns the rectangle that encloses the geometry. |
| [GetWidenedBounds](#getwidenedbounds) | Returns the rectangle that encloses the geometry's outline drawn with a pen. |
| [StrokeContainsPoint](#strokecontainspoint) | Tells whether a point lies on the outline drawn with a pen. |
| [FillContainsPoint](#fillcontainspoint) | Tells whether a point lies inside the geometry. |
| [CompareWithGeometry](#comparewithgeometry) | Tells whether two geometries are apart, overlap or contain one another. |
| [Simplify](#simplify) | Writes the geometry as lines, or lines and cubic Béziers, into a sink. |
| [Tessellate](#tessellate) | Writes triangles that cover the geometry into a sink. |
| [CombineWithGeometry](#combinewithgeometry) | Writes the union, intersection, difference or exclusive-or of two geometries into a sink. |
| [Outline](#outline) | Writes the outer boundary of the geometry, with no overlaps, into a sink. |
| [ComputeArea](#computearea) | Measures the area. |
| [ComputeLength](#computelength) | Measures the length of all the segments. |
| [ComputePointAtLength](#computepointatlength) | Finds the point and direction at a distance along the geometry. |
| [Widen](#widen) | Writes the shape of the outline drawn with a pen into a sink. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval pGeometry as ID2D1Geometry ptr )
```

The first form makes an object that holds no geometry. The second takes over `pGeometry`: the
object does not add a reference, it adopts the one you pass, and releases it when it is
destroyed. The pointer of any kind of geometry converts to `ID2D1Geometry ptr` by itself, so the
result of any `Create…Geometry` call of [CD2D1Factory](CD2D1Factory) can be passed as it is.

| Parameter | Meaning |
| --- | --- |
| `pGeometry` | The geometry to wrap, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1Geometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
print shape.ComputeArea( D2D1_IdentityMatrix() )      ' 5008.434
```

Microsoft Learn: [ID2D1Geometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1geometry)

### Destructor

```freebasic
destructor
```

Releases the geometry, if the object holds one. A group or transformed geometry made from it
keeps its own reference, so it stays usable.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pShape as CID2D1Geometry ptr = new CID2D1Geometry( factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 10, 10 ) ) )
delete pShape   ' releases the geometry
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1Geometry ptr
operator @() as ID2D1Geometry ptr ptr
operator *( byref geometry as CID2D1Geometry ) as ID2D1Geometry ptr
```

`cast` and `*` return the wrapped `ID2D1Geometry` pointer, which is how the object is passed
where Direct2D wants the interface. The pointer still belongs to the object: do not release it.
`@` returns the address of the stored pointer, `m_pGeometry`, for a function that writes a
geometry into it; it does not release what is there first, so use it on an empty object.

The derived classes declare their own `cast`, `@` and `*` for their own interface types, which
hide these. Use `*shape` to pass any of them where an `ID2D1Geometry ptr` is wanted: a pointer to
a particular kind of geometry converts to `ID2D1Geometry ptr` by itself.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1Geometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
dim pGeo as ID2D1Geometry ptr = shape
print "same interface:"; pGeo = *shape
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Returns the factory that made the geometry, with a reference added for you: release it when
done. Only geometries from the same factory can be combined, compared or put in one group.

**Returns** the factory, or `NULL` when the object holds no geometry.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1Geometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
dim pFactory as ID2D1Factory ptr = shape.GetFactory()
print "made by this factory:"; pFactory = *factory
pFactory->Release()
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### GetBounds

```freebasic
function GetBounds( byref worldTransform as const D2D1_MATRIX_3X2_F, byref bounds as D2D1_RECT_F ) as HRESULT
function GetBounds( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval bounds as D2D1_RECT_F ptr ) as HRESULT
function GetBounds( byref worldTransform as const D2D1_MATRIX_3X2_F ) as D2D1_RECT_F
function GetBounds( byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as D2D1_RECT_F
```

Returns the smallest axis-aligned rectangle that encloses the filled geometry after
`worldTransform` is applied. The outline a pen draws reaches beyond it by half the pen's width;
[GetWidenedBounds](#getwidenedbounds) includes it. A path with nothing in it gives a rectangle
whose `left` is greater than its `right`.

| Parameter | Meaning |
| --- | --- |
| `worldTransform` | The transform applied to the geometry first. |
| `bounds` | Receives the rectangle. |

**Returns** `S_OK` or the failing `HRESULT`, or the rectangle (all zero on failure).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
dim b as D2D1_RECT_F = shape.GetBounds( D2D1_IdentityMatrix() )
print b.left; b.top; b.right; b.bottom      ' 10 10 90 90
```

Microsoft Learn: [ID2D1Geometry::GetBounds](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-getbounds%28constd2d1_matrix_3x2_f_d2d1_rect_f%29)

### GetWidenedBounds

```freebasic
function GetWidenedBounds( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byref bounds as D2D1_RECT_F ) as HRESULT
function GetWidenedBounds( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval bounds as D2D1_RECT_F ptr ) as HRESULT
function GetWidenedBounds( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT ) as D2D1_RECT_F
function GetWidenedBounds( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as D2D1_RECT_F
function GetWidenedBounds( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F, byref bounds as D2D1_RECT_F ) as HRESULT
function GetWidenedBounds( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval bounds as D2D1_RECT_F ptr ) as HRESULT
function GetWidenedBounds( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F ) as D2D1_RECT_F
function GetWidenedBounds( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as D2D1_RECT_F
```

Returns the rectangle that encloses the outline of the geometry as `DrawGeometry` would draw it
with a pen `strokeWidth` DIPs wide: the area a redraw of the outline has to cover.

| Parameter | Meaning |
| --- | --- |
| `strokeWidth` | The width of the pen. |
| `strokeStyle` | Caps, joins and dashes of the pen, or `NULL` for a plain solid line (see [Direct2D stroke styles](SysWin-Direct2D-Stroke-Styles)). |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely curves are followed. |
| `bounds` | Receives the rectangle. |

**Returns** `S_OK` or the failing `HRESULT`, or the rectangle.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) )
dim b as D2D1_RECT_F = shape.GetWidenedBounds( 10, NULL, D2D1_IdentityMatrix() )
print b.left; b.top; b.right; b.bottom      ' -5 -5 105 55
```

Microsoft Learn: [ID2D1Geometry::GetWidenedBounds](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-getwidenedbounds%28float_id2d1strokestyle_constd2d1_matrix_3x2_f_float_d2d1_rect_f%29)

### StrokeContainsPoint

```freebasic
function StrokeContainsPoint( byval pt as D2D1_POINT_2F, byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byref contains as boolean ) as HRESULT
function StrokeContainsPoint( byval pt as D2D1_POINT_2F, byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval contains as boolean ptr ) as HRESULT
function StrokeContainsPoint( byval pt as D2D1_POINT_2F, byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT ) as boolean
function StrokeContainsPoint( byval pt as D2D1_POINT_2F, byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as boolean
function StrokeContainsPoint( byval pt as D2D1_POINT_2F, byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F, byref contains as boolean ) as HRESULT
function StrokeContainsPoint( byval pt as D2D1_POINT_2F, byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval contains as boolean ptr ) as HRESULT
function StrokeContainsPoint( byval pt as D2D1_POINT_2F, byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F ) as boolean
function StrokeContainsPoint( byval pt as D2D1_POINT_2F, byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as boolean
```

Tells whether `pt` falls on the outline of the geometry drawn with a pen `strokeWidth` DIPs wide,
centred on the edge. Use it to hit-test a line or the border of a shape; `pt` is in the same
coordinates as the transformed geometry, so a mouse position in pixels must first be converted to
DIPs.

| Parameter | Meaning |
| --- | --- |
| `pt` | The point to test. |
| `strokeWidth` | The width of the pen. |
| `strokeStyle` | Caps, joins and dashes, or `NULL` for a plain solid line. |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely curves are followed. |
| `contains` | Receives `true` when the point is on the outline. |

**Returns** `S_OK` or the failing `HRESULT`, or `true` when the point is on the outline.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) )
print shape.StrokeContainsPoint( D2D1_Point2F( 0, 10 ), 4, NULL, D2D1_IdentityMatrix() )    ' true
print shape.StrokeContainsPoint( D2D1_Point2F( 10, 10 ), 4, NULL, D2D1_IdentityMatrix() )   ' false
```

Microsoft Learn: [ID2D1Geometry::StrokeContainsPoint](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-strokecontainspoint%28d2d1_point_2f_float_id2d1strokestyle_constd2d1_matrix_3x2_f_float_bool%29)

### FillContainsPoint

```freebasic
function FillContainsPoint( byval pt as D2D1_POINT_2F, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byref contains as boolean ) as HRESULT
function FillContainsPoint( byval pt as D2D1_POINT_2F, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval contains as boolean ptr ) as HRESULT
function FillContainsPoint( byval pt as D2D1_POINT_2F, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT ) as boolean
function FillContainsPoint( byval pt as D2D1_POINT_2F, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as boolean
function FillContainsPoint( byval pt as D2D1_POINT_2F, byref worldTransform as const D2D1_MATRIX_3X2_F, byref contains as boolean ) as HRESULT
function FillContainsPoint( byval pt as D2D1_POINT_2F, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval contains as boolean ptr ) as HRESULT
function FillContainsPoint( byval pt as D2D1_POINT_2F, byref worldTransform as const D2D1_MATRIX_3X2_F ) as boolean
function FillContainsPoint( byval pt as D2D1_POINT_2F, byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as boolean
```

Tells whether `pt` lies inside the area `FillGeometry` would paint. For a path that crosses
itself, its fill mode decides which parts count as inside.

| Parameter | Meaning |
| --- | --- |
| `pt` | The point to test, in the coordinates of the transformed geometry. |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely curves are followed. |
| `contains` | Receives `true` when the point is inside. |

**Returns** `S_OK` or the failing `HRESULT`, or `true` when the point is inside.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) )
print shape.FillContainsPoint( D2D1_Point2F( 10, 10 ), D2D1_IdentityMatrix() )    ' true
print shape.FillContainsPoint( D2D1_Point2F( 200, 10 ), D2D1_IdentityMatrix() )   ' false
```

Microsoft Learn: [ID2D1Geometry::FillContainsPoint](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-fillcontainspoint%28d2d1_point_2f_constd2d1_matrix_3x2_f_float_bool%29)

### CompareWithGeometry

```freebasic
function CompareWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byref inputGeometryTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byref relation as D2D1_GEOMETRY_RELATION ) as HRESULT
function CompareWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval inputGeometryTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval relation as D2D1_GEOMETRY_RELATION ptr ) as HRESULT
function CompareWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byref inputGeometryTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT ) as D2D1_GEOMETRY_RELATION
function CompareWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval inputGeometryTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as D2D1_GEOMETRY_RELATION
function CompareWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byref inputGeometryTransform as const D2D1_MATRIX_3X2_F, byref relation as D2D1_GEOMETRY_RELATION ) as HRESULT
function CompareWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval inputGeometryTransform as const D2D1_MATRIX_3X2_F ptr, byval relation as D2D1_GEOMETRY_RELATION ptr ) as HRESULT
function CompareWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byref inputGeometryTransform as const D2D1_MATRIX_3X2_F ) as D2D1_GEOMETRY_RELATION
function CompareWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval inputGeometryTransform as const D2D1_MATRIX_3X2_F ptr ) as D2D1_GEOMETRY_RELATION
```

Compares the filled area of this geometry with that of `inputGeometry`. The transform applies to
`inputGeometry`, not to this geometry. Both must come from the same factory.

| Parameter | Meaning |
| --- | --- |
| `inputGeometry` | The geometry to compare with; pass a wrapper object as `*other`. |
| `inputGeometryTransform` | The transform applied to `inputGeometry` first. |
| `flatteningTolerance` | How closely curves are followed. |
| `relation` | Receives the result. |

**Returns** `S_OK` or the failing `HRESULT`, or the relation:

| Value | Meaning |
| --- | --- |
| `D2D1_GEOMETRY_RELATION_UNKNOWN` (0) | Not worked out; returned on failure. |
| `D2D1_GEOMETRY_RELATION_DISJOINT` (1) | The two do not touch. |
| `D2D1_GEOMETRY_RELATION_IS_CONTAINED` (2) | This geometry lies wholly inside `inputGeometry`. |
| `D2D1_GEOMETRY_RELATION_CONTAINS` (3) | `inputGeometry` lies wholly inside this geometry. |
| `D2D1_GEOMETRY_RELATION_OVERLAP` (4) | They overlap in part. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim outer as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim inner as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 10, 10, 20, 20 ) )
print outer.CompareWithGeometry( *inner, D2D1_IdentityMatrix() )      ' 3 (contains)
```

Microsoft Learn: [ID2D1Geometry::CompareWithGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-comparewithgeometry%28id2d1geometry_constd2d1_matrix_3x2_f_float_d2d1_geometry_relation%29)

### Simplify

```freebasic
function Simplify( byval simplificationOption as D2D1_GEOMETRY_SIMPLIFICATION_OPTION, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Simplify( byval simplificationOption as D2D1_GEOMETRY_SIMPLIFICATION_OPTION, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Simplify( byval simplificationOption as D2D1_GEOMETRY_SIMPLIFICATION_OPTION, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT ) as ID2D1SimplifiedGeometrySink ptr
function Simplify( byval simplificationOption as D2D1_GEOMETRY_SIMPLIFICATION_OPTION, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as ID2D1SimplifiedGeometrySink ptr
function Simplify( byval simplificationOption as D2D1_GEOMETRY_SIMPLIFICATION_OPTION, byref worldTransform as const D2D1_MATRIX_3X2_F, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Simplify( byval simplificationOption as D2D1_GEOMETRY_SIMPLIFICATION_OPTION, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Simplify( byval simplificationOption as D2D1_GEOMETRY_SIMPLIFICATION_OPTION, byref worldTransform as const D2D1_MATRIX_3X2_F ) as ID2D1SimplifiedGeometrySink ptr
function Simplify( byval simplificationOption as D2D1_GEOMETRY_SIMPLIFICATION_OPTION, byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as ID2D1SimplifiedGeometrySink ptr
```

Writes the transformed geometry into `geometrySink` using only straight lines, or lines and cubic
Béziers: arcs and quadratic Béziers are converted. Use it to get a shape into a form other code
can read, or, written into a new path, to bake a transform into it.

The forms that return a sink take none and pass Direct2D a null one; the call ends the program
with an access violation. On an object that holds no geometry the other forms return `S_OK` and
write nothing.

| Parameter | Meaning |
| --- | --- |
| `simplificationOption` | `D2D1_GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES` (0) keeps cubic Béziers; `D2D1_GEOMETRY_SIMPLIFICATION_OPTION_LINES` (1) flattens every curve into lines. |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely the lines follow the curves. |
| `geometrySink` | Receives the figures; usually the sink of a new path, passed as `*sink`. |

**Returns** `S_OK` or the failing `HRESULT`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
dim flat as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = flat.Open()
shape.Simplify( D2D1_GEOMETRY_SIMPLIFICATION_OPTION_CUBICS_AND_LINES, D2D1_IdentityMatrix(), *sink )
sink.Close()
print "segments:"; flat.GetSegmentCount()      ' 8
```

Microsoft Learn: [ID2D1Geometry::Simplify](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-simplify%28d2d1_geometry_simplification_option_constd2d1_matrix_3x2_f_float_id2d1simplifiedgeometrysink%29)

### Tessellate

```freebasic
function Tessellate( byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byval tessellationSink as ID2D1TessellationSink ptr ) as HRESULT
function Tessellate( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval tessellationSink as ID2D1TessellationSink ptr ) as HRESULT
function Tessellate( byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT ) as ID2D1TessellationSink ptr
function Tessellate( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as ID2D1TessellationSink ptr
function Tessellate( byref worldTransform as const D2D1_MATRIX_3X2_F, byval tessellationSink as ID2D1TessellationSink ptr ) as HRESULT
function Tessellate( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval tessellationSink as ID2D1TessellationSink ptr ) as HRESULT
function Tessellate( byref worldTransform as const D2D1_MATRIX_3X2_F ) as ID2D1TessellationSink ptr
function Tessellate( byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as ID2D1TessellationSink ptr
```

Covers the transformed geometry with clockwise triangles and writes them into
`tessellationSink`. The usual sink is the one a mesh hands out: make the mesh with `CreateMesh`
of [CID2D1RenderTarget](CID2D1RenderTarget), open it, tessellate into it, close the sink, and
paint the mesh with `FillMesh`. A mesh draws faster than the geometry it came from, but only at
the size and position it was tessellated for.

The forms that return a sink take none and pass Direct2D a null one; the call ends the program
with an access violation.

| Parameter | Meaning |
| --- | --- |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely the triangles follow the curves. |
| `tessellationSink` | Receives the triangles. |

**Returns** `S_OK` or the failing `HRESULT`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pMesh as ID2D1Mesh ptr = rt.CreateMesh()
dim pSink as ID2D1TessellationSink ptr
pMesh->Open( pSink )
dim shape as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
if shape.Tessellate( D2D1_IdentityMatrix(), pSink ) = S_OK then pSink->Close()
pSink->Release() : pMesh->Release()
```

Microsoft Learn: [ID2D1Geometry::Tessellate](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-tessellate%28constd2d1_matrix_3x2_f_float_id2d1tessellationsink%29)

### CombineWithGeometry

```freebasic
function CombineWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval combineMode as D2D1_COMBINE_MODE, byref inputGeometryTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function CombineWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval combineMode as D2D1_COMBINE_MODE, byval inputGeometryTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function CombineWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval combineMode as D2D1_COMBINE_MODE, byref inputGeometryTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT ) as ID2D1SimplifiedGeometrySink ptr
function CombineWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval combineMode as D2D1_COMBINE_MODE, byval inputGeometryTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as ID2D1SimplifiedGeometrySink ptr
function CombineWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval combineMode as D2D1_COMBINE_MODE, byref inputGeometryTransform as const D2D1_MATRIX_3X2_F, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function CombineWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval combineMode as D2D1_COMBINE_MODE, byval inputGeometryTransform as const D2D1_MATRIX_3X2_F ptr, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function CombineWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval combineMode as D2D1_COMBINE_MODE, byref inputGeometryTransform as const D2D1_MATRIX_3X2_F ) as ID2D1SimplifiedGeometrySink ptr
function CombineWithGeometry( byval inputGeometry as ID2D1Geometry ptr, byval combineMode as D2D1_COMBINE_MODE, byval inputGeometryTransform as const D2D1_MATRIX_3X2_F ptr ) as ID2D1SimplifiedGeometrySink ptr
```

Combines the filled area of this geometry with that of `inputGeometry` and writes the resulting
shape into `geometrySink`. The transform applies to `inputGeometry` only. Both geometries must
come from the same factory.

The forms that return a sink take none and pass Direct2D a null one; the call ends the program
with an access violation.

| Parameter | Meaning |
| --- | --- |
| `inputGeometry` | The other geometry; pass a wrapper object as `*other`. |
| `combineMode` | `D2D1_COMBINE_MODE_UNION` (0, either), `D2D1_COMBINE_MODE_INTERSECT` (1, both), `D2D1_COMBINE_MODE_XOR` (2, one but not both) or `D2D1_COMBINE_MODE_EXCLUDE` (3, this one less the other). |
| `inputGeometryTransform` | The transform applied to `inputGeometry` first. |
| `flatteningTolerance` | How closely curves are followed. |
| `geometrySink` | Receives the result; usually the sink of a new path, passed as `*sink`. |

**Returns** `S_OK` or the failing `HRESULT`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim disc as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 100, 100, 50, 50 ) )
dim both as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = both.Open()
square.CombineWithGeometry( *disc, D2D1_COMBINE_MODE_UNION, D2D1_IdentityMatrix(), *sink )
sink.Close()
```

Microsoft Learn: [ID2D1Geometry::CombineWithGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-combinewithgeometry%28id2d1geometry_d2d1_combine_mode_constd2d1_matrix_3x2_f_float_id2d1simplifiedgeometrysink%29)

### Outline

```freebasic
function Outline( byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Outline( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Outline( byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT ) as ID2D1SimplifiedGeometrySink ptr
function Outline( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as ID2D1SimplifiedGeometrySink ptr
function Outline( byref worldTransform as const D2D1_MATRIX_3X2_F, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Outline( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Outline( byref worldTransform as const D2D1_MATRIX_3X2_F ) as ID2D1SimplifiedGeometrySink ptr
function Outline( byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as ID2D1SimplifiedGeometrySink ptr
```

Writes the boundary of the filled area into `geometrySink`: the same area, redrawn as figures
that neither cross themselves nor overlap one another. A five-pointed star drawn as one
self-crossing line with the winding fill mode, for instance, comes out as one figure that runs
round its outer edge, with the same area.

The forms that return a sink take none and pass Direct2D a null one; the call ends the program
with an access violation.

| Parameter | Meaning |
| --- | --- |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely curves are followed. |
| `geometrySink` | Receives the outline; usually the sink of a new path, passed as `*sink`. |

**Returns** `S_OK` or the failing `HRESULT`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1EllipseGeometry = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
dim edge as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = edge.Open()
shape.Outline( D2D1_IdentityMatrix(), *sink )
sink.Close()
```

Microsoft Learn: [ID2D1Geometry::Outline](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-outline%28constd2d1_matrix_3x2_f_float_id2d1simplifiedgeometrysink%29)

### ComputeArea

```freebasic
function ComputeArea( byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byref area as FLOAT ) as HRESULT
function ComputeArea( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval area as FLOAT ptr ) as HRESULT
function ComputeArea( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as FLOAT
function ComputeArea( byref worldTransform as const D2D1_MATRIX_3X2_F, byref area as FLOAT ) as HRESULT
function ComputeArea( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval area as FLOAT ptr ) as HRESULT
function ComputeArea( byref worldTransform as const D2D1_MATRIX_3X2_F ) as FLOAT
function ComputeArea( byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as FLOAT
```

Measures the area of the transformed geometry, in square DIPs.

Three forms need care. `ComputeArea( m )`, with the matrix by reference and no tolerance, returns
the area. The two value forms that take the matrix by pointer, `ComputeArea( @m )` and
`ComputeArea( @m, tolerance )`, return the `HRESULT` converted to a number, so 0 on success,
not the area. And `ComputeArea( m, 0.01 )` is the form that writes the area into its second
argument: given a number, it writes into a temporary and returns the `HRESULT`. To measure with
a tolerance, pass a variable as the third argument.

| Parameter | Meaning |
| --- | --- |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely curves are followed. |
| `area` | Receives the area. |

**Returns** `S_OK` or the failing `HRESULT`; `ComputeArea( m )` returns the area, or 0 on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) )
dim area as single
if shape.ComputeArea( D2D1_IdentityMatrix(), area ) = S_OK then print area     ' 5000
```

Microsoft Learn: [ID2D1Geometry::ComputeArea](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-computearea%28constd2d1_matrix_3x2_f_float_float%29)

### ComputeLength

```freebasic
function ComputeLength( byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byref Length as FLOAT ) as HRESULT
function ComputeLength( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval Length as FLOAT ptr ) as HRESULT
function ComputeLength( byref worldTransform as const D2D1_MATRIX_3X2_F, byref Length as FLOAT ) as HRESULT
function ComputeLength( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval Length as FLOAT ptr ) as HRESULT
function ComputeLength( byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as FLOAT
function ComputeLength( byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as FLOAT
```

Measures the length of every segment of the transformed geometry laid end to end: the perimeter
of a closed shape, closing side included, or the length of an open path.

The two forms that return a value return the `HRESULT` converted to a number, 0 on success, not
the length, and `ComputeLength( m, 0.01 )` writes the length into a temporary. Pass a variable to
receive it, as below.

| Parameter | Meaning |
| --- | --- |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely curves are followed. |
| `Length` | Receives the length. |

**Returns** `S_OK` or the failing `HRESULT`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) )
dim perimeter as single
if shape.ComputeLength( D2D1_IdentityMatrix(), perimeter ) = S_OK then print perimeter     ' 300
```

Microsoft Learn: [ID2D1Geometry::ComputeLength](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-computelength%28constd2d1_matrix_3x2_f_float_float%29)

### ComputePointAtLength

```freebasic
function ComputePointAtLength( byval length as FLOAT, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byref point as D2D1_POINT_2F, byref unitTangentVector as D2D1_POINT_2F ) as HRESULT
function ComputePointAtLength( byval length as FLOAT, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval pt as D2D1_POINT_2F ptr, byval unitTangentVector as D2D1_POINT_2F ptr ) as HRESULT
function ComputePointAtLength( byval length as FLOAT, byref worldTransform as const D2D1_MATRIX_3X2_F, byref point as D2D1_POINT_2F, byref unitTangentVector as D2D1_POINT_2F ) as HRESULT
function ComputePointAtLength( byval length as FLOAT, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval pt as D2D1_POINT_2F ptr, byval unitTangentVector as D2D1_POINT_2F ptr ) as HRESULT
function ComputePointAtLength( byval length as FLOAT, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byref pt as D2D1_POINT_2F ) as D2D1_POINT_2F
function ComputePointAtLength( byval length as FLOAT, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval pt as D2D1_POINT_2F ptr ) as D2D1_POINT_2F
function ComputePointAtLength( byval length as FLOAT, byref worldTransform as const D2D1_MATRIX_3X2_F, byref pt as D2D1_POINT_2F ) as D2D1_POINT_2F
function ComputePointAtLength( byval length as FLOAT, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval pt as D2D1_POINT_2F ptr ) as D2D1_POINT_2F
```

Walks `length` DIPs along the transformed geometry, from the start of its first figure, and
reports the point reached and the direction of travel there as a vector of length 1. Use it to
move something along a path or to place labels on it. A length of 0 or less gives the start; a
length past the end gives the end, which for a closed figure is the start again.

The forms that return a value write the point into `pt` and return the **tangent**, not the
point.

| Parameter | Meaning |
| --- | --- |
| `length` | The distance to walk. |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely curves are followed. |
| `point`, `pt` | Receives the point. |
| `unitTangentVector` | Receives the direction, a vector of length 1. |

**Returns** `S_OK` or the failing `HRESULT`, or the tangent vector.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim shape as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 50 ) )
dim pt as D2D1_POINT_2F, tangent as D2D1_POINT_2F
shape.ComputePointAtLength( 120, D2D1_IdentityMatrix(), pt, tangent )
print pt.x; pt.y; " heading"; tangent.x; tangent.y      ' 100 20 heading 0 1
```

Microsoft Learn: [ID2D1Geometry::ComputePointAtLength](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-computepointatlength%28float_constd2d1_matrix_3x2_f_float_d2d1_point_2f_d2d1_point_2f%29)

### Widen

```freebasic
function Widen( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Widen( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Widen( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F, byval flatteningTolerance as FLOAT ) as ID2D1SimplifiedGeometrySink ptr
function Widen( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval flatteningTolerance as FLOAT ) as ID2D1SimplifiedGeometrySink ptr
function Widen( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Widen( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr, byval geometrySink as ID2D1SimplifiedGeometrySink ptr ) as HRESULT
function Widen( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byref worldTransform as const D2D1_MATRIX_3X2_F ) as ID2D1SimplifiedGeometrySink ptr
function Widen( byval strokeWidth as FLOAT, byval strokeStyle as ID2D1StrokeStyle ptr, byval worldTransform as const D2D1_MATRIX_3X2_F ptr ) as ID2D1SimplifiedGeometrySink ptr
```

Turns the outline that a pen `strokeWidth` DIPs wide would draw into a shape of its own and
writes it into `geometrySink`. Filling the result paints what `DrawGeometry` would; the shape can
then be measured, hit-tested or combined like any other.

The forms that return a sink take none and pass Direct2D a null one; the call ends the program
with an access violation.

| Parameter | Meaning |
| --- | --- |
| `strokeWidth` | The width of the pen. |
| `strokeStyle` | Caps, joins and dashes, or `NULL` for a plain solid line. |
| `worldTransform` | The transform applied to the geometry first. |
| `flatteningTolerance` | How closely curves are followed. |
| `geometrySink` | Receives the shape; usually the sink of a new path, passed as `*sink`. |

**Returns** `S_OK` or the failing `HRESULT`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim square as CID2D1RectangleGeometry = factory.CreateRectangleGeometry( D2D1_RectF( 0, 0, 100, 100 ) )
dim frame as CID2D1PathGeometry = factory.CreatePathGeometry()
dim sink as CID2D1GeometrySink = frame.Open()
square.Widen( 10, NULL, D2D1_IdentityMatrix(), *sink )
sink.Close()
print frame.ComputeArea( D2D1_IdentityMatrix() )      ' 4000
```

Microsoft Learn: [ID2D1Geometry::Widen](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1geometry-widen%28float_id2d1strokestyle_constd2d1_matrix_3x2_f_float_id2d1simplifiedgeometrysink%29)

## See also

- [Direct2D geometries](SysWin-Direct2D-Geometries) for the rectangle, ellipse, path, group and transformed geometry classes, and the sinks that build paths
- [CD2D1Factory](CD2D1Factory), which makes geometries
- [CID2D1RenderTarget](CID2D1RenderTarget) for `FillGeometry`, `DrawGeometry`, `CreateMesh` and `FillMesh`
- [Direct2D stroke styles](SysWin-Direct2D-Stroke-Styles) for the `strokeStyle` parameters
- [sys/win/direct2d](SysWin-Direct2D)
