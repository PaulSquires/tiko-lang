[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gdiplus](SysWin-GdiPlus) › **CGpMatrix**

# CGpMatrix

Moves, scales, rotates and shears points with a GDI+ affine transformation matrix.

A `CGpMatrix` wraps one GDI+ `Matrix` object, which it creates in its constructor and deletes in
its destructor. You pass it by address to the calls that take a transformation:
[CGpGraphics](CGpGraphics) `SetTransform` and `MultiplyTransform`,
[CGpGraphicsPath](CGpGraphicsPath) `TransForm`, [CGpRegion](CGpRegion) `Transform`, and the
transform methods of pens and brushes.

**The six numbers.** A matrix holds `m11`, `m12`, `m21`, `m22`, `dx` and `dy`. A point
(`x`, `y`) becomes

```text
x' = x * m11 + y * m21 + dx
y' = x * m12 + y * m22 + dy
```

so `m11` … `m22` scale, rotate and shear, and `dx`, `dy` move. A new matrix is the identity
(1, 0, 0, 1, 0, 0), which leaves every point where it is.

**Order.** [Translate](#translate), [Scale](#scale), [Rotate](#rotate), [RotateAt](#rotateat),
[Shear](#shear) and [Multiply](#multiply) combine a new operation with the matrix. With
`MatrixOrderPrepend` (the default) the new operation is applied to a point **before** the ones
already in the matrix; with `MatrixOrderAppend` it is applied **after** them. So a matrix built
with `Scale( 2, 2 )` and then `Translate( 10, 0 )` (both prepended) moves a point first and
scales it second. Angles are in degrees, clockwise on the screen, because y grows downwards.

**Lifetime.** Never copy a `CGpMatrix` by value (`dim b as CGpMatrix = a`, or a `byval`
parameter): the copy holds the same GDI+ object and deletes it when it goes, which leaves the
original unusable. To make an independent copy pass the address, `dim b as CGpMatrix = @a`, or
use [Clone](#clone).

**Status.** The methods that change the matrix return a `GpStatus`: `Ok` (0) on success,
otherwise the reason, such as `InvalidParameter` (2). The status is also stored, and
`GetLastStatus()`, which every `CGp*` class inherits, returns it; getters that return a value
store theirs too. GDI+ itself is started and stopped by the `CGp*` objects as they come and go;
see [CGpGraphics](CGpGraphics) and [GDI+ procedures](SysWin-GdiPlus-Procedures).

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus
```

## Example

A window that draws one rectangle six times, each copy turned 30 degrees further about the same
centre. The matrix scales 96-DPI units to pixels last, after the rotation:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/gdiplus"
using win, gui, gdiplus

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim token as ULONG_PTR = gdiplus.Init()
    dim pWindow as CWindow = "MatrixDemo"
    pWindow.Create( NULL, "CGpMatrix", @WndProc )
    pWindow.SetClientSize( 360, 240 )
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
                graphics.Clear( ARGB_WHITE )
                dim ratio as single = graphics.GetDpiX() / 96
                dim pen as CGpPen = CGpPen( ARGB_DARKSLATEBLUE, 2 )
                dim centre as GpPointF = type<GpPointF>( 180, 120 )
                for i as long = 0 to 5
                    dim matrix as CGpMatrix
                    matrix.Scale( ratio, ratio )            ' applied last
                    matrix.RotateAt( i * 30, @centre )      ' prepended: applied first
                    graphics.SetTransform( @matrix )
                    graphics.DrawRectangle( @pen, 100, 100, 160, 40 )
                next
                graphics.ResetTransform()
            end scope
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

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates an identity matrix, a copy, or a matrix from six numbers or a parallelogram. |
| [Destructor](#destructor) | Deletes the GDI+ matrix. |
| [Clone](#clone) | Copies this matrix into another `CGpMatrix`. |
| [GetElements](#getelements) | Reads the six numbers into an array. |
| [SetElements](#setelements) | Replaces the six numbers. |
| [OffsetX](#offsetx) | Returns the horizontal translation, `dx`. |
| [OffsetY](#offsety) | Returns the vertical translation, `dy`. |
| [Reset](#reset) | Makes the matrix the identity again. |
| [Multiply](#multiply) | Combines the matrix with another one. |
| [Translate](#translate) | Adds a move. |
| [Scale](#scale) | Adds a scaling. |
| [Rotate](#rotate) | Adds a rotation about the origin. |
| [RotateAt](#rotateat) | Adds a rotation about a given point. |
| [Shear](#shear) | Adds a shear. |
| [Invert](#invert) | Replaces the matrix with its inverse. |
| [TransformPoints](#transformpoints) | Applies the matrix to an array of points. |
| [TransformVectors](#transformvectors) | Applies the matrix to an array of vectors, without the translation. |
| [IsInvertible](#isinvertible) | Tells whether the matrix has an inverse. |
| [IsIdentity](#isidentity) | Tells whether the matrix is the identity. |
| [Equals](#equals) | Tells whether two matrices hold the same numbers. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval pMatrix as CGpMatrix ptr )
constructor( byval m11 as single, byval m12 as single, byval m21 as single, byval m22 as single, byval dx as single, byval dy as single )
constructor( byval rcf as GpRectF ptr, byval dstplg as GpPointF ptr )
constructor( byval rc as GpRect ptr, byval dstplg as GpPoint ptr )
```

Creates the GDI+ matrix.

- With no argument it is the identity matrix.
- With a pointer to another `CGpMatrix` it is an independent copy of that matrix. The pointer
  must not be `NULL`.
- With six numbers it holds exactly those, in the order shown in the introduction.
- With a rectangle and three points it maps the rectangle onto a parallelogram: `dstplg` points
  to an array of three points, where the rectangle's top-left, top-right and bottom-left corners
  go. The bottom-right corner follows from the other three.

`GetLastStatus()` tells whether the matrix was created.

| Parameter | Meaning |
| --- | --- |
| `pMatrix` | The matrix to copy. |
| `m11`, `m12`, `m21`, `m22` | The scaling, rotation and shearing part. |
| `dx`, `dy` | The translation. |
| `rcf`, `rc` | The source rectangle. |
| `dstplg` | An array of three destination points. |

**Example**

```freebasic
dim rc as GpRectF = type<GpRectF>( 0, 0, 10, 10 )
dim plg(0 to 2) as GpPointF = { (100, 100), (120, 100), (100, 130) }
dim m as CGpMatrix = CGpMatrix( @rc, @plg(0) )
dim pt as GpPointF = type<GpPointF>( 10, 10 )
m.TransformPoints( @pt )
print pt.x; pt.y                            ' 120 130
```

Microsoft Learn: [Matrix::Matrix](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-matrix%28constrectf__constpointf%29)

### Destructor

```freebasic
destructor
```

Deletes the GDI+ matrix. Objects that were given the matrix (a graphics transform, a path that
was transformed) keep their own copy of the numbers and are not affected.

**Example**

```freebasic
dim pM as CGpMatrix ptr = new CGpMatrix( 2, 0, 0, 2, 0, 0 )
print pM->IsIdentity()                      ' false
delete pM
```

### Clone

```freebasic
function Clone( byval pMatrix as CGpMatrix ptr ) as GpStatus
```

Copies this matrix into the existing `CGpMatrix` that `pMatrix` points to. The GDI+ matrix the
target held is deleted first.

| Parameter | Meaning |
| --- | --- |
| `pMatrix` | The object that receives the copy. |

**Returns** `Ok` on success; `InvalidParameter` when `pMatrix` is `NULL`.

**Example**

```freebasic
dim m as CGpMatrix
m.Rotate( 45 )
dim copy as CGpMatrix
if m.Clone( @copy ) = Ok then print copy.Equals( @m )   ' true
```

Microsoft Learn: [Matrix::Clone](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-clone)

### GetElements

```freebasic
function GetElements( byval m as single ptr ) as GpStatus
```

Copies the six numbers into an array of six `single` values that `m` points to, in the order
`m11`, `m12`, `m21`, `m22`, `dx`, `dy`.

| Parameter | Meaning |
| --- | --- |
| `m` | The first of six `single` values. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix = CGpMatrix( 1, 2, 3, 4, 5, 6 )
dim e(0 to 5) as single
m.GetElements( @e(0) )
print e(0); e(1); e(2); e(3); e(4); e(5)    ' 1 2 3 4 5 6
```

Microsoft Learn: [Matrix::GetElements](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-getelements)

### SetElements

```freebasic
function SetElements( byval m11 as single, byval m12 as single, byval m21 as single, byval m22 as single, byval dx as single, byval dy as single ) as GpStatus
```

Replaces all six numbers of the matrix.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix
m.SetElements( 1, 0, 0, 1, 7, 8 )
print m.OffsetX(); m.OffsetY()              ' 7 8
```

Microsoft Learn: [Matrix::SetElements](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-setelements)

### OffsetX

```freebasic
function OffsetX() as single
```

Returns `dx`, the horizontal translation.

**Returns** the value, or 0 when the elements could not be read.

**Example**

```freebasic
dim m as CGpMatrix
m.Translate( 10, 20 )
print m.OffsetX()                           ' 10
```

Microsoft Learn: [Matrix::OffsetX](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-offsetx)

### OffsetY

```freebasic
function OffsetY() as single
```

Returns `dy`, the vertical translation.

**Returns** the value, or 0 when the elements could not be read.

**Example**

```freebasic
dim m as CGpMatrix
m.Translate( 10, 20 )
print m.OffsetY()                           ' 20
```

Microsoft Learn: [Matrix::OffsetY](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-offsety)

### Reset

```freebasic
function Reset() as GpStatus
```

Sets the matrix back to the identity (1, 0, 0, 1, 0, 0).

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix = CGpMatrix( 2, 0, 0, 2, 5, 5 )
m.Reset()
print m.IsIdentity()                        ' true
```

Microsoft Learn: [Matrix::Reset](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-reset)

### Multiply

```freebasic
function Multiply( byval pMatrix as CGpMatrix ptr, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Combines this matrix with another one and keeps the product. With `MatrixOrderPrepend` the
other matrix is applied to points first, with `MatrixOrderAppend` last. `pMatrix` must not be
`NULL`.

| Parameter | Meaning |
| --- | --- |
| `pMatrix` | The matrix to combine with. |
| `order` | `MatrixOrderPrepend` (the default) or `MatrixOrderAppend`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim t as CGpMatrix
t.Translate( 10, 0 )
dim s as CGpMatrix
s.Scale( 2, 2 )
t.Multiply( @s )                            ' scale first, then move
dim pt as GpPointF = type<GpPointF>( 1, 1 )
t.TransformPoints( @pt )
print pt.x; pt.y                            ' 12 2
```

Microsoft Learn: [Matrix::Multiply](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-multiply)

### Translate

```freebasic
function Translate( byval nOffsetX as single, byval nOffsetY as single, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Combines the matrix with a move by `nOffsetX`, `nOffsetY`.

| Parameter | Meaning |
| --- | --- |
| `nOffsetX`, `nOffsetY` | The distances to move. |
| `order` | `MatrixOrderPrepend` (the default) or `MatrixOrderAppend`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix
m.Scale( 2, 3 )
m.Translate( 5, 5 )                         ' prepended: moved, then scaled
dim pt as GpPointF = type<GpPointF>( 0, 0 )
m.TransformPoints( @pt )
print pt.x; pt.y                            ' 10 15
```

Microsoft Learn: [Matrix::Translate](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-translate)

### Scale

```freebasic
function Scale( byval scaleX as single, byval scaleY as single, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Combines the matrix with a scaling by `scaleX` horizontally and `scaleY` vertically, about the
origin. A negative factor mirrors.

| Parameter | Meaning |
| --- | --- |
| `scaleX`, `scaleY` | The factors. |
| `order` | `MatrixOrderPrepend` (the default) or `MatrixOrderAppend`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix
m.Scale( 2, 2 )
m.Rotate( 90, MatrixOrderAppend )           ' scaled, then rotated
dim pt as GpPointF = type<GpPointF>( 1, 0 )
m.TransformPoints( @pt )                    ' (0, 2) give or take rounding
```

Microsoft Learn: [Matrix::Scale](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-scale)

### Rotate

```freebasic
function Rotate( byval angle as single, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Combines the matrix with a rotation by `angle` degrees about the origin, clockwise on the
screen.

| Parameter | Meaning |
| --- | --- |
| `angle` | The angle in degrees. |
| `order` | `MatrixOrderPrepend` (the default) or `MatrixOrderAppend`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix
m.Translate( 10, 20 )
m.Rotate( 90 )                              ' rotated, then moved
dim pt as GpPointF = type<GpPointF>( 1, 0 )
m.TransformPoints( @pt )
print pt.x; pt.y                            ' 10 21
```

Microsoft Learn: [Matrix::Rotate](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-rotate)

### RotateAt

```freebasic
function RotateAt( byval angle as single, byval center as GpPointF ptr, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Combines the matrix with a rotation by `angle` degrees about the point `center`. It is made of
three steps (a move of `center` to the origin, the rotation, and the move back), combined in the
order that `order` asks for; only the status of the last step is returned.

| Parameter | Meaning |
| --- | --- |
| `angle` | The angle in degrees, clockwise. |
| `center` | The point to rotate about. |
| `order` | `MatrixOrderPrepend` (the default) or `MatrixOrderAppend`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix
dim centre as GpPointF = type<GpPointF>( 10, 10 )
m.RotateAt( 90, @centre )
dim pt as GpPointF = type<GpPointF>( 20, 10 )
m.TransformPoints( @pt )                    ' (10, 20) give or take rounding
```

Microsoft Learn: [Matrix::RotateAt](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-rotateat)

### Shear

```freebasic
function Shear( byval shearX as single, byval shearY as single, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Combines the matrix with a shear: `shearX` moves each point sideways by `shearX` times its y
coordinate, and `shearY` moves it vertically by `shearY` times its x coordinate.

| Parameter | Meaning |
| --- | --- |
| `shearX`, `shearY` | The shear factors. |
| `order` | `MatrixOrderPrepend` (the default) or `MatrixOrderAppend`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix
m.Shear( 1, 0 )
dim pt as GpPointF = type<GpPointF>( 0, 10 )
m.TransformPoints( @pt )
print pt.x; pt.y                            ' 10 10
```

Microsoft Learn: [Matrix::Shear](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-shear)

### Invert

```freebasic
function Invert() as GpStatus
```

Replaces the matrix with its inverse, the matrix that undoes it. A matrix that has no inverse
(see [IsInvertible](#isinvertible)) is left unchanged.

**Returns** `Ok` on success; `InvalidParameter` when the matrix has no inverse.

**Example**

```freebasic
dim m as CGpMatrix
m.Rotate( 30 )
dim undo as CGpMatrix = @m
if undo.Invert() = Ok then print "inverse ready"
```

Microsoft Learn: [Matrix::Invert](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-invert)

### TransformPoints

```freebasic
function TransformPoints( byval pts as GpPointF ptr, byval nCount as INT_ = 1 ) as GpStatus
function TransformPoints( byval pts as GpPoint ptr, byval nCount as INT_ = 1 ) as GpStatus
```

Applies the matrix to `nCount` points in place, translation included. With `GpPoint` the
results are rounded to whole numbers.

| Parameter | Meaning |
| --- | --- |
| `pts` | The first point of the array; the points are overwritten. |
| `nCount` | How many points; 1 by default. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix
m.Translate( 5, 5 )
dim pts(0 to 1) as GpPoint = { (0, 0), (10, 10) }
m.TransformPoints( @pts(0), 2 )             ' (5, 5) and (15, 15)
```

Microsoft Learn: [Matrix::TransformPoints](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-transformpoints%28pointf_int%29)

### TransformVectors

```freebasic
function TransformVectors( byval pts as GpPointF ptr, byval nCount as INT_ = 1 ) as GpStatus
function TransformVectors( byval pts as GpPoint ptr, byval nCount as INT_ = 1 ) as GpStatus
```

Applies the matrix to `nCount` vectors in place, leaving out `dx` and `dy`: a direction or a
distance is scaled, rotated and sheared but not moved.

| Parameter | Meaning |
| --- | --- |
| `pts` | The first vector of the array; the vectors are overwritten. |
| `nCount` | How many vectors; 1 by default. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim m as CGpMatrix
m.Translate( 10, 20 )
m.Rotate( 90 )
dim v as GpPointF = type<GpPointF>( 1, 0 )
m.TransformVectors( @v )                    ' (0, 1): turned, not moved
```

Microsoft Learn: [Matrix::TransformVectors](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-transformvectors%28pointf_int%29)

### IsInvertible

```freebasic
function IsInvertible() as boolean
```

Tells whether the matrix has an inverse. A matrix that squashes the plane onto a line, such as
(1, 2, 2, 4, 0, 0), has none.

**Returns** `true` if it is invertible.

**Example**

```freebasic
dim m as CGpMatrix = CGpMatrix( 1, 2, 2, 4, 0, 0 )
print m.IsInvertible()                      ' false
```

Microsoft Learn: [Matrix::IsInvertible](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-isinvertible)

### IsIdentity

```freebasic
function IsIdentity() as boolean
```

Tells whether the matrix is the identity. The test is on the stored numbers, so a matrix that
was rotated and rotated back may differ from the identity by rounding.

**Returns** `true` if it is the identity.

**Example**

```freebasic
dim m as CGpMatrix
print m.IsIdentity()                        ' true
```

Microsoft Learn: [Matrix::IsIdentity](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-isidentity)

### Equals

```freebasic
function Equals( byval pMatrix as CGpMatrix ptr ) as boolean
```

Tells whether this matrix and the one `pMatrix` points to hold the same six numbers.

| Parameter | Meaning |
| --- | --- |
| `pMatrix` | The matrix to compare with. |

**Returns** `true` if they are equal; `false` when they differ or `pMatrix` is `NULL`.

**Example**

```freebasic
dim a as CGpMatrix = CGpMatrix( 2, 0, 0, 2, 0, 0 )
dim b as CGpMatrix
b.Scale( 2, 2 )
print a.Equals( @b )                        ' true
```

Microsoft Learn: [Matrix::Equals](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusmatrix/nf-gdiplusmatrix-matrix-equals)

## See also

- [CGpGraphics](CGpGraphics) for the world transformation a matrix is set as
- [CGpGraphicsPath](CGpGraphicsPath) and [CGpRegion](CGpRegion), which a matrix transforms
- [sys/win/gdiplus](SysWin-GdiPlus)
