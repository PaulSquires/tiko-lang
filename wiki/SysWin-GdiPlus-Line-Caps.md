[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gdiplus](SysWin-GdiPlus) › **GDI+ line caps**

# GDI+ line caps
Draws arrow heads and shapes of your own at the ends of lines drawn with a GDI+ pen.

<!-- scope: CGpCustomLineCap -->
<!-- scope: CGpAdjustableArrowCap -->

Draws arrow heads and shapes of your own at the ends of lines drawn with a GDI+ pen.

A [CGpPen](CGpPen) has standard caps (`LineCapRound`, `LineCapArrowAnchor` …) that need no
object. For anything else, make a cap object and give it to the pen with `SetCustomStartCap` or
`SetCustomEndCap`:

- [CGpAdjustableArrowCap](#cgpadjustablearrowcap) is an arrow head whose height, width, notch
  and fill you choose.
- [CGpCustomLineCap](#cgpcustomlinecap) is any shape, given as a
  [CGpGraphicsPath](CGpGraphicsPath) that is either filled or stroked.

**The cap's coordinates.** A cap is drawn in its own coordinate system: the origin is the end of
the line, the positive y axis points onwards in the direction the line was going, and one unit is
one pen width (times the [width scale](#setwidthscale-getwidthscale)). So a stroke path from
(-3, 0) to (0, 3) to (3, 0) draws a "V" whose point is three pen widths beyond the end of the
line, and a cap drawn with a pen twice as wide is twice as big. The same cap at the start of a
line points backwards, away from the line.

**Lifetime.** Each object wraps one GDI+ cap, which its constructor creates and the
`CGpCustomLineCap` destructor deletes. A pen keeps its own copy of a cap it is given, so the cap
object can go out of scope while the pen is in use, and changing the cap afterwards does not
change the pen: set it again. Never copy a cap object by value; pass its address, as in
`dim b as CGpCustomLineCap = @a`, or use [Clone](#clone).

**Status.** The setters return a `GpStatus`: `Ok` (0) on success, otherwise the reason. The
status is also stored, and `GetLastStatus()`, which every `CGp*` class inherits, returns it;
getters that return a value store theirs too.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus
```

## Example

A window with four lines: a filled arrow head, an open one, a notched one, and a custom stroked
"V" cap at both ends:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/gdiplus"
using win, gui, gdiplus

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim token as ULONG_PTR = gdiplus.Init()
    dim pWindow as CWindow = "CapDemo"
    pWindow.Create( NULL, "GDI+ line caps", @WndProc )
    pWindow.SetClientSize( 360, 200 )
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
                graphics.ScaleTransformForDpi()
                dim pen as CGpPen = CGpPen( ARGB_DARKSLATEBLUE, 3 )

                dim filled as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 5, 4 )
                pen.SetCustomEndCap( @filled )
                graphics.DrawLine( @pen, 30, 30, 320, 30 )

                dim hollow as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 5, 4, FALSE )
                pen.SetCustomEndCap( @hollow )
                graphics.DrawLine( @pen, 30, 75, 320, 75 )

                dim notched as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 5, 4 )
                notched.SetMiddleInset( 2 )
                pen.SetCustomEndCap( @notched )
                graphics.DrawLine( @pen, 30, 120, 320, 120 )

                dim v as CGpGraphicsPath
                v.AddLine( -2, 0, 0, 2 )
                v.AddLine( 0, 2, 2, 0 )
                dim vcap as CGpCustomLineCap = CGpCustomLineCap( NULL, @v )
                vcap.SetStrokeCap( LineCapRound )
                pen.SetCustomStartCap( @vcap )
                pen.SetCustomEndCap( @vcap )
                graphics.DrawLine( @pen, 40, 165, 310, 165 )
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
| **CGpCustomLineCap** | |
| [Constructor](#constructor) | Creates an empty object, a copy, or a cap from a fill path or a stroke path. |
| [Destructor](#destructor) | Deletes the GDI+ cap. |
| [SetStrokeCaps, GetStrokeCaps](#setstrokecaps-getstrokecaps) | Sets or reads the caps of the lines a stroked cap is drawn with. |
| [SetStrokeCap](#setstrokecap) | Sets both of those caps to one style. |
| [SetStrokeJoin, GetStrokeJoin](#setstrokejoin-getstrokejoin) | Sets or reads how the lines of a stroked cap are joined. |
| [SetBaseCap, GetBaseCap](#setbasecap-getbasecap) | Sets or reads the standard cap drawn under the custom one. |
| [SetBaseInset, GetBaseInset](#setbaseinset-getbaseinset) | Sets or reads how far the line is cut back for the cap. |
| [SetWidthScale, GetWidthScale](#setwidthscale-getwidthscale) | Sets or reads the size of the cap relative to the pen width. |
| [Clone](#clone) | Copies this cap into another object. |
| **CGpAdjustableArrowCap** | |
| [Constructor](#constructor-1) | Creates an arrow head of a given height and width, or a copy. |
| [SetHeight, GetHeight](#setheight-getheight) | Sets or reads the length of the arrow head. |
| [SetWidth, GetWidth](#setwidth-getwidth) | Sets or reads the width across the base of the arrow head. |
| [SetMiddleInset, GetMiddleInset](#setmiddleinset-getmiddleinset) | Sets or reads how deep the notch in the base is. |
| [SetFillState, IsFilled](#setfillstate-isfilled) | Makes the arrow head filled or an outline, or reads which. |

## Reference

## CGpCustomLineCap

A cap of any shape, defined by a path in the cap's coordinates. A fill path is filled with the
pen's colour; a stroke path is drawn with the pen, using the [stroke caps](#setstrokecaps-getstrokecaps)
and [join](#setstrokejoin-getstrokejoin) set here. Pass one of the two paths and `NULL` for the
other.

### Constructor

```freebasic
constructor
constructor( byval pCustomLineCap as CGpCustomLineCap ptr )
constructor( byval pFillPath as CGpGraphicsPath_ ptr, byval pStrokePath as CGpGraphicsPath_ ptr, byval baseCap as LineCap = LinecapFLat, byval baseInset as single = 0.0 )
```

Creates the GDI+ cap.

- With no argument the object holds no cap: calls on it fail with `InvalidParameter` until
  [Clone](#clone) or a pen's `GetCustomStartCap` / `GetCustomEndCap` fills it.
- With a pointer to another cap it is an independent copy. The pointer must not be `NULL`.
- With paths it is a cap of that shape. The cap keeps its own copy of the path.

| Parameter | Meaning |
| --- | --- |
| `pCustomLineCap` | The cap to copy. |
| `pFillPath` | A path to fill, or `NULL`. |
| `pStrokePath` | A path to stroke, or `NULL`. |
| `baseCap` | A standard cap drawn at the end of the line under the custom one: `LineCapFlat` (the default), `LineCapSquare`, `LineCapRound` or `LineCapTriangle`. |
| `baseInset` | How far, in pen widths, the line is cut back before the cap; 0 by default. |

**Example**

```freebasic
dim v as CGpGraphicsPath
v.AddLine( -3, 0, 0, 3 )
v.AddLine( 0, 3, 3, 0 )
dim cap as CGpCustomLineCap = CGpCustomLineCap( NULL, @v )
print cap.GetLastStatus(); cap.GetWidthScale()      ' 0 1
```

Microsoft Learn: [CustomLineCap::CustomLineCap](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusheaders/nf-gdiplusheaders-customlinecap-customlinecap%28constgraphicspath_constgraphicspath_linecap_real%29)

### Destructor

```freebasic
destructor
```

Deletes the GDI+ cap. Pens that were given the cap keep their own copy. `CGpAdjustableArrowCap`
uses this destructor.

**Example**

```freebasic
dim pCap as CGpAdjustableArrowCap ptr = new CGpAdjustableArrowCap( 5, 4 )
dim pen as CGpPen = CGpPen( ARGB_BLACK, 2 )
pen.SetCustomEndCap( pCap )
delete pCap                                         ' the pen keeps its copy
```

### SetStrokeCaps, GetStrokeCaps

```freebasic
function SetStrokeCaps( byval startCap as LineCap, byval endCap as LineCap ) as GpStatus
function GetStrokeCaps( byval startCap as LineCap ptr, byval endCap as LineCap ptr ) as GpStatus
```

A stroked cap is drawn as lines; these are the caps at the start and end of those lines, both
`LineCapFlat` for a new cap. `GetStrokeCaps` stores them in two variables.

| Parameter | Meaning |
| --- | --- |
| `startCap`, `endCap` | The caps, or the variables that receive them. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim v as CGpGraphicsPath
v.AddLine( -3, 0, 0, 3 )
dim cap as CGpCustomLineCap = CGpCustomLineCap( NULL, @v )
cap.SetStrokeCaps( LineCapFlat, LineCapTriangle )
dim as LineCap s, e
cap.GetStrokeCaps( @s, @e )
print s; e                                          ' 0 3
```

Microsoft Learn: [CustomLineCap::SetStrokeCaps](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusheaders/nf-gdiplusheaders-customlinecap-setstrokecaps)

### SetStrokeCap

```freebasic
function SetStrokeCap( byval strokeCap as LineCap ) as GpStatus
```

Sets the start and end caps of a stroked cap's lines to the same style: `LineCapRound` softens
the ends of a "V".

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim v as CGpGraphicsPath
v.AddLine( -3, 0, 0, 3 )
dim cap as CGpCustomLineCap = CGpCustomLineCap( NULL, @v )
cap.SetStrokeCap( LineCapRound )
dim as LineCap s, e
cap.GetStrokeCaps( @s, @e )
print s; e                                          ' 2 2
```

Microsoft Learn: [CustomLineCap::SetStrokeCap](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusheaders/nf-gdiplusheaders-customlinecap-setstrokecap)

### SetStrokeJoin, GetStrokeJoin

```freebasic
function SetStrokeJoin( byval nLineJoin as LineJoin ) as GpStatus
function GetStrokeJoin() as LineJoin
```

`SetStrokeJoin` sets how the lines of a stroked cap meet at corners: `LineJoinMiter` (the
default), `LineJoinBevel`, `LineJoinRound` or `LineJoinMiterClipped`. `GetStrokeJoin` returns
it.

| Parameter | Meaning |
| --- | --- |
| `nLineJoin` | The join. |

**Returns** `SetStrokeJoin`: `Ok` on success, otherwise the error. `GetStrokeJoin`: the join.

**Example**

```freebasic
dim v as CGpGraphicsPath
v.AddLine( -3, 0, 0, 3 )
v.AddLine( 0, 3, 3, 0 )
dim cap as CGpCustomLineCap = CGpCustomLineCap( NULL, @v )
cap.SetStrokeJoin( LineJoinRound )
print cap.GetStrokeJoin()                           ' 2
```

Microsoft Learn: [CustomLineCap::SetStrokeJoin](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusheaders/nf-gdiplusheaders-customlinecap-setstrokejoin)

### SetBaseCap, GetBaseCap

```freebasic
function SetBaseCap( byval baseCap as LineCap ) as GpStatus
function GetBaseCap() as LineCap
```

`SetBaseCap` sets the standard cap drawn at the end of the line, under the custom shape.
`GetBaseCap` returns it: `LineCapFlat` (0) unless the constructor was given one, and
`LineCapTriangle` (3) for an arrow cap.

| Parameter | Meaning |
| --- | --- |
| `baseCap` | `LineCapFlat`, `LineCapSquare`, `LineCapRound` or `LineCapTriangle`. |

**Returns** `SetBaseCap`: `Ok` on success, otherwise the error. `GetBaseCap`: the cap.

**Example**

```freebasic
dim v as CGpGraphicsPath
v.AddLine( -3, 0, 0, 3 )
dim cap as CGpCustomLineCap = CGpCustomLineCap( NULL, @v )
cap.SetBaseCap( LineCapTriangle )
print cap.GetBaseCap()                              ' 3
```

Microsoft Learn: [CustomLineCap::SetBaseCap](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusheaders/nf-gdiplusheaders-customlinecap-setbasecap)

### SetBaseInset, GetBaseInset

```freebasic
function SetBaseInset( byval inset as single ) as GpStatus
function GetBaseInset() as single
```

`SetBaseInset` sets how far, in pen widths, the line stops short of its end point to make room
for the cap. `GetBaseInset` returns it: 0 for a new custom cap; an arrow cap works out its own.

| Parameter | Meaning |
| --- | --- |
| `inset` | The distance. |

**Returns** `SetBaseInset`: `Ok` on success, otherwise the error. `GetBaseInset`: the inset.

**Example**

```freebasic
dim v as CGpGraphicsPath
v.AddLine( -3, 0, 0, 3 )
dim cap as CGpCustomLineCap = CGpCustomLineCap( NULL, @v )
cap.SetBaseInset( 1.5 )
print cap.GetBaseInset()                            ' 1.5
```

Microsoft Learn: [CustomLineCap::SetBaseInset](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusheaders/nf-gdiplusheaders-customlinecap-setbaseinset)

### SetWidthScale, GetWidthScale

```freebasic
function SetWidthScale( byval widthScale as single ) as GpStatus
function GetWidthScale() as single
```

`SetWidthScale` scales the cap relative to the pen width: with 2 the cap is twice as big as its
path says. `GetWidthScale` returns it, 1 for a new cap.

| Parameter | Meaning |
| --- | --- |
| `widthScale` | The scale. |

**Returns** `SetWidthScale`: `Ok` on success, otherwise the error. `GetWidthScale`: the scale,
or 0 when the object holds no cap.

**Example**

```freebasic
dim arrow as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 5, 4 )
arrow.SetWidthScale( 2 )
print arrow.GetWidthScale()                         ' 2
```

Microsoft Learn: [CustomLineCap::SetWidthScale](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusheaders/nf-gdiplusheaders-customlinecap-setwidthscale)

### Clone

```freebasic
function Clone( byval pCustomLineCap as CGpCustomLineCap ptr ) as GpStatus
```

Copies this cap into the existing object that `pCustomLineCap` points to, usually an empty
`CGpCustomLineCap`. The GDI+ cap the target held is deleted first.

| Parameter | Meaning |
| --- | --- |
| `pCustomLineCap` | The object that receives the copy. |

**Returns** `Ok` on success; `InvalidParameter` when the pointer is `NULL`.

**Example**

```freebasic
dim arrow as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 5, 4 )
arrow.SetWidthScale( 2 )
dim copy as CGpCustomLineCap
if arrow.Clone( @copy ) = Ok then print copy.GetWidthScale()   ' 2
```

Microsoft Learn: [CustomLineCap::Clone](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusheaders/nf-gdiplusheaders-customlinecap-clone)

## CGpAdjustableArrowCap

An arrow head, derived from `CGpCustomLineCap`, whose tip is at the end of the line. Its height
and width are in pen widths, like every cap. The members of `CGpCustomLineCap` work on it too.

### Constructor

```freebasic
constructor( byval pAdjustableArrowCap as CGpAdjustableArrowCap ptr )
constructor( byval nHeight as single, byval nWidth as single, byval isFilled as BOOL = CTRUE )
```

Creates an arrow head `nHeight` pen widths long and `nWidth` pen widths across, filled unless
`isFilled` is `FALSE`, with no notch; or an independent copy of another arrow cap, whose pointer
must not be `NULL`. There is no constructor without arguments.

| Parameter | Meaning |
| --- | --- |
| `pAdjustableArrowCap` | The arrow cap to copy. |
| `nHeight` | The distance from the base of the arrow head to its tip. |
| `nWidth` | The width of the base. |
| `isFilled` | `CTRUE` (the default) for a solid arrow head, `FALSE` for an outline. |

**Example**

```freebasic
dim arrow as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 6, 4 )
dim pen as CGpPen = CGpPen( ARGB_BLACK, 2 )
pen.SetCustomEndCap( @arrow )
print arrow.GetHeight(); arrow.GetWidth(); " "; arrow.IsFilled()   ' 6 4 true
```

Microsoft Learn: [AdjustableArrowCap::AdjustableArrowCap](https://learn.microsoft.com/en-us/windows/win32/api/gdipluslinecaps/nf-gdipluslinecaps-adjustablearrowcap-adjustablearrowcap%28real_real_bool%29)

### SetHeight, GetHeight

```freebasic
function SetHeight( byval nHeight as single ) as GpStatus
function GetHeight() as single
```

`SetHeight` sets the distance from the base of the arrow head to its tip, in pen widths.
`GetHeight` returns it.

| Parameter | Meaning |
| --- | --- |
| `nHeight` | The new height. |

**Returns** `SetHeight`: `Ok` on success, otherwise the error. `GetHeight`: the height.

**Example**

```freebasic
dim arrow as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 6, 4 )
arrow.SetHeight( 10 )
print arrow.GetHeight()                             ' 10
```

Microsoft Learn: [AdjustableArrowCap::SetHeight](https://learn.microsoft.com/en-us/windows/win32/api/gdipluslinecaps/nf-gdipluslinecaps-adjustablearrowcap-setheight)

### SetWidth, GetWidth

```freebasic
function SetWidth( byval nWidth as single ) as GpStatus
function GetWidth() as single
```

`SetWidth` sets the width of the arrow head's base, from one corner to the other, in pen widths.
`GetWidth` returns it.

| Parameter | Meaning |
| --- | --- |
| `nWidth` | The new width. |

**Returns** `SetWidth`: `Ok` on success, otherwise the error. `GetWidth`: the width.

**Example**

```freebasic
dim arrow as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 6, 4 )
arrow.SetWidth( 8 )
print arrow.GetWidth()                              ' 8
```

Microsoft Learn: [AdjustableArrowCap::SetWidth](https://learn.microsoft.com/en-us/windows/win32/api/gdipluslinecaps/nf-gdipluslinecaps-adjustablearrowcap-setwidth)

### SetMiddleInset, GetMiddleInset

```freebasic
function SetMiddleInset( byval middleInset as single ) as GpStatus
function GetMiddleInset() as single
```

`SetMiddleInset` moves the middle of the base towards the tip by `middleInset` pen widths, which
cuts a notch in the back of the arrow head. `GetMiddleInset` returns it, 0 for a new arrow cap.

| Parameter | Meaning |
| --- | --- |
| `middleInset` | The depth of the notch. |

**Returns** `SetMiddleInset`: `Ok` on success, otherwise the error. `GetMiddleInset`: the inset.

**Example**

```freebasic
dim arrow as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 6, 4 )
arrow.SetMiddleInset( 2 )
print arrow.GetMiddleInset()                        ' 2
```

Microsoft Learn: [AdjustableArrowCap::SetMiddleInset](https://learn.microsoft.com/en-us/windows/win32/api/gdipluslinecaps/nf-gdipluslinecaps-adjustablearrowcap-setmiddleinset)

### SetFillState, IsFilled

```freebasic
function SetFillState( byval isFilled as BOOL ) as GpStatus
function IsFilled() as boolean
```

`SetFillState` makes the arrow head solid (`CTRUE`) or an outline drawn with the pen (`FALSE`).
`IsFilled` tells which.

| Parameter | Meaning |
| --- | --- |
| `isFilled` | `CTRUE` or `FALSE`. |

**Returns** `SetFillState`: `Ok` on success, otherwise the error. `IsFilled`: `true` for a solid
arrow head.

**Example**

```freebasic
dim arrow as CGpAdjustableArrowCap = CGpAdjustableArrowCap( 6, 4 )
arrow.SetFillState( FALSE )
print arrow.IsFilled()                              ' false
```

Microsoft Learn: [AdjustableArrowCap::SetFillState](https://learn.microsoft.com/en-us/windows/win32/api/gdipluslinecaps/nf-gdipluslinecaps-adjustablearrowcap-setfillstate)

## See also

- [CGpPen](CGpPen), whose `SetCustomStartCap` and `SetCustomEndCap` take a cap
- [CGpGraphicsPath](CGpGraphicsPath) for the shape of a custom cap
- [sys/win/gdiplus](SysWin-GdiPlus)
