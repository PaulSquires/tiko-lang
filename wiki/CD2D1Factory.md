[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **CD2D1Factory**

# CD2D1Factory
Creates the Direct2D factory that makes render targets, geometries and stroke styles.

<!-- scope: CD2D1Factory -->
<!-- scope: CD2D1Factory1 -->
<!-- scope: CD2D1Factory2 -->
<!-- scope: CD2D1Factory3 -->
<!-- scope: CD2D1Factory4 -->
<!-- scope: CD2D1Factory5 -->
<!-- scope: CD2D1Factory6 -->
<!-- scope: CD2D1Factory7 -->
<!-- scope: CD2D1Factory8 -->

Creates the Direct2D factory that makes render targets, geometries and stroke styles.

Everything Direct2D draws with starts at a factory. The factory makes the **render targets**
(a window, a GDI device context, a WIC bitmap or a DXGI surface) and the **device-independent
resources**: geometries, stroke styles and drawing state blocks. Brushes, bitmaps and layers are
made by a render target instead, see [CID2D1RenderTarget](CID2D1RenderTarget). A resource works
only with render targets from the same factory, so a program normally creates one factory and
keeps it for as long as it draws.

**Ownership.** A `CD2D1Factory` holds one `ID2D1Factory` interface, in its public field
`m_pFactory`. The constructor that takes a `D2D1_FACTORY_TYPE` creates it; the destructor
releases it. The default constructor creates nothing: every member of an empty object returns
`NULL`, 0 or `E_POINTER`. Never copy a factory object by value (`dim g as CD2D1Factory = f`, or a
`byval` parameter): the class has no copy constructor, so the copy holds the same pointer and both
release it. Pass it `byref`, or pass the interface pointer.

**What you must release.** Every `Create…` member returns a new interface pointer and the
reference that comes with it is yours: release it with `D2D1_SafeRelease( p )` (or
`p->Release()`) when you are done, or hand it to a wrapper class that releases it for you, such as
[CID2D1StrokeStyle](SysWin-Direct2D-Stroke-Styles) or [CID2D1Geometry](CID2D1Geometry). Each
resource keeps the factory alive, but release the resources before the factory goes out of scope
all the same.

**Errors.** The constructors and the `Create…` members store the `HRESULT` of the Direct2D call
with `SetLastError`; read `GetLastError()` straight after the call, before anything else (a
`print` can change it). `S_OK` (0) means success, and a failed `Create…` returns `NULL`. Members
that return an `HRESULT` return it directly.

**Units.** Direct2D measures in device-independent pixels (DIPs), 1/96 inch each. A render target
maps them to pixels by its DPI, so at 96 DPI one DIP is one pixel and at 144 DPI it is 1.5.

**Versions.** `CD2D1Factory1` to `CD2D1Factory8` each extend the one before and wrap the newer
`ID2D1Factory1` … `ID2D1Factory8` interface, which a newer Windows provides. Each constructor
creates the newest interface and stores the same object in every inherited field (`m_pFactory`,
`m_pFactory1` …), so every inherited member works on it. The later versions add only a
`CreateDevice…` member each. On a Windows that lacks the interface the constructor fails and the
object stays empty.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A window that draws a filled, tilted ellipse inside a dashed rounded frame. The factory creates a
render target for the memory device context of a [CGraphCtx](CGraphCtx) control, two geometries,
a rotated copy of one, and a dashed stroke style:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/direct2d"
using win, gui, direct2d

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

' Draws a filled, tilted ellipse inside a dashed rounded frame into a GDI device context
function RenderScene( byval hDC as HDC, byval nWidth as long, byval nHeight as long ) as HRESULT
    dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
    dim hr as HRESULT = GetLastError()
    if hr <> S_OK then return hr

    ' a render target for a device context: desktop DPI, 32-bit BGRA, alpha ignored
    dim pRT as ID2D1DCRenderTarget ptr = factory.CreateDCRenderTarget()
    if pRT = NULL then return GetLastError()
    dim rc as RECT = ( 0, 0, nWidth, nHeight )
    pRT->BindDC( hDC, rc )

    ' device-independent resources come from the factory
    dim pFrame as ID2D1RoundedRectangleGeometry ptr = factory.CreateRoundedRectangleGeometry( D2D1_RoundedRect( 20, 20, 280, 180, 12, 12 ) )
    dim pEllipse as ID2D1EllipseGeometry ptr = factory.CreateEllipseGeometry( D2D1_EllipseF( 150, 100, 90, 40 ) )
    dim pTilted as ID2D1TransformedGeometry ptr = factory.CreateTransformedGeometry( pEllipse, D2D1_MatrixRotation( -20, 150, 100 ) )
    dim pDashed as ID2D1StrokeStyle ptr = factory.CreateStrokeStyle( D2D1_StrokeStyleProperties( D2D1_CAP_STYLE_ROUND, D2D1_CAP_STYLE_ROUND, D2D1_CAP_STYLE_ROUND, , , D2D1_DASH_STYLE_DASH ), byval NULL, 0 )

    ' a brush belongs to the render target
    dim pBrush as ID2D1SolidColorBrush ptr
    pRT->CreateSolidColorBrush( D2D1_ColorF( D2D1_SteelBlue ), byval NULL, pBrush )

    pRT->BeginDraw()
    pRT->Clear( D2D1_ColorF( D2D1_White ) )
    pRT->FillGeometry( pTilted, pBrush )
    pRT->DrawGeometry( pFrame, pBrush, 3, pDashed )
    hr = pRT->EndDraw()

    D2D1_SafeRelease( pBrush )
    D2D1_SafeRelease( pDashed )
    D2D1_SafeRelease( pTilted )
    D2D1_SafeRelease( pEllipse )
    D2D1_SafeRelease( pFrame )
    D2D1_SafeRelease( pRT )
    return hr
end function

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "D2DFactoryDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Direct2D factory", @WndProc )
    pWindow.SetClientSize( 300, 200 )
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

The geometry and stroke-style pointers convert to the `ID2D1Geometry ptr` and
`ID2D1StrokeStyle ptr` parameters of the drawing calls by themselves; a brush pointer converts to
`ID2D1Brush ptr` the same way.

## Members

