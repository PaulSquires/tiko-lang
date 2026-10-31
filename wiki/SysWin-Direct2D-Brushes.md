[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **Direct2D brushes**

# Direct2D brushes
Paints shapes, lines and text in Direct2D with a colour, a gradient, a bitmap or an image.

<!-- scope: CID2D1GradientStopCollection -->
<!-- scope: CID2D1GradientStopCollection1 -->
<!-- scope: CID2D1SolidColorBrush -->
<!-- scope: CID2D1LinearGradientBrush -->
<!-- scope: CID2D1RadialGradientBrush -->
<!-- scope: CID2D1BitmapBrush -->
<!-- scope: CID2D1BitmapBrush1 -->
<!-- scope: CID2D1ImageBrush -->

Paints shapes, lines and text in Direct2D with a colour, a gradient, a bitmap or an image.

The `Fill…` calls of a render target, and its `Draw…` calls for lines, outlines and text, take a
brush as an `ID2D1Brush ptr`. Each class on this page holds one Direct2D brush interface and converts to `ID2D1Brush ptr` by itself,
so the object is passed as it is: `rt.FillRectangle( 0, 0, 100, 50, brush )`.

| Class | Paints with | Made by |
| --- | --- | --- |
| [CID2D1SolidColorBrush](#cid2d1solidcolorbrush) | one colour | `CreateSolidColorBrush` of a render target |
| [CID2D1LinearGradientBrush](#cid2d1lineargradientbrush) | colours that blend along a line | `CreateLinearGradientBrush` |
| [CID2D1RadialGradientBrush](#cid2d1radialgradientbrush) | colours that blend outwards in an ellipse | `CreateRadialGradientBrush` |
| [CID2D1BitmapBrush](#cid2d1bitmapbrush) | a bitmap, clamped, tiled or mirrored | `CreateBitmapBrush` |
| [CID2D1BitmapBrush1](#cid2d1bitmapbrush1) | a bitmap, with the higher-quality interpolation modes | `CreateBitmapBrush` of a device context |
| [CID2D1ImageBrush](#cid2d1imagebrush) | any image: a bitmap, an effect's output, a command list | `CreateImageBrush` of a device context |

The two gradient brushes take their colours from a **gradient stop collection**,
[CID2D1GradientStopCollection](#cid2d1gradientstopcollection), which one or more brushes can
share; [CID2D1GradientStopCollection1](#cid2d1gradientstopcollection1) is the form a device
context makes. A device context is the `ID2D1DeviceContext` interface of a render target, which
render targets also implement on Windows 8 and later: ask for it with `QueryInterface`, as the
examples below do, and release it when done.

**Ownership.** A brush or a stop collection belongs to the render target that made it and can be
used only with that target (or one sharing its device). Construct the wrapper from the pointer a
`Create…` member returns, at the declaration: the object takes over the reference that came with
it and releases it in its destructor, so nothing else needs releasing.

```freebasic
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( D2D1_ColorF( D2D1_Red ), D2D1_BrushProperties() )
```

To wrap a pointer you go on using yourself, call its `AddRef` first. The `…1` classes add a
reference in their constructor and release one in each destructor, so they take over the
reference in the same way. Never copy or assign a wrapper (`dim b as CID2D1SolidColorBrush = a`
where `a` is a wrapper, `b = a`, or a `byval` parameter): the classes have no copy constructor
or assignment, so both objects hold the same pointer and release it twice, which crashes. Pass
them `byref`, or pass the interface pointer.

**What you must release.** Members that return an interface pointer (`GetFactory`,
`GetGradientStopCollection`, `GetBitmap`, `GetImage`) add a reference to it: release what they
return, or construct a wrapper from it.

**Empty objects.** An object whose pointer is `NULL` does nothing: setters are ignored and getters
return 0 or a zeroed structure. `GetFactory` of the five brush classes is the exception: it is not
guarded and must only be called on an object that holds a brush.

**Brush space.** A gradient or a bitmap is laid out in the brush's own coordinate space, which
the brush transform ([SetTransform](#settransform-gettransform)) and then the render target's
transform map onto the target. It is not relative to the shape being filled: a bitmap brush tiles
from the target's origin, wherever the rectangle is. Coordinates are in device-independent
pixels (DIPs).

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A window with four shapes, one filled by each kind of render-target brush. The scene is drawn
once into the memory device context of a [CGraphCtx](CGraphCtx) control:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/direct2d"
using win, gui, direct2d

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

' Fills four shapes into a GDI device context, one with each kind of brush
function RenderScene( byval hDC as HDC, byval nWidth as long, byval nHeight as long ) as HRESULT
    dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
    if GetLastError() <> S_OK then return GetLastError()
    dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
    if *rt = NULL then return GetLastError()
    rt.BindDC( hDC, 0, 0, nWidth, nHeight )

    ' one colour, made half transparent by the brush opacity
    dim solid as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( D2D1_ColorF( D2D1_SteelBlue ), D2D1_BrushProperties() )
    solid.SetOpacity( 0.5 )

    ' two gradients that share one stop collection, gold to purple
    dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Gold ), D2D1_GradientStop( 1, D2D1_Purple ) }
    dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
    dim linear as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 160, 20, 280, 20, stopColl )
    dim radial as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 80, 160, -20, -20, 60, 50, stopColl )

    ' a 2 x 2 checker bitmap, tiled and enlarged ten times by the brush transform
    dim pixels(3) as ulong = { &hFF2E8B57, &hFFFFFFFF, &hFFFFFFFF, &hFF2E8B57 }
    dim checker as CID2D1Bitmap = rt.CreateBitmap( 2, 2, @pixels(0), 8, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
    dim tiles as CID2D1BitmapBrush = rt.CreateBitmapBrush( checker, D2D1_BitmapBrushProperties( D2D1_EXTEND_MODE_WRAP, D2D1_EXTEND_MODE_WRAP, D2D1_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR ) )
    tiles.SetTransform( D2D1_MatrixScale( 10, 10 ) )

    rt.BeginDraw()
    rt.Clear( D2D1_ColorF( D2D1_White ) )
    rt.FillRectangle( 20, 20, 140, 100, solid )
    rt.FillRectangle( 160, 20, 280, 100, linear )
    rt.FillEllipse( 80, 160, 60, 50, radial )
    rt.FillRoundedRectangle( 160, 120, 280, 200, 10, 10, tiles )
    return rt.EndDraw()
end function

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "D2DBrushDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Direct2D brushes", @WndProc )
    pWindow.SetClientSize( 300, 220 )
    pWindow.Center()
    dim pGraphCtx as CGraphCtx = CGraphCtx( @pWindow, 1001, "", 0, 0, pWindow.ClientWidth, pWindow.ClientHeight )
    RenderScene( pGraphCtx.GetMemDc(), pGraphCtx.GetVirtualBufferWidth(), pGraphCtx.GetVirtualBufferHeight() )
    return pWindow.DoEvents( SW_NORMAL )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

The wrappers are destroyed in reverse order when `RenderScene` returns, and each releases its
interface; the bitmap brush keeps its own reference to the bitmap, the gradient brushes to the
stop collection.

## Members

| Member | Does |
| --- | --- |
| **CID2D1GradientStopCollection** | |
| [Constructor](#constructor) | Wraps a stop collection, taking over its reference. |
| [Destructor](#destructor) | Releases the stop collection. |
| [Cast, Operator @, Operator *](#cast-operator--operator-) | Give the interface pointer, or its address. |
| [GetFactory](#getfactory) | Returns the factory the collection belongs to. |
| [GetGradientStopCount](#getgradientstopcount) | Returns the number of stops. |
| [GetGradientStops](#getgradientstops) | Copies the stops into an array. |
| [GetColorInterpolationGamma](#getcolorinterpolationgamma) | Tells in which gamma the colours are blended. |
| [GetExtendMode](#getextendmode) | Tells what the gradient does outside its range. |
| **CID2D1GradientStopCollection1** | |
| [Constructor](#constructor-1) | Wraps a device-context stop collection, taking over its reference. |
| [Destructor](#destructor-1) | Releases the stop collection. |
| [Cast, Operator @, Operator *](#cast-operator--operator--1) | Give the `ID2D1GradientStopCollection1` pointer, or its address. |
| [GetGradientStops1](#getgradientstops1) | Copies the stops as they were given. |
| [GetPreInterpolationSpace](#getpreinterpolationspace) | Tells the colour space the stops are blended in. |
| [GetPostInterpolationSpace](#getpostinterpolationspace) | Tells the colour space the blended colours end up in. |
| [GetBufferPrecision](#getbufferprecision) | Tells the precision of the gradient's buffer. |
| [GetColorInterpolationMode](#getcolorinterpolationmode) | Tells whether alpha is blended straight or premultiplied. |
| **CID2D1SolidColorBrush** | |
| [Constructor](#constructor-2) | Wraps a solid-colour brush, taking over its reference. |
| [Destructor](#destructor-2) | Releases the brush. |
| [Cast, Operator @, Operator *](#cast-operator--operator--2) | Give the brush pointer, or its address. |
| [GetFactory](#getfactory-1) | Returns the factory the brush belongs to. |
| [SetOpacity, GetOpacity](#setopacity-getopacity) | Set or read how opaque the brush paints. |
| [SetTransform, GetTransform](#settransform-gettransform) | Set or read the brush transform. |
| [SetColor, GetColor](#setcolor-getcolor) | Set or read the colour. |
| **CID2D1LinearGradientBrush** | |
| [Constructor](#constructor-3) | Wraps a linear gradient brush, taking over its reference. |
| [Destructor](#destructor-3) | Releases the brush. |
| [Cast, Operator @, Operator *](#cast-operator--operator--3) | Give the brush pointer, or its address. |
| [GetFactory](#getfactory-2) | Returns the factory the brush belongs to. |
| [SetOpacity, GetOpacity](#setopacity-getopacity-1) | Set or read how opaque the brush paints. |
| [SetTransform, GetTransform](#settransform-gettransform-1) | Set or read the brush transform. |
| [SetStartPoint, GetStartPoint](#setstartpoint-getstartpoint) | Set or read where the gradient starts. |
| [SetEndPoint, GetEndPoint](#setendpoint-getendpoint) | Set or read where the gradient ends. |
| [GetGradientStopCollection](#getgradientstopcollection) | Returns the brush's stop collection. |
| **CID2D1RadialGradientBrush** | |
| [Constructor](#constructor-4) | Wraps a radial gradient brush, taking over its reference. |
| [Destructor](#destructor-4) | Releases the brush. |
| [Cast, Operator @, Operator *](#cast-operator--operator--4) | Give the brush pointer, or its address. |
| [GetFactory](#getfactory-3) | Returns the factory the brush belongs to. |
| [SetOpacity, GetOpacity](#setopacity-getopacity-2) | Set or read how opaque the brush paints. |
| [SetTransform, GetTransform](#settransform-gettransform-2) | Set or read the brush transform. |
| [SetCenter, GetCenter](#setcenter-getcenter) | Set or read the centre of the gradient ellipse. |
| [SetGradientOriginOffset, GetGradientOriginOffset](#setgradientoriginoffset-getgradientoriginoffset) | Set or read where the gradient starts, relative to the centre. |
| [SetRadiusX, GetRadiusX](#setradiusx-getradiusx) | Set or read the horizontal radius. |
| [SetRadiusY, GetRadiusY](#setradiusy-getradiusy) | Set or read the vertical radius. |
| [GetGradientStopCollection](#getgradientstopcollection-1) | Returns the brush's stop collection. |
| **CID2D1BitmapBrush** | |
| [Constructor](#constructor-5) | Creates an empty object, or wraps a bitmap brush. |
| [Destructor](#destructor-5) | Releases the brush. |
| [Cast, Operator @, Operator *](#cast-operator--operator--5) | Give the brush pointer, or its address. |
| [GetFactory](#getfactory-4) | Returns the factory the brush belongs to. |
| [SetOpacity, GetOpacity](#setopacity-getopacity-3) | Set or read how opaque the brush paints. |
| [SetTransform, GetTransform](#settransform-gettransform-3) | Set or read the brush transform. |
| [SetExtendModeX, GetExtendModeX](#setextendmodex-getextendmodex) | Set or read what fills the area left and right of the bitmap. |
| [SetExtendModeY, GetExtendModeY](#setextendmodey-getextendmodey) | Set or read what fills the area above and below the bitmap. |
| [SetInterpolationMode, GetInterpolationMode](#setinterpolationmode-getinterpolationmode) | Set or read how the bitmap is resampled. |
| [SetBitmap, GetBitmap](#setbitmap-getbitmap) | Set or read the bitmap. |
| **CID2D1BitmapBrush1** | |
| [Constructor](#constructor-6) | Wraps a device-context bitmap brush, taking over its reference. |
| [Destructor](#destructor-6) | Releases the brush. |
| [Cast, Operator @, Operator *](#cast-operator--operator--6) | Give the brush pointer, or its address. |
| [SetInterpolationMode1, GetInterpolationMode1](#setinterpolationmode1-getinterpolationmode1) | Set or read the resampling, with the full set of modes. |
| **CID2D1ImageBrush** | |
| [Constructor](#constructor-7) | Wraps an image brush, taking over its reference. |
| [Destructor](#destructor-7) | Releases the brush. |
| [Cast, Operator @, Operator *](#cast-operator--operator--7) | Give the brush pointer, or its address. |
| [GetFactory](#getfactory-5) | Returns the factory the brush belongs to. |
| [SetOpacity, GetOpacity](#setopacity-getopacity-4) | Set or read how opaque the brush paints. |
| [SetTransform, GetTransform](#settransform-gettransform-4) | Set or read the brush transform. |
| [SetImage, GetImage](#setimage-getimage) | Set or read the image. |
| [SetExtendModeX, GetExtendModeX](#setextendmodex-getextendmodex-1) | Set or read what fills the area left and right of the source rectangle. |
| [SetExtendModeY, GetExtendModeY](#setextendmodey-getextendmodey-1) | Set or read what fills the area above and below the source rectangle. |
| [SetInterpolationMode, GetInterpolationMode](#setinterpolationmode-getinterpolationmode-1) | Set or read how the image is resampled. |
| [SetSourceRectangle, GetSourceRectangle](#setsourcerectangle-getsourcerectangle) | Set or read the part of the image the brush paints with. |

## Reference

## CID2D1GradientStopCollection

The colours of a gradient: an array of `D2D1_GRADIENT_STOP`, each a `position` from 0 to 1 along
the gradient and the `color` at that position, plus how to blend between them. Make one with
`CreateGradientStopCollection` of a [render target](CID2D1RenderTarget); it cannot be changed
afterwards. The `D2D1_GradientStop` helper builds a stop from a position and a colour.

### Constructor

```freebasic
constructor
constructor( byval pGradientStopCollection as ID2D1GradientStopCollection ptr )
```

With a pointer the object holds that stop collection and takes over the reference that came with
it; it does not add one. Without one it is empty until a pointer is stored in its public field
`m_pGradientStopCollection`.

| Parameter | Meaning |
| --- | --- |
| `pGradientStopCollection` | The stop collection, normally straight from `CreateGradientStopCollection`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
```

Microsoft Learn: [ID2D1GradientStopCollection](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1gradientstopcollection)

### Destructor

```freebasic
destructor
```

Releases the stop collection, if the object holds one. Brushes made with it keep their own
reference, so the collection can go out of scope before them.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim pColl as CID2D1GradientStopCollection ptr = new CID2D1GradientStopCollection( rt.CreateGradientStopCollection( stops(0), 2 ) )
delete pColl                             ' releases the collection
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1GradientStopCollection ptr
operator @() as ID2D1GradientStopCollection ptr ptr
operator *( byref gradientStopCollection as CID2D1GradientStopCollection ) as ID2D1GradientStopCollection ptr
```

`cast` gives the interface pointer, so the object can be passed wherever an
`ID2D1GradientStopCollection ptr` is expected, such as `CreateLinearGradientBrush`; `*stopColl`
gives the same pointer for calling an interface method directly. Neither adds a reference.

`@` returns the address of `m_pGradientStopCollection`, for a call that writes a new pointer into
an output parameter; it does not release one the object already holds. Applying `@` to one of
these objects currently stops the build with an internal compiler error; until it builds, pass
the field `m_pGradientStopCollection` itself.

**Returns** the interface pointer (`NULL` for an empty object), or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim pColl as ID2D1GradientStopCollection ptr = stopColl           ' cast
print ( *stopColl )->GetGradientStopCount()                        ' 2
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Returns the factory that made the render target the collection came from. The pointer carries a
new reference: release it.

**Returns** the factory, or `NULL` for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim pFactory as ID2D1Factory ptr = stopColl.GetFactory()
print ( pFactory = *factory )            ' -1 (true)
pFactory->Release()
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### GetGradientStopCount

```freebasic
function GetGradientStopCount() as UINT32
```

**Returns** the number of stops in the collection, or 0 for an empty object. Use it to size the
array for [GetGradientStops](#getgradientstops).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
print stopColl.GetGradientStopCount()    ' 2
```

Microsoft Learn: [ID2D1GradientStopCollection::GetGradientStopCount](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1gradientstopcollection-getgradientstopcount)

### GetGradientStops

```freebasic
sub GetGradientStops( byref gradientStops as D2D1_GRADIENT_STOP, byval gradientStopsCount as UINT32 )
```

Copies the stops, in order, into the array whose first element is `gradientStops`. At most
`gradientStopsCount` are written: a smaller count gives the first stops only, and array elements
beyond the number of stops are left as they were.

| Parameter | Meaning |
| --- | --- |
| `gradientStops` | The first element of the array that receives the stops. |
| `gradientStopsCount` | The number of elements the array has room for. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim got(1) as D2D1_GRADIENT_STOP
stopColl.GetGradientStops( got(0), 2 )
print got(1).position; got(1).color.r; got(1).color.g; got(1).color.b    ' 1 1 1 0
```

Microsoft Learn: [ID2D1GradientStopCollection::GetGradientStops](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1gradientstopcollection-getgradientstops)

### GetColorInterpolationGamma

```freebasic
function GetColorInterpolationGamma() as D2D1_GAMMA
```

Tells in which gamma space the colours between two stops are blended: `D2D1_GAMMA_2_2` (0), the
ordinary sRGB space, or `D2D1_GAMMA_1_0` (1), linear light. The
two-argument `CreateGradientStopCollection` uses `D2D1_GAMMA_2_2`.

**Returns** the gamma, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( @stops(0), 2, D2D1_GAMMA_1_0, D2D1_EXTEND_MODE_MIRROR )
print stopColl.GetColorInterpolationGamma()                         ' 1
```

Microsoft Learn: [ID2D1GradientStopCollection::GetColorInterpolationGamma](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1gradientstopcollection-getcolorinterpolationgamma)

### GetExtendMode

```freebasic
function GetExtendMode() as D2D1_EXTEND_MODE
```

Tells what a brush paints beyond the ends of the gradient: `D2D1_EXTEND_MODE_CLAMP` (0) repeats
the end colours, `D2D1_EXTEND_MODE_WRAP` (1) repeats the gradient, `D2D1_EXTEND_MODE_MIRROR` (2)
repeats it reflected. The two-argument `CreateGradientStopCollection` uses
`D2D1_EXTEND_MODE_CLAMP`.

**Returns** the mode, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( @stops(0), 2, D2D1_GAMMA_2_2, D2D1_EXTEND_MODE_MIRROR )
print stopColl.GetExtendMode()                                      ' 2
```

Microsoft Learn: [ID2D1GradientStopCollection::GetExtendMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1gradientstopcollection-getextendmode)

## CID2D1GradientStopCollection1

A stop collection made by `CreateGradientStopCollection` of a device context, which also says in
which colour space the stops are given and blended, and at what precision the gradient is
rendered. It extends [CID2D1GradientStopCollection](#cid2d1gradientstopcollection), whose members
all work on it. The examples below share these lines, which ask the render target for its device
context:

```freebasic
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
```

### Constructor

```freebasic
constructor( byval pGradientStopCollection1 as ID2D1GradientStopCollection1 ptr )
```

Holds the stop collection in `m_pGradientStopCollection1`, and the same object in the inherited
`m_pGradientStopCollection`, and takes over the reference that came with it. There is no
constructor without arguments.

| Parameter | Meaning |
| --- | --- |
| `pGradientStopCollection1` | The stop collection from a device context. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Blue ) }
dim pColl1 as ID2D1GradientStopCollection1 ptr
pDC->CreateGradientStopCollection( stops(0), 2, D2D1_COLOR_SPACE_SRGB, D2D1_COLOR_SPACE_SCRGB, D2D1_BUFFER_PRECISION_8BPC_UNORM, D2D1_EXTEND_MODE_CLAMP, D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT, pColl1 )
dim stopColl as CID2D1GradientStopCollection1 = pColl1
pDC->Release()
```

Microsoft Learn: [ID2D1GradientStopCollection1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1gradientstopcollection1)

### Destructor

```freebasic
destructor
```

Releases the stop collection; with the inherited destructor this gives back the one reference
the object took over.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Blue ) }
dim pColl1 as ID2D1GradientStopCollection1 ptr
pDC->CreateGradientStopCollection( stops(0), 2, D2D1_COLOR_SPACE_SRGB, D2D1_COLOR_SPACE_SCRGB, D2D1_BUFFER_PRECISION_8BPC_UNORM, D2D1_EXTEND_MODE_CLAMP, D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT, pColl1 )
scope
    dim stopColl as CID2D1GradientStopCollection1 = pColl1
end scope                                ' released here
pDC->Release()
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1GradientStopCollection1 ptr
operator @() as ID2D1GradientStopCollection1 ptr ptr
operator *( byref gradientStopCollection as CID2D1GradientStopCollection1 ) as ID2D1GradientStopCollection1 ptr
```

As for [CID2D1GradientStopCollection](#cast-operator--operator-), but for the
`ID2D1GradientStopCollection1` pointer in `m_pGradientStopCollection1`. The inherited `cast` to
`ID2D1GradientStopCollection ptr` still works, so the object can be given to
`CreateLinearGradientBrush`. `@` currently stops the build with an internal compiler error; use
the field `m_pGradientStopCollection1`.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Blue ) }
dim pColl1 as ID2D1GradientStopCollection1 ptr
pDC->CreateGradientStopCollection( stops(0), 2, D2D1_COLOR_SPACE_SRGB, D2D1_COLOR_SPACE_SCRGB, D2D1_BUFFER_PRECISION_8BPC_UNORM, D2D1_EXTEND_MODE_CLAMP, D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT, pColl1 )
dim stopColl as CID2D1GradientStopCollection1 = pColl1
dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, cast( ID2D1GradientStopCollection ptr, *stopColl ) )
pDC->Release()
```

### GetGradientStops1

```freebasic
sub GetGradientStops1( byref gradientStops as D2D1_GRADIENT_STOP, byval gradientStopsCount as UINT32 )
```

Copies the stops into an array like [GetGradientStops](#getgradientstops). For a collection
made by a device context, these are the colours exactly as they were given to
`CreateGradientStopCollection`.

| Parameter | Meaning |
| --- | --- |
| `gradientStops` | The first element of the array that receives the stops. |
| `gradientStopsCount` | The number of elements the array has room for. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Blue ) }
dim pColl1 as ID2D1GradientStopCollection1 ptr
pDC->CreateGradientStopCollection( stops(0), 2, D2D1_COLOR_SPACE_SRGB, D2D1_COLOR_SPACE_SCRGB, D2D1_BUFFER_PRECISION_8BPC_UNORM, D2D1_EXTEND_MODE_CLAMP, D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT, pColl1 )
dim stopColl as CID2D1GradientStopCollection1 = pColl1
dim got(1) as D2D1_GRADIENT_STOP
stopColl.GetGradientStops1( got(0), 2 )
print got(1).color.r; got(1).color.g; got(1).color.b                ' 0 0 1
pDC->Release()
```

Microsoft Learn: [ID2D1GradientStopCollection1::GetGradientStops1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1gradientstopcollection1-getgradientstops1)

### GetPreInterpolationSpace

```freebasic
function GetPreInterpolationSpace() as D2D1_COLOR_SPACE
```

Tells the colour space the stops were given in, which is also the space they are blended in:
`D2D1_COLOR_SPACE_SRGB` (1), `D2D1_COLOR_SPACE_SCRGB` (2, linear) or `D2D1_COLOR_SPACE_CUSTOM`
(0).

**Returns** the colour space, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Blue ) }
dim pColl1 as ID2D1GradientStopCollection1 ptr
pDC->CreateGradientStopCollection( stops(0), 2, D2D1_COLOR_SPACE_SRGB, D2D1_COLOR_SPACE_SCRGB, D2D1_BUFFER_PRECISION_8BPC_UNORM, D2D1_EXTEND_MODE_CLAMP, D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT, pColl1 )
dim stopColl as CID2D1GradientStopCollection1 = pColl1
print stopColl.GetPreInterpolationSpace()                           ' 1
pDC->Release()
```

Microsoft Learn: [ID2D1GradientStopCollection1::GetPreInterpolationSpace](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1gradientstopcollection1-getpreinterpolationspace)

### GetPostInterpolationSpace

```freebasic
function GetPostInterpolationSpace() as D2D1_COLOR_SPACE
```

Tells the colour space the blended colours are converted to before they are drawn.

**Returns** a `D2D1_COLOR_SPACE_…` value, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Blue ) }
dim pColl1 as ID2D1GradientStopCollection1 ptr
pDC->CreateGradientStopCollection( stops(0), 2, D2D1_COLOR_SPACE_SRGB, D2D1_COLOR_SPACE_SCRGB, D2D1_BUFFER_PRECISION_8BPC_UNORM, D2D1_EXTEND_MODE_CLAMP, D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT, pColl1 )
dim stopColl as CID2D1GradientStopCollection1 = pColl1
print stopColl.GetPostInterpolationSpace()                          ' 2
pDC->Release()
```

Microsoft Learn: [ID2D1GradientStopCollection1::GetPostInterpolationSpace](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1gradientstopcollection1-getpostinterpolationspace)

### GetBufferPrecision

```freebasic
function GetBufferPrecision() as D2D1_BUFFER_PRECISION
```

Tells the precision of the buffer the gradient is rendered into: `D2D1_BUFFER_PRECISION_8BPC_UNORM`
(1), `…_8BPC_UNORM_SRGB` (2), `…_16BPC_UNORM` (3), `…_16BPC_FLOAT` (4) or `…_32BPC_FLOAT` (5).

**Returns** the precision, or 0 (`D2D1_BUFFER_PRECISION_UNKNOWN`) for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Blue ) }
dim pColl1 as ID2D1GradientStopCollection1 ptr
pDC->CreateGradientStopCollection( stops(0), 2, D2D1_COLOR_SPACE_SRGB, D2D1_COLOR_SPACE_SCRGB, D2D1_BUFFER_PRECISION_8BPC_UNORM, D2D1_EXTEND_MODE_CLAMP, D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT, pColl1 )
dim stopColl as CID2D1GradientStopCollection1 = pColl1
print stopColl.GetBufferPrecision()                                 ' 1
pDC->Release()
```

Microsoft Learn: [ID2D1GradientStopCollection1::GetBufferPrecision](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1gradientstopcollection1-getbufferprecision)

### GetColorInterpolationMode

```freebasic
function GetColorInterpolationMode() as D2D1_COLOR_INTERPOLATION_MODE
```

Tells how alpha is treated when two stops are blended: `D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT`
(0) blends colour and alpha separately, `…_PREMULTIPLIED` (1) blends the colour already
multiplied by alpha.

**Returns** the mode, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Blue ) }
dim pColl1 as ID2D1GradientStopCollection1 ptr
pDC->CreateGradientStopCollection( stops(0), 2, D2D1_COLOR_SPACE_SRGB, D2D1_COLOR_SPACE_SCRGB, D2D1_BUFFER_PRECISION_8BPC_UNORM, D2D1_EXTEND_MODE_CLAMP, D2D1_COLOR_INTERPOLATION_MODE_STRAIGHT, pColl1 )
dim stopColl as CID2D1GradientStopCollection1 = pColl1
print stopColl.GetColorInterpolationMode()                          ' 0
pDC->Release()
```

Microsoft Learn: [ID2D1GradientStopCollection1::GetColorInterpolationMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1gradientstopcollection1-getcolorinterpolationmode)

## CID2D1SolidColorBrush

Paints with one colour. The colour's alpha and the brush opacity multiply, so a colour with alpha
0.5 painted at opacity 0.5 paints at alpha 0.25. Make one with `CreateSolidColorBrush` of a
[render target](CID2D1RenderTarget); the brush transform has no visible effect on it.

### Constructor

```freebasic
constructor( byval pSolidColorBrush as ID2D1SolidColorBrush ptr )
```

Holds the brush and takes over the reference that came with it. There is no constructor without
arguments.

| Parameter | Meaning |
| --- | --- |
| `pSolidColorBrush` | The brush, normally straight from `CreateSolidColorBrush`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( D2D1_ColorF( D2D1_SteelBlue ), D2D1_BrushProperties() )
if *brush = NULL then print "no brush: &h"; hex( GetLastError() )
```

Microsoft Learn: [ID2D1SolidColorBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1solidcolorbrush)

### Destructor

```freebasic
destructor
```

Releases the brush, if the object holds one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
scope
    dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( D2D1_ColorF( D2D1_Red ), D2D1_BrushProperties() )
end scope                                ' released here
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1SolidColorBrush ptr
operator cast() as ID2D1Brush ptr
operator @() as ID2D1SolidColorBrush ptr ptr
operator *( byref solidColorBrush as CID2D1SolidColorBrush ) as ID2D1SolidColorBrush ptr
```

The two `cast`s give the brush pointer, as an `ID2D1SolidColorBrush ptr` or as the
`ID2D1Brush ptr` that drawing calls take; `*brush` gives the `ID2D1SolidColorBrush` pointer for
calling an interface method directly. None adds a reference.

`@` returns the address of the field `m_pSolidColorBrush`, for a call that writes a new brush
pointer into an output parameter; it does not release a brush the object already holds. Applying
`@` to one of these objects currently stops the build with an internal compiler error; until it
builds, pass `m_pSolidColorBrush` itself.

**Returns** the brush pointer (`NULL` for an empty object), or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( D2D1_ColorF( D2D1_Red ), D2D1_BrushProperties() )
dim pBrush as ID2D1Brush ptr = brush                      ' cast
( *brush )->SetColor( D2D1_ColorF( D2D1_Gold ) )          ' the interface itself
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Returns the factory that made the brush's render target. The pointer carries a new reference:
release it. The object must hold a brush: on an empty object this member is not guarded.

**Returns** the factory.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( D2D1_ColorF( D2D1_Red ), D2D1_BrushProperties() )
dim pFactory as ID2D1Factory ptr = brush.GetFactory()
print ( pFactory = *factory )            ' -1 (true)
pFactory->Release()
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### SetOpacity, GetOpacity

```freebasic
sub SetOpacity( byval opacity as FLOAT )
function GetOpacity() as FLOAT
```

The opacity multiplies the alpha of everything the brush paints: 1 (the default) paints as the
colours say, 0 paints nothing. Values are meant to lie from 0 to 1; the brush stores what it is
given (2 reads back as 2).

| Parameter | Meaning |
| --- | --- |
| `opacity` | The new opacity, 0 to 1. |

**Returns** (`GetOpacity`) the opacity, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( D2D1_ColorF( D2D1_Red ), D2D1_BrushProperties() )
brush.SetOpacity( 0.5 )
print brush.GetOpacity()                 ' 0.5
```

Microsoft Learn: [ID2D1Brush::SetOpacity](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1brush-setopacity), [ID2D1Brush::GetOpacity](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1brush-getopacity)

### SetTransform, GetTransform

```freebasic
sub SetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub SetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
sub GetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub GetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
function GetTransform() as D2D1_MATRIX_3X2_F
```

The brush transform maps brush space onto the render target's space, before the target's own
transform: it moves, scales, turns or skews a gradient or a bitmap pattern without changing the
shapes it fills. A new brush has the identity matrix. Build matrices with `D2D1_MatrixTranslation`,
`D2D1_MatrixScale`, `D2D1_MatrixRotation` and `D2D1_MatrixSkew`; see
[Direct2D helpers](SysWin-Direct2D-Helpers).

`SetTransform` replaces the transform; `GetTransform` reads it into a variable, through a
pointer, or as its result.

| Parameter | Meaning |
| --- | --- |
| `transform` | The matrix to set, or the variable (or pointer to one) that receives it. |

**Returns** (the function form of `GetTransform`) the matrix; for an empty object, a zeroed one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( D2D1_ColorF( D2D1_Red ), D2D1_BrushProperties() )
brush.SetTransform( D2D1_MatrixTranslation( 5, 7 ) )
dim m as D2D1_MATRIX_3X2_F = brush.GetTransform()
print m.m31; m.m32                       ' 5 7
```

Microsoft Learn: [ID2D1Brush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1brush), [ID2D1Brush::GetTransform](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1brush-gettransform)

### SetColor, GetColor

```freebasic
sub SetColor( byref clr as D2D1_COLOR_F )
sub SetColor( byval clr as D2D1_COLOR_F ptr )
function GetColor() as D2D1_COLOR_F
sub GetColor( byref clr as D2D1_COLOR_F )
sub GetColor( byval clr as D2D1_COLOR_F ptr )
```

`SetColor` changes the colour the brush paints with; one brush can paint many colours in turn,
which is cheaper than a brush per colour. `GetColor` reads it, as a result, into a variable or
through a pointer. A `D2D1_COLOR_F` holds red, green, blue and alpha as 0 to 1; `D2D1_ColorF`
builds one from an `&hRRGGBB` value or the `D2D1_…` colour names.

| Parameter | Meaning |
| --- | --- |
| `clr` | The new colour, or the variable (or pointer to one) that receives it. |

**Returns** (the function form) the colour; for an empty object, a zeroed one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( D2D1_ColorF( D2D1_Black ), D2D1_BrushProperties() )
brush.SetColor( D2D1_ColorF( D2D1_Red ) )
dim c as D2D1_COLOR_F = brush.GetColor()
print c.r; c.g; c.b; c.a                 ' 1 0 0 1
```

Microsoft Learn: [ID2D1SolidColorBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1solidcolorbrush), [ID2D1SolidColorBrush::GetColor](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1solidcolorbrush-getcolor)

## CID2D1LinearGradientBrush

Paints a gradient along the line from a start point to an end point: the colour at the start point
is the stop at position 0, the colour at the end point the stop at position 1, and every line at
right angles to it has one colour. Beyond the two points the stop collection's extend mode
applies. Make one with `CreateLinearGradientBrush` of a [render target](CID2D1RenderTarget),
from a [stop collection](#cid2d1gradientstopcollection).

### Constructor

```freebasic
constructor( byval pLinearGradientBrush as ID2D1LinearGradientBrush ptr )
```

Holds the brush and takes over the reference that came with it. There is no constructor without
arguments.

| Parameter | Meaning |
| --- | --- |
| `pLinearGradientBrush` | The brush, normally straight from `CreateLinearGradientBrush`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, stopColl )
```

Microsoft Learn: [ID2D1LinearGradientBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1lineargradientbrush)

### Destructor

```freebasic
destructor
```

Releases the brush, if the object holds one; the brush in turn lets go of its stop collection.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
scope
    dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, stopColl )
end scope                                ' released here
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1LinearGradientBrush ptr
operator cast() as ID2D1Brush ptr
operator @() as ID2D1LinearGradientBrush ptr ptr
operator *( byref linearGradientBrush as CID2D1LinearGradientBrush ) as ID2D1LinearGradientBrush ptr
```

As for [CID2D1SolidColorBrush](#cast-operator--operator--2), for the brush in
`m_pLinearGradientBrush`. `@` currently stops the build with an internal compiler error; use the
field.

**Returns** the brush pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, stopColl )
dim pBrush as ID2D1Brush ptr = brush
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

As for [CID2D1SolidColorBrush](#getfactory-1): returns the factory with a new reference, and is
not guarded on an empty object.

**Returns** the factory.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, stopColl )
dim pFactory as ID2D1Factory ptr = brush.GetFactory()
pFactory->Release()
```

### SetOpacity, GetOpacity

```freebasic
sub SetOpacity( byval opacity as FLOAT )
function GetOpacity() as FLOAT
```

As for [CID2D1SolidColorBrush](#setopacity-getopacity): sets or reads the opacity, 0 to 1.

**Returns** (`GetOpacity`) the opacity, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, stopColl )
brush.SetOpacity( 0.75 )
```

### SetTransform, GetTransform

```freebasic
sub SetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub SetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
sub GetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub GetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
function GetTransform() as D2D1_MATRIX_3X2_F
```

As for [CID2D1SolidColorBrush](#settransform-gettransform). The start and end points are in brush
space, so turning the brush turns the gradient.

**Returns** (the function form of `GetTransform`) the matrix.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, stopColl )
brush.SetTransform( D2D1_MatrixRotation( 45, 50, 50 ) )   ' a diagonal gradient
```

### SetStartPoint, GetStartPoint

```freebasic
sub SetStartPoint( byval startPoint as D2D1_POINT_2F )
sub SetStartPoint( byval x as single, byval y as single )
sub GetStartPoint( byref startPoint as D2D1_POINT_2F )
sub GetStartPoint( byval startPoint as D2D1_POINT_2F ptr )
```

Sets or reads the point where the gradient starts (the stop at position 0), in brush space. There
is no function form of `GetStartPoint`: read it into a variable or through a pointer.

| Parameter | Meaning |
| --- | --- |
| `startPoint` | The new point, or the variable (or pointer to one) that receives it. |
| `x`, `y` | The new point as two coordinates. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, stopColl )
brush.SetStartPoint( 10, 20 )
dim pt as D2D1_POINT_2F
brush.GetStartPoint( pt )
print pt.x; pt.y                         ' 10 20
```

Microsoft Learn: [ID2D1LinearGradientBrush::SetStartPoint](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1lineargradientbrush-setstartpoint), [ID2D1LinearGradientBrush::GetStartPoint](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1lineargradientbrush-getstartpoint)

### SetEndPoint, GetEndPoint

```freebasic
sub SetEndPoint( byval endPoint as D2D1_POINT_2F )
sub SetEndPoint( byval x as single, byval y as single )
sub GetEndPoint( byref endPoint as D2D1_POINT_2F )
sub GetEndPoint( byval endPoint as D2D1_POINT_2F ptr )
function GetEndPoint() as D2D1_POINT_2F
```

Sets or reads the point where the gradient ends (the stop at position 1), in brush space.

| Parameter | Meaning |
| --- | --- |
| `endPoint` | The new point, or the variable (or pointer to one) that receives it. |
| `x`, `y` | The new point as two coordinates. |

**Returns** (the function form) the point; for an empty object, (0, 0).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, stopColl )
dim pt as D2D1_POINT_2F = brush.GetEndPoint()
print pt.x; pt.y                         ' 100 0
```

Microsoft Learn: [ID2D1LinearGradientBrush::SetEndPoint](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1lineargradientbrush-setendpoint), [ID2D1LinearGradientBrush::GetEndPoint](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1lineargradientbrush-getendpoint)

### GetGradientStopCollection

```freebasic
function GetGradientStopCollection() as ID2D1GradientStopCollection ptr
```

Returns the stop collection the brush was made with. The pointer carries a new reference:
release it, or wrap it in a [CID2D1GradientStopCollection](#cid2d1gradientstopcollection), which
releases it for you.

**Returns** the stop collection, or `NULL` for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Red ), D2D1_GradientStop( 1, D2D1_Yellow ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 100, 0, stopColl )
dim current as CID2D1GradientStopCollection = brush.GetGradientStopCollection()
print current.GetGradientStopCount()     ' 2
```

Microsoft Learn: [ID2D1LinearGradientBrush::GetGradientStopCollection](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1lineargradientbrush-getgradientstopcollection)

## CID2D1RadialGradientBrush

Paints a gradient inside an ellipse: the stop at position 0 is at the gradient origin, the stop at
position 1 on the edge of the ellipse, and the colours blend in between. The origin is the centre
of the ellipse moved by an offset, so it can sit off-centre for a highlight. Outside the ellipse
the stop collection's extend mode applies. Make one with `CreateRadialGradientBrush` of a
[render target](CID2D1RenderTarget).

### Constructor

```freebasic
constructor( byval pRadialGradientBrush as ID2D1RadialGradientBrush ptr )
```

Holds the brush and takes over the reference that came with it. There is no constructor without
arguments.

| Parameter | Meaning |
| --- | --- |
| `pRadialGradientBrush` | The brush, normally straight from `CreateRadialGradientBrush`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
```

Microsoft Learn: [ID2D1RadialGradientBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1radialgradientbrush)

### Destructor

```freebasic
destructor
```

Releases the brush, if the object holds one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
scope
    dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
end scope                                ' released here
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1RadialGradientBrush ptr
operator cast() as ID2D1Brush ptr
operator @() as ID2D1RadialGradientBrush ptr ptr
operator *( byref radialGradientBrush as CID2D1RadialGradientBrush ) as ID2D1RadialGradientBrush ptr
```

As for [CID2D1SolidColorBrush](#cast-operator--operator--2), for the brush in
`m_pRadialGradientBrush`. `@` currently stops the build with an internal compiler error; use the
field.

**Returns** the brush pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
print ( *brush )->GetRadiusX()           ' 40
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

As for [CID2D1SolidColorBrush](#getfactory-1): returns the factory with a new reference, and is
not guarded on an empty object.

**Returns** the factory.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
dim pFactory as ID2D1Factory ptr = brush.GetFactory()
pFactory->Release()
```

### SetOpacity, GetOpacity

```freebasic
sub SetOpacity( byval opacity as FLOAT )
function GetOpacity() as FLOAT
```

As for [CID2D1SolidColorBrush](#setopacity-getopacity): sets or reads the opacity, 0 to 1.

**Returns** (`GetOpacity`) the opacity, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
print brush.GetOpacity()                 ' 1
```

### SetTransform, GetTransform

```freebasic
sub SetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub SetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
sub GetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub GetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
function GetTransform() as D2D1_MATRIX_3X2_F
```

As for [CID2D1SolidColorBrush](#settransform-gettransform). A rotation turns the ellipse of the
gradient; a skew slants it.

**Returns** (the function form of `GetTransform`) the matrix.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
brush.SetTransform( D2D1_MatrixRotation( 30, 50, 50 ) )
```

### SetCenter, GetCenter

```freebasic
sub SetCenter( byval center as D2D1_POINT_2F )
sub SetCenter( byval centerX as single, byval centerY as single )
function GetCenter() as D2D1_POINT_2F
```

Sets or reads the centre of the gradient ellipse, in brush space. Moving the centre moves the
origin with it.

| Parameter | Meaning |
| --- | --- |
| `center` | The new centre. |
| `centerX`, `centerY` | The new centre as two coordinates. |

**Returns** (`GetCenter`) the centre; for an empty object, (0, 0).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
brush.SetCenter( 5, 6 )
dim c as D2D1_POINT_2F = brush.GetCenter()
print c.x; c.y                           ' 5 6
```

Microsoft Learn: [ID2D1RadialGradientBrush::SetCenter](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1radialgradientbrush-setcenter), [ID2D1RadialGradientBrush::GetCenter](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1radialgradientbrush-getcenter)

### SetGradientOriginOffset, GetGradientOriginOffset

```freebasic
sub SetGradientOriginOffset( byval gradientOriginOffset as D2D1_POINT_2F )
sub SetGradientOriginOffset( byval gradientOriginOffsetX as single, byval gradientOriginOffsetXY as single )
function GetGradientOriginOffset() as D2D1_POINT_2F
```

Sets or reads how far the gradient origin, where the stop at position 0 is, lies from the centre
of the ellipse. (0, 0) puts it at the centre; an offset towards the top left gives the look of a
ball lit from there. The second parameter of the two-coordinate form is the y offset.

| Parameter | Meaning |
| --- | --- |
| `gradientOriginOffset` | The new offset. |
| `gradientOriginOffsetX`, `gradientOriginOffsetXY` | The new offset as x and y. |

**Returns** (`GetGradientOriginOffset`) the offset; for an empty object, (0, 0).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
brush.SetGradientOriginOffset( -3, 4 )
dim o as D2D1_POINT_2F = brush.GetGradientOriginOffset()
print o.x; o.y                           ' -3 4
```

Microsoft Learn: [ID2D1RadialGradientBrush::SetGradientOriginOffset](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1radialgradientbrush-setgradientoriginoffset), [ID2D1RadialGradientBrush::GetGradientOriginOffset](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1radialgradientbrush-getgradientoriginoffset)

### SetRadiusX, GetRadiusX

```freebasic
sub SetRadiusX( byval radiusX as FLOAT )
function GetRadiusX() as FLOAT
```

Sets or reads the horizontal radius of the gradient ellipse, in brush space.

| Parameter | Meaning |
| --- | --- |
| `radiusX` | The new horizontal radius. |

**Returns** (`GetRadiusX`) the radius, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
brush.SetRadiusX( 7 )
print brush.GetRadiusX()                 ' 7
```

Microsoft Learn: [ID2D1RadialGradientBrush::SetRadiusX](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1radialgradientbrush-setradiusx), [ID2D1RadialGradientBrush::GetRadiusX](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1radialgradientbrush-getradiusx)

### SetRadiusY, GetRadiusY

```freebasic
sub SetRadiusY( byval radiusY as FLOAT )
function GetRadiusY() as FLOAT
```

Sets or reads the vertical radius of the gradient ellipse, in brush space.

| Parameter | Meaning |
| --- | --- |
| `radiusY` | The new vertical radius. |

**Returns** (`GetRadiusY`) the radius, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
print brush.GetRadiusY()                 ' 30
```

Microsoft Learn: [ID2D1RadialGradientBrush::SetRadiusY](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1radialgradientbrush-setradiusy), [ID2D1RadialGradientBrush::GetRadiusY](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1radialgradientbrush-getradiusy)

### GetGradientStopCollection

```freebasic
function GetGradientStopCollection() as ID2D1GradientStopCollection ptr
```

Returns the stop collection the brush was made with, with a new reference: release it, or wrap
it in a [CID2D1GradientStopCollection](#cid2d1gradientstopcollection).

**Returns** the stop collection, or `NULL` for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim stops(1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim stopColl as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( stops(0), 2 )
dim brush as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 50, 50, 0, 0, 40, 30, stopColl )
dim current as CID2D1GradientStopCollection = brush.GetGradientStopCollection()
print ( *current = *stopColl )           ' -1 (true)
```

Microsoft Learn: [ID2D1RadialGradientBrush::GetGradientStopCollection](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1radialgradientbrush-getgradientstopcollection)

## CID2D1BitmapBrush

Paints with a [bitmap](SysWin-Direct2D-Bitmaps): the bitmap's top-left corner is at the origin
of brush space and its size is its size in DIPs. What lies beyond the bitmap depends on the extend
modes: the edge pixels stretched outwards (clamp), the bitmap repeated (wrap) or repeated
reflected (mirror). Make one with `CreateBitmapBrush` of a [render target](CID2D1RenderTarget),
passing the bitmap and a `D2D1_BitmapBrushProperties( extendModeX, extendModeY,
interpolationMode )`; the brush keeps its own reference to the bitmap.

### Constructor

```freebasic
constructor
constructor( byval pID2D1BitmapBrush as ID2D1BitmapBrush ptr )
```

With a pointer the object holds that brush and takes over the reference that came with it.
Without one it is empty until a pointer is stored in its public field `m_pBitmapBrush`.

| Parameter | Meaning |
| --- | --- |
| `pID2D1BitmapBrush` | The brush, normally straight from `CreateBitmapBrush`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties( D2D1_EXTEND_MODE_WRAP, D2D1_EXTEND_MODE_WRAP ) )
```

Microsoft Learn: [ID2D1BitmapBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1bitmapbrush)

### Destructor

```freebasic
destructor
```

Releases the brush, if the object holds one; the brush in turn lets go of its bitmap.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
scope
    dim brush as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties() )
end scope                                ' released here
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1BitmapBrush ptr
operator cast() as ID2D1Brush ptr
operator @() as ID2D1BitmapBrush ptr ptr
operator *( byref bitmapBrush as CID2D1BitmapBrush ) as ID2D1BitmapBrush ptr
```

As for [CID2D1SolidColorBrush](#cast-operator--operator--2), for the brush in `m_pBitmapBrush`.
`@` currently stops the build with an internal compiler error; use the field.

**Returns** the brush pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1BitmapBrush
rt.m_pRenderTarget->CreateBitmapBrush( bmp, byval NULL, byval NULL, brush.m_pBitmapBrush )
dim pBrush as ID2D1Brush ptr = brush
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

As for [CID2D1SolidColorBrush](#getfactory-1): returns the factory with a new reference, and is
not guarded on an empty object.

**Returns** the factory.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties() )
dim pFactory as ID2D1Factory ptr = brush.GetFactory()
pFactory->Release()
```

### SetOpacity, GetOpacity

```freebasic
sub SetOpacity( byval opacity as FLOAT )
function GetOpacity() as FLOAT
```

As for [CID2D1SolidColorBrush](#setopacity-getopacity): sets or reads the opacity, 0 to 1, which
multiplies the bitmap's own alpha.

**Returns** (`GetOpacity`) the opacity, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties() )
brush.SetOpacity( 0.3 )
```

### SetTransform, GetTransform

```freebasic
sub SetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub SetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
sub GetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub GetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
function GetTransform() as D2D1_MATRIX_3X2_F
```

As for [CID2D1SolidColorBrush](#settransform-gettransform). A translation moves where the tiles
start, a scaling makes them bigger: to have the bitmap's corner at a shape's corner, translate the
brush to that corner.

**Returns** (the function form of `GetTransform`) the matrix; for an empty object, a zeroed one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties( D2D1_EXTEND_MODE_WRAP, D2D1_EXTEND_MODE_WRAP ) )
brush.SetTransform( D2D1_MatrixTranslation( 20, 20 ) )    ' tiles start at (20, 20)
```

### SetExtendModeX, GetExtendModeX

```freebasic
sub SetExtendModeX( byval extendModeX as D2D1_EXTEND_MODE )
function GetExtendModeX() as D2D1_EXTEND_MODE
```

Sets or reads what the brush paints to the left and right of the bitmap:
`D2D1_EXTEND_MODE_CLAMP` (0) stretches the edge pixels, `D2D1_EXTEND_MODE_WRAP` (1) repeats the
bitmap, `D2D1_EXTEND_MODE_MIRROR` (2) repeats it reflected.

| Parameter | Meaning |
| --- | --- |
| `extendModeX` | The horizontal extend mode. |

**Returns** (`GetExtendModeX`) the mode, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties() )
brush.SetExtendModeX( D2D1_EXTEND_MODE_WRAP )
print brush.GetExtendModeX()             ' 1
```

Microsoft Learn: [ID2D1BitmapBrush::SetExtendModeX](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmapbrush-setextendmodex), [ID2D1BitmapBrush::GetExtendModeX](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmapbrush-getextendmodex)

### SetExtendModeY, GetExtendModeY

```freebasic
sub SetExtendModeY( byval extendModeY as D2D1_EXTEND_MODE )
function GetExtendModeY() as D2D1_EXTEND_MODE
```

Sets or reads what the brush paints above and below the bitmap, with the same modes as
[SetExtendModeX](#setextendmodex-getextendmodex).

| Parameter | Meaning |
| --- | --- |
| `extendModeY` | The vertical extend mode. |

**Returns** (`GetExtendModeY`) the mode, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties() )
brush.SetExtendModeY( D2D1_EXTEND_MODE_MIRROR )
print brush.GetExtendModeY()             ' 2
```

Microsoft Learn: [ID2D1BitmapBrush::SetExtendModeY](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmapbrush-setextendmodey), [ID2D1BitmapBrush::GetExtendModeY](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmapbrush-getextendmodey)

### SetInterpolationMode, GetInterpolationMode

```freebasic
sub SetInterpolationMode( byval InterpolationMode as D2D1_BITMAP_INTERPOLATION_MODE )
function GetInterpolationMode() as D2D1_BITMAP_INTERPOLATION_MODE
```

Sets or reads how the bitmap is resampled when the brush scales or turns it:
`D2D1_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR` (0) keeps hard pixel edges,
`D2D1_BITMAP_INTERPOLATION_MODE_LINEAR` (1), the default of `D2D1_BitmapBrushProperties`, blends
neighbouring pixels. For the other modes use a [CID2D1BitmapBrush1](#cid2d1bitmapbrush1).

| Parameter | Meaning |
| --- | --- |
| `InterpolationMode` | The resampling mode. |

**Returns** (`GetInterpolationMode`) the mode, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties() )
print brush.GetInterpolationMode()       ' 1
brush.SetInterpolationMode( D2D1_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR )
```

Microsoft Learn: [ID2D1BitmapBrush::SetInterpolationMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmapbrush-setinterpolationmode), [ID2D1BitmapBrush::GetInterpolationMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmapbrush-getinterpolationmode)

### SetBitmap, GetBitmap

```freebasic
sub SetBitmap( byval bitmap as ID2D1Bitmap ptr )
function GetBitmap() as ID2D1Bitmap ptr
```

`SetBitmap` replaces the bitmap the brush paints with; the brush adds its own reference to the new
one and lets go of the old one; `NULL` leaves the brush with no bitmap. `GetBitmap` returns the bitmap with a new reference: release it, or wrap it in a
[CID2D1Bitmap](SysWin-Direct2D-Bitmaps#cid2d1bitmap).

| Parameter | Meaning |
| --- | --- |
| `bitmap` | The new bitmap, or `NULL`. |

**Returns** (`GetBitmap`) the bitmap, or `NULL` when the brush has none or the object is empty.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties() )
dim current as CID2D1Bitmap = brush.GetBitmap()
print ( *current = *bmp )                ' -1 (true)
brush.SetBitmap( NULL )
```

Microsoft Learn: [ID2D1BitmapBrush::SetBitmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmapbrush-setbitmap), [ID2D1BitmapBrush::GetBitmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmapbrush-getbitmap)

## CID2D1BitmapBrush1

A bitmap brush made by `CreateBitmapBrush` of a device context, which can also resample with the
higher-quality modes of `D2D1_INTERPOLATION_MODE`. It extends
[CID2D1BitmapBrush](#cid2d1bitmapbrush), whose members all work on it. The examples below ask the
render target for its device context, as in
[CID2D1GradientStopCollection1](#cid2d1gradientstopcollection1).

### Constructor

```freebasic
constructor( byval pBitmapBrush1 as ID2D1BitmapBrush1 ptr )
```

Holds the brush in `m_pBitmapBrush1`, and the same object in the inherited `m_pBitmapBrush`, and
takes over the reference that came with it. There is no constructor without arguments.

| Parameter | Meaning |
| --- | --- |
| `pBitmapBrush1` | The brush from a device context. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pBrush1 as ID2D1BitmapBrush1 ptr
pDC->CreateBitmapBrush( bmp, D2D1_ImageBrushProperties1( D2D1_EXTEND_MODE_WRAP, D2D1_EXTEND_MODE_WRAP, D2D1_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC ), D2D1_BrushProperties(), pBrush1 )
dim brush as CID2D1BitmapBrush1 = pBrush1
pDC->Release()
```

Microsoft Learn: [ID2D1BitmapBrush1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1bitmapbrush1)

### Destructor

```freebasic
destructor
```

Releases the brush; with the inherited destructor this gives back the one reference the object
took over.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pBrush1 as ID2D1BitmapBrush1 ptr
pDC->CreateBitmapBrush( bmp, D2D1_ImageBrushProperties1(), D2D1_BrushProperties(), pBrush1 )
scope
    dim brush as CID2D1BitmapBrush1 = pBrush1
end scope                                ' released here
pDC->Release()
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1BitmapBrush1 ptr
operator cast() as ID2D1Brush ptr
operator @() as ID2D1BitmapBrush1 ptr ptr
operator *( byref bitmapBrush as CID2D1BitmapBrush1 ) as ID2D1BitmapBrush1 ptr
```

As for [CID2D1SolidColorBrush](#cast-operator--operator--2), for the `ID2D1BitmapBrush1` pointer
in `m_pBitmapBrush1`; the inherited `cast` to `ID2D1BitmapBrush ptr` still works. `@` currently
stops the build with an internal compiler error; use the field.

**Returns** the brush pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pBrush1 as ID2D1BitmapBrush1 ptr
pDC->CreateBitmapBrush( bmp, D2D1_ImageBrushProperties1(), D2D1_BrushProperties(), pBrush1 )
dim brush as CID2D1BitmapBrush1 = pBrush1
dim pBrush as ID2D1Brush ptr = brush
pDC->Release()
```

### SetInterpolationMode1, GetInterpolationMode1

```freebasic
sub SetInterpolationMode1( byval InterpolationMode as D2D1_BITMAP_INTERPOLATION_MODE )
function GetInterpolationMode1() as D2D1_BITMAP_INTERPOLATION_MODE
```

Sets or reads how the bitmap is resampled, with any `D2D1_INTERPOLATION_MODE_…` value:
`NEAREST_NEIGHBOR` (0), `LINEAR` (1), `CUBIC` (2), `MULTI_SAMPLE_LINEAR` (3), `ANISOTROPIC` (4)
or `HIGH_QUALITY_CUBIC` (5). The parameter and result are declared as
`D2D1_BITMAP_INTERPOLATION_MODE`, but both types are numbers and the `D2D1_INTERPOLATION_MODE_…`
constants pass as they are. With `HIGH_QUALITY_CUBIC` set, the inherited
[GetInterpolationMode](#setinterpolationmode-getinterpolationmode) reads 1 (linear).

| Parameter | Meaning |
| --- | --- |
| `InterpolationMode` | A `D2D1_INTERPOLATION_MODE_…` value. |

**Returns** (`GetInterpolationMode1`) the mode, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pBrush1 as ID2D1BitmapBrush1 ptr
pDC->CreateBitmapBrush( bmp, D2D1_ImageBrushProperties1(), D2D1_BrushProperties(), pBrush1 )
dim brush as CID2D1BitmapBrush1 = pBrush1
brush.SetInterpolationMode1( D2D1_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC )
print brush.GetInterpolationMode1(); brush.GetInterpolationMode()   ' 5 1
pDC->Release()
```

Microsoft Learn: [ID2D1BitmapBrush1::SetInterpolationMode1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1bitmapbrush1-setinterpolationmode1), [ID2D1BitmapBrush1::GetInterpolationMode1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1bitmapbrush1-getinterpolationmode1)

## CID2D1ImageBrush

Paints with any `ID2D1Image`: a bitmap, the output of an effect or a command list. The brush
paints with the part of the image inside a **source rectangle**, which lies in brush space at the
same place; outside it the extend modes apply as for a bitmap brush.
Make one with `CreateImageBrush` of a device context, passing the image and a
`D2D1_ImageBrushProperties( sourceRectangle, extendModeX, extendModeY, interpolationMode )`. The
examples below ask the render target for its device context, as in
[CID2D1GradientStopCollection1](#cid2d1gradientstopcollection1).

### Constructor

```freebasic
constructor
constructor( byval pID2D1ImageBrush as ID2D1ImageBrush ptr )
```

With a pointer the object holds that brush and takes over the reference that came with it. The
constructor without arguments is declared but has no body, so a program that declares
`dim brush as CID2D1ImageBrush` with no initialiser builds but does not link (an undefined
symbol): always construct the object from a pointer, `NULL` included.

| Parameter | Meaning |
| --- | --- |
| `pID2D1ImageBrush` | The brush, normally straight from `CreateImageBrush`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pImageBrush as ID2D1ImageBrush ptr
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), pImageBrush )
dim brush as CID2D1ImageBrush = pImageBrush
pDC->Release()
```

Microsoft Learn: [ID2D1ImageBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1imagebrush)

### Destructor

```freebasic
destructor
```

Releases the brush, if the object holds one; the brush in turn lets go of its image.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pImageBrush as ID2D1ImageBrush ptr
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), pImageBrush )
scope
    dim brush as CID2D1ImageBrush = pImageBrush
end scope                                ' released here
pDC->Release()
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1ImageBrush ptr
operator cast() as ID2D1Brush ptr
operator @() as ID2D1ImageBrush ptr ptr
operator *( byref imageBrush as CID2D1ImageBrush ) as ID2D1ImageBrush ptr
```

As for [CID2D1SolidColorBrush](#cast-operator--operator--2), for the brush in `m_pImageBrush`.
`@` currently stops the build with an internal compiler error; use the field.

**Returns** the brush pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1ImageBrush = cast( ID2D1ImageBrush ptr, NULL )
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), brush.m_pImageBrush )
dim pBrush as ID2D1Brush ptr = brush
pDC->Release()
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

As for [CID2D1SolidColorBrush](#getfactory-1): returns the factory with a new reference, and is
not guarded on an empty object.

**Returns** the factory.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pImageBrush as ID2D1ImageBrush ptr
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), pImageBrush )
dim brush as CID2D1ImageBrush = pImageBrush
dim pFactory as ID2D1Factory ptr = brush.GetFactory()
pFactory->Release()
pDC->Release()
```

### SetOpacity, GetOpacity

```freebasic
sub SetOpacity( byval opacity as FLOAT )
function GetOpacity() as FLOAT
```

As for [CID2D1SolidColorBrush](#setopacity-getopacity): sets or reads the opacity, 0 to 1.

**Returns** (`GetOpacity`) the opacity, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pImageBrush as ID2D1ImageBrush ptr
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), pImageBrush )
dim brush as CID2D1ImageBrush = pImageBrush
brush.SetOpacity( 0.5 )
pDC->Release()
```

### SetTransform, GetTransform

```freebasic
sub SetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub SetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
sub GetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub GetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
function GetTransform() as D2D1_MATRIX_3X2_F
```

As for [CID2D1SolidColorBrush](#settransform-gettransform); the source rectangle is in brush
space and moves with it.

**Returns** (the function form of `GetTransform`) the matrix; for an empty object, a zeroed one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pImageBrush as ID2D1ImageBrush ptr
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), pImageBrush )
dim brush as CID2D1ImageBrush = pImageBrush
brush.SetTransform( D2D1_MatrixScale( 4, 4 ) )
pDC->Release()
```

### SetImage, GetImage

```freebasic
sub SetImage( byval image as ID2D1Image ptr )
function GetImage() as ID2D1Image ptr
```

`SetImage` replaces the image; `NULL` leaves the brush with none. A [CID2D1Bitmap](SysWin-Direct2D-Bitmaps#cid2d1bitmap)
converts to `ID2D1Image ptr` by itself. `GetImage` returns the image with a new reference: release
it.

| Parameter | Meaning |
| --- | --- |
| `image` | The new image, or `NULL`. |

**Returns** (`GetImage`) the image, or `NULL` when the brush has none or the object is empty.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim brush as CID2D1ImageBrush = cast( ID2D1ImageBrush ptr, NULL )
pDC->CreateImageBrush( NULL, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), brush.m_pImageBrush )
brush.SetImage( bmp )
dim pImage as ID2D1Image ptr = brush.GetImage()
print ( pImage = cast( ID2D1Image ptr, bmp ) )            ' -1 (true)
pImage->Release()
pDC->Release()
```

Microsoft Learn: [ID2D1ImageBrush::SetImage](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-setimage), [ID2D1ImageBrush::GetImage](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-getimage)

### SetExtendModeX, GetExtendModeX

```freebasic
sub SetExtendModeX( byval extendModeX as D2D1_EXTEND_MODE )
function GetExtendModeX() as D2D1_EXTEND_MODE
```

Sets or reads what the brush paints to the left and right of the source rectangle:
`D2D1_EXTEND_MODE_CLAMP` (0), `…_WRAP` (1) or `…_MIRROR` (2), as for a
[bitmap brush](#setextendmodex-getextendmodex).

| Parameter | Meaning |
| --- | --- |
| `extendModeX` | The horizontal extend mode. |

**Returns** (`GetExtendModeX`) the mode, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pImageBrush as ID2D1ImageBrush ptr
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), pImageBrush )
dim brush as CID2D1ImageBrush = pImageBrush
brush.SetExtendModeX( D2D1_EXTEND_MODE_WRAP )
print brush.GetExtendModeX()             ' 1
pDC->Release()
```

Microsoft Learn: [ID2D1ImageBrush::SetExtendModeX](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-setextendmodex), [ID2D1ImageBrush::GetExtendModeX](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-getextendmodex)

### SetExtendModeY, GetExtendModeY

```freebasic
sub SetExtendModeY( byval extendModeY as D2D1_EXTEND_MODE )
function GetExtendModeY() as D2D1_EXTEND_MODE
```

Sets or reads what the brush paints above and below the source rectangle, with the same modes.

| Parameter | Meaning |
| --- | --- |
| `extendModeY` | The vertical extend mode. |

**Returns** (`GetExtendModeY`) the mode, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pImageBrush as ID2D1ImageBrush ptr
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), pImageBrush )
dim brush as CID2D1ImageBrush = pImageBrush
brush.SetExtendModeY( D2D1_EXTEND_MODE_WRAP )
print brush.GetExtendModeY()             ' 1
pDC->Release()
```

Microsoft Learn: [ID2D1ImageBrush::SetExtendModeY](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-setextendmodey), [ID2D1ImageBrush::GetExtendModeY](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-getextendmodey)

### SetInterpolationMode, GetInterpolationMode

```freebasic
sub SetInterpolationMode( byval InterpolationMode as D2D1_INTERPOLATION_MODE )
function GetInterpolationMode() as D2D1_INTERPOLATION_MODE
```

Sets or reads how the image is resampled when the brush scales or turns it: any
`D2D1_INTERPOLATION_MODE_…` value, from `NEAREST_NEIGHBOR` (0) to `HIGH_QUALITY_CUBIC` (5).
`D2D1_ImageBrushProperties` uses `D2D1_INTERPOLATION_MODE_LINEAR` (1).

| Parameter | Meaning |
| --- | --- |
| `InterpolationMode` | The resampling mode. |

**Returns** (`GetInterpolationMode`) the mode, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pImageBrush as ID2D1ImageBrush ptr
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), pImageBrush )
dim brush as CID2D1ImageBrush = pImageBrush
brush.SetInterpolationMode( D2D1_INTERPOLATION_MODE_HIGH_QUALITY_CUBIC )
print brush.GetInterpolationMode()       ' 5
pDC->Release()
```

Microsoft Learn: [ID2D1ImageBrush::SetInterpolationMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-setinterpolationmode), [ID2D1ImageBrush::GetInterpolationMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-getinterpolationmode)

### SetSourceRectangle, GetSourceRectangle

```freebasic
sub SetSourceRectangle( byref sourceRectangle as D2D1_RECT_F )
sub SetSourceRectangle( byval sourceRectangle as D2D1_RECT_F ptr )
function GetSourceRectangle() as D2D1_RECT_F
```

Sets or reads the rectangle of the image the brush paints with, in the image's own coordinates
(DIPs for a bitmap). The same rectangle is where that part of the image lies in brush space, so
`(1, 1, 3, 3)` paints a 2 × 2 piece of the image at (1, 1).

| Parameter | Meaning |
| --- | --- |
| `sourceRectangle` | The new rectangle, or a pointer to it. |

**Returns** (`GetSourceRectangle`) the rectangle; for an empty object, a zeroed one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pImageBrush as ID2D1ImageBrush ptr
pDC->CreateImageBrush( bmp, D2D1_ImageBrushProperties( D2D1_RectF( 0, 0, 8, 8 ) ), D2D1_BrushProperties(), pImageBrush )
dim brush as CID2D1ImageBrush = pImageBrush
brush.SetSourceRectangle( D2D1_RectF( 1, 1, 3, 3 ) )
dim r as D2D1_RECT_F = brush.GetSourceRectangle()
print r.left; r.top; r.right; r.bottom   ' 1 1 3 3
pDC->Release()
```

Microsoft Learn: [ID2D1ImageBrush::SetSourceRectangle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-setsourcerectangle), [ID2D1ImageBrush::GetSourceRectangle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1imagebrush-getsourcerectangle)

## See also

- [sys/win/direct2d](SysWin-Direct2D)
- [CID2D1RenderTarget](CID2D1RenderTarget) for the `Create…Brush` members and the drawing calls that take a brush
- [Direct2D bitmaps and colour contexts](SysWin-Direct2D-Bitmaps) for the bitmaps a bitmap or image brush paints with
- [Direct2D helpers](SysWin-Direct2D-Helpers) for `D2D1_ColorF`, `D2D1_GradientStop`, `D2D1_BitmapBrushProperties` and the matrix builders
- [CD2D1Factory](CD2D1Factory)
- [Direct2D interfaces](SysWin-Direct2D-Interfaces) for `ID2D1DeviceContext` and the other raw interfaces
- [GDI+ brushes](SysWin-GdiPlus-Brushes), the GDI+ counterparts
