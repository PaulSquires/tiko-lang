[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **CID2D1RenderTarget**

# CID2D1RenderTarget

Draws shapes, bitmaps and text with Direct2D and creates the brushes and bitmaps it uses.

`CID2D1RenderTarget` wraps the `ID2D1RenderTarget` interface that every Direct2D render target
implements. You seldom declare one yourself: a [CD2D1Factory](CD2D1Factory) makes a render target
for a window, a GDI device context or a DXGI surface, and the classes on
[Direct2D render targets](SysWin-Direct2D-Render-Targets) (`CID2D1HwndRenderTarget`,
`CID2D1DCRenderTarget`, `CID2D1BitmapRenderTarget`) wrap those. They extend this class, so every
member here is theirs too.

**A frame.** All drawing happens between [BeginDraw](#begindraw) and [EndDraw](#enddraw). The
drawing members return nothing: Direct2D records the commands and reports any failure from
`EndDraw`. When `EndDraw` returns `D2DERR_RECREATE_TARGET` the display device was lost; delete
the render target and everything created from it, and make them again before the next frame.

**Coordinates.** Positions and sizes are in device-independent pixels (DIPs), 1/96 inch each.
The target's DPI turns them into pixels: at 96 DPI a DIP is a pixel, at 144 DPI (150 %) it is
1.5 pixels. A render target made with a DPI of 0 uses the desktop's, so a program drawing in
96-DPI units comes out the same physical size on every display. [GetSize](#getsize-getsizewidth-getsizeheight)
gives the size in DIPs and [GetPixelSize](#getpixelsize-getpixelwidth-getpixelheight) in pixels.
The current [transform](#settransform-gettransform) is applied to everything drawn.

**Resources.** The `Create…` members return a raw interface pointer holding one reference, which
is yours: call `Release` on it when done, or hand it to the matching wrapper class
(`CID2D1SolidColorBrush`, `CID2D1BitmapBrush`, `CID2D1GradientStopCollection` …, see
[Direct2D brushes](SysWin-Direct2D-Brushes)) whose destructor releases it. A wrapper converts to
`ID2D1Brush ptr` by itself, so it can be passed straight to a drawing member. Resources made by
one render target work only on that target and on targets compatible with it. On failure a
`Create…` member returns `NULL`, and `GetLastError()` holds the `HRESULT`.

**Lifetime.** The constructor takes over the reference it is given and the destructor releases
it: do not release that pointer yourself, and never copy a render target object by value
(`dim b as CID2D1HwndRenderTarget = a`, or a `byval` parameter), because the copy releases the
same interface again. Use a pointer or `dim byref` to refer to one from elsewhere. Every member
does nothing, or returns `NULL` or 0, on an object that holds no interface.

**Colours.** [Clear](#clear) and the `D2D1_ColorF` helper take `&hRRGGBB` values, red in the
high byte, such as the `D2D1_*` colour constants (`D2D1_SteelBlue`). The `RGB_*` constants of
`sys/win/gui` put red in the low byte and come out with red and blue swapped.

The examples below start from a factory and a render target for the window `hwnd`, made in two
lines; drawing calls go between `BeginDraw` and `EndDraw`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A window that fills a rounded rectangle with a gradient, outlines it, writes a title in it with
DirectWrite, and draws an ellipse and a line. The render target is made on the first `WM_PAINT`,
resized with the window, and made again if the device is lost:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/direct2d"
using win, gui, direct2d

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

dim shared pFactory as CD2D1Factory ptr
dim shared pDWrite as IDWriteFactory ptr
dim shared pFormat as IDWriteTextFormat ptr
dim shared pRT as CID2D1HwndRenderTarget ptr

sub Render( byval hwnd as HWND )
    if pRT = NULL then
        var (l, t, r, b) = GetWindowClientRect( hwnd )
        pRT = new CID2D1HwndRenderTarget( pFactory->CreateHwndRenderTarget( D2D1_RenderTargetProperties(), _
                                          D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( r, b ) ) ) )
    end if
    dim byref rt as CID2D1HwndRenderTarget = *pRT

    dim stops(0 to 1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_LightSteelBlue ), D2D1_GradientStop( 1, D2D1_SteelBlue ) }
    dim gradient as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( @stops(0), 2 )
    dim fill as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 20, 0, 140, gradient )
    dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
    dim pen as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )

    rt.BeginDraw()
    rt.Clear( D2D1_White )
    rt.FillRoundedRectangle( 20, 20, 340, 140, 12, 12, fill )
    rt.DrawRoundedRectangle( 20, 20, 340, 140, 12, 12, pen, 2 )
    rt.DrawText( "Direct2D", 8, pFormat, 20, 55, 340, 105, pen )
    rt.DrawEllipse( 80, 200, 50, 30, pen, 3 )
    rt.DrawLine( 160, 170, 340, 230, pen, 4 )
    if rt.EndDraw() = D2DERR_RECREATE_TARGET then
        delete pRT : pRT = NULL      ' made again on the next WM_PAINT
    end if
end sub

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    pFactory = new CD2D1Factory( D2D1_FACTORY_TYPE_SINGLE_THREADED )
    DWriteCreateFactory( DWRITE_FACTORY_TYPE_SHARED, IID_IDWriteFactory, pDWrite )
    pDWrite->CreateTextFormat( "Segoe UI", NULL, DWRITE_FONT_WEIGHT_BOLD, DWRITE_FONT_STYLE_NORMAL, _
                               DWRITE_FONT_STRETCH_NORMAL, 32, "en-us", pFormat )
    pFormat->SetTextAlignment( DWRITE_TEXT_ALIGNMENT_CENTER )

    dim pWindow as CWindow = "D2DRenderTarget"
    pWindow.Create( NULL, "CID2D1RenderTarget", @WndProc )
    pWindow.SetClientSize( 360, 250 )
    pWindow.Center()
    dim nResult as long = pWindow.DoEvents( SW_NORMAL )

    pFormat->Release()
    pDWrite->Release()
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
        case WM_SIZE
            if pRT then pRT->Resize( D2D1_SizeU( LOWORD( lParam ), HIWORD( lParam ) ) )
            return 0
        case WM_DESTROY
            delete pRT : pRT = NULL
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

The brushes are wrapper objects declared in `Render`, so they are released when it returns; the
render target, the factory and the text format live as long as the window.

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Makes an empty object, or one that takes over an `ID2D1RenderTarget` pointer. |
| [Destructor](#destructor) | Releases the render target. |
| [Cast, Operator @, Operator *](#cast-operator--operator-) | Give the interface pointer or its address. |
| [BeginDraw](#begindraw) | Starts a frame. |
| [EndDraw](#enddraw) | Ends a frame and reports whether its drawing succeeded. |
| [Clear](#clear) | Fills the whole target, or the current clip, with one colour. |
| [Flush](#flush) | Runs the drawing commands recorded so far. |
| [GetFactory](#getfactory) | Returns the factory that made the target. |
| [CreateSolidColorBrush](#createsolidcolorbrush) | Creates a brush of one colour. |
| [CreateGradientStopCollection](#creategradientstopcollection) | Creates the colour stops of a gradient. |
| [CreateLinearGradientBrush](#createlineargradientbrush) | Creates a brush that blends colours along a line. |
| [CreateRadialGradientBrush](#createradialgradientbrush) | Creates a brush that blends colours outwards from a centre. |
| [CreateBitmap](#createbitmap) | Creates a bitmap, empty or from pixels in memory. |
| [CreateBitmapFromWicBitmap](#createbitmapfromwicbitmap) | Creates a bitmap from a WIC image. |
| [CreateSharedBitmap](#createsharedbitmap) | Creates a bitmap that shares its pixels with another resource. |
| [CreateBitmapBrush](#createbitmapbrush) | Creates a brush that paints with a bitmap. |
| [CreateCompatibleRenderTarget](#createcompatiblerendertarget) | Creates an off-screen render target compatible with this one. |
| [CreateLayer](#createlayer) | Creates a layer for [PushLayer](#pushlayer). |
| [CreateMesh](#createmesh) | Creates a mesh of triangles for [FillMesh](#fillmesh). |
| [DrawLine](#drawline) | Draws a line. |
| [DrawRectangle](#drawrectangle) | Draws the outline of a rectangle. |
| [FillRectangle](#fillrectangle) | Paints the inside of a rectangle. |
| [DrawRoundedRectangle](#drawroundedrectangle) | Draws the outline of a rectangle with rounded corners. |
| [FillRoundedRectangle](#fillroundedrectangle) | Paints the inside of a rectangle with rounded corners. |
| [DrawEllipse](#drawellipse) | Draws the outline of an ellipse. |
| [FillEllipse](#fillellipse) | Paints the inside of an ellipse. |
| [DrawGeometry](#drawgeometry) | Draws the outline of a geometry. |
| [FillGeometry](#fillgeometry) | Paints the inside of a geometry. |
| [FillMesh](#fillmesh) | Paints the triangles of a mesh. |
| [FillOpacityMask](#fillopacitymask) | Paints with a brush through the alpha of a bitmap. |
| [DrawBitmap](#drawbitmap) | Draws a bitmap, or part of it, into a rectangle. |
| [DrawText](#drawtext) | Lays out and draws a string in a rectangle. |
| [DrawTextLayout](#drawtextlayout) | Draws text laid out beforehand by DirectWrite. |
| [DrawGlyphRun](#drawglyphrun) | Draws a run of glyphs. |
| [SetTransform, GetTransform](#settransform-gettransform) | Sets or reads the transform applied to all drawing. |
| [SetAntialiasMode, GetAntialiasMode](#setantialiasmode-getantialiasmode) | Sets or reads how the edges of shapes are smoothed. |
| [SetTextAntialiasMode, GetTextAntialiasMode](#settextantialiasmode-gettextantialiasmode) | Sets or reads how text is smoothed. |
| [SetTextRenderingParams, GetTextRenderingParams](#settextrenderingparams-gettextrenderingparams) | Sets or reads the DirectWrite rendering options for text. |
| [SetTags, GetTags](#settags-gettags) | Sets or reads the two labels that identify a failing command. |
| [SaveDrawingState](#savedrawingstate) | Copies the drawing state into a state block. |
| [RestoreDrawingState](#restoredrawingstate) | Sets the drawing state from a state block. |
| [PushAxisAlignedClip](#pushaxisalignedclip) | Clips all drawing to a rectangle. |
| [PopAxisAlignedClip](#popaxisalignedclip) | Removes the last rectangle clip. |
| [PushLayer](#pushlayer) | Starts drawing into a layer, clipped and blended as it says. |
| [PopLayer](#poplayer) | Ends the last layer and blends it onto the target. |
| [GetPixelFormat](#getpixelformat) | Returns the pixel format and alpha mode. |
| [SetDpi, GetDpi, GetDpiX, GetDpiY](#setdpi-getdpi-getdpix-getdpiy) | Sets or reads the DPI that converts DIPs to pixels. |
| [GetSize, GetSizeWidth, GetSizeHeight](#getsize-getsizewidth-getsizeheight) | Returns the size in DIPs. |
| [GetPixelSize, GetPixelWidth, GetPixelHeight](#getpixelsize-getpixelwidth-getpixelheight) | Returns the size in pixels. |
| [GetMaximumBitmapSize](#getmaximumbitmapsize) | Is meant to return the largest bitmap the target supports. |
| [IsSupported](#issupported) | Is meant to tell whether the target supports a set of properties. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval pRenderTarget as ID2D1RenderTarget ptr )
```

The first form makes an object that holds no render target; every member then does nothing. The
second takes over `pRenderTarget`: the object does not add a reference, it adopts the one you
pass, and releases it when it is destroyed. Pass it the result of a factory call that returns an
`ID2D1RenderTarget ptr`, such as `CreateWicBitmapRenderTarget` or `CreateDxgiSurfaceRenderTarget`
of [CD2D1Factory](CD2D1Factory).

| Parameter | Meaning |
| --- | --- |
| `pRenderTarget` | The render target to wrap, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1RenderTarget = cast( ID2D1RenderTarget ptr, factory.CreateDCRenderTarget() )
print "dpi:"; rt.GetDpiX()
```

### Destructor

```freebasic
destructor
```

Releases the render target, if the object holds one. Resources created from it that you still
hold stay valid until you release them.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pRT as CID2D1RenderTarget ptr = new CID2D1RenderTarget( cast( ID2D1RenderTarget ptr, factory.CreateDCRenderTarget() ) )
delete pRT   ' releases the render target
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1RenderTarget ptr
operator @() as ID2D1RenderTarget ptr ptr
operator *( byref renderTarget as CID2D1RenderTarget ) as ID2D1RenderTarget ptr
```

`cast` and `*` return the wrapped `ID2D1RenderTarget` pointer, which is how the object is passed
where Windows wants the interface. The pointer still belongs to the object: do not release it.
`@` returns the address of the stored pointer, `m_pRenderTarget`, for a function that writes a
render target into it; it does not release what is there first, so use it on an empty object.
Applying `@` to the object currently stops the build with an internal compiler error; take the address of the field instead, `@obj.m_pRenderTarget`, which is the same address.

The derived classes declare their own `cast`, `@` and `*` for their own interface types, which
hide these: on a `CID2D1HwndRenderTarget`, `cast` gives an `ID2D1HwndRenderTarget ptr`. The
`ID2D1RenderTarget` pointer of any of them is in the public field `m_pRenderTarget`.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1RenderTarget = cast( ID2D1RenderTarget ptr, factory.CreateDCRenderTarget() )
dim pRT as ID2D1RenderTarget ptr = rt
print "same interface:"; pRT = *rt
```

### BeginDraw

```freebasic
sub BeginDraw
```

Starts a frame. Every drawing member, and `Clear`, must come after `BeginDraw` and before the
matching [EndDraw](#enddraw). Calling `BeginDraw` again before `EndDraw` puts the target in an
error state that the next `EndDraw` reports as `D2DERR_WRONG_STATE`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
rt.BeginDraw()
rt.Clear( D2D1_White )
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::BeginDraw](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-begindraw)

### EndDraw

```freebasic
function EndDraw( byref tag1 as D2D1_TAG, byref tag2 as D2D1_TAG ) as HRESULT
function EndDraw( byval tag1 as D2D1_TAG ptr = NULL, byval tag2 as D2D1_TAG ptr = NULL ) as HRESULT
```

Ends the frame started by [BeginDraw](#begindraw): runs any commands still pending, presents the
result (for a window target) and returns the first error any drawing call of the frame met. When
there was one, `tag1` and `tag2` receive the [tags](#settags-gettags) that were set when the
failing command was recorded; on success they are set to 0. `EndDraw()` without arguments
returns only the result.

| Parameter | Meaning |
| --- | --- |
| `tag1`, `tag2` | Receive the tags of the failing command; may be `NULL` in the pointer form. |

**Returns** `S_OK` on success; `D2DERR_RECREATE_TARGET` when the device was lost and the target
must be made again; `D2DERR_WRONG_STATE` when there was no `BeginDraw`, or a second one;
`E_POINTER` when the object holds no render target.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim as D2D1_TAG t1, t2
rt.BeginDraw()
rt.Clear( D2D1_White )
if rt.EndDraw( t1, t2 ) <> S_OK then print "failed at tags"; t1; t2
```

Microsoft Learn: [ID2D1RenderTarget::EndDraw](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-enddraw)

### Clear

```freebasic
sub Clear( byref clearColor as const D2D1_COLOR_F )
sub Clear( byval clearColor as const D2D1_COLOR_F ptr )
sub Clear( byval clearColor as UINT32, byval alpha as FLOAT = 1.0 )
```

Fills the target with one colour, replacing what was there; inside an axis-aligned clip only the
clip rectangle is filled. The third form takes an `&hRRGGBB` value such as `D2D1_White` and an
opacity from 0 to 1. A `NULL` pointer in the second form clears to transparent black.

| Parameter | Meaning |
| --- | --- |
| `clearColor` | The colour. |
| `alpha` | The opacity for the `UINT32` form; 1 is opaque. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
rt.BeginDraw()
rt.Clear( D2D1_CornflowerBlue )
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::Clear](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-clear%28constd2d1_color_f_%29)

### Flush

```freebasic
function Flush( byref tag1 as D2D1_TAG = NULL, byref tag2 as D2D1_TAG = NULL ) as HRESULT
function Flush( byval tag1 as D2D1_TAG ptr = NULL, byval tag2 as D2D1_TAG ptr = NULL ) as HRESULT
```

Runs the drawing commands recorded so far in this frame without ending it, and returns the first
error so far, with its tags in `tag1` and `tag2`. Use it when GDI or another API has to see the
pixels before `EndDraw`.

Both forms default every argument, so `Flush()` with no arguments matches both and does not
compile; pass two `D2D1_TAG` variables, or `NULL` pointers.

**Returns** `S_OK`, or the first error recorded.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim as D2D1_TAG t1, t2
rt.BeginDraw()
rt.Clear( D2D1_White )
if rt.Flush( t1, t2 ) = S_OK then rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::Flush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-flush)

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Returns the factory that created the render target, with a reference added: release it when
done. Unlike the other members it does not check for an empty object, so call it only on one
that holds a render target.

**Returns** the factory.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim pF as ID2D1Factory ptr = rt.GetFactory()
print "same factory:"; pF = cast( ID2D1Factory ptr, factory )
pF->Release()
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### CreateSolidColorBrush

```freebasic
function CreateSolidColorBrush( byref clr as D2D1_COLOR_F, byref brushProperties as const D2D1_BRUSH_PROPERTIES ) as ID2D1SolidColorBrush ptr
function CreateSolidColorBrush( byval clr as D2D1_COLOR_F ptr, byval brushProperties as const D2D1_BRUSH_PROPERTIES ptr ) as ID2D1SolidColorBrush ptr
function CreateSolidColorBrush( byval clr as D2D1_COLOR_F ptr ) as ID2D1SolidColorBrush ptr
```

Creates a brush that paints in one colour. Brush properties set its opacity and its own
transform (`D2D1_BrushProperties( opacity, transform )`); without them the brush is opaque and
untransformed. The short form takes the colour by address, so put it in a variable first.

| Parameter | Meaning |
| --- | --- |
| `clr` | The colour, for example `D2D1_ColorF( D2D1_Navy )` or `D2D1_ColorF( 0, 0, 0.5 )`. |
| `brushProperties` | Opacity and transform; `NULL` in the pointer form for the defaults. |

**Returns** the brush, which you release (or give to a `CID2D1SolidColorBrush`), or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
dim faint as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( navy, D2D1_BrushProperties( 0.5 ) )
```

Microsoft Learn: [ID2D1RenderTarget::CreateSolidColorBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createsolidcolorbrush%28constd2d1_color_f__constd2d1_brush_properties__id2d1solidcolorbrush%29)

### CreateGradientStopCollection

```freebasic
function CreateGradientStopCollection( byref gradientStops as D2D1_GRADIENT_STOP, byval gradientStopsCount as UINT32, byval colorInterpolationGamma as D2D1_GAMMA, byval extendMode as D2D1_EXTEND_MODE ) as ID2D1GradientStopCollection ptr
function CreateGradientStopCollection( byval gradientStops as D2D1_GRADIENT_STOP ptr, byval gradientStopsCount as UINT32, byval colorInterpolationGamma as D2D1_GAMMA, byval extendMode as D2D1_EXTEND_MODE ) as ID2D1GradientStopCollection ptr
function CreateGradientStopCollection( byref gradientStops as D2D1_GRADIENT_STOP, byval gradientStopsCount as UINT32 ) as ID2D1GradientStopCollection ptr
function CreateGradientStopCollection( byval gradientStops as D2D1_GRADIENT_STOP ptr, byval gradientStopsCount as UINT32 ) as ID2D1GradientStopCollection ptr
```

Creates the list of colours, each at a position from 0 to 1, that a gradient brush blends between.
Pass the first element of an array and the number of elements. The two-argument forms blend in
the gamma 2.2 colour space (`D2D1_GAMMA_2_2`) and clamp beyond the ends
(`D2D1_EXTEND_MODE_CLAMP`): past the last stop the last colour continues.

| Parameter | Meaning |
| --- | --- |
| `gradientStops` | The first of the stops; `D2D1_GradientStop( position, colour )` makes one. |
| `gradientStopsCount` | How many stops. |
| `colorInterpolationGamma` | `D2D1_GAMMA_2_2` or `D2D1_GAMMA_1_0` (linear). |
| `extendMode` | What lies beyond the ends: `D2D1_EXTEND_MODE_CLAMP`, `_WRAP` or `_MIRROR`. |

**Returns** the collection, which you release (or give to a `CID2D1GradientStopCollection`), or
`NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim stops(0 to 1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim gradient as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( @stops(0), 2, D2D1_GAMMA_2_2, D2D1_EXTEND_MODE_MIRROR )
```

Microsoft Learn: [ID2D1RenderTarget::CreateGradientStopCollection](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-creategradientstopcollection%28constd2d1_gradient_stop_uint32_d2d1_gamma_d2d1_extend_mode_id2d1gradientstopcollection%29)

### CreateLinearGradientBrush

```freebasic
function CreateLinearGradientBrush( byref linearGradientBrushProperties as const D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES, byref brushProperties as const D2D1_BRUSH_PROPERTIES, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1LinearGradientBrush ptr
function CreateLinearGradientBrush( byval startPointX as single, byval startPointY as single, byval endPointX as single, byval endPointY as single, byref brushProperties as const D2D1_BRUSH_PROPERTIES, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1LinearGradientBrush ptr
function CreateLinearGradientBrush( byval linearGradientBrushProperties as const D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES ptr, byval brushProperties as const D2D1_BRUSH_PROPERTIES ptr, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1LinearGradientBrush ptr
function CreateLinearGradientBrush( byval startPointX as single, byval startPointY as single, byval endPointX as single, byval endPointY as single, byval brushProperties as const D2D1_BRUSH_PROPERTIES ptr, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1LinearGradientBrush ptr
function CreateLinearGradientBrush( byref linearGradientBrushProperties as const D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1LinearGradientBrush ptr
function CreateLinearGradientBrush( byval startPointX as single, byval startPointY as single, byval endPointX as single, byval endPointY as single, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1LinearGradientBrush ptr
```

Creates a brush whose colour runs along the line from the start point to the end point, through
the stops of `gradientStopCollection`. The points are in the coordinates of the drawing, not of
the shape filled, so the same brush gives each shape a different part of the gradient. Without
brush properties the brush is opaque and untransformed.

| Parameter | Meaning |
| --- | --- |
| `linearGradientBrushProperties` | The start and end points, as `D2D1_LinearGradientBrushProperties( start, end )`. |
| `startPointX`, `startPointY`, `endPointX`, `endPointY` | The same two points as numbers. |
| `brushProperties` | Opacity and transform; `NULL` in the pointer forms for the defaults. |
| `gradientStopCollection` | The colours, from [CreateGradientStopCollection](#creategradientstopcollection). |

**Returns** the brush, which you release (or give to a `CID2D1LinearGradientBrush`), or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim stops(0 to 1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_White ), D2D1_GradientStop( 1, D2D1_Navy ) }
dim gradient as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( @stops(0), 2 )
dim fill as CID2D1LinearGradientBrush = rt.CreateLinearGradientBrush( 0, 0, 200, 0, gradient )   ' left to right
```

Microsoft Learn: [ID2D1RenderTarget::CreateLinearGradientBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createlineargradientbrush%28constd2d1_linear_gradient_brush_properties__constd2d1_brush_properties__id2d1gradientstopcollection_id2d1lineargradientbrush%29)

### CreateRadialGradientBrush

```freebasic
function CreateRadialGradientBrush( byref radialGradientBrushProperties as const D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES, byref brushProperties as const D2D1_BRUSH_PROPERTIES, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1RadialGradientBrush ptr
function CreateRadialGradientBrush( byval centerX as single, byval centerY as single, byval originOffsetX as single, byval originOffsetY as single, byval radiusX as single, byval radiusY as single, byref brushProperties as const D2D1_BRUSH_PROPERTIES, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1RadialGradientBrush ptr
function CreateRadialGradientBrush( byval radialGradientBrushProperties as const D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES ptr, byval brushProperties as const D2D1_BRUSH_PROPERTIES ptr, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1RadialGradientBrush ptr
function CreateRadialGradientBrush( byval centerX as single, byval centerY as single, byval originOffsetX as single, byval originOffsetY as single, byval radiusX as single, byval radiusY as single, byval brushProperties as const D2D1_BRUSH_PROPERTIES ptr, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1RadialGradientBrush ptr
function CreateRadialGradientBrush( byref radialGradientBrushProperties as const D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1RadialGradientBrush ptr
function CreateRadialGradientBrush( byval centerX as single, byval centerY as single, byval originOffsetX as single, byval originOffsetY as single, byval radiusX as single, byval radiusY as single, byval gradientStopCollection as ID2D1GradientStopCollection ptr ) as ID2D1RadialGradientBrush ptr
```

Creates a brush whose colour runs from the gradient origin out to the edge of an ellipse. The
origin is the centre moved by the offset; an offset of (0, 0) gives rings around the centre, any
other a highlight off to one side.

| Parameter | Meaning |
| --- | --- |
| `radialGradientBrushProperties` | Centre, origin offset and radii, as one structure. |
| `centerX`, `centerY` | The centre of the ellipse. |
| `originOffsetX`, `originOffsetY` | Where the gradient starts, relative to the centre. |
| `radiusX`, `radiusY` | The radii of the ellipse; position 1 of the stops lies on its edge. |
| `brushProperties` | Opacity and transform; `NULL` in the pointer forms for the defaults. |
| `gradientStopCollection` | The colours, from [CreateGradientStopCollection](#creategradientstopcollection). |

**Returns** the brush, which you release (or give to a `CID2D1RadialGradientBrush`), or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim stops(0 to 1) as D2D1_GRADIENT_STOP = { D2D1_GradientStop( 0, D2D1_Gold ), D2D1_GradientStop( 1, D2D1_DarkOrange ) }
dim gradient as CID2D1GradientStopCollection = rt.CreateGradientStopCollection( @stops(0), 2 )
dim glow as CID2D1RadialGradientBrush = rt.CreateRadialGradientBrush( 100, 100, -20, -20, 60, 60, gradient )
```

Microsoft Learn: [ID2D1RenderTarget::CreateRadialGradientBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createradialgradientbrush%28constd2d1_radial_gradient_brush_properties__constd2d1_brush_properties__id2d1gradientstopcollection_id2d1radialgradientbrush%29)

### CreateBitmap

```freebasic
function CreateBitmap( byval size as D2D1_SIZE_U, byval srcData as const any ptr, byval pitch as UINT32, byref bitmapProperties as D2D1_BITMAP_PROPERTIES ) as ID2D1Bitmap ptr
function CreateBitmap( byval size as D2D1_SIZE_U, byval srcData as const any ptr, byval pitch as UINT32, byval bitmapProperties as D2D1_BITMAP_PROPERTIES ptr ) as ID2D1Bitmap ptr
function CreateBitmap( byval nWidth as UINT32, byval nHeight as UINT32, byval srcData as const any ptr, byval pitch as UINT32, byref bitmapProperties as D2D1_BITMAP_PROPERTIES ) as ID2D1Bitmap ptr
function CreateBitmap( byval nWidth as UINT32, byval nHeight as UINT32, byval srcData as const any ptr, byval pitch as UINT32, byval bitmapProperties as D2D1_BITMAP_PROPERTIES ptr ) as ID2D1Bitmap ptr
```

Creates a bitmap of the given size in pixels. With `srcData` it copies those pixels in;
with `NULL` the content is undefined until you fill it (`ID2D1Bitmap.CopyFromMemory`, or by
drawing it from a compatible render target). The pixel format of the bitmap properties must be
one the target supports, such as `DXGI_FORMAT_B8G8R8A8_UNORM` with `D2D1_ALPHA_MODE_IGNORE` or
`D2D1_ALPHA_MODE_PREMULTIPLIED`.

The two forms that take `bitmapProperties` by reference leave `GetLastError()` as it was; the
pointer forms store the `HRESULT` there.

| Parameter | Meaning |
| --- | --- |
| `size`, or `nWidth` and `nHeight` | The size in pixels. |
| `srcData` | The first pixel, or `NULL`. |
| `pitch` | The number of bytes from one row of `srcData` to the next; ignored when `srcData` is `NULL`. |
| `bitmapProperties` | Pixel format and DPI, as `D2D1_BitmapProperties( pixelFormat, dpiX, dpiY )`. |

**Returns** the bitmap, which you release, or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim px(0 to 3) as ulong = { &hFFFF0000, &hFF00FF00, &hFF0000FF, &hFFFFFFFF }   ' 2 x 2, BGRA
dim props as D2D1_BITMAP_PROPERTIES = D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_IGNORE ) )
dim bmp as ID2D1Bitmap ptr = rt.CreateBitmap( 2, 2, @px(0), 8, @props )
if bmp then bmp->Release()
```

Microsoft Learn: [ID2D1RenderTarget::CreateBitmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createbitmap%28d2d1_size_u_constvoid_uint32_constd2d1_bitmap_properties__id2d1bitmap%29)

### CreateBitmapFromWicBitmap

```freebasic
function CreateBitmapFromWicBitmap( byval wicBitmapSource as IWICBitmapSource ptr, byref bitmapProperties as const D2D1_BITMAP_PROPERTIES ) as ID2D1Bitmap ptr
function CreateBitmapFromWicBitmap( byval wicBitmapSource as IWICBitmapSource ptr, byval bitmapProperties as const D2D1_BITMAP_PROPERTIES ptr ) as ID2D1Bitmap ptr
function CreateBitmapFromWicBitmap( byval wicBitmapSource as IWICBitmapSource ptr ) as ID2D1Bitmap ptr
```

Creates a bitmap by copying the pixels of a Windows Imaging Component image: a decoded frame of
a PNG, JPEG or other file, usually passed through a format converter to
`IID_WICPixelFormat32bppPBGRA`. Without properties the bitmap takes the image's pixel format and
DPI. See [WIC interfaces](SysWin-WIC-Interfaces) for decoding.

| Parameter | Meaning |
| --- | --- |
| `wicBitmapSource` | The image. |
| `bitmapProperties` | Pixel format and DPI; `NULL` in the pointer form for those of the image. |

**Returns** the bitmap, which you release, or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim pConverter as IWICFormatConverter ptr   ' a decoded frame, converted to 32bppPBGRA
dim bmp as ID2D1Bitmap ptr = rt.CreateBitmapFromWicBitmap( cast( IWICBitmapSource ptr, pConverter ) )
if bmp then bmp->Release()
```

Microsoft Learn: [ID2D1RenderTarget::CreateBitmapFromWicBitmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createbitmapfromwicbitmap%28iwicbitmapsource_constd2d1_bitmap_properties__id2d1bitmap%29)

### CreateSharedBitmap

```freebasic
function CreateSharedBitmap( byref iid as IID, byval pdata as any ptr, byref bitmapProperties as const D2D1_BITMAP_PROPERTIES ) as ID2D1Bitmap ptr
function CreateSharedBitmap( byval iid as IID ptr, byval pdata as any ptr, byval bitmapProperties as const D2D1_BITMAP_PROPERTIES ptr ) as ID2D1Bitmap ptr
```

Creates a bitmap that uses the pixels of another object instead of copying them: an
`ID2D1Bitmap` made by a compatible render target (`IID_ID2D1Bitmap`), a DXGI surface
(`IID_IDXGISurface`) or a WIC bitmap lock (`IID_IWICBitmapLock`). Changes to either show in the
other.

| Parameter | Meaning |
| --- | --- |
| `iid` | The interface `pdata` points to. |
| `pdata` | The object whose pixels are shared. |
| `bitmapProperties` | Pixel format and DPI; `NULL` in the pointer form to take them from `pdata`. |

**Returns** the bitmap, which you release, or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim props as D2D1_BITMAP_PROPERTIES = D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_IGNORE ) )
dim bmp as ID2D1Bitmap ptr = rt.CreateBitmap( 64, 64, NULL, 0, @props )
dim shared1 as ID2D1Bitmap ptr = rt.CreateSharedBitmap( @IID_ID2D1Bitmap, bmp, NULL )
if shared1 then shared1->Release()
if bmp then bmp->Release()
```

Microsoft Learn: [ID2D1RenderTarget::CreateSharedBitmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createsharedbitmap)

### CreateBitmapBrush

```freebasic
function CreateBitmapBrush( byval bitmap as ID2D1Bitmap ptr, byref bitmapBrushProperties as const D2D1_BITMAP_BRUSH_PROPERTIES, byref brushProperties as const D2D1_BRUSH_PROPERTIES ) as ID2D1BitmapBrush ptr
function CreateBitmapBrush( byval bitmap as ID2D1Bitmap ptr, byval bitmapBrushProperties as const D2D1_BITMAP_BRUSH_PROPERTIES ptr, byval brushProperties as const D2D1_BRUSH_PROPERTIES ptr ) as ID2D1BitmapBrush ptr
function CreateBitmapBrush( byval bitmap as ID2D1Bitmap ptr, byref bitmapBrushProperties as const D2D1_BITMAP_BRUSH_PROPERTIES ) as ID2D1BitmapBrush ptr
function CreateBitmapBrush( byval bitmap as ID2D1Bitmap ptr, byval bitmapBrushProperties as const D2D1_BITMAP_BRUSH_PROPERTIES ptr ) as ID2D1BitmapBrush ptr
function CreateBitmapBrush( byval bitmap as ID2D1Bitmap ptr ) as ID2D1BitmapBrush ptr
```

Creates a brush that paints with a bitmap, its top-left corner at (0, 0) of the drawing. The
bitmap brush properties say what lies beyond the bitmap's edges in each direction (clamp, wrap
to tile it, or mirror) and how it is scaled; without them it is clamped, which repeats the edge
pixels. `NULL` pointers take the defaults.

The one-argument form is declared but has no body, so a program that calls it does not link;
pass `NULL, NULL` for the defaults instead.

| Parameter | Meaning |
| --- | --- |
| `bitmap` | The bitmap; the brush keeps its own reference. |
| `bitmapBrushProperties` | Extend modes and interpolation, as `D2D1_BitmapBrushProperties( extendModeX, extendModeY, interpolationMode )`. |
| `brushProperties` | Opacity and transform; move the bitmap with the transform. |

**Returns** the brush, which you release (or give to a `CID2D1BitmapBrush`), or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim props as D2D1_BITMAP_PROPERTIES = D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_IGNORE ) )
dim bmp as ID2D1Bitmap ptr = rt.CreateBitmap( 16, 16, NULL, 0, @props )
dim tiles as CID2D1BitmapBrush = rt.CreateBitmapBrush( bmp, D2D1_BitmapBrushProperties( D2D1_EXTEND_MODE_WRAP, D2D1_EXTEND_MODE_WRAP ) )
if bmp then bmp->Release()
```

Microsoft Learn: [ID2D1RenderTarget::CreateBitmapBrush](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createbitmapbrush%28id2d1bitmap_constd2d1_bitmap_brush_properties__constd2d1_brush_properties__id2d1bitmapbrush%29)

### CreateCompatibleRenderTarget

```freebasic
function CreateCompatibleRenderTarget() as ID2D1BitmapRenderTarget ptr
function CreateCompatibleRenderTarget( byref desiredSize as const D2D1_SIZE_F ) as ID2D1BitmapRenderTarget ptr
function CreateCompatibleRenderTarget( byval desiredSize as const D2D1_SIZE_F ptr ) as ID2D1BitmapRenderTarget ptr
function CreateCompatibleRenderTarget( byval desiredSizeWidth as single, byval desiredSizeHeight as single ) as ID2D1BitmapRenderTarget ptr
function CreateCompatibleRenderTarget( byref desiredSize as const D2D1_SIZE_F, byref desiredPixelSize as const D2D1_SIZE_U ) as ID2D1BitmapRenderTarget ptr
function CreateCompatibleRenderTarget( byval desiredSize as const D2D1_SIZE_F ptr, byval desiredPixelSize as const D2D1_SIZE_U ptr ) as ID2D1BitmapRenderTarget ptr
function CreateCompatibleRenderTarget( byval desiredSizeWidth as single, byval desiredSizeHeight as single, byval desiredPixelSizeWidth as UINT32, byval desiredPixelSizeWidthHeight as UINT32 ) as ID2D1BitmapRenderTarget ptr
function CreateCompatibleRenderTarget( byref desiredSize as const D2D1_SIZE_F, byref desiredPixelSize as const D2D1_SIZE_U, byref desiredFormat as const D2D1_PIXEL_FORMAT, byval options as D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS ) as ID2D1BitmapRenderTarget ptr
function CreateCompatibleRenderTarget( byval desiredSize as const D2D1_SIZE_F ptr, byval desiredPixelSize as const D2D1_SIZE_U ptr, byval desiredFormat as const D2D1_PIXEL_FORMAT ptr, byval options as D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS ) as ID2D1BitmapRenderTarget ptr
function CreateCompatibleRenderTarget( byval desiredSizeWidth as single, byval desiredSizeHeight as single, byval desiredPixelSizeWidth as UINT32, byval desiredPixelSizeWidthHeight as UINT32, byref desiredFormat as const D2D1_PIXEL_FORMAT, byval options as D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS ) as ID2D1BitmapRenderTarget ptr
```

Creates an off-screen render target that draws into a bitmap and shares this target's device, so
brushes and bitmaps work on both. Draw into it once, take its bitmap with
`CID2D1BitmapRenderTarget.GetBitmap`, and draw that bitmap, or paint with it, as often as needed:
the usual way to cache a costly picture or to make a tile for a bitmap brush. Without a size it
is as big as this target; without a pixel size the size in DIPs is converted with this target's
DPI; without a format it takes this target's.

| Parameter | Meaning |
| --- | --- |
| `desiredSize`, or `desiredSizeWidth` and `desiredSizeHeight` | The size in DIPs. |
| `desiredPixelSize`, or `desiredPixelSizeWidth` and `desiredPixelSizeWidthHeight` | The size in pixels. |
| `desiredFormat` | The pixel format and alpha mode. |
| `options` | `D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_GDI_COMPATIBLE` for a target that also takes GDI drawing, otherwise `_NONE`. |

**Returns** the new target, which you give to a [CID2D1BitmapRenderTarget](SysWin-Direct2D-Render-Targets#cid2d1bitmaprendertarget)
or release, or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim tile as CID2D1BitmapRenderTarget = rt.CreateCompatibleRenderTarget( 20, 20 )
tile.BeginDraw()
tile.Clear( D2D1_Gainsboro )
tile.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::CreateCompatibleRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createcompatiblerendertarget%28constd2d1_size_f_constd2d1_size_u_constd2d1_pixel_format_d2d1_compatible_render_target_options_id2d1bitmaprendertarget%29)

### CreateLayer

```freebasic
function CreateLayer( byref size as const D2D1_SIZE_F ) as ID2D1Layer ptr
function CreateLayer( byval size as const D2D1_SIZE_F ptr ) as ID2D1Layer ptr
function CreateLayer( byval nWidth as single, byval nHeight as single ) as ID2D1Layer ptr
function CreateLayer() as ID2D1Layer ptr
```

Creates a layer, the off-screen surface that [PushLayer](#pushlayer) draws into. A size, in DIPs,
only sets how much memory is reserved at first; without one the layer grows to what it needs.
One layer can be pushed again and again, but not while it is already pushed.

| Parameter | Meaning |
| --- | --- |
| `size`, or `nWidth` and `nHeight` | The starting size in DIPs. |

**Returns** the layer, which you release, or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim layer as ID2D1Layer ptr = rt.CreateLayer()
if layer then layer->Release()
```

Microsoft Learn: [ID2D1RenderTarget::CreateLayer](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createlayer%28constd2d1_size_f_id2d1layer%29)

### CreateMesh

```freebasic
function CreateMesh() as ID2D1Mesh ptr
```

Creates an empty mesh. Fill it with triangles through `ID2D1Mesh.Open`, which returns a
tessellation sink, or by tessellating a geometry into that sink, then paint it with
[FillMesh](#fillmesh).

**Returns** the mesh, which you release, or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim mesh as ID2D1Mesh ptr = rt.CreateMesh()
if mesh then mesh->Release()
```

Microsoft Learn: [ID2D1RenderTarget::CreateMesh](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createmesh)

### DrawLine

```freebasic
sub DrawLine( byval point0 as D2D1_POINT_2F, byval point1 as D2D1_POINT_2F, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
sub DrawLine( byval startPointX as single, byval startPointY as single, byval endPointX as single, byval endPointY as single, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
```

Draws a line from one point to the other. The stroke is centred on the line; the stroke style
sets dashes, caps and joins (see [Direct2D stroke styles](SysWin-Direct2D-Stroke-Styles)), and
without one the line is solid with flat ends.

| Parameter | Meaning |
| --- | --- |
| `point0`, `point1`, or the four coordinates | The two ends, in DIPs. |
| `brush` | What the stroke is painted with. |
| `strokeWidth` | The width in DIPs; 1 by default. |
| `strokeStyle` | Dashes, caps and joins, or `NULL`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
rt.BeginDraw()
rt.DrawLine( 10, 10, 200, 80, brush, 2 )
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::DrawLine](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-drawline)

### DrawRectangle

```freebasic
sub DrawRectangle( byref rect as const D2D1_RECT_F, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
sub DrawRectangle( byval rect as const D2D1_RECT_F ptr, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
sub DrawRectangle( byval left as single, byval top as single, byval right as single, byval bottom as single, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
```

Draws the outline of a rectangle, the stroke centred on its edges, so half the width falls
outside. Parameters as for [DrawLine](#drawline), with the rectangle as a `D2D1_RECT_F`
(`D2D1_RectF( left, top, right, bottom )`) or four numbers.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
rt.BeginDraw()
rt.DrawRectangle( D2D1_RectF( 20, 20, 180, 100 ), brush, 3 )
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::DrawRectangle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-drawrectangle%28constd2d1_rect_f__id2d1brush_float_id2d1strokestyle%29)

### FillRectangle

```freebasic
sub FillRectangle( byref rect as const D2D1_RECT_F, byval brush as ID2D1Brush ptr )
sub FillRectangle( byval rect as const D2D1_RECT_F ptr, byval brush as ID2D1Brush ptr )
sub FillRectangle( byval left as single, byval top as single, byval right as single, byval bottom as single, byval brush as ID2D1Brush ptr )
```

Paints the inside of a rectangle with a brush.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
rt.BeginDraw()
rt.FillRectangle( 20, 20, 180, 100, brush )
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::FillRectangle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-fillrectangle%28constd2d1_rect_f__id2d1brush%29)

### DrawRoundedRectangle

```freebasic
sub DrawRoundedRectangle( byref roundedRect as const D2D1_ROUNDED_RECT, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
sub DrawRoundedRectangle( byval roundedRect as const D2D1_ROUNDED_RECT ptr, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
sub DrawRoundedRectangle( byval left as single, byval top as single, byval right as single, byval bottom as single, byval radiusX as single, byval radiuxY as single, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
```

Draws the outline of a rectangle whose corners are quarter ellipses with the given radii. The
rounded rectangle is a `D2D1_ROUNDED_RECT` (`D2D1_RoundedRect( left, top, right, bottom,
radiusX, radiusY )`) or six numbers, the last of them the vertical radius. Other parameters as
for [DrawLine](#drawline).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
rt.BeginDraw()
rt.DrawRoundedRectangle( 20, 20, 180, 100, 10, 10, brush, 2 )
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::DrawRoundedRectangle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-drawroundedrectangle%28constd2d1_rounded_rect__id2d1brush_float_id2d1strokestyle%29)

### FillRoundedRectangle

```freebasic
sub FillRoundedRectangle( byref roundedRect as const D2D1_ROUNDED_RECT, byval brush as ID2D1Brush ptr )
sub FillRoundedRectangle( byval roundedRect as const D2D1_ROUNDED_RECT ptr, byval brush as ID2D1Brush ptr )
sub FillRoundedRectangle( byval left as single, byval top as single, byval right as single, byval bottom as single, byval radiusX as single, byval radiusY as single, byval brush as ID2D1Brush ptr )
```

Paints the inside of a rectangle with rounded corners.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
rt.BeginDraw()
rt.FillRoundedRectangle( D2D1_RoundedRect( 20, 20, 180, 100, 10, 10 ), brush )
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::FillRoundedRectangle](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-fillroundedrectangle%28constd2d1_rounded_rect__id2d1brush%29)

### DrawEllipse

```freebasic
sub DrawEllipse( byref tEllipse as const D2D1_ELLIPSE, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
sub DrawEllipse( byval tEllipse as const D2D1_ELLIPSE ptr, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
sub DrawEllipse( byval x as single, byval y as single, byval radiusX as single, byval radiusY as single, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
```

Draws the outline of an ellipse given by its centre and its two radii, as a `D2D1_ELLIPSE`
(`D2D1_EllipseF( x, y, radiusX, radiusY )`) or four numbers. Equal radii make a circle. Other
parameters as for [DrawLine](#drawline).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
rt.BeginDraw()
rt.DrawEllipse( 150, 150, 100, 100, brush, 3 )   ' a circle
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::DrawEllipse](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-drawellipse%28constd2d1_ellipse__id2d1brush_float_id2d1strokestyle%29)

### FillEllipse

```freebasic
sub FillEllipse( byref tEllipse as const D2D1_ELLIPSE, byval brush as ID2D1Brush ptr )
sub FillEllipse( byval tEllipse as const D2D1_ELLIPSE ptr, byval brush as ID2D1Brush ptr )
sub FillEllipse( byval x as single, byval y as single, byval radiusX as single, byval radiusY as single, byval brush as ID2D1Brush ptr )
```

Paints the inside of an ellipse.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
rt.BeginDraw()
rt.FillEllipse( D2D1_EllipseF( 150, 100, 80, 40 ), brush )
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::FillEllipse](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-fillellipse%28constd2d1_ellipse__id2d1brush%29)

### DrawGeometry

```freebasic
sub DrawGeometry( byval geometry as ID2D1Geometry ptr, byval brush as ID2D1Brush ptr, byval strokeWidth as FLOAT = 1.0!, byval strokeStyle as ID2D1StrokeStyle ptr = NULL )
```

Draws the outline of a geometry: any shape a factory makes, from a rectangle to a path of lines,
arcs and Béziers (see [Direct2D geometries](SysWin-Direct2D-Geometries)). Geometries belong to
the factory, not to a render target, so one geometry can be drawn on any target. Other parameters
as for [DrawLine](#drawline).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
dim shape as ID2D1EllipseGeometry ptr = factory.CreateEllipseGeometry( D2D1_EllipseF( 100, 100, 60, 30 ) )
rt.BeginDraw() : rt.DrawGeometry( cast( ID2D1Geometry ptr, shape ), brush, 2 ) : rt.EndDraw()
shape->Release()
```

Microsoft Learn: [ID2D1RenderTarget::DrawGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-drawgeometry)

### FillGeometry

```freebasic
sub FillGeometry( byval geometry as ID2D1Geometry ptr, byval brush as ID2D1Brush ptr )
```

Paints the inside of a geometry. For a path the fill mode chosen when it was built decides which
parts of a self-crossing figure are inside.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
dim shape as ID2D1RoundedRectangleGeometry ptr = factory.CreateRoundedRectangleGeometry( D2D1_RoundedRect( 20, 20, 180, 100, 8, 8 ) )
rt.BeginDraw() : rt.FillGeometry( cast( ID2D1Geometry ptr, shape ), brush ) : rt.EndDraw()
shape->Release()
```

Microsoft Learn: [ID2D1RenderTarget::FillGeometry](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-fillgeometry)

### FillMesh

```freebasic
sub FillMesh( byval mesh as ID2D1Mesh ptr, byval brush as ID2D1Brush ptr )
```

Paints the triangles of a mesh made by [CreateMesh](#createmesh). Meshes are drawn without
antialiasing: set [SetAntialiasMode](#setantialiasmode-getantialiasmode) to
`D2D1_ANTIALIAS_MODE_ALIASED` first, or `EndDraw` reports an error.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
dim mesh as ID2D1Mesh ptr = rt.CreateMesh()   ' triangles added through mesh->Open()
rt.BeginDraw() : rt.SetAntialiasMode( D2D1_ANTIALIAS_MODE_ALIASED ) : rt.FillMesh( mesh, brush ) : rt.EndDraw()
mesh->Release()
```

Microsoft Learn: [ID2D1RenderTarget::FillMesh](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-fillmesh)

### FillOpacityMask

```freebasic
sub FillOpacityMask( byval opacityMask as ID2D1Bitmap ptr, byval brush as ID2D1Brush ptr, byval content as D2D1_OPACITY_MASK_CONTENT, byref destinationRectangle as const D2D1_RECT_F, byref sourceRectangle as const D2D1_RECT_F )
sub FillOpacityMask( byval opacityMask as ID2D1Bitmap ptr, byval brush as ID2D1Brush ptr, byval content as D2D1_OPACITY_MASK_CONTENT, byval destinationRectangle as const D2D1_RECT_F ptr, byval sourceRectangle as const D2D1_RECT_F ptr )
```

Paints a rectangle with a brush, letting through only as much at each point as the alpha of the
mask bitmap there: a stencil. The part of the mask in `sourceRectangle` is stretched over
`destinationRectangle`. Like [FillMesh](#fillmesh) it needs `D2D1_ANTIALIAS_MODE_ALIASED`.

| Parameter | Meaning |
| --- | --- |
| `opacityMask` | The bitmap whose alpha is used. |
| `brush` | What the visible part is painted with. |
| `content` | What the mask holds: `D2D1_OPACITY_MASK_CONTENT_GRAPHICS`, `_TEXT_NATURAL` or `_TEXT_GDI_COMPATIBLE`. |
| `destinationRectangle` | Where to paint, in DIPs; `NULL` in the pointer form for the size of the mask at (0, 0). |
| `sourceRectangle` | The part of the mask, in DIPs; `NULL` in the pointer form for all of it. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
dim mask as ID2D1Bitmap ptr   ' a bitmap with an alpha channel
rt.BeginDraw() : rt.SetAntialiasMode( D2D1_ANTIALIAS_MODE_ALIASED )
rt.FillOpacityMask( mask, brush, D2D1_OPACITY_MASK_CONTENT_GRAPHICS, D2D1_RectF( 0, 0, 100, 100 ), D2D1_RectF( 0, 0, 32, 32 ) ) : rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::FillOpacityMask](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-fillopacitymask%28id2d1bitmap_id2d1brush_d2d1_opacity_mask_content_constd2d1_rect_f__constd2d1_rect_f_%29)

### DrawBitmap

```freebasic
sub DrawBitmap( byval bitmap as ID2D1Bitmap ptr, byref destinationRectangle as const D2D1_RECT_F, byval opacity as FLOAT = 1.0!, byval InterpolationMode as D2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR, byref sourceRectangle as const D2D1_RECT_F )
sub DrawBitmap( byval bitmap as ID2D1Bitmap ptr, byval destinationRectangle as const D2D1_RECT_F ptr, byval opacity as FLOAT = 1.0!, byval InterpolationMode as D2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR, byval sourceRectangle as const D2D1_RECT_F ptr )
sub DrawBitmap( byval bitmap as ID2D1Bitmap ptr, byval destRectLeft as single, byval destRectTop as single, byval destRectRight as single, byval destRectBottom as single, byval opacity as FLOAT = 1.0!, byval InterpolationMode as D2D1_BITMAP_INTERPOLATION_MODE = D2D1_BITMAP_INTERPOLATION_MODE_LINEAR, byval sourceRectangleLeft as single, byval sourceRectangleLeftTop as single, byval sourceRectangleRight as single, byval sourceRectangleBottom as single )
```

Draws the part of a bitmap in the source rectangle, scaled to fill the destination rectangle.
The source rectangle has no default in any form, though it follows two that have: give it every
time, or skip the two with empty arguments (`DrawBitmap( bmp, dest, , , src )`). To draw the
whole bitmap use the pointer form with `NULL` for the source, and `NULL` for the destination to
draw it at its own size at (0, 0).

| Parameter | Meaning |
| --- | --- |
| `bitmap` | The bitmap, made by this target or a compatible one. |
| `destinationRectangle`, or the four `destRect…` values | Where to draw, in DIPs. |
| `opacity` | From 0 (invisible) to 1 (opaque, the default). |
| `InterpolationMode` | `D2D1_BITMAP_INTERPOLATION_MODE_LINEAR` (the default) for smooth scaling, `_NEAREST_NEIGHBOR` for hard pixels. |
| `sourceRectangle`, or the four `sourceRectangle…` values | The part of the bitmap, in DIPs. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim tile as CID2D1BitmapRenderTarget = rt.CreateCompatibleRenderTarget( 50, 40 )
dim bmp as ID2D1Bitmap ptr = tile.GetBitmap()
dim dest as D2D1_RECT_F = D2D1_RectF( 60, 0, 160, 80 )
rt.BeginDraw() : rt.DrawBitmap( bmp, @dest, 0.5, D2D1_BITMAP_INTERPOLATION_MODE_LINEAR, NULL ) : rt.EndDraw()
bmp->Release()
```

Microsoft Learn: [ID2D1RenderTarget::DrawBitmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-drawbitmap%28id2d1bitmap_constd2d1_rect_f__float_d2d1_bitmap_interpolation_mode_constd2d1_rect_f_%29)

### DrawText

```freebasic
sub DrawText( byref wzSstr as wstring, byval stringLength as UINT32, byval textFormat as IDWriteTextFormat ptr, byref layoutRect as D2D1_RECT_F, byval defaultForegroundBrush as ID2D1Brush ptr, byval options as D2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_NONE, byval measuringMode as DWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL )
sub DrawText( byval pwzSstr as wstring ptr, byval stringLength as UINT32, byval textFormat as IDWriteTextFormat ptr, byval layoutRect as D2D1_RECT_F ptr, byval defaultForegroundBrush as ID2D1Brush ptr, byval options as D2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_NONE, byval measuringMode as DWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL )
sub DrawText( byref wzSstr as wstring, byval stringLength as UINT32, byval textFormat as IDWriteTextFormat ptr, byval layoutRectLeft as single, byval layoutRectTop as single, byval layoutRectRight as single, byval layoutRectBottom as single, byval defaultForegroundBrush as ID2D1Brush ptr, byval options as D2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_NONE, byval measuringMode as DWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL )
```

Lays out `stringLength` characters of a string with a DirectWrite text format (font, size,
weight, alignment, wrapping) inside a rectangle and draws them. The text wraps at the right edge
of the rectangle as the format says; text that does not fit spills out unless
`D2D1_DRAW_TEXT_OPTIONS_CLIP` is given. For text drawn often, lay it out once with
`IDWriteFactory.CreateTextLayout` and use [DrawTextLayout](#drawtextlayout).

| Parameter | Meaning |
| --- | --- |
| `wzSstr`, `pwzSstr` | The text: a literal, a `ustring` or a `wstring`. |
| `stringLength` | The number of UTF-16 code units to draw, `len( text )` for all of it. |
| `textFormat` | The format, from `IDWriteFactory.CreateTextFormat`. |
| `layoutRect`, or the four `layoutRect…` values | The rectangle to lay the text out in, in DIPs. |
| `defaultForegroundBrush` | What the text is painted with. |
| `options` | `D2D1_DRAW_TEXT_OPTIONS_CLIP`, `_NO_SNAP` and, on newer systems, `_ENABLE_COLOR_FONT` for colour emoji. |
| `measuringMode` | How glyphs are measured; the default suits most text. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
dim pDW as IDWriteFactory ptr, pFmt as IDWriteTextFormat ptr
DWriteCreateFactory( DWRITE_FACTORY_TYPE_SHARED, IID_IDWriteFactory, pDW )
pDW->CreateTextFormat( "Segoe UI", NULL, DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL, 16, "", pFmt )
dim s as ustring = "Hello, Direct2D"
rt.BeginDraw() : rt.DrawText( s, len( s ), pFmt, 10, 10, 300, 40, brush ) : rt.EndDraw()
pFmt->Release() : pDW->Release()
```

Microsoft Learn: [ID2D1RenderTarget::DrawText](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-drawtext%28constwchar_uint32_idwritetextformat_constd2d1_rect_f__id2d1brush_d2d1_draw_text_options_dwrite_measuring_mode%29)

### DrawTextLayout

```freebasic
sub DrawTextLayout( byval origin as D2D1_POINT_2F, byval textLayout as IDWriteTextLayout ptr, byval defaultFillBrush as ID2D1Brush ptr, byval options as D2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_NONE )
sub DrawTextLayout( byval originX as single, byval originY as single, byval textLayout as IDWriteTextLayout ptr, byval defaultFillBrush as ID2D1Brush ptr, byval options as D2D1_DRAW_TEXT_OPTIONS = D2D1_DRAW_TEXT_OPTIONS_NONE )
```

Draws a DirectWrite text layout with its top-left corner at `origin`. A layout holds text already
broken into lines and can carry its own fonts, sizes, colours and underlines per range; parts
with no brush of their own are painted with `defaultFillBrush`.

| Parameter | Meaning |
| --- | --- |
| `origin`, or `originX` and `originY` | The top-left corner, in DIPs. |
| `textLayout` | The layout, from `IDWriteFactory.CreateTextLayout`. |
| `defaultFillBrush` | The brush for text with none of its own. |
| `options` | As for [DrawText](#drawtext). |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
dim pDW as IDWriteFactory ptr, pFmt as IDWriteTextFormat ptr, pLayout as IDWriteTextLayout ptr
DWriteCreateFactory( DWRITE_FACTORY_TYPE_SHARED, IID_IDWriteFactory, pDW )
pDW->CreateTextFormat( "Segoe UI", NULL, DWRITE_FONT_WEIGHT_NORMAL, DWRITE_FONT_STYLE_NORMAL, DWRITE_FONT_STRETCH_NORMAL, 16, "", pFmt )
pDW->CreateTextLayout( "Laid out once", 13, pFmt, 300, 40, pLayout )
rt.BeginDraw() : rt.DrawTextLayout( 10, 10, pLayout, brush ) : rt.EndDraw()
pLayout->Release() : pFmt->Release() : pDW->Release()
```

Microsoft Learn: [ID2D1RenderTarget::DrawTextLayout](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-drawtextlayout)

### DrawGlyphRun

```freebasic
sub DrawGlyphRun( byval baselineOrigin as D2D1_POINT_2F, byref glyphRun as const DWRITE_GLYPH_RUN, byval foregroundBrush as ID2D1Brush ptr, byval measuringMode as DWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL )
sub DrawGlyphRun( byval baselineOrigin as D2D1_POINT_2F, byval glyphRun as const DWRITE_GLYPH_RUN ptr, byval foregroundBrush as ID2D1Brush ptr, byval measuringMode as DWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL )
sub DrawGlyphRun( byval baselineOriginX as single, byval baselineOriginY as single, byref glyphRun as const DWRITE_GLYPH_RUN, byval foregroundBrush as ID2D1Brush ptr, byval measuringMode as DWRITE_MEASURING_MODE = DWRITE_MEASURING_MODE_NATURAL )
```

Draws glyphs you have chosen yourself, by index in a font face, starting at a point on the
baseline. This is the lowest text level: the glyph run names the font face, the em size, the
glyph indices and, optionally, their advances and offsets. Most programs use
[DrawText](#drawtext) instead.

| Parameter | Meaning |
| --- | --- |
| `baselineOrigin`, or `baselineOriginX` and `baselineOriginY` | Where the first glyph sits on the baseline, in DIPs. |
| `glyphRun` | The glyphs and their font. |
| `foregroundBrush` | What they are painted with. |
| `measuringMode` | Must match how the advances were measured. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
dim glyphs as DWRITE_GLYPH_RUN   ' fontFace, fontEmSize, glyphCount and glyphIndices filled in
rt.BeginDraw() : rt.DrawGlyphRun( 10, 50, glyphs, brush ) : rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::DrawGlyphRun](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-drawglyphrun)

### SetTransform, GetTransform

```freebasic
sub SetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub SetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
sub GetTransform( byref transform as D2D1_MATRIX_3X2_F )
sub GetTransform( byval transform as D2D1_MATRIX_3X2_F ptr )
function GetTransform() as D2D1_MATRIX_3X2_F
```

`SetTransform` replaces the transform applied to everything drawn afterwards: a 3 × 2 matrix
that can move, scale, rotate and skew. Make one with the helpers `D2D1_MatrixTranslation`,
`D2D1_MatrixScale`, `D2D1_MatrixRotation` (degrees, clockwise, about a centre) and combine them
with `D2D1_MultiplyMatrices`; `D2D1_IdentityMatrix()` removes it. `GetTransform` reads it; a new
render target has the identity.

**Returns** (function form) the current transform.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
rt.SetTransform( D2D1_MatrixRotation( 45, 100, 100 ) )
dim m as D2D1_MATRIX_3X2_F = rt.GetTransform()
print m.m11; m.m12; m.m31; m.m32
```

Microsoft Learn: [ID2D1RenderTarget::SetTransform](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-settransform%28constd2d1_matrix_3x2_f_%29), [ID2D1RenderTarget::GetTransform](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-gettransform)

### SetAntialiasMode, GetAntialiasMode

```freebasic
sub SetAntialiasMode( byval antialiasMode as D2D1_ANTIALIAS_MODE )
function GetAntialiasMode() as D2D1_ANTIALIAS_MODE
```

Sets or reads how the edges of shapes (not text) are drawn: `D2D1_ANTIALIAS_MODE_PER_PRIMITIVE`
(0, the default) smooths them; `D2D1_ANTIALIAS_MODE_ALIASED` (1) gives hard edges, and is
required by [FillMesh](#fillmesh) and [FillOpacityMask](#fillopacitymask).

**Returns** (`GetAntialiasMode`) the current mode.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
rt.SetAntialiasMode( D2D1_ANTIALIAS_MODE_ALIASED )
print "mode:"; rt.GetAntialiasMode()   ' 1
```

Microsoft Learn: [ID2D1RenderTarget::SetAntialiasMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-setantialiasmode)

### SetTextAntialiasMode, GetTextAntialiasMode

```freebasic
sub SetTextAntialiasMode( byval textAntialiasMode as D2D1_TEXT_ANTIALIAS_MODE )
function GetTextAntialiasMode() as D2D1_TEXT_ANTIALIAS_MODE
```

Sets or reads how text is smoothed: `D2D1_TEXT_ANTIALIAS_MODE_DEFAULT` (0, the system setting),
`_CLEARTYPE`, `_GRAYSCALE` or `_ALIASED`. ClearType needs an opaque background, so on a target
with transparent pixels choose grayscale.

**Returns** (`GetTextAntialiasMode`) the current mode.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
rt.SetTextAntialiasMode( D2D1_TEXT_ANTIALIAS_MODE_GRAYSCALE )
print "text mode:"; rt.GetTextAntialiasMode()
```

Microsoft Learn: [ID2D1RenderTarget::SetTextAntialiasMode](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-settextantialiasmode)

### SetTextRenderingParams, GetTextRenderingParams

```freebasic
sub SetTextRenderingParams( byval textRenderingParams as IDWriteRenderingParams ptr )
sub GetTextRenderingParams( byref textRenderingParams as IDWriteRenderingParams ptr )
function GetTextRenderingParams() as IDWriteRenderingParams ptr
```

Sets or reads DirectWrite rendering options for text drawn afterwards: gamma, contrast, ClearType
level, pixel geometry and rendering mode, made with `IDWriteFactory.CreateCustomRenderingParams`.
`NULL` goes back to the defaults. The text antialias mode set with
[SetTextAntialiasMode](#settextantialiasmode-gettextantialiasmode) still applies on top.

**Returns** the parameters with a reference added, which you release, or `NULL` when none were
set (the default).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim pParams as IDWriteRenderingParams ptr = rt.GetTextRenderingParams()
if pParams = NULL then print "default text rendering" else pParams->Release()
```

Microsoft Learn: [ID2D1RenderTarget::SetTextRenderingParams](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-settextrenderingparams)

### SetTags, GetTags

```freebasic
sub SetTags( byval tag1 as D2D1_TAG, byval tag2 as D2D1_TAG )
sub GetTags( byref tag1 as D2D1_TAG = NULL, byref tag2 as D2D1_TAG = NULL )
sub GetTags( byval tag1 as D2D1_TAG ptr = NULL, byval tag2 as D2D1_TAG ptr = NULL )
```

Tags are two numbers of your choosing that Direct2D attaches to each drawing command recorded
after `SetTags`. When a command fails, [EndDraw](#enddraw) and [Flush](#flush) hand back the tags
it was recorded with, which tells you which part of the frame went wrong. `GetTags` reads the
current pair. As with `Flush`, `GetTags()` with no arguments matches both forms and does not
compile; pass at least one variable.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim as D2D1_TAG t1, t2
rt.SetTags( 1, 100 )
rt.GetTags( t1, t2 )
print t1; " "; t2   ' 1 100
```

Microsoft Learn: [ID2D1RenderTarget::SetTags](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-settags), [ID2D1RenderTarget::GetTags](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-gettags)

### SaveDrawingState

```freebasic
sub SaveDrawingState( byval drawingStateBlock as ID2D1DrawingStateBlock ptr )
```

Copies the target's drawing state (transform, antialias modes, tags and text rendering
parameters) into a state block made by the factory, so it can be put back later with
[RestoreDrawingState](#restoredrawingstate). Clips and layers are not part of it.

| Parameter | Meaning |
| --- | --- |
| `drawingStateBlock` | The block to fill; a [CID2D1DrawingStateBlock](SysWin-Direct2D-Render-Targets#cid2d1drawingstateblock) can be passed as it is. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim state as CID2D1DrawingStateBlock = factory.CreateDrawingStateBlock()
rt.SetTransform( D2D1_MatrixTranslation( 10, 20 ) )
rt.SaveDrawingState( state )
print "saved offset:"; state.GetDescription().transform.m31   ' 10
```

Microsoft Learn: [ID2D1RenderTarget::SaveDrawingState](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-savedrawingstate)

### RestoreDrawingState

```freebasic
sub RestoreDrawingState( byval drawingStateBlock as ID2D1DrawingStateBlock ptr )
```

Sets the target's transform, antialias modes, tags and text rendering parameters to those held in
a state block, as saved by [SaveDrawingState](#savedrawingstate) or set with its
`SetDescription`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim state as CID2D1DrawingStateBlock = factory.CreateDrawingStateBlock()
rt.SaveDrawingState( state )
rt.SetTransform( D2D1_MatrixScale( 2, 2 ) )
rt.RestoreDrawingState( state )   ' back to the saved transform
```

Microsoft Learn: [ID2D1RenderTarget::RestoreDrawingState](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-restoredrawingstate)

### PushAxisAlignedClip

```freebasic
sub PushAxisAlignedClip( byref clipRect as D2D1_RECT_F, byval antialiasMode as D2D1_ANTIALIAS_MODE )
sub PushAxisAlignedClip( byval clipRect as D2D1_RECT_F ptr, byval antialiasMode as D2D1_ANTIALIAS_MODE )
sub PushAxisAlignedClip( byval clipRectLeft as single, byval clipRecTop as single, byval clipRectRight as single, byval clipRectBottom as single, byval antialiasMode as D2D1_ANTIALIAS_MODE )
```

Clips everything drawn afterwards to a rectangle, until the matching
[PopAxisAlignedClip](#popaxisalignedclip). The rectangle goes through the current transform; if
that rotates it, the clip becomes the rectangle around the rotated one. Clips nest: each one
narrows the last. Pushes and pops must pair up within a frame, and clips and layers must be popped
in the reverse order they were pushed.

| Parameter | Meaning |
| --- | --- |
| `clipRect`, or the four `clipRect…` values | The rectangle, in DIPs. |
| `antialiasMode` | `D2D1_ANTIALIAS_MODE_ALIASED` for a hard edge on whole pixels, `_PER_PRIMITIVE` for a smooth one. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
rt.BeginDraw() : rt.PushAxisAlignedClip( 0, 0, 100, 100, D2D1_ANTIALIAS_MODE_ALIASED )
rt.FillEllipse( 100, 100, 80, 80, brush )   ' only the top-left quarter shows
rt.PopAxisAlignedClip() : rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::PushAxisAlignedClip](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-pushaxisalignedclip%28constd2d1_rect_f__d2d1_antialias_mode%29)

### PopAxisAlignedClip

```freebasic
sub PopAxisAlignedClip
```

Removes the clip rectangle pushed last by [PushAxisAlignedClip](#pushaxisalignedclip).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
rt.BeginDraw()
rt.PushAxisAlignedClip( D2D1_RectF( 0, 0, 50, 50 ), D2D1_ANTIALIAS_MODE_ALIASED )
rt.Clear( D2D1_Red )   ' clears only the clip
rt.PopAxisAlignedClip()
rt.EndDraw()
```

Microsoft Learn: [ID2D1RenderTarget::PopAxisAlignedClip](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-popaxisalignedclip)

### PushLayer

```freebasic
sub PushLayer( byref layerParameters as D2D1_LAYER_PARAMETERS, byval layer as ID2D1Layer ptr )
sub PushLayer( byval layerParameters as D2D1_LAYER_PARAMETERS ptr, byval layer as ID2D1Layer ptr )
```

Sends everything drawn afterwards into a layer, until the matching [PopLayer](#poplayer), which
blends the layer onto the target. The layer parameters say how: content bounds clip it to a
rectangle, a geometric mask clips it to any shape, the opacity and an opacity brush fade it.
`D2D1_LayerParameters( contentBounds, geometricMask, maskAntialiasMode, maskTransform, opacity,
opacityBrush, layerOptions )` makes them, every argument optional.

| Parameter | Meaning |
| --- | --- |
| `layerParameters` | Bounds, mask, opacity and options. |
| `layer` | A layer from [CreateLayer](#createlayer). |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim navy as D2D1_COLOR_F = D2D1_ColorF( D2D1_Navy )
dim brush as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @navy )
dim layer as ID2D1Layer ptr = rt.CreateLayer()
rt.BeginDraw() : rt.PushLayer( D2D1_LayerParameters( D2D1_RectF( 0, 0, 200, 100 ), NULL, D2D1_ANTIALIAS_MODE_PER_PRIMITIVE, D2D1_IdentityMatrix(), 0.5 ), layer )
rt.FillEllipse( 100, 100, 80, 80, brush ) : rt.PopLayer() : rt.EndDraw()
layer->Release()
```

Microsoft Learn: [ID2D1RenderTarget::PushLayer](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-pushlayer%28constd2d1_layer_parameters__id2d1layer%29)

### PopLayer

```freebasic
sub PopLayer
```

Ends the layer pushed last by [PushLayer](#pushlayer) and blends what was drawn into it onto the
target, through its bounds, mask and opacity.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim layer as ID2D1Layer ptr = rt.CreateLayer()
rt.BeginDraw() : rt.PushLayer( D2D1_LayerParameters( D2D1_RectF( 0, 0, 50, 50 ) ), layer )
rt.Clear( D2D1_Red ) : rt.PopLayer() : rt.EndDraw()
layer->Release()
```

Microsoft Learn: [ID2D1RenderTarget::PopLayer](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-poplayer)

### GetPixelFormat

```freebasic
sub GetPixelFormat( byref pixelFormat as D2D1_PIXEL_FORMAT )
sub GetPixelFormat( byval pixelFormat as D2D1_PIXEL_FORMAT ptr )
function GetPixelFormat() as D2D1_PIXEL_FORMAT
```

Returns the target's pixel format: its `format` (a `DXGI_FORMAT`, usually
`DXGI_FORMAT_B8G8R8A8_UNORM`, 87) and its `alphaMode` (`D2D1_ALPHA_MODE_IGNORE`, 3, for a window
or a DC target made with the defaults).

**Returns** (function form) the pixel format.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim pf as D2D1_PIXEL_FORMAT = rt.GetPixelFormat()
print "format"; pf.format; " alpha"; pf.alphaMode   ' format 87 alpha 3
```

Microsoft Learn: [ID2D1RenderTarget::GetPixelFormat](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-getpixelformat)

### SetDpi, GetDpi, GetDpiX, GetDpiY

```freebasic
sub SetDpi( byval dpiX as FLOAT, byval dpiY as FLOAT )
sub GetDpi( byref dpiX as FLOAT, byref dpiY as FLOAT )
function GetDpiX() as FLOAT
function GetDpiY() as FLOAT
```

The DPI converts DIPs to pixels: a target of 200 pixels at 192 DPI is 100 DIPs wide. `SetDpi`
changes it, which changes [GetSize](#getsize-getsizewidth-getsizeheight) but not the pixels;
pass 0 for both to go back to the desktop's DPI. It does not affect what is already drawn.
`GetDpi` reads both values and `GetDpiX`, `GetDpiY` one each.

**Returns** (`GetDpiX`, `GetDpiY`) the DPI.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
rt.SetDpi( 192, 192 )
print rt.GetDpiX(); " dpi:"; rt.GetSizeWidth(); " DIPs for"; rt.GetPixelWidth(); " pixels"
```

Microsoft Learn: [ID2D1RenderTarget::SetDpi](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-setdpi), [ID2D1RenderTarget::GetDpi](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-getdpi)

### GetSize, GetSizeWidth, GetSizeHeight

```freebasic
sub GetSize( byref size as D2D1_SIZE_F )
sub GetSize( byval size as D2D1_SIZE_F ptr )
function GetSize() as D2D1_SIZE_F
function GetSizeWidth() as single
function GetSizeHeight() as single
```

Return the size of the target in DIPs, the coordinates you draw in: the pixel size divided by
DPI / 96. A DC render target is 0 × 0 until it is bound to a device context.

**Returns** the size, its width or its height.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim sz as D2D1_SIZE_F = rt.GetSize()
print sz.width; " x"; sz.height; " DIPs"
```

Microsoft Learn: [ID2D1RenderTarget::GetSize](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-getsize)

### GetPixelSize, GetPixelWidth, GetPixelHeight

```freebasic
sub GetPixelSize( byref pixelSize as D2D1_SIZE_U )
sub GetPixelSize( byval pixelSize as D2D1_SIZE_U ptr )
function GetPixelSize() as D2D1_SIZE_U
function GetPixelWidth() as single
function GetPixelHeight() as single
```

Return the size of the target in device pixels. `GetPixelWidth` and `GetPixelHeight` return the
whole-number width and height as `single`.

**Returns** the size, its width or its height.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
print rt.GetPixelWidth(); " x"; rt.GetPixelHeight(); " pixels"   ' 400 x 300
```

Microsoft Learn: [ID2D1RenderTarget::GetPixelSize](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-getpixelsize)

### GetMaximumBitmapSize

```freebasic
function GetMaximumBitmapSize() as UINT32
```

Is meant to return the largest width or height, in pixels, of a bitmap the target's device can
hold. The member is declared but has no body, so a program that calls it does not link. Call the
interface instead, through `m_pRenderTarget`, as the example does.

**Returns** the largest bitmap dimension (through the interface).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
print "largest bitmap side:"; rt.m_pRenderTarget->GetMaximumBitmapSize()
```

Microsoft Learn: [ID2D1RenderTarget::GetMaximumBitmapSize](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-getmaximumbitmapsize)

### IsSupported

```freebasic
function IsSupported( byref renderTargetProperties as const D2D1_RENDER_TARGET_PROPERTIES ) as boolean
function IsSupported( byval renderTargetProperties as const D2D1_RENDER_TARGET_PROPERTIES ptr ) as boolean
```

Is meant to tell whether the target supports the given render target properties (type, pixel
format, DPI, usage, feature level). Both forms ask the interface but do not return its answer,
so they always return `false`, even for the target's own properties. Call the interface through
`m_pRenderTarget` for the real answer.

| Parameter | Meaning |
| --- | --- |
| `renderTargetProperties` | The properties to test, as `D2D1_RenderTargetProperties( … )`. |

**Returns** `false`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim props as D2D1_RENDER_TARGET_PROPERTIES = D2D1_RenderTargetProperties()
print rt.IsSupported( props ); " "; rt.m_pRenderTarget->IsSupported( props )   ' false, then the real answer
```

Microsoft Learn: [ID2D1RenderTarget::IsSupported](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-issupported%28constd2d1_render_target_properties_%29)

## See also

- [sys/win/direct2d](SysWin-Direct2D)
- [Direct2D render targets](SysWin-Direct2D-Render-Targets) for the window, DC and bitmap targets and drawing state blocks
- [CD2D1Factory](CD2D1Factory), which creates render targets, geometries and state blocks
- [Direct2D brushes](SysWin-Direct2D-Brushes), [Direct2D bitmaps](SysWin-Direct2D-Bitmaps), [Direct2D geometries](SysWin-Direct2D-Geometries)
- [Direct2D helpers](SysWin-Direct2D-Helpers) for `D2D1_ColorF`, `D2D1_RectF`, the matrix functions and the colour constants
- [DirectWrite interfaces](SysWin-DirectWrite-Interfaces) for text formats and layouts