| Member | Does |
| --- | --- |
| **CD2D1Factory** | |
| [Constructor](#constructor) | Creates a single- or multithreaded Direct2D factory, or an empty object. |
| [Destructor](#destructor) | Releases the factory. |
| [Cast, Operator @, Operator *](#cast-operator--operator-) | Give the `ID2D1Factory` pointer, or its address. |
| [GetDesktopDpi](#getdesktopdpi) | Reads the desktop's horizontal and vertical DPI. |
| [GetDpi](#getdpi) | Returns the desktop's horizontal DPI. |
| [GetDpiX](#getdpix) | Returns the desktop's horizontal DPI. |
| [GetDpiY](#getdpiy) | Returns the desktop's vertical DPI. |
| [ReloadSystemMetrics](#reloadsystemmetrics) | Makes the factory read the system settings again. |
| [CreateRectangleGeometry](#createrectanglegeometry) | Creates a rectangle geometry. |
| [CreateRoundedRectangleGeometry](#createroundedrectanglegeometry) | Creates a rounded rectangle geometry. |
| [CreateEllipseGeometry](#createellipsegeometry) | Creates an ellipse geometry. |
| [CreateGeometryGroup](#creategeometrygroup) | Creates one geometry from several. |
| [CreateTransformedGeometry](#createtransformedgeometry) | Creates a geometry that is another one moved, scaled, rotated or skewed. |
| [CreatePathGeometry](#createpathgeometry) | Creates an empty path geometry to fill with figures. |
| [CreateStrokeStyle](#createstrokestyle) | Creates a stroke style: caps, joins and dashes. |
| [CreateDrawingStateBlock](#createdrawingstateblock) | Creates a block that saves and restores a render target's state. |
| [CreateWicBitmapRenderTarget](#createwicbitmaprendertarget) | Creates a render target that draws into a WIC bitmap. |
| [CreateHwndRenderTarget](#createhwndrendertarget) | Creates a render target that draws into a window. |
| [CreateDxgiSurfaceRenderTarget](#createdxgisurfacerendertarget) | Creates a render target that draws into a DXGI surface. |
| [CreateDCRenderTarget](#createdcrendertarget) | Creates a render target that draws into a GDI device context. |
| **CD2D1Factory1** | |
| [Constructor](#constructor-1) | Creates an `ID2D1Factory1`. |
| [Destructor](#destructor-1) | Releases it. |
| [Cast, Operator @, Operator *](#cast-operator--operator--1) | Give the `ID2D1Factory1` or `ID2D1Factory` pointer. |
| [CreateDevice](#createdevice) | Creates a Direct2D device on a Direct3D device. |
| [CreateStrokeStyle1](#createstrokestyle1) | Creates a stroke style that can ignore the world transform. |
| [CreatePathGeometry1](#createpathgeometry1) | Creates an empty `ID2D1PathGeometry1`. |
| [CreateDrawingStateBlock1](#createdrawingstateblock1) | Creates a drawing state block that also saves the blend and unit modes. |
| [CreateGdiMetafile](#creategdimetafile) | Loads an EMF metafile from a stream for drawing. |
| [RegisterEffectFromStream](#registereffectfromstream) | Registers a custom effect described by XML in a stream. |
| [RegisterEffectFromString](#registereffectfromstring) | Registers a custom effect described by XML in a string. |
| [UnregisterEffect](#unregistereffect) | Removes a custom effect registration. |
| [GetRegisteredEffects](#getregisteredeffects) | Lists the class IDs of the registered effects. |
| [GetEffectProperties](#geteffectproperties) | Reads the properties an effect declares. |
| **CD2D1Factory2** | |
| [Constructor](#constructor-2) | Creates an `ID2D1Factory2`. |
| [Destructor](#destructor-2) | Releases it. |
| [Cast, Operator @, Operator *](#cast-operator--operator--2) | Give the `ID2D1Factory2` or `ID2D1Factory` pointer. |
| [CreateDevice1](#createdevice1) | Creates an `ID2D1Device1`. |
| **CD2D1Factory3** | |
| [Constructor](#constructor-3) | Creates an `ID2D1Factory3`. |
| [Destructor](#destructor-3) | Releases it. |
| [Cast, Operator @, Operator *](#cast-operator--operator--3) | Give the `ID2D1Factory3` or `ID2D1Factory` pointer. |
| [CreateDevice2](#createdevice2) | Creates an `ID2D1Device2`. |
| **CD2D1Factory4** | |
| [Constructor](#constructor-4) | Creates an `ID2D1Factory4`. |
| [Destructor](#destructor-4) | Releases it. |
| [Cast, Operator @, Operator *](#cast-operator--operator--4) | Give the `ID2D1Factory4` or `ID2D1Factory` pointer. |
| [CreateDevice3](#createdevice3) | Creates an `ID2D1Device3`. |
| **CD2D1Factory5** | |
| [Constructor](#constructor-5) | Creates an `ID2D1Factory5`. |
| [Destructor](#destructor-5) | Releases it. |
| [Cast, Operator @, Operator *](#cast-operator--operator--5) | Give the `ID2D1Factory5` or `ID2D1Factory` pointer. |
| [CreateDevice4](#createdevice4) | Creates an `ID2D1Device4`. |
| **CD2D1Factory6** | |
| [Constructor](#constructor-6) | Creates an `ID2D1Factory6`. |
| [Destructor](#destructor-6) | Releases it. |
| [Cast, Operator @, Operator *](#cast-operator--operator--6) | Give the `ID2D1Factory6` or `ID2D1Factory` pointer. |
| [CreateDevice5](#createdevice5) | Creates an `ID2D1Device5`. |
| **CD2D1Factory7** | |
| [Constructor](#constructor-7) | Creates an `ID2D1Factory7`. |
| [Destructor](#destructor-7) | Releases it. |
| [Cast, Operator @, Operator *](#cast-operator--operator--7) | Give the `ID2D1Factory7` or `ID2D1Factory` pointer. |
| [CreateDevice6](#createdevice6) | Creates an `ID2D1Device6`. |
| **CD2D1Factory8** | |
| [Constructor](#constructor-8) | Creates an `ID2D1Factory8`. |
| [Destructor](#destructor-8) | Releases it. |
| [Cast, Operator @, Operator *](#cast-operator--operator--8) | Give the `ID2D1Factory8` or `ID2D1Factory` pointer. |
| [CreateDevice7](#createdevice7) | Creates an `ID2D1Device7`. |

## Reference

## CD2D1Factory

### Constructor

```freebasic
constructor
constructor( byval factoryType as D2D1_FACTORY_TYPE )
```

The form with a `factoryType` creates a Direct2D factory and keeps its `ID2D1Factory` interface in
`m_pFactory`. The `HRESULT` of the creation is stored with `SetLastError`.

A **single-threaded** factory (`D2D1_FACTORY_TYPE_SINGLE_THREADED`) and the resources it makes
must be used from one thread at a time; it is the faster choice for a program that draws from one
thread. A **multithreaded** factory (`D2D1_FACTORY_TYPE_MULTI_THREADED`) serialises access
itself, so several threads may share it and its resources; see
[CID2D1Multithread](SysWin-Direct2D-Stroke-Styles#cid2d1multithread) for taking its lock
yourself.

The form without arguments creates no factory: the object is empty until something stores an
interface pointer in `m_pFactory`.

| Parameter | Meaning |
| --- | --- |
| `factoryType` | `D2D1_FACTORY_TYPE_SINGLE_THREADED` or `D2D1_FACTORY_TYPE_MULTI_THREADED`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim hr as HRESULT = GetLastError()
if hr <> S_OK then print "no Direct2D factory: &h"; hex( hr )
```

Microsoft Learn: [D2D1CreateFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-d2d1createfactory)

### Destructor

```freebasic
destructor
```

Releases the factory interface, if the object holds one. Resources created from the factory keep
their own reference to it, but release them first all the same.

**Example**

```freebasic
dim pFactory as CD2D1Factory ptr = new CD2D1Factory( D2D1_FACTORY_TYPE_SINGLE_THREADED )
print "DPI:"; pFactory->GetDpiX()
delete pFactory
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1Factory ptr
operator @() as ID2D1Factory ptr ptr
operator *( byref factory as CD2D1Factory ) as ID2D1Factory ptr
```

`cast` gives the `ID2D1Factory` pointer, so a `CD2D1Factory` can be passed wherever an
`ID2D1Factory ptr` is expected; `*factory` gives the same pointer and lets you call an interface
method directly, `(*factory)->ReloadSystemMetrics()`. Neither adds a reference: do not release
what they return.

`@` returns the address of `m_pFactory`, for a function that writes a new factory pointer into an
output parameter. It does not release a factory the object already holds. Applying `@` to a
factory object currently stops the build with an internal compiler error; until it builds, pass
`m_pFactory` itself, which is the same field.

**Returns** the interface pointer (`NULL` for an empty object), or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pFactory as ID2D1Factory ptr = factory          ' cast
print ( *factory )->ReloadSystemMetrics()           ' 0
dim empty as CD2D1Factory
D2D1CreateFactory( D2D1_FACTORY_TYPE_MULTI_THREADED, IID_ID2D1Factory, byval NULL, empty.m_pFactory )
```

### GetDesktopDpi

```freebasic
sub GetDesktopDpi( byref dpiX as single, byref dpiY as single )
sub GetDesktopDpi( byval dpiX as single ptr, byval dpiY as single ptr )
```

Reads the horizontal and vertical DPI of the desktop into `dpiX` and `dpiY`, as the factory last
read them (at creation, or at the last [ReloadSystemMetrics](#reloadsystemmetrics)). The values
follow the program's DPI awareness: a program that is not DPI aware reads 96 whatever the display
scaling; a system-DPI-aware program reads the real value, 168 at 175 %. Microsoft marks the
underlying method as deprecated in favour of the DPI of the window you draw in
(`GetDpiForWindow`); for a whole-desktop value it still works.

The object must hold a factory: on an empty object this member is not guarded.

| Parameter | Meaning |
| --- | --- |
| `dpiX` | Receives the horizontal DPI. |
| `dpiY` | Receives the vertical DPI. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim as single dpiX, dpiY
factory.GetDesktopDpi( dpiX, dpiY )
print dpiX; " x"; dpiY
```

Microsoft Learn: [ID2D1Factory::GetDesktopDpi](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-getdesktopdpi)

### GetDpi

```freebasic
function GetDpi() as single
```

Returns the horizontal DPI of the desktop, the same value as [GetDpiX](#getdpix).

**Returns** the DPI, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
print "scale"; factory.GetDpi() / 96   ' 1 when the program is not DPI aware
```

### GetDpiX

```freebasic
function GetDpiX() as single
```

Returns the horizontal DPI of the desktop, as [GetDesktopDpi](#getdesktopdpi) reads it.

**Returns** the DPI, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
print "horizontal DPI:"; factory.GetDpiX()
```

### GetDpiY

```freebasic
function GetDpiY() as single
```

Returns the vertical DPI of the desktop, as [GetDesktopDpi](#getdesktopdpi) reads it.

**Returns** the DPI, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
print "vertical DPI:"; factory.GetDpiY()
```

### ReloadSystemMetrics

```freebasic
function ReloadSystemMetrics() as HRESULT
```

Makes the factory read the system settings again, the desktop DPI among them. Call it after a
`WM_SETTINGCHANGE` or `WM_DISPLAYCHANGE` and before you create new render targets; targets that
already exist keep their settings.

**Returns** `S_OK` (0) on success, otherwise the failing `HRESULT`; `E_POINTER` for an empty
object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
if factory.ReloadSystemMetrics() = S_OK then print "now"; factory.GetDpiX(); " DPI"
```

Microsoft Learn: [ID2D1Factory::ReloadSystemMetrics](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-reloadsystemmetrics)

### CreateRectangleGeometry

```freebasic
function CreateRectangleGeometry( byref rectangle as D2D1_RECT_F ) as ID2D1RectangleGeometry ptr
function CreateRectangleGeometry( byval rectangle as D2D1_RECT_F ptr ) as ID2D1RectangleGeometry ptr
```

Creates a geometry that is the rectangle `rectangle`, given as left, top, right and bottom in
DIPs. Build one with `D2D1_RectF`.

**Returns** the new geometry, which you release; `NULL` on failure, with the `HRESULT` in
`GetLastError()`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pRect as ID2D1RectangleGeometry ptr = factory.CreateRectangleGeometry( D2D1_RectF( 10, 10, 110, 60 ) )
D2D1_SafeRelease( pRect )
```

Microsoft Learn: [ID2D1Factory::CreateRectangleGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createrectanglegeometry%28constd2d1_rect_f__id2d1rectanglegeometry%29)

### CreateRoundedRectangleGeometry

```freebasic
function CreateRoundedRectangleGeometry( byref roundedRectangle as D2D1_ROUNDED_RECT ) as ID2D1RoundedRectangleGeometry ptr
function CreateRoundedRectangleGeometry( byval roundedRectangle as D2D1_ROUNDED_RECT ptr ) as ID2D1RoundedRectangleGeometry ptr
```

Creates a geometry that is a rectangle with rounded corners: `roundedRectangle` holds the
rectangle and the x and y radii of the corners. Build one with `D2D1_RoundedRect`.

**Returns** the new geometry, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pRounded as ID2D1RoundedRectangleGeometry ptr = factory.CreateRoundedRectangleGeometry( D2D1_RoundedRect( 0, 0, 100, 50, 8, 8 ) )
D2D1_SafeRelease( pRounded )
```

Microsoft Learn: [ID2D1Factory::CreateRoundedRectangleGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createroundedrectanglegeometry%28constd2d1_rounded_rect__id2d1roundedrectanglegeometry%29)

### CreateEllipseGeometry

```freebasic
function CreateEllipseGeometry( byref ellipse as const D2D1_ELLIPSE ) as ID2D1EllipseGeometry ptr
function CreateEllipseGeometry( byval ellipse as const D2D1_ELLIPSE ptr ) as ID2D1EllipseGeometry ptr
```

Creates a geometry that is an ellipse: `ellipse` holds the centre point and the x and y radii.
Build one with `D2D1_EllipseF`; equal radii give a circle.

**Returns** the new geometry, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pCircle as ID2D1EllipseGeometry ptr = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
D2D1_SafeRelease( pCircle )
```

Microsoft Learn: [ID2D1Factory::CreateEllipseGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createellipsegeometry%28constd2d1_ellipse__id2d1ellipsegeometry%29)

### CreateGeometryGroup

```freebasic
function CreateGeometryGroup( byval fillMode as D2D1_FILL_MODE, byval geometries as ID2D1Geometry ptr, byval geometriesCount as UINT32 ) as ID2D1GeometryGroup ptr
```

Creates one geometry made of `geometriesCount` others. The group keeps its own references to
them, so you may release yours once it is created. `fillMode` decides which overlapping areas
count as inside: with `D2D1_FILL_MODE_ALTERNATE` an area covered twice is outside (a ring from two
circles), with `D2D1_FILL_MODE_WINDING` it is inside.

Direct2D reads `geometries` as an **array of geometry pointers**, although the parameter is
declared as a single `ID2D1Geometry ptr`: pass the address of the array's first element as
`cast( any ptr, @array(0) )`.

| Parameter | Meaning |
| --- | --- |
| `fillMode` | `D2D1_FILL_MODE_ALTERNATE` or `D2D1_FILL_MODE_WINDING`. |
| `geometries` | The address of an array of `ID2D1Geometry ptr`. |
| `geometriesCount` | The number of elements in the array. |

**Returns** the new group, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim parts(1) as ID2D1Geometry ptr
parts(0) = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 40 ) )
parts(1) = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 20, 20 ) )
dim pRing as ID2D1GeometryGroup ptr = factory.CreateGeometryGroup( D2D1_FILL_MODE_ALTERNATE, cast( any ptr, @parts(0) ), 2 )
D2D1_SafeRelease( parts(0) ) : D2D1_SafeRelease( parts(1) ) : D2D1_SafeRelease( pRing )
```

Microsoft Learn: [ID2D1Factory::CreateGeometryGroup](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-creategeometrygroup)

### CreateTransformedGeometry

```freebasic
function CreateTransformedGeometry( byval sourceGeometry as ID2D1Geometry ptr, byref transform as D2D1_MATRIX_3X2_F ) as ID2D1TransformedGeometry ptr
function CreateTransformedGeometry( byval sourceGeometry as ID2D1Geometry ptr, byval transform as D2D1_MATRIX_3X2_F ptr ) as ID2D1TransformedGeometry ptr
```

Creates a geometry that is `sourceGeometry` with the matrix `transform` applied: moved, scaled,
rotated or skewed. The source is not changed, and the new geometry keeps a reference to it. A
stroke drawn on the result is not transformed, only the shape is: a 2-DIP line stays 2 DIPs
wide. The `D2D1_Matrix…` helpers build the matrix (`D2D1_MatrixRotation`, `D2D1_MatrixScale`,
`D2D1_MatrixTranslation`, `D2D1_MatrixSkew`).

| Parameter | Meaning |
| --- | --- |
| `sourceGeometry` | Any geometry; a pointer to a rectangle, ellipse or path geometry converts by itself. |
| `transform` | The matrix to apply. |

**Returns** the new geometry, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pEllipse as ID2D1EllipseGeometry ptr = factory.CreateEllipseGeometry( D2D1_EllipseF( 50, 50, 40, 20 ) )
dim pTilted as ID2D1TransformedGeometry ptr = factory.CreateTransformedGeometry( pEllipse, D2D1_MatrixRotation( 45, 50, 50 ) )
D2D1_SafeRelease( pTilted ) : D2D1_SafeRelease( pEllipse )
```

Microsoft Learn: [ID2D1Factory::CreateTransformedGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createtransformedgeometry%28id2d1geometry_constd2d1_matrix_3x2_f__id2d1transformedgeometry%29)

### CreatePathGeometry

```freebasic
function CreatePathGeometry() as ID2D1PathGeometry ptr
```

Creates an empty path geometry. Fill it once: `Open` it for an `ID2D1GeometrySink`, add figures
of lines, arcs and Bézier curves, then `Close` the sink. After that the path can be drawn but no
longer changed. See [Direct2D geometries](SysWin-Direct2D-Geometries) for the sink.

**Returns** the new path, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pPath as ID2D1PathGeometry ptr = factory.CreatePathGeometry()
dim pSink as ID2D1GeometrySink ptr
if pPath andalso pPath->Open( pSink ) = S_OK then print "ready for figures"
D2D1_SafeRelease( pSink ) : D2D1_SafeRelease( pPath )
```

Microsoft Learn: [ID2D1Factory::CreatePathGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createpathgeometry)

### CreateStrokeStyle

```freebasic
function CreateStrokeStyle( byref strokeStyleProperties as D2D1_STROKE_STYLE_PROPERTIES, byref dashes as const FLOAT, byval dashesCount as UINT32 ) as ID2D1StrokeStyle ptr
function CreateStrokeStyle( byval strokeStyleProperties as D2D1_STROKE_STYLE_PROPERTIES ptr, byval dashes as const FLOAT ptr, byval dashesCount as UINT32 ) as ID2D1StrokeStyle ptr
```

Creates a stroke style: how lines and outlines end (caps), how their segments meet (joins), and
whether they are dashed. `strokeStyleProperties` holds the caps, the join, the miter limit, the
dash style and the dash offset; `D2D1_StrokeStyleProperties` builds it with flat caps, mitred
joins, a miter limit of 10 and a solid line as the defaults.

With `D2D1_DASH_STYLE_CUSTOM` the dash pattern comes from `dashes`: alternating dash and gap
lengths, in multiples of the stroke width. For any other dash style pass no dashes:
`byval NULL` and 0 in the first form, `NULL` and 0 in the second. A stroke style object cannot be
changed; create another one for another style. [CID2D1StrokeStyle](SysWin-Direct2D-Stroke-Styles)
wraps the result and reads its settings back.

| Parameter | Meaning |
| --- | --- |
| `strokeStyleProperties` | The caps, join, miter limit, dash style and dash offset. |
| `dashes` | The first element of an array of dash and gap lengths, or none. |
| `dashesCount` | The number of elements in `dashes`. |

**Returns** the new stroke style, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim dashes(3) as FLOAT = { 4, 1, 1, 1 }   ' dash, gap, dot, gap
dim props as D2D1_STROKE_STYLE_PROPERTIES = D2D1_StrokeStyleProperties( , , D2D1_CAP_STYLE_ROUND, , , D2D1_DASH_STYLE_CUSTOM )
dim pStyle as ID2D1StrokeStyle ptr = factory.CreateStrokeStyle( props, dashes(0), 4 )
D2D1_SafeRelease( pStyle )
```

Microsoft Learn: [ID2D1Factory::CreateStrokeStyle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createstrokestyle%28constd2d1_stroke_style_properties__constfloat_uint32_id2d1strokestyle%29)

### CreateDrawingStateBlock

```freebasic
function CreateDrawingStateBlock( byref drawingStateDescription as const D2D1_DRAWING_STATE_DESCRIPTION, byval textRenderingParams as IDWriteRenderingParams ptr ) as ID2D1DrawingStateBlock ptr
function CreateDrawingStateBlock( byval drawingStateDescription as const D2D1_DRAWING_STATE_DESCRIPTION ptr, byval textRenderingParams as IDWriteRenderingParams ptr ) as ID2D1DrawingStateBlock ptr
function CreateDrawingStateBlock( byref drawingStateDescription as const D2D1_DRAWING_STATE_DESCRIPTION ) as ID2D1DrawingStateBlock ptr
function CreateDrawingStateBlock( byval drawingStateDescription as const D2D1_DRAWING_STATE_DESCRIPTION ptr ) as ID2D1DrawingStateBlock ptr
function CreateDrawingStateBlock() as ID2D1DrawingStateBlock ptr
```

Creates a drawing state block: a container for a render target's antialiasing modes, its two
tags, its transform and its text rendering parameters. `SaveDrawingState` on a render target
copies its current state into the block and `RestoreDrawingState` puts it back, so a routine can
change the transform and leave things as it found them.

`drawingStateDescription` sets the block's first contents (`D2D1_DrawingStateDescription` builds
one); the forms without it start from the defaults (per-primitive antialiasing, default text
antialiasing, no tags, the identity transform). The forms without `textRenderingParams` store no
text rendering parameters.

| Parameter | Meaning |
| --- | --- |
| `drawingStateDescription` | The antialiasing modes, tags and transform to start with. |
| `textRenderingParams` | DirectWrite rendering parameters to store, or `NULL`. |

**Returns** the new block, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pState as ID2D1DrawingStateBlock ptr = factory.CreateDrawingStateBlock()
' pRT->SaveDrawingState( pState ) ... change the transform ... pRT->RestoreDrawingState( pState )
D2D1_SafeRelease( pState )
```

Microsoft Learn: [ID2D1Factory::CreateDrawingStateBlock](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createdrawingstateblock%28constd2d1_drawing_state_description_idwriterenderingparams_id2d1drawingstateblock%29)

### CreateWicBitmapRenderTarget

```freebasic
function CreateWicBitmapRenderTarget( byval target as IWICBitmap ptr, byref renderTargetProperties as D2D1_RENDER_TARGET_PROPERTIES ) as ID2D1RenderTarget ptr
function CreateWicBitmapRenderTarget( byval target as IWICBitmap ptr, byval renderTargetProperties as D2D1_RENDER_TARGET_PROPERTIES ptr ) as ID2D1RenderTarget ptr
```

Creates a render target that draws into the Windows Imaging Component bitmap `target`, which
needs no window: use it to draw an image and then save it with a WIC encoder. The bitmap must have
a pixel format Direct2D can draw into, such as 32-bit premultiplied BGRA
(`IID_WICPixelFormat32bppPBGRA`). With the properties from `D2D1_RenderTargetProperties()` the
target takes the bitmap's pixel format and draws at 96 DPI, so one DIP is one pixel: a 64 × 32
bitmap gives a target of 64 × 32 DIPs.

| Parameter | Meaning |
| --- | --- |
| `target` | The WIC bitmap to draw into. |
| `renderTargetProperties` | Pixel format, DPI, software or hardware rendering, and feature level. |

**Returns** the new render target, which you release before the bitmap; `NULL` on failure.

**Example**

```freebasic
dim pWic as IWICImagingFactory ptr
CoCreateInstance( @CLSID_WICImagingFactory, NULL, CLSCTX_INPROC_SERVER, @IID_IWICImagingFactory, @pWic )
dim pBitmap as IWICBitmap ptr
pWic->CreateBitmap( 64, 32, IID_WICPixelFormat32bppPBGRA, WICBitmapCacheOnLoad, pBitmap )
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pRT as ID2D1RenderTarget ptr = factory.CreateWicBitmapRenderTarget( pBitmap, D2D1_RenderTargetProperties() )
```

Microsoft Learn: [ID2D1Factory::CreateWicBitmapRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createwicbitmaprendertarget%28iwicbitmap_constd2d1_render_target_properties__id2d1rendertarget%29)

### CreateHwndRenderTarget

```freebasic
function CreateHwndRenderTarget( byref renderTargetProperties as D2D1_RENDER_TARGET_PROPERTIES, byref hwndRenderTargetProperties as D2D1_HWND_RENDER_TARGET_PROPERTIES ) as ID2D1HwndRenderTarget ptr
function CreateHwndRenderTarget( byval renderTargetProperties as D2D1_RENDER_TARGET_PROPERTIES ptr, byval hwndRenderTargetProperties as D2D1_HWND_RENDER_TARGET_PROPERTIES ptr ) as ID2D1HwndRenderTarget ptr
```

Creates a render target that draws into a window's client area, on the graphics card when one
is available. `hwndRenderTargetProperties` names the window and the size of the target in
pixels, normally the client size; build it with `D2D1_HwndRenderTargetProperties`. When the
window is resized, call the target's `Resize` rather than creating a new one.

A window target can be lost, for example when the display driver restarts: `EndDraw` then
returns `D2DERR_RECREATE_TARGET`. Release the target and everything it created (brushes,
bitmaps) and create them again; the factory and its geometries and stroke styles stay valid.

| Parameter | Meaning |
| --- | --- |
| `renderTargetProperties` | Pixel format, DPI (0 for the default), rendering type and feature level. |
| `hwndRenderTargetProperties` | The window, the pixel size and the present options. |

**Returns** the new render target, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pRT as ID2D1HwndRenderTarget ptr = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), _
    D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( GetWindowClientWidth( hwnd ), GetWindowClientHeight( hwnd ) ) ) )
```

Microsoft Learn: [ID2D1Factory::CreateHwndRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createhwndrendertarget%28constd2d1_render_target_properties__constd2d1_hwnd_render_target_properties__id2d1hwndrendertarget%29)

### CreateDxgiSurfaceRenderTarget

```freebasic
function CreateDxgiSurfaceRenderTarget( byval dxgiSurface as IDXGISurface ptr, byref renderTargetProperties as D2D1_RENDER_TARGET_PROPERTIES ) as ID2D1RenderTarget ptr
function CreateDxgiSurfaceRenderTarget( byval dxgiSurface as IDXGISurface ptr, byval renderTargetProperties as D2D1_RENDER_TARGET_PROPERTIES ptr ) as ID2D1RenderTarget ptr
```

Creates a render target that draws into a DXGI surface, such as the back buffer of a swap chain
or a Direct3D texture, so Direct2D can draw into a Direct3D scene. The surface's Direct3D device
must have been created with BGRA support. The surface comes from Direct3D, which `sys/win` does
not wrap; see [DXGI interfaces](SysWin-DXGI-Interfaces).

| Parameter | Meaning |
| --- | --- |
| `dxgiSurface` | The surface to draw into. |
| `renderTargetProperties` | Pixel format (that of the surface, or unknown to take it), DPI and rendering type. |

**Returns** the new render target, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pSurface as IDXGISurface ptr   ' for example a swap chain's back buffer
dim pRT as ID2D1RenderTarget ptr = factory.CreateDxgiSurfaceRenderTarget( pSurface, _
    D2D1_RenderTargetProperties( D2D1_RENDER_TARGET_TYPE_DEFAULT, D2D1_PixelFormat( DXGI_FORMAT_UNKNOWN, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
```

Microsoft Learn: [ID2D1Factory::CreateDxgiSurfaceRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createdxgisurfacerendertarget%28idxgisurface_constd2d1_render_target_properties__id2d1rendertarget%29)

### CreateDCRenderTarget

```freebasic
function CreateDCRenderTarget( byref renderTargetProperties as D2D1_RENDER_TARGET_PROPERTIES ) as ID2D1DCRenderTarget ptr
function CreateDCRenderTarget( byval renderTargetProperties as D2D1_RENDER_TARGET_PROPERTIES ptr ) as ID2D1DCRenderTarget ptr
function CreateDCRenderTarget( byval targetType as D2D1_RENDER_TARGET_TYPE = D2D1_RENDER_TARGET_TYPE_DEFAULT, byval pixelFormat as DXGI_FORMAT = DXGI_FORMAT_B8G8R8A8_UNORM, byval alphaMode as D2D1_ALPHA_MODE = D2D1_ALPHA_MODE_IGNORE, byval dpiX as single = -1, byval dpiY as single = -1, byval usage as D2D1_RENDER_TARGET_USAGE = D2D1_RENDER_TARGET_USAGE_NONE, byval minLevel as D2D1_FEATURE_LEVEL = D2D1_FEATURE_LEVEL_DEFAULT ) as ID2D1DCRenderTarget ptr
```

Creates a render target that draws into a GDI device context: a window's DC, a memory DC, a
printer DC. Before drawing, bind it to the DC and the rectangle to draw in with the target's
`BindDC`, and bind it again whenever the DC or the rectangle changes.

A DC target needs a pixel format GDI understands: `DXGI_FORMAT_B8G8R8A8_UNORM` with
`D2D1_ALPHA_MODE_IGNORE` or `D2D1_ALPHA_MODE_PREMULTIPLIED`. Properties with an unknown format,
such as those `D2D1_RenderTargetProperties()` gives, make it fail with
`D2DERR_UNSUPPORTED_PIXEL_FORMAT`. The third form fills the properties in for you: with no
arguments it asks for BGRA with alpha ignored, at the desktop DPI (a `dpiX` or `dpiY` of -1 means
the value from [GetDesktopDpi](#getdesktopdpi)).

| Parameter | Meaning |
| --- | --- |
| `renderTargetProperties` | The complete properties. |
| `targetType` | `D2D1_RENDER_TARGET_TYPE_DEFAULT`, `…_SOFTWARE` or `…_HARDWARE`. |
| `pixelFormat`, `alphaMode` | The pixel format. |
| `dpiX`, `dpiY` | The DPI; -1 for the desktop DPI. |
| `usage` | `D2D1_RENDER_TARGET_USAGE_*` flags, for example `…_GDI_COMPATIBLE`. |
| `minLevel` | The lowest Direct3D feature level for hardware rendering. |

**Returns** the new render target, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pRT as ID2D1DCRenderTarget ptr = factory.CreateDCRenderTarget()
dim hDC as HDC = GetDC( hwnd )
var (l, t, r, b) = GetWindowClientRect( hwnd )
dim rc as RECT = ( l, t, r, b )
if pRT then pRT->BindDC( hDC, rc )
```

Microsoft Learn: [ID2D1Factory::CreateDCRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createdcrendertarget)

## CD2D1Factory1

`CD2D1Factory1` extends `CD2D1Factory` and wraps `ID2D1Factory1` (field `m_pFactory1`). Besides
everything above it creates Direct2D devices, which draw through a device context with effects,
and it manages custom effects.

### Constructor

```freebasic
constructor
constructor( byval factoryType as D2D1_FACTORY_TYPE )
```

The form with a `factoryType` creates an `ID2D1Factory1` and stores it both in `m_pFactory1` and
in the inherited `m_pFactory`, so every `CD2D1Factory` member works on it. The `HRESULT` is stored
with `SetLastError`. The form without arguments creates nothing.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
if factory.m_pFactory1 = NULL then print "ID2D1Factory1 is not available"
```

Microsoft Learn: [ID2D1Factory1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1factory1)

### Destructor

```freebasic
destructor
```

Releases `m_pFactory1`; the inherited destructor then releases `m_pFactory`.

**Example**

```freebasic
dim pFactory as CD2D1Factory1 ptr = new CD2D1Factory1( D2D1_FACTORY_TYPE_SINGLE_THREADED )
delete pFactory
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1Factory1 ptr ptr
operator cast() as ID2D1Factory1 ptr
operator cast() as ID2D1Factory ptr
operator *( byref factory as CD2D1Factory1 ) as ID2D1Factory1 ptr
```

The two `cast`s give the factory as an `ID2D1Factory1 ptr` or an `ID2D1Factory ptr`; `*` gives
the `ID2D1Factory1` pointer. None adds a reference. `@` returns the address of `m_pFactory1` only:
a pointer stored through it leaves `m_pFactory` empty, so the inherited members would not see it.
Applying `@` to the object currently stops the build with an internal compiler error.

**Returns** the interface pointer, or the address of `m_pFactory1`.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim p1 as ID2D1Factory1 ptr = factory
print ( p1 = *factory )   ' -1: the same pointer
```

### CreateDevice

```freebasic
function CreateDevice( byval dxgiDevice as IDXGIDevice ptr ) as ID2D1Device ptr
```

Creates a Direct2D device on the Direct3D device whose `IDXGIDevice` interface is `dxgiDevice`.
The device creates `ID2D1DeviceContext` objects, the render targets of effects, command lists and
printing. The Direct3D 11 device must have been created with
`D3D11_CREATE_DEVICE_BGRA_SUPPORT`; query it for `IID_IDXGIDevice` to get `dxgiDevice`.

**Returns** the new device, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pDxgiDevice as IDXGIDevice ptr   ' the IDXGIDevice of a Direct3D 11 device
dim pDevice as ID2D1Device ptr = factory.CreateDevice( pDxgiDevice )
D2D1_SafeRelease( pDevice )
```

Microsoft Learn: [ID2D1Factory1::CreateDevice](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-createdevice)

### CreateStrokeStyle1

```freebasic
function CreateStrokeStyle1( byref strokeStyleProperties as D2D1_STROKE_STYLE_PROPERTIES1, byref dashes as const FLOAT, byval dashesCount as UINT32 ) as ID2D1StrokeStyle1 ptr
function CreateStrokeStyle1( byval strokeStyleProperties as D2D1_STROKE_STYLE_PROPERTIES1 ptr, byref dashes as const FLOAT ptr, byval dashesCount as UINT32 ) as ID2D1StrokeStyle1 ptr
```

Creates a stroke style like [CreateStrokeStyle](#createstrokestyle), with one more setting, the
transform type: `D2D1_STROKE_TRANSFORM_TYPE_NORMAL` scales the stroke with the world transform,
`…_FIXED` keeps its width whatever the transform, and `…_HAIRLINE` draws it one pixel wide.
`D2D1_StrokeStyleProperties1` builds the properties.

In the second form `dashes` is a pointer passed by reference: pass a pointer variable or `NULL`.

**Returns** the new stroke style, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim props as D2D1_STROKE_STYLE_PROPERTIES1 = D2D1_StrokeStyleProperties1( , , , , , , , D2D1_STROKE_TRANSFORM_TYPE_HAIRLINE )
dim pStyle as ID2D1StrokeStyle1 ptr = factory.CreateStrokeStyle1( props, byval NULL, 0 )
D2D1_SafeRelease( pStyle )
```

Microsoft Learn: [ID2D1Factory1::CreateStrokeStyle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-createstrokestyle%28constd2d1_stroke_style_properties1__constfloat_uint32_id2d1strokestyle1%29)

### CreatePathGeometry1

```freebasic
function CreatePathGeometry1() as ID2D1PathGeometry1 ptr
```

Creates an empty `ID2D1PathGeometry1`, a path geometry that can also find a point and tangent at
a given length along a segment. It is filled like the path of
[CreatePathGeometry](#createpathgeometry).

**Returns** the new path, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pPath as ID2D1PathGeometry1 ptr = factory.CreatePathGeometry1()
D2D1_SafeRelease( pPath )
```

Microsoft Learn: [ID2D1Factory1::CreatePathGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-createpathgeometry)

### CreateDrawingStateBlock1

```freebasic
function CreateDrawingStateBlock1( byref drawingStateDescription as D2D1_DRAWING_STATE_DESCRIPTION1, byval textRenderingParams as IDWriteRenderingParams ptr ) as ID2D1DrawingStateBlock1 ptr
function CreateDrawingStateBlock1( byval drawingStateDescription as D2D1_DRAWING_STATE_DESCRIPTION1 ptr, byval textRenderingParams as IDWriteRenderingParams ptr ) as ID2D1DrawingStateBlock1 ptr
function CreateDrawingStateBlock1( byref drawingStateDescription as D2D1_DRAWING_STATE_DESCRIPTION1 ) as ID2D1DrawingStateBlock1 ptr
function CreateDrawingStateBlock1( byval drawingStateDescription as D2D1_DRAWING_STATE_DESCRIPTION1 ptr ) as ID2D1DrawingStateBlock1 ptr
function CreateDrawingStateBlock1() as ID2D1DrawingStateBlock1 ptr
```

Creates a drawing state block like [CreateDrawingStateBlock](#createdrawingstateblock) that also
holds the primitive blend mode and the unit mode (DIPs or pixels) of a device context.
`D2D1_DrawingStateDescription1` builds the description.

The second form, a description pointer with `textRenderingParams`, goes through the older
`ID2D1Factory::CreateDrawingStateBlock`: the block it returns keeps the antialiasing modes, tags
and transform of the description but starts with the default blend and unit modes. Use another
form when those two matter.

**Returns** the new block, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim desc as D2D1_DRAWING_STATE_DESCRIPTION1 = D2D1_DrawingStateDescription1( , , , , , , D2D1_UNIT_MODE_PIXELS )
dim pState as ID2D1DrawingStateBlock1 ptr = factory.CreateDrawingStateBlock1( desc )
D2D1_SafeRelease( pState )
```

Microsoft Learn: [ID2D1Factory1::CreateDrawingStateBlock](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-createdrawingstateblock%28constd2d1_drawing_state_description1_idwriterenderingparams_id2d1drawingstateblock1%29)

### CreateGdiMetafile

```freebasic
function CreateGdiMetafile( byval metafileStream as IStream ptr ) as ID2D1GdiMetafile ptr
```

Reads an enhanced metafile (EMF) from `metafileStream` into an `ID2D1GdiMetafile`, which an
`ID2D1DeviceContext` can draw with `DrawGdiMetafile`. The stream is read from its current
position.

**Returns** the new metafile, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pStream as IStream ptr   ' a stream holding an .emf file
dim pMetafile as ID2D1GdiMetafile ptr = factory.CreateGdiMetafile( pStream )
D2D1_SafeRelease( pMetafile )
```

Microsoft Learn: [ID2D1Factory1::CreateGdiMetafile](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-creategdimetafile)

### RegisterEffectFromStream

```freebasic
function RegisterEffectFromStream( byref ClassId as CLSID, byval propertyXml as IStream ptr, byref bindings as const D2D1_PROPERTY_BINDING, byval bindingsCount as UINT32, byval effectFactory as const PD2D1_EFFECT_FACTORY ) as HRESULT
function RegisterEffectFromStream( byval ClassId as CLSID ptr, byval propertyXml as IStream ptr, byval bindings as const D2D1_PROPERTY_BINDING ptr, byval bindingsCount as UINT32, byval effectFactory as const PD2D1_EFFECT_FACTORY ) as HRESULT
```

Registers a custom effect with this factory under `ClassId`, so a device context from it can
create the effect. `propertyXml` is a stream holding the XML that names the effect, its author,
category and description, its inputs and its properties. `bindings` connects properties to
getter and setter functions (pass `byval NULL` and 0 when the XML declares none), and
`effectFactory` is the function Direct2D calls to create an instance, which returns the effect's
`ID2D1EffectImpl`. Registering the same class ID again adds a reference to the registration.

**Returns** `S_OK` (0) on success, otherwise the failing `HRESULT`; `E_POINTER` for an empty
object.

**Example**

```freebasic
dim shared CLSID_MyEffect as CLSID = ( &h6A8C2F31, &h1B4D, &h4E7A, { &h9C, &h21, &h5D, &h3E, &h7F, &h80, &h41, &hB2 } )

function CreateMyEffect( byref effectImpl as IUnknown ptr ) as HRESULT
    effectImpl = NULL   ' a real effect stores its ID2D1EffectImpl here
    return E_NOTIMPL
end function

dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pStream as IStream ptr   ' a stream holding the effect's XML
print factory.RegisterEffectFromStream( CLSID_MyEffect, pStream, byval NULL, 0, @CreateMyEffect )
```

Microsoft Learn: [ID2D1Factory1::RegisterEffectFromStream](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-registereffectfromstream)

### RegisterEffectFromString

```freebasic
function RegisterEffectFromString( byref ClassId as CLSID, byref propertyXml as wstring, byref bindings as const D2D1_PROPERTY_BINDING, byval bindingsCount as UINT32, byval effectFactory as const PD2D1_EFFECT_FACTORY ) as HRESULT
function RegisterEffectFromString( byval ClassId as CLSID ptr, byref propertyXml as wstring, byval bindings as const D2D1_PROPERTY_BINDING ptr, byval bindingsCount as UINT32, byval effectFactory as const PD2D1_EFFECT_FACTORY ) as HRESULT
```

Registers a custom effect like [RegisterEffectFromStream](#registereffectfromstream), with the
XML in a wide string. The XML must declare at least the `DisplayName`, `Author`, `Category` and
`Description` properties and the inputs.

**Returns** `S_OK` (0) on success, otherwise the failing `HRESULT`; `E_POINTER` for an empty
object.

**Example**

```freebasic
dim shared CLSID_MyEffect as CLSID = ( &h6A8C2F31, &h1B4D, &h4E7A, { &h9C, &h21, &h5D, &h3E, &h7F, &h80, &h41, &hB2 } )

function CreateMyEffect( byref effectImpl as IUnknown ptr ) as HRESULT
    effectImpl = NULL   ' a real effect stores its ID2D1EffectImpl here
    return E_NOTIMPL
end function

dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim xml as wstring * 512 = "<?xml version='1.0'?><Effect><Property name='DisplayName' type='string' value='My effect'/>" & _
    "<Property name='Author' type='string' value='Me'/><Property name='Category' type='string' value='Sample'/>" & _
    "<Property name='Description' type='string' value='Does nothing'/><Inputs><Input name='Source'/></Inputs></Effect>"
print factory.RegisterEffectFromString( CLSID_MyEffect, xml, byval NULL, 0, @CreateMyEffect )   ' 0
```

Microsoft Learn: [ID2D1Factory1::RegisterEffectFromString](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-registereffectfromstring)

### UnregisterEffect

```freebasic
function UnregisterEffect( byref ClassId as CLSID ) as HRESULT
function UnregisterEffect( byval ClassId as CLSID ptr ) as HRESULT
```

Removes one reference to the registration of the custom effect `ClassId`; when the last one goes
the effect can no longer be created from this factory. Effects that already exist keep working.
Built-in effects cannot be unregistered.

**Returns** `S_OK` (0) on success; `D2DERR_EFFECT_IS_NOT_REGISTERED` when no custom effect is
registered under `ClassId`, built-in ones included; `E_POINTER` for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
if factory.UnregisterEffect( CLSID_D2D1GaussianBlur ) = D2DERR_EFFECT_IS_NOT_REGISTERED then print "built in"
```

Microsoft Learn: [ID2D1Factory1::UnregisterEffect](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-unregistereffect)

### GetRegisteredEffects

```freebasic
function GetRegisteredEffects( byref effects as CLSID, byval effectsCount as UINT32, byref effectsReturned as UINT32, byref effectsRegistered as UINT32 ) as HRESULT
function GetRegisteredEffects( byval effects as CLSID ptr, byval effectsCount as UINT32, byval effectsReturned as UINT32 ptr, byval effectsRegistered as UINT32 ptr ) as HRESULT
```

Copies the class IDs of the effects this factory can create, built-in and custom, into an array
of `effectsCount` elements. `effectsReturned` receives how many were copied and
`effectsRegistered` how many there are. To learn the number first, call the pointer form with
`NULL` and 0 for the array and `NULL` for `effectsReturned`.

| Parameter | Meaning |
| --- | --- |
| `effects` | The first element of a `CLSID` array, or `NULL`. |
| `effectsCount` | The number of elements in the array. |
| `effectsReturned` | Receives the number copied. |
| `effectsRegistered` | Receives the number registered. |

**Returns** `S_OK` (0) on success, otherwise the failing `HRESULT`; `E_POINTER` for an empty
object.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim nCount as UINT32
factory.GetRegisteredEffects( NULL, 0, NULL, @nCount )
print nCount; " effects"
```

Microsoft Learn: [ID2D1Factory1::GetRegisteredEffects](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-getregisteredeffects)

### GetEffectProperties

```freebasic
function GetEffectProperties( byref effectId as CLSID ) as ID2D1Properties ptr
```

Returns the properties that the registered effect `effectId` declares (its name, author,
category, description, inputs and settings), without creating the effect.

**Returns** an `ID2D1Properties` interface, which you release; `NULL` when the effect is not
registered or the call fails.

**Example**

```freebasic
dim factory as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pProps as ID2D1Properties ptr = factory.GetEffectProperties( CLSID_D2D1GaussianBlur )
if pProps then print pProps->GetPropertyCount(); " properties"   ' 3
D2D1_SafeRelease( pProps )
```

Microsoft Learn: [ID2D1Factory1::GetEffectProperties](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-geteffectproperties)

## CD2D1Factory2

`CD2D1Factory2` extends `CD2D1Factory1` and wraps `ID2D1Factory2` (field `m_pFactory2`).

### Constructor

```freebasic
constructor
constructor( byval factoryType as D2D1_FACTORY_TYPE )
```

The form with a `factoryType` creates an `ID2D1Factory2` and stores it in `m_pFactory2` and in
every inherited field. The form without arguments creates nothing.

**Example**

```freebasic
dim factory as CD2D1Factory2 = D2D1_FACTORY_TYPE_SINGLE_THREADED
print ( factory.m_pFactory2 <> NULL )
```

Microsoft Learn: [ID2D1Factory2](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_2/nn-d2d1_2-id2d1factory2)

### Destructor

```freebasic
destructor
```

Releases `m_pFactory2`; the inherited destructors release the other fields.

**Example**

```freebasic
dim pFactory as CD2D1Factory2 ptr = new CD2D1Factory2( D2D1_FACTORY_TYPE_SINGLE_THREADED )
delete pFactory
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1Factory2 ptr ptr
operator cast() as ID2D1Factory2 ptr
operator cast() as ID2D1Factory ptr
operator *( byref factory as CD2D1Factory2 ) as ID2D1Factory2 ptr
```

As for [CD2D1Factory1](#cast-operator--operator--1), with `ID2D1Factory2` and `m_pFactory2`.

**Example**

```freebasic
dim factory as CD2D1Factory2 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim p2 as ID2D1Factory2 ptr = factory
```

### CreateDevice1

```freebasic
function CreateDevice1( byval dxgiDevice as IDXGIDevice ptr ) as ID2D1Device1 ptr
```

Creates a Direct2D device on a Direct3D device, as an `ID2D1Device1`, which adds a rendering
priority. It calls the factory's `ID2D1Factory1` `CreateDevice` and returns that device typed as
`ID2D1Device1 ptr`; on Windows 11 the object returned answers to `IID_ID2D1Device1` with the same
pointer. Query the device for `IID_ID2D1Device1` if you need to be certain.

**Returns** the new device, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory2 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pDxgiDevice as IDXGIDevice ptr   ' the IDXGIDevice of a Direct3D 11 device
dim pDevice as ID2D1Device1 ptr = factory.CreateDevice1( pDxgiDevice )
D2D1_SafeRelease( pDevice )
```

Microsoft Learn: [ID2D1Factory2::CreateDevice](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_2/nf-d2d1_2-id2d1factory2-createdevice)

## CD2D1Factory3

`CD2D1Factory3` extends `CD2D1Factory2` and wraps `ID2D1Factory3` (field `m_pFactory3`).

### Constructor

```freebasic
constructor
constructor( byval factoryType as D2D1_FACTORY_TYPE )
```

The form with a `factoryType` creates an `ID2D1Factory3` and stores it in `m_pFactory3` and in
every inherited field. The form without arguments creates nothing.

**Example**

```freebasic
dim factory as CD2D1Factory3 = D2D1_FACTORY_TYPE_SINGLE_THREADED
print ( factory.m_pFactory3 <> NULL )
```

Microsoft Learn: [ID2D1Factory3](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1factory3)

### Destructor

```freebasic
destructor
```

Releases `m_pFactory3`; the inherited destructors release the other fields.

**Example**

```freebasic
dim pFactory as CD2D1Factory3 ptr = new CD2D1Factory3( D2D1_FACTORY_TYPE_SINGLE_THREADED )
delete pFactory
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1Factory3 ptr ptr
operator cast() as ID2D1Factory3 ptr
operator cast() as ID2D1Factory ptr
operator *( byref factory as CD2D1Factory3 ) as ID2D1Factory3 ptr
```

As for [CD2D1Factory1](#cast-operator--operator--1), with `ID2D1Factory3` and `m_pFactory3`.

**Example**

```freebasic
dim factory as CD2D1Factory3 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim p3 as ID2D1Factory3 ptr = factory
```

### CreateDevice2

```freebasic
function CreateDevice2( byval dxgiDevice as IDXGIDevice ptr ) as ID2D1Device2 ptr
```

Creates a Direct2D device on a Direct3D device, as an `ID2D1Device2`, whose device contexts add
ink and gradient meshes; the device can also return its DXGI device.

**Returns** the new device, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory3 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pDxgiDevice as IDXGIDevice ptr   ' the IDXGIDevice of a Direct3D 11 device
dim pDevice as ID2D1Device2 ptr = factory.CreateDevice2( pDxgiDevice )
D2D1_SafeRelease( pDevice )
```

Microsoft Learn: [ID2D1Factory3::CreateDevice](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-id2d1factory3-createdevice)

## CD2D1Factory4

`CD2D1Factory4` extends `CD2D1Factory3` and wraps `ID2D1Factory4` (field `m_pFactory4`).

### Constructor

```freebasic
constructor
constructor( byval factoryType as D2D1_FACTORY_TYPE )
```

The form with a `factoryType` creates an `ID2D1Factory4` and stores it in `m_pFactory4` and in
every inherited field. The form without arguments creates nothing.

**Example**

```freebasic
dim factory as CD2D1Factory4 = D2D1_FACTORY_TYPE_SINGLE_THREADED
print ( factory.m_pFactory4 <> NULL )
```

### Destructor

```freebasic
destructor
```

Releases `m_pFactory4`; the inherited destructors release the other fields.

**Example**

```freebasic
dim pFactory as CD2D1Factory4 ptr = new CD2D1Factory4( D2D1_FACTORY_TYPE_SINGLE_THREADED )
delete pFactory
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1Factory4 ptr ptr
operator cast() as ID2D1Factory4 ptr
operator cast() as ID2D1Factory ptr
operator *( byref factory as CD2D1Factory4 ) as ID2D1Factory4 ptr
```

As for [CD2D1Factory1](#cast-operator--operator--1), with `ID2D1Factory4` and `m_pFactory4`.

**Example**

```freebasic
dim factory as CD2D1Factory4 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim p4 as ID2D1Factory4 ptr = factory
```

### CreateDevice3

```freebasic
function CreateDevice3( byval dxgiDevice as IDXGIDevice ptr ) as ID2D1Device3 ptr
```

Creates a Direct2D device on a Direct3D device, as an `ID2D1Device3`, whose device contexts can
draw sprite batches.

**Returns** the new device, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory4 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pDxgiDevice as IDXGIDevice ptr   ' the IDXGIDevice of a Direct3D 11 device
dim pDevice as ID2D1Device3 ptr = factory.CreateDevice3( pDxgiDevice )
D2D1_SafeRelease( pDevice )
```

Microsoft Learn: [ID2D1Factory4::CreateDevice](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-id2d1factory4-createdevice)

## CD2D1Factory5

`CD2D1Factory5` extends `CD2D1Factory4` and wraps `ID2D1Factory5` (field `m_pFactory5`).

### Constructor

```freebasic
constructor
constructor( byval factoryType as D2D1_FACTORY_TYPE )
```

The form with a `factoryType` creates an `ID2D1Factory5` and stores it in `m_pFactory5` and in
every inherited field. The form without arguments creates nothing.

**Example**

```freebasic
dim factory as CD2D1Factory5 = D2D1_FACTORY_TYPE_SINGLE_THREADED
print ( factory.m_pFactory5 <> NULL )
```

### Destructor

```freebasic
destructor
```

Releases `m_pFactory5`; the inherited destructors release the other fields.

**Example**

```freebasic
dim pFactory as CD2D1Factory5 ptr = new CD2D1Factory5( D2D1_FACTORY_TYPE_SINGLE_THREADED )
delete pFactory
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1Factory5 ptr ptr
operator cast() as ID2D1Factory5 ptr
operator cast() as ID2D1Factory ptr
operator *( byref factory as CD2D1Factory5 ) as ID2D1Factory5 ptr
```

As for [CD2D1Factory1](#cast-operator--operator--1), with `ID2D1Factory5` and `m_pFactory5`.

**Example**

```freebasic
dim factory as CD2D1Factory5 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim p5 as ID2D1Factory5 ptr = factory
```

### CreateDevice4

```freebasic
function CreateDevice4( byval dxgiDevice as IDXGIDevice ptr ) as ID2D1Device4 ptr
```

Creates a Direct2D device on a Direct3D device, as an `ID2D1Device4`, which adds colour-glyph
text and a cache of glyph images.

**Returns** the new device, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory5 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pDxgiDevice as IDXGIDevice ptr   ' the IDXGIDevice of a Direct3D 11 device
dim pDevice as ID2D1Device4 ptr = factory.CreateDevice4( pDxgiDevice )
D2D1_SafeRelease( pDevice )
```

Microsoft Learn: [ID2D1Factory5::CreateDevice](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-id2d1factory5-createdevice)

## CD2D1Factory6

`CD2D1Factory6` extends `CD2D1Factory5` and wraps `ID2D1Factory6` (field `m_pFactory6`).

### Constructor

```freebasic
constructor
constructor( byval factoryType as D2D1_FACTORY_TYPE )
```

The form with a `factoryType` creates an `ID2D1Factory6` and stores it in `m_pFactory6` and in
every inherited field. The form without arguments creates nothing.

**Example**

```freebasic
dim factory as CD2D1Factory6 = D2D1_FACTORY_TYPE_SINGLE_THREADED
print ( factory.m_pFactory6 <> NULL )
```

### Destructor

```freebasic
destructor
```

Releases `m_pFactory6`; the inherited destructors release the other fields.

**Example**

```freebasic
dim pFactory as CD2D1Factory6 ptr = new CD2D1Factory6( D2D1_FACTORY_TYPE_SINGLE_THREADED )
delete pFactory
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1Factory6 ptr ptr
operator cast() as ID2D1Factory6 ptr
operator cast() as ID2D1Factory ptr
operator *( byref factory as CD2D1Factory6 ) as ID2D1Factory6 ptr
```

As for [CD2D1Factory1](#cast-operator--operator--1), with `ID2D1Factory6` and `m_pFactory6`.

**Example**

```freebasic
dim factory as CD2D1Factory6 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim p6 as ID2D1Factory6 ptr = factory
```

### CreateDevice5

```freebasic
function CreateDevice5( byval dxgiDevice as IDXGIDevice ptr ) as ID2D1Device5 ptr
```

Creates a Direct2D device on a Direct3D device, as an `ID2D1Device5`, whose device contexts can
create and draw SVG documents.

**Returns** the new device, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory6 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pDxgiDevice as IDXGIDevice ptr   ' the IDXGIDevice of a Direct3D 11 device
dim pDevice as ID2D1Device5 ptr = factory.CreateDevice5( pDxgiDevice )
D2D1_SafeRelease( pDevice )
```

Microsoft Learn: [ID2D1Factory6::CreateDevice](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-id2d1factory6-createdevice)

## CD2D1Factory7

`CD2D1Factory7` extends `CD2D1Factory6` and wraps `ID2D1Factory7` (field `m_pFactory7`).

### Constructor

```freebasic
constructor
constructor( byval factoryType as D2D1_FACTORY_TYPE )
```

The form with a `factoryType` creates an `ID2D1Factory7` and stores it in `m_pFactory7` and in
every inherited field. The form without arguments creates nothing.

**Example**

```freebasic
dim factory as CD2D1Factory7 = D2D1_FACTORY_TYPE_SINGLE_THREADED
print ( factory.m_pFactory7 <> NULL )
```

### Destructor

```freebasic
destructor
```

Releases `m_pFactory7`; the inherited destructors release the other fields.

**Example**

```freebasic
dim pFactory as CD2D1Factory7 ptr = new CD2D1Factory7( D2D1_FACTORY_TYPE_SINGLE_THREADED )
delete pFactory
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1Factory7 ptr ptr
operator cast() as ID2D1Factory7 ptr
operator cast() as ID2D1Factory ptr
operator *( byref factory as CD2D1Factory7 ) as ID2D1Factory7 ptr
```

As for [CD2D1Factory1](#cast-operator--operator--1), with `ID2D1Factory7` and `m_pFactory7`.

**Example**

```freebasic
dim factory as CD2D1Factory7 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim p7 as ID2D1Factory7 ptr = factory
```

### CreateDevice6

```freebasic
function CreateDevice6( byval dxgiDevice as IDXGIDevice ptr ) as ID2D1Device6 ptr
```

Creates a Direct2D device on a Direct3D device, as an `ID2D1Device6`, whose device contexts add
a blend mode for drawing images.

**Returns** the new device, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory7 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pDxgiDevice as IDXGIDevice ptr   ' the IDXGIDevice of a Direct3D 11 device
dim pDevice as ID2D1Device6 ptr = factory.CreateDevice6( pDxgiDevice )
D2D1_SafeRelease( pDevice )
```

Microsoft Learn: [ID2D1Factory7::CreateDevice](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-id2d1factory7-createdevice)

## CD2D1Factory8

`CD2D1Factory8` extends `CD2D1Factory7` and wraps `ID2D1Factory8` (field `m_pFactory8`), the
newest factory interface.

### Constructor

```freebasic
constructor
constructor( byval factoryType as D2D1_FACTORY_TYPE )
```

The form with a `factoryType` creates an `ID2D1Factory8` and stores it in `m_pFactory8` and in
every inherited field. The form without arguments creates nothing.

**Example**

```freebasic
dim factory as CD2D1Factory8 = D2D1_FACTORY_TYPE_SINGLE_THREADED
if factory.m_pFactory8 = NULL then print "ID2D1Factory8 needs a newer Windows"
```

Microsoft Learn: [ID2D1Factory8](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1factory8)

### Destructor

```freebasic
destructor
```

Releases `m_pFactory8`; the inherited destructors release the other fields.

**Example**

```freebasic
dim pFactory as CD2D1Factory8 ptr = new CD2D1Factory8( D2D1_FACTORY_TYPE_SINGLE_THREADED )
delete pFactory
```

### Cast, Operator @, Operator *

```freebasic
operator @() as ID2D1Factory8 ptr ptr
operator cast() as ID2D1Factory8 ptr
operator cast() as ID2D1Factory ptr
operator *( byref factory as CD2D1Factory8 ) as ID2D1Factory8 ptr
```

As for [CD2D1Factory1](#cast-operator--operator--1), with `ID2D1Factory8` and `m_pFactory8`.

**Example**

```freebasic
dim factory as CD2D1Factory8 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim p8 as ID2D1Factory8 ptr = factory
```

### CreateDevice7

```freebasic
function CreateDevice7( byval dxgiDevice as IDXGIDevice ptr ) as ID2D1Device7 ptr
```

Creates a Direct2D device on a Direct3D device, as an `ID2D1Device7`, the newest device
interface.

**Returns** the new device, which you release; `NULL` on failure.

**Example**

```freebasic
dim factory as CD2D1Factory8 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pDxgiDevice as IDXGIDevice ptr   ' the IDXGIDevice of a Direct3D 11 device
dim pDevice as ID2D1Device7 ptr = factory.CreateDevice7( pDxgiDevice )
D2D1_SafeRelease( pDevice )
```

Microsoft Learn: [ID2D1Factory8::CreateDevice](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-id2d1factory8-createdevice)

## See also

- [sys/win/direct2d](SysWin-Direct2D)
- [Direct2D stroke styles and multithreading](SysWin-Direct2D-Stroke-Styles) for `CID2D1StrokeStyle` and `CID2D1Multithread`
- [CID2D1RenderTarget](CID2D1RenderTarget) and [Direct2D render targets](SysWin-Direct2D-Render-Targets) for drawing on what the factory creates
- [CID2D1Geometry](CID2D1Geometry) and [Direct2D geometries](SysWin-Direct2D-Geometries)
- [Direct2D helpers](SysWin-Direct2D-Helpers) for `D2D1_RectF`, `D2D1_EllipseF`, `D2D1_RenderTargetProperties` and the other structure builders
- [CGraphCtx](CGraphCtx), a control with a memory device context to draw into
- [Display, screen and DPI](SysWin-Display-and-DPI)
