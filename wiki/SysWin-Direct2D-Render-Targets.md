[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **Direct2D render targets**

# Direct2D render targets
Draws into windows, device contexts and bitmaps, and saves and restores drawing state.

<!-- scope: CID2D1HwndRenderTarget -->
<!-- scope: CID2D1DCRenderTarget -->
<!-- scope: CID2D1BitmapRenderTarget -->
<!-- scope: CID2D1GdiInteropRenderTarget -->
<!-- scope: CID2D1DrawingStateBlock -->
<!-- scope: CID2D1DrawingStateBlock1 -->

Draws into windows, device contexts and bitmaps, and saves and restores drawing state.

A render target is where Direct2D draws. Each class here wraps one kind and adds what is special
to it; the three render target classes extend [CID2D1RenderTarget](CID2D1RenderTarget), so they
all have its drawing, resource and state members.

| Class | Draws into | Made by |
| --- | --- | --- |
| [CID2D1HwndRenderTarget](#cid2d1hwndrendertarget) | the client area of a window | `CD2D1Factory.CreateHwndRenderTarget` |
| [CID2D1DCRenderTarget](#cid2d1dcrendertarget) | a GDI device context, such as a memory DC or the DC of `BeginPaint` | `CD2D1Factory.CreateDCRenderTarget` |
| [CID2D1BitmapRenderTarget](#cid2d1bitmaprendertarget) | an off-screen bitmap that shares another target's device | `CID2D1RenderTarget.CreateCompatibleRenderTarget` |
| [CID2D1GdiInteropRenderTarget](#cid2d1gdiinteroprendertarget) | the same pixels as a render target, through a GDI device context | `QueryInterface` on a GDI-compatible target |

The other two classes hold drawing state: [CID2D1DrawingStateBlock](#cid2d1drawingstateblock)
keeps a transform, antialias modes, tags and text rendering parameters that
`SaveDrawingState` and `RestoreDrawingState` copy to and from a render target, and
[CID2D1DrawingStateBlock1](#cid2d1drawingstateblock1) adds the primitive blend and unit mode of
Direct2D 1.1.

**Ownership.** Every constructor that takes an interface pointer takes over the reference that
comes with it, and the destructor releases it: pass the pointer a factory call returns, straight
in, and do not release it yourself. Never copy one of these objects by value (`dim b as
CID2D1HwndRenderTarget = a`, or a `byval` parameter): the copy releases the same interface again.
Members called on an object that holds no interface do nothing and return 0 or `NULL`, except
where an entry says otherwise.

**A window target and the device.** A window render target lives on the graphics device. Make it
on the first `WM_PAINT`, call [Resize](#resize) from `WM_SIZE`, and when `EndDraw` returns
`D2DERR_RECREATE_TARGET` delete it, with every brush and bitmap made from it, and make it again.
A DC render target is bound to a device context with [BindDC](#binddc) before each frame.

The examples start from a factory made in one line,
`dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A window render target that paints a checkerboard from a 20 × 20 tile drawn off screen with a
bitmap render target, draws a rotated rectangle between a saved and a restored drawing state,
skips frames while the window is covered, and shows its size in pixels and DIPs in the caption:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/direct2d"
using win, gui, direct2d

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

dim shared pFactory as CD2D1Factory ptr
dim shared pRT as CID2D1HwndRenderTarget ptr

sub Render( byval hwnd as HWND )
    if pRT = NULL then
        var (l, t, r, b) = GetWindowClientRect( hwnd )
        pRT = new CID2D1HwndRenderTarget( pFactory->CreateHwndRenderTarget( D2D1_RenderTargetProperties(), _
                                          D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( r, b ) ) ) )
    end if
    dim byref rt as CID2D1HwndRenderTarget = *pRT
    if rt.CheckWindowState() and D2D1_WINDOW_STATE_OCCLUDED then exit sub

    ' a 20 x 20 tile drawn once, off screen, then used as a repeating brush
    dim tile as CID2D1BitmapRenderTarget = rt.CreateCompatibleRenderTarget( 20, 20 )
    dim grey as D2D1_COLOR_F = D2D1_ColorF( D2D1_Gainsboro )
    dim tileBrush as CID2D1SolidColorBrush = tile.CreateSolidColorBrush( @grey )
    tile.BeginDraw()
    tile.Clear( D2D1_White )
    tile.FillRectangle( 0, 0, 10, 10, tileBrush )
    tile.FillRectangle( 10, 10, 20, 20, tileBrush )
    tile.EndDraw()
    dim pBitmap as ID2D1Bitmap ptr = tile.GetBitmap()
    dim checks as CID2D1BitmapBrush = rt.CreateBitmapBrush( pBitmap, D2D1_BitmapBrushProperties( D2D1_EXTEND_MODE_WRAP, D2D1_EXTEND_MODE_WRAP ) )
    pBitmap->Release()

    dim blue as D2D1_COLOR_F = D2D1_ColorF( D2D1_SteelBlue, 0.8 )
    dim fill as CID2D1SolidColorBrush = rt.CreateSolidColorBrush( @blue )
    dim w as single = rt.GetSizeWidth(), h as single = rt.GetSizeHeight()
    dim state as CID2D1DrawingStateBlock = pFactory->CreateDrawingStateBlock()

    rt.BeginDraw()
    rt.FillRectangle( 0, 0, w, h, checks )
    rt.SaveDrawingState( state )
    rt.SetTransform( D2D1_MatrixRotation( 30, w / 2, h / 2 ) )
    rt.FillRectangle( w / 2 - 80, h / 2 - 40, w / 2 + 80, h / 2 + 40, fill )
    rt.RestoreDrawingState( state )             ' back to no rotation
    rt.FillRectangle( 10, 10, 60, 40, fill )
    if rt.EndDraw() = D2DERR_RECREATE_TARGET then
        delete pRT : pRT = NULL
    end if
end sub

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    pFactory = new CD2D1Factory( D2D1_FACTORY_TYPE_SINGLE_THREADED )
    dim pWindow as CWindow = "D2DTargets"
    pWindow.Create( NULL, "Direct2D render targets", @WndProc )
    pWindow.SetClientSize( 400, 260 )
    pWindow.Center()
    dim nResult as long = pWindow.DoEvents( SW_NORMAL )
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
            if pRT then
                pRT->Resize( D2D1_SizeU( LOWORD( lParam ), HIWORD( lParam ) ) )
                SetWindowText( hwnd, "pixels " & pRT->GetPixelWidth() & " x " & pRT->GetPixelHeight() & _
                                     ", DIPs " & pRT->GetSizeWidth() & " x " & pRT->GetSizeHeight() )
            end if
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

At 100 % scaling the two sizes in the caption are equal; at 150 % the size in DIPs is two thirds
of the size in pixels, and the drawing keeps its physical size.

## Members

| Member | Does |
| --- | --- |
| **CID2D1HwndRenderTarget** | |
| [Constructor](#constructor) | Takes over an `ID2D1HwndRenderTarget` pointer. |
| [Destructor](#destructor) | Releases the render target. |
| [Cast, Operator @, Operator *](#cast-operator--operator-) | Give the interface pointer or its address. |
| [CheckWindowState](#checkwindowstate) | Tells whether the window is covered. |
| [Resize](#resize) | Changes the size in pixels to match the window. |
| [GetHwnd](#gethwnd) | Returns the window. |
| **CID2D1DCRenderTarget** | |
| [Constructor](#constructor-1) | Takes over an `ID2D1DCRenderTarget` pointer. |
| [Destructor](#destructor-1) | Releases the render target. |
| [Cast, Operator @, Operator *](#cast-operator--operator--1) | Give the interface pointer or its address. |
| [BindDC](#binddc) | Binds the target to a device context and a rectangle of it. |
| **CID2D1BitmapRenderTarget** | |
| [Constructor](#constructor-2) | Takes over an `ID2D1BitmapRenderTarget` pointer. |
| [Destructor](#destructor-2) | Releases the render target. |
| [Cast, Operator @, Operator *](#cast-operator--operator--2) | Give the interface pointer or its address. |
| [GetBitmap](#getbitmap) | Returns the bitmap drawn into. |
| **CID2D1GdiInteropRenderTarget** | |
| [Constructor](#constructor-3) | Makes an empty object, or takes over an `ID2D1GdiInteropRenderTarget` pointer. |
| [Destructor](#destructor-3) | Releases the interface. |
| [Cast, Operator @, Operator *](#cast-operator--operator--3) | Give the interface pointer or its address. |
| [GetDC](#getdc) | Returns a GDI device context for the render target's pixels. |
| [ReleaseDC](#releasedc) | Hands the device context back to Direct2D. |
| **CID2D1DrawingStateBlock** | |
| [Constructor](#constructor-4) | Makes an empty object, or takes over an `ID2D1DrawingStateBlock` pointer. |
| [Destructor](#destructor-4) | Releases the state block. |
| [Cast, Operator @, Operator *](#cast-operator--operator--4) | Give the interface pointer or its address. |
| [GetFactory](#getfactory) | Returns the factory that made the block. |
| [GetDescription, SetDescription](#getdescription-setdescription) | Read or set the transform, antialias modes and tags held. |
| [SetTextRenderingParams, GetTextRenderingParams](#settextrenderingparams-gettextrenderingparams) | Set or read the text rendering parameters held. |
| **CID2D1DrawingStateBlock1** | |
| [Constructor](#constructor-5) | Makes an empty object, or takes over an `ID2D1DrawingStateBlock1` pointer. |
| [Destructor](#destructor-5) | Releases the state block. |
| [Cast, Operator @, Operator *](#cast-operator--operator--5) | Give the interface pointer, as either interface, or its address. |
| [GetDescription1, SetDescription1](#getdescription1-setdescription1) | Read or set the state, primitive blend and unit mode included. |

## Reference

## CID2D1HwndRenderTarget

Renders to the client area of a window. Make the interface with `CD2D1Factory.CreateHwndRenderTarget`,
giving the window and its client size in pixels in `D2D1_HwndRenderTargetProperties`; with a DPI of
0 in `D2D1_RenderTargetProperties` the target uses the desktop's. `EndDraw` presents the frame:
there is no separate swap or `BitBlt`.

Microsoft Learn: [ID2D1HwndRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1hwndrendertarget)

### Constructor

```freebasic
constructor( byval pHwndRenderTarget as ID2D1HwndRenderTarget ptr )
```

Wraps a window render target and takes over the reference that comes with `pHwndRenderTarget`.
The object stores the pointer twice, as its own interface and, in the base class, as an
`ID2D1RenderTarget`; it adds a reference for the second copy and the two destructors release
both. There is no constructor without arguments: pass `NULL` for an empty object.

| Parameter | Meaning |
| --- | --- |
| `pHwndRenderTarget` | The render target, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
if rt.m_pHwndRenderTarget = NULL then print "error &h"; hex( GetLastError() )
```

Microsoft Learn: [ID2D1Factory::CreateHwndRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createhwndrendertarget%28constd2d1_render_target_properties_constd2d1_hwnd_render_target_properties_id2d1hwndrendertarget%29)

### Destructor

```freebasic
destructor
```

Releases the window render target. Brushes and bitmaps you made from it stay valid until you
release them, but are of no use without it.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pRT as CID2D1HwndRenderTarget ptr = new CID2D1HwndRenderTarget( factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) ) )
delete pRT
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1HwndRenderTarget ptr
operator @() as ID2D1HwndRenderTarget ptr ptr
operator *( byref renderTarget as CID2D1HwndRenderTarget ) as ID2D1HwndRenderTarget ptr
```

`cast` and `*` return the `ID2D1HwndRenderTarget` pointer, which stays the object's. `@` returns
the address of `m_pHwndRenderTarget` only: a function that writes a pointer there leaves the
base class's `m_pRenderTarget` empty, so the inherited drawing members would do nothing. Build the
object with the constructor instead. The `ID2D1RenderTarget` pointer is the field
`m_pRenderTarget`. Applying `@` to the object currently stops the build with an internal compiler error; take the address of the field instead, `@obj.m_pHwndRenderTarget`, which is the same address.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim pHwndRT as ID2D1HwndRenderTarget ptr = *rt
dim pRT as ID2D1RenderTarget ptr = rt.m_pRenderTarget
```

### CheckWindowState

```freebasic
function CheckWindowState() as D2D1_WINDOW_STATE
```

Tells whether the window is covered by other windows, so that a program animating
it can skip frames nobody would see.

**Returns** `D2D1_WINDOW_STATE_OCCLUDED` (1) when the window is covered, otherwise
`D2D1_WINDOW_STATE_NONE` (0); 0 also on an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
if ( rt.CheckWindowState() and D2D1_WINDOW_STATE_OCCLUDED ) = 0 then
    rt.BeginDraw() : rt.Clear( D2D1_White ) : rt.EndDraw()
end if
```

Microsoft Learn: [ID2D1HwndRenderTarget::CheckWindowState](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1hwndrendertarget-checkwindowstate)

### Resize

```freebasic
function Resize( byref pixelSize as D2D1_SIZE_U ) as HRESULT
function Resize( byval pixelSize as D2D1_SIZE_U ptr ) as HRESULT
function Resize() as D2D1_SIZE_U
```

Changes the size of the target, in pixels. Call it when the window's client area changes size,
with the new width and height from `WM_SIZE`; without it the frame is stretched to the window.
The size in DIPs follows from the new pixel size and the DPI.

The form without arguments resizes the target to 0 × 0 pixels and returns that size, (0, 0),
storing the `HRESULT` in `GetLastError()`. It does not read the current size: use
`GetPixelSize` for that.

| Parameter | Meaning |
| --- | --- |
| `pixelSize` | The new size in pixels, `D2D1_SizeU( width, height )`. |

**Returns** `S_OK` on success, or an error. On an empty object the first two forms return 0 and
the third returns (0, 0) with `E_POINTER` in `GetLastError()`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
rt.Resize( D2D1_SizeU( 640, 480 ) )
print rt.GetPixelWidth(); " x"; rt.GetPixelHeight()   ' 640 x 480
```

Microsoft Learn: [ID2D1HwndRenderTarget::Resize](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1hwndrendertarget-resize%28constd2d1_size_u_%29)

### GetHwnd

```freebasic
function GetHwnd() as HWND
```

Returns the window the target draws into.

**Returns** the window handle; `NULL` on an empty object, with `E_POINTER` in `GetLastError()`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
print "same window:"; rt.GetHwnd() = hwnd
```

Microsoft Learn: [ID2D1HwndRenderTarget::GetHwnd](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1hwndrendertarget-gethwnd)

## CID2D1DCRenderTarget

Renders into a GDI device context: a memory DC holding a bitmap, a printer DC, or the DC a window
procedure gets from `BeginPaint`, so Direct2D drawing can be mixed with GDI drawing on the same
surface. `CD2D1Factory.CreateDCRenderTarget()` with no arguments makes one with the desktop's
DPI, the `DXGI_FORMAT_B8G8R8A8_UNORM` format and no alpha. Its size is 0 × 0 until
[BindDC](#binddc) gives it a device context.

Microsoft Learn: [ID2D1DCRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1dcrendertarget)

### Constructor

```freebasic
constructor( byval pDCRenderTarget as ID2D1DCRenderTarget ptr )
```

Wraps a DC render target and takes over the reference that comes with `pDCRenderTarget`, in the
same way as the [window target's constructor](#constructor).

| Parameter | Meaning |
| --- | --- |
| `pDCRenderTarget` | The render target, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
print "size before BindDC:"; rt.GetSizeWidth()   ' 0
```

Microsoft Learn: [ID2D1Factory::CreateDCRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createdcrendertarget)

### Destructor

```freebasic
destructor
```

Releases the DC render target. The device context it was bound to is not touched: release or
delete it as you would otherwise.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pRT as CID2D1DCRenderTarget ptr = new CID2D1DCRenderTarget( factory.CreateDCRenderTarget() )
delete pRT
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1DCRenderTarget ptr
operator @() as ID2D1DCRenderTarget ptr ptr
operator *( byref renderTarget as CID2D1DCRenderTarget ) as ID2D1RenderTarget ptr
```

`cast` returns the `ID2D1DCRenderTarget` pointer and `@` the address of `m_pDCRenderTarget`, with
the same caution as for the [window target](#cast-operator--operator-). `*` returns the same
pointer typed as an `ID2D1RenderTarget ptr`, the base interface.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DCRenderTarget ptr = rt
dim pRT as ID2D1RenderTarget ptr = *rt
```

### BindDC

```freebasic
function BindDC( byval hDC as HDC, byref subRect as const RECT ) as HRESULT
function BindDC( byval hDC as HDC, byval subRect as const RECT ptr ) as HRESULT
function BindDC( byval hDC as HDC, byval nLeft as long, byval nTop as long, byval nRight as long, byval nBottom as long ) as HRESULT
```

Binds the target to a device context: what is drawn between the next `BeginDraw` and `EndDraw`
lands in the given rectangle of it, in the DC's pixels, and the target takes the rectangle's
size. Bind again whenever the DC or the rectangle changes, for example on every `WM_PAINT` that
draws into the `BeginPaint` DC, and always outside `BeginDraw` / `EndDraw`. `EndDraw` copies the
frame into the DC.

| Parameter | Meaning |
| --- | --- |
| `hDC` | The device context. |
| `subRect`, or `nLeft` to `nBottom` | The rectangle of the DC to draw into, in pixels. |

**Returns** `S_OK` on success, or an error; `E_POINTER` on an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim hdc as HDC = GetDC( hwnd )
if rt.BindDC( hdc, 0, 0, 400, 300 ) = S_OK then
    rt.BeginDraw() : rt.Clear( D2D1_White ) : rt.EndDraw()
end if
ReleaseDC( hwnd, hdc )
```

Microsoft Learn: [ID2D1DCRenderTarget::BindDC](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1dcrendertarget-binddc)

## CID2D1BitmapRenderTarget

Renders into an off-screen bitmap made by `CreateCompatibleRenderTarget` of another target, on
the same device. Draw into it between its own `BeginDraw` and `EndDraw`, then take the result
with [GetBitmap](#getbitmap) and draw it on the parent target, or tile it with a bitmap brush.

Microsoft Learn: [ID2D1BitmapRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1bitmaprendertarget)

### Constructor

```freebasic
constructor( byval pBitmapRenderTarget as ID2D1BitmapRenderTarget ptr )
```

Wraps a bitmap render target and takes over the reference that comes with
`pBitmapRenderTarget`, in the same way as the [window target's constructor](#constructor).

| Parameter | Meaning |
| --- | --- |
| `pBitmapRenderTarget` | The render target, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim offscreen as CID2D1BitmapRenderTarget = rt.CreateCompatibleRenderTarget( 100, 50 )
print offscreen.GetPixelWidth(); " x"; offscreen.GetPixelHeight()
```

Microsoft Learn: [ID2D1RenderTarget::CreateCompatibleRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1rendertarget-createcompatiblerendertarget%28constd2d1_size_f_constd2d1_size_u_constd2d1_pixel_format_d2d1_compatible_render_target_options_id2d1bitmaprendertarget%29)

### Destructor

```freebasic
destructor
```

Releases the bitmap render target. A bitmap taken from it with [GetBitmap](#getbitmap) has its
own reference and stays usable.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim pOff as CID2D1BitmapRenderTarget ptr = new CID2D1BitmapRenderTarget( rt.CreateCompatibleRenderTarget() )
delete pOff
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1BitmapRenderTarget ptr
operator @() as ID2D1BitmapRenderTarget ptr ptr
operator *( byref renderTarget as CID2D1BitmapRenderTarget ) as ID2D1BitmapRenderTarget ptr
```

`cast` and `*` return the `ID2D1BitmapRenderTarget` pointer; `@` returns the address of
`m_pBitmapRenderTarget`, with the same caution as for the [window target](#cast-operator--operator-).

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim offscreen as CID2D1BitmapRenderTarget = rt.CreateCompatibleRenderTarget()
dim pBRT as ID2D1BitmapRenderTarget ptr = offscreen
```

### GetBitmap

```freebasic
function GetBitmap() as ID2D1Bitmap ptr
```

Returns the bitmap the target draws into. It holds what was drawn up to the last `EndDraw`, and
works on the parent target and on any target compatible with it.

**Returns** the bitmap with a reference added, which you release, or `NULL`; the `HRESULT` is in
`GetLastError()`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1HwndRenderTarget = factory.CreateHwndRenderTarget( D2D1_RenderTargetProperties(), D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( 400, 300 ) ) )
dim offscreen as CID2D1BitmapRenderTarget = rt.CreateCompatibleRenderTarget( 50, 40 )
offscreen.BeginDraw() : offscreen.Clear( D2D1_Yellow ) : offscreen.EndDraw()
dim bmp as ID2D1Bitmap ptr = offscreen.GetBitmap()
rt.BeginDraw() : rt.DrawBitmap( bmp, 0, 0, 50, 40, 1, D2D1_BITMAP_INTERPOLATION_MODE_LINEAR, 0, 0, 50, 40 ) : rt.EndDraw()
bmp->Release()
```

Microsoft Learn: [ID2D1BitmapRenderTarget::GetBitmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmaprendertarget-getbitmap)

## CID2D1GdiInteropRenderTarget

Gives GDI a device context for the pixels of a render target, so GDI calls (`FillRect`,
`DrawTextW`, `BitBlt` of a GDI bitmap, a themed part) can draw in the middle of a Direct2D frame.
The interface is not created on its own: ask a render target for it with `QueryInterface` and
`IID_ID2D1GdiInteropRenderTarget`. That works when the target was made with
`D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE`, the `DXGI_FORMAT_B8G8R8A8_UNORM` format and
premultiplied or ignored alpha (or, for a compatible target, with
`D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS_GDI_COMPATIBLE`).

`CID2D1GdiInteropRenderTarget` extends [CID2D1DrawingStateBlock](#cid2d1drawingstateblock), so it
also has that class's members, but it holds no state block: they do nothing, and its
[GetFactory](#getfactory) must not be called on it.

Microsoft Learn: [ID2D1GdiInteropRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1gdiinteroprendertarget)

### Constructor

```freebasic
constructor
constructor( byval pGdiInteropRenderTarget as ID2D1GdiInteropRenderTarget ptr )
```

The first form makes an empty object. The second takes over `pGdiInteropRenderTarget` without
adding a reference, and the destructor releases it: pass the pointer `QueryInterface` filled in.

| Parameter | Meaning |
| --- | --- |
| `pGdiInteropRenderTarget` | The interface, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget( D2D1_RENDER_TARGET_TYPE_DEFAULT, DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED, -1, -1, D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE )
dim pGI as ID2D1GdiInteropRenderTarget ptr
rt.m_pRenderTarget->QueryInterface( @IID_ID2D1GdiInteropRenderTarget, @pGI )
dim gi as CID2D1GdiInteropRenderTarget = pGI
```

Microsoft Learn: [IUnknown::QueryInterface](https://learn.microsoft.com/en-us/windows/win32/api/unknwn/nf-unknwn-iunknown-queryinterface%28refiid_void%29)

### Destructor

```freebasic
destructor
```

Releases the interface. The render target it came from is not affected.

**Example**

```freebasic
dim pGI as ID2D1GdiInteropRenderTarget ptr   ' from QueryInterface
dim p as CID2D1GdiInteropRenderTarget ptr = new CID2D1GdiInteropRenderTarget( pGI )
delete p
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1GdiInteropRenderTarget ptr
operator @() as ID2D1GdiInteropRenderTarget ptr ptr
operator *( byref interopRenderTarget as CID2D1GdiInteropRenderTarget ) as ID2D1GdiInteropRenderTarget ptr
```

`cast` and `*` return the `ID2D1GdiInteropRenderTarget` pointer. `@` returns the address of
`m_pGdiInteropRenderTarget` without releasing what is there, for `QueryInterface` to fill on an
empty object. Applying `@` to the object currently stops the build with an internal compiler error; take the address of the field instead, `@obj.m_pGdiInteropRenderTarget`, which is the same address. The examples do that.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget( D2D1_RENDER_TARGET_TYPE_DEFAULT, DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED, -1, -1, D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE )
dim gi as CID2D1GdiInteropRenderTarget
rt.m_pRenderTarget->QueryInterface( @IID_ID2D1GdiInteropRenderTarget, @gi.m_pGdiInteropRenderTarget )
print "interop available:"; cast( ID2D1GdiInteropRenderTarget ptr, gi ) <> NULL
```

### GetDC

```freebasic
function GetDC( byval mode as D2D1_DC_INITIALIZE_MODE, byref hDC as ..HDC ) as HRESULT
function GetDC( byval mode as D2D1_DC_INITIALIZE_MODE, byval hDC as ..HDC ptr ) as HRESULT
function GetDC( byval mode as D2D1_DC_INITIALIZE_MODE ) as ..HDC
```

Returns a GDI device context whose pixels are the render target's. Call it only between
`BeginDraw` and `EndDraw`, draw with GDI, then give it back with [ReleaseDC](#releasedc) before
any further Direct2D drawing and before `EndDraw`. Do not release or delete the DC with the GDI
functions.

| Parameter | Meaning |
| --- | --- |
| `mode` | `D2D1_DC_INITIALIZE_MODE_COPY` keeps what Direct2D drew so far; `D2D1_DC_INITIALIZE_MODE_CLEAR` starts from cleared pixels. |
| `hDC` | Receives the device context. |

**Returns** the first two forms `S_OK` or an error (`D2DERR_WRONG_STATE` outside a frame,
`E_POINTER` on an empty object); the third the DC, or `NULL`, with the `HRESULT` in
`GetLastError()`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget( D2D1_RENDER_TARGET_TYPE_DEFAULT, DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED, -1, -1, D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE )
dim gi as CID2D1GdiInteropRenderTarget
rt.m_pRenderTarget->QueryInterface( @IID_ID2D1GdiInteropRenderTarget, @gi.m_pGdiInteropRenderTarget )
dim hdcWin as HDC = GetDC( hwnd ), rc as RECT = ( 10, 10, 50, 50 )
rt.BindDC( hdcWin, 0, 0, 100, 100 ) : rt.BeginDraw() : rt.Clear( D2D1_White )
dim hdc as HDC = gi.GetDC( D2D1_DC_INITIALIZE_MODE_COPY )
FillRect( hdc, @rc, GetStockObject( BLACK_BRUSH ) ) : gi.ReleaseDC() : rt.EndDraw()
ReleaseDC( hwnd, hdcWin )
```

Microsoft Learn: [ID2D1GdiInteropRenderTarget::GetDC](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1gdiinteroprendertarget-getdc)

### ReleaseDC

```freebasic
function ReleaseDC( byref rcUpdate as const RECT ) as HRESULT
function ReleaseDC( byval rcUpdate as const RECT ptr = NULL ) as HRESULT
```

Tells Direct2D that GDI has finished with the device context from [GetDC](#getdc), and which part
of it changed. Unlike the other members it does not check for an empty object, so call it only
after a successful `GetDC`.

| Parameter | Meaning |
| --- | --- |
| `rcUpdate` | The rectangle GDI drew in, in pixels; `NULL` (the default) for all of it. |

**Returns** `S_OK` on success, or an error.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget( D2D1_RENDER_TARGET_TYPE_DEFAULT, DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED, -1, -1, D2D1_RENDER_TARGET_USAGE_GDI_COMPATIBLE )
dim gi as CID2D1GdiInteropRenderTarget
rt.m_pRenderTarget->QueryInterface( @IID_ID2D1GdiInteropRenderTarget, @gi.m_pGdiInteropRenderTarget )
dim hdcWin as HDC = GetDC( hwnd ), rc as RECT = ( 10, 10, 50, 50 )
rt.BindDC( hdcWin, 0, 0, 100, 100 ) : rt.BeginDraw()
dim hdc as HDC = gi.GetDC( D2D1_DC_INITIALIZE_MODE_COPY )
if hdc then FillRect( hdc, @rc, GetStockObject( BLACK_BRUSH ) ) : gi.ReleaseDC( rc )
rt.EndDraw() : ReleaseDC( hwnd, hdcWin )
```

Microsoft Learn: [ID2D1GdiInteropRenderTarget::ReleaseDC](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1gdiinteroprendertarget-releasedc)

## CID2D1DrawingStateBlock

Holds a copy of a render target's drawing state: the transform, the antialias mode for shapes
and for text, the two tags and the text rendering parameters. A block belongs to the factory, not
to a render target, so one block can carry the state from one target to another. Make it with
`CD2D1Factory.CreateDrawingStateBlock`, optionally with a description to start from, fill it with
`SaveDrawingState` and put it back with `RestoreDrawingState`.

Microsoft Learn: [ID2D1DrawingStateBlock](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1drawingstateblock)

### Constructor

```freebasic
constructor
constructor( byval pDrawingStateBlock as ID2D1DrawingStateBlock ptr )
```

The first form makes an empty object. The second takes over `pDrawingStateBlock` without adding
a reference, and the destructor releases it.

| Parameter | Meaning |
| --- | --- |
| `pDrawingStateBlock` | The state block, with a reference the object now owns. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim state as CID2D1DrawingStateBlock = factory.CreateDrawingStateBlock()
```

Microsoft Learn: [ID2D1Factory::CreateDrawingStateBlock](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1factory-createdrawingstateblock%28constd2d1_drawing_state_description__id2d1drawingstateblock%29)

### Destructor

```freebasic
destructor
```

Releases the state block.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pState as CID2D1DrawingStateBlock ptr = new CID2D1DrawingStateBlock( factory.CreateDrawingStateBlock() )
delete pState
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1DrawingStateBlock ptr
operator @() as ID2D1DrawingStateBlock ptr ptr
operator *( byref drawingStateBlock as CID2D1DrawingStateBlock ) as ID2D1DrawingStateBlock ptr
```

`cast` and `*` return the `ID2D1DrawingStateBlock` pointer, which is how the object is passed to
`SaveDrawingState` and `RestoreDrawingState`. `@` returns the address of `m_pDrawingStateBlock`
without releasing what is there, for a function that writes a block into an empty object.
Applying `@` to the object currently stops the build with an internal compiler error; take the address of the field instead, `@obj.m_pDrawingStateBlock`, which is the same address.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim state as CID2D1DrawingStateBlock = factory.CreateDrawingStateBlock()
dim pBlock as ID2D1DrawingStateBlock ptr = state
print "same block:"; pBlock = *state
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Returns the factory that created the block, with a reference added: release it when done. It
does not check for an empty object, so call it only on one that holds a block.

**Returns** the factory.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim state as CID2D1DrawingStateBlock = factory.CreateDrawingStateBlock()
dim pF as ID2D1Factory ptr = state.GetFactory()
print "same factory:"; pF = cast( ID2D1Factory ptr, factory )
pF->Release()
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### GetDescription, SetDescription

```freebasic
sub GetDescription( byref stateDescription as D2D1_DRAWING_STATE_DESCRIPTION )
sub GetDescription( byval stateDescription as D2D1_DRAWING_STATE_DESCRIPTION ptr )
function GetDescription() as D2D1_DRAWING_STATE_DESCRIPTION
sub SetDescription( byref stateDescription as D2D1_DRAWING_STATE_DESCRIPTION )
sub SetDescription( byval stateDescription as D2D1_DRAWING_STATE_DESCRIPTION ptr )
```

Read or replace the state held, apart from the text rendering parameters: a
`D2D1_DRAWING_STATE_DESCRIPTION` with the fields `antialiasMode`, `textAntialiasMode`, `tag1`,
`tag2` and `transform`. `D2D1_DrawingStateDescription( antialiasMode, textAntialiasMode, tag1,
tag2, transform )` makes one, every argument optional. A new block holds the defaults: smoothed
shapes, the default text mode, zero tags and the identity transform.

| Parameter | Meaning |
| --- | --- |
| `stateDescription` | Receives the state (`GetDescription`), or the state to store (`SetDescription`). |

**Returns** (function form) the state held.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim state as CID2D1DrawingStateBlock = factory.CreateDrawingStateBlock()
dim d as D2D1_DRAWING_STATE_DESCRIPTION = D2D1_DrawingStateDescription( D2D1_ANTIALIAS_MODE_ALIASED )
state.SetDescription( d )
print "antialias mode:"; state.GetDescription().antialiasMode   ' 1
```

Microsoft Learn: [ID2D1DrawingStateBlock::GetDescription](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1drawingstateblock-getdescription), [ID2D1DrawingStateBlock::SetDescription](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1drawingstateblock-setdescription%28constd2d1_drawing_state_description_%29)

### SetTextRenderingParams, GetTextRenderingParams

```freebasic
sub SetTextRenderingParams( byval textRenderingParams as IDWriteRenderingParams ptr )
sub GetTextRenderingParams( byref textRenderingParams as IDWriteRenderingParams ptr )
function GetTextRenderingParams() as IDWriteRenderingParams ptr
```

Set or read the DirectWrite text rendering parameters held in the block; `NULL` means the
defaults.

**Returns** the parameters with a reference added, which you release, or `NULL` when there are
none.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim state as CID2D1DrawingStateBlock = factory.CreateDrawingStateBlock()
state.SetTextRenderingParams( NULL )
print "no parameters:"; state.GetTextRenderingParams() = NULL
```

Microsoft Learn: [ID2D1DrawingStateBlock::SetTextRenderingParams](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1drawingstateblock-settextrenderingparams), [ID2D1DrawingStateBlock::GetTextRenderingParams](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1drawingstateblock-gettextrenderingparams)

## CID2D1DrawingStateBlock1

A drawing state block that also holds the primitive blend and the unit mode, the two pieces of
state a Direct2D 1.1 device context adds. Make it with `CD2D1Factory1.CreateDrawingStateBlock1`.
It extends [CID2D1DrawingStateBlock](#cid2d1drawingstateblock), whose members work on it too, and
converts to either interface, so it can be passed to `SaveDrawingState` as it is.

Microsoft Learn: [ID2D1DrawingStateBlock1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1drawingstateblock1)

### Constructor

```freebasic
constructor
constructor( byval pDrawingStateBlock1 as ID2D1DrawingStateBlock1 ptr )
```

The first form makes an empty object. The second takes over the reference that comes with
`pDrawingStateBlock1`: like the render target classes it stores the pointer twice, adds a
reference for the copy in the base class, and the two destructors release both.

| Parameter | Meaning |
| --- | --- |
| `pDrawingStateBlock1` | The state block, with a reference the object now owns. |

**Example**

```freebasic
dim factory1 as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim state1 as CID2D1DrawingStateBlock1 = factory1.CreateDrawingStateBlock1()
```

Microsoft Learn: [ID2D1Factory1::CreateDrawingStateBlock](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1factory1-createdrawingstateblock%28constd2d1_drawing_state_description1__id2d1drawingstateblock1%29)

### Destructor

```freebasic
destructor
```

Releases the state block.

**Example**

```freebasic
dim factory1 as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim pState as CID2D1DrawingStateBlock1 ptr = new CID2D1DrawingStateBlock1( factory1.CreateDrawingStateBlock1() )
delete pState
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1DrawingStateBlock1 ptr
operator cast() as ID2D1DrawingStateBlock ptr
operator @() as ID2D1DrawingStateBlock1 ptr ptr
operator *( byref drawingStateBlock1 as CID2D1DrawingStateBlock1 ) as ID2D1DrawingStateBlock1 ptr
```

The two `cast` operators return the block as an `ID2D1DrawingStateBlock1` or as an
`ID2D1DrawingStateBlock`, whichever the target type asks for; `*` returns the first. `@` returns
the address of `m_pDrawingStateBlock1` only, leaving the base class's pointer empty, so build the
object with the constructor. Applying `@` to the object currently stops the build with an internal compiler error; take the address of the field instead, `@obj.m_pDrawingStateBlock1`, which is the same address.

**Returns** the interface pointer, or its address.

**Example**

```freebasic
dim factory1 as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim state1 as CID2D1DrawingStateBlock1 = factory1.CreateDrawingStateBlock1()
dim pBlock1 as ID2D1DrawingStateBlock1 ptr = state1
dim pBlock as ID2D1DrawingStateBlock ptr = state1
```

### GetDescription1, SetDescription1

```freebasic
sub GetDescription1( byref stateDescription1 as D2D1_DRAWING_STATE_DESCRIPTION1 )
sub GetDescription1( byval stateDescription1 as D2D1_DRAWING_STATE_DESCRIPTION1 ptr )
function GetDescription1() as D2D1_DRAWING_STATE_DESCRIPTION1
sub SetDescription1( byref stateDescription1 as D2D1_DRAWING_STATE_DESCRIPTION1 )
sub SetDescription1( byval stateDescription1 as D2D1_DRAWING_STATE_DESCRIPTION1 ptr )
```

Read or replace the state held, as a `D2D1_DRAWING_STATE_DESCRIPTION1`: the fields of
[GetDescription](#getdescription-setdescription) plus `primitiveBlend` (how drawing combines
with what is below, `D2D1_PRIMITIVE_BLEND_SOURCE_OVER` by default) and `unitMode` (DIPs or
pixels, `D2D1_UNIT_MODE_DIPS` by default). `D2D1_DrawingStateDescription1( … )` makes one.

| Parameter | Meaning |
| --- | --- |
| `stateDescription1` | Receives the state, or the state to store. |

**Returns** (function form) the state held.

**Example**

```freebasic
dim factory1 as CD2D1Factory1 = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim state1 as CID2D1DrawingStateBlock1 = factory1.CreateDrawingStateBlock1()
dim d1 as D2D1_DRAWING_STATE_DESCRIPTION1 = state1.GetDescription1()
print "blend"; d1.primitiveBlend; " unit"; d1.unitMode   ' blend 0 unit 0
```

Microsoft Learn: [ID2D1DrawingStateBlock1::GetDescription](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1drawingstateblock1-getdescription), [ID2D1DrawingStateBlock1::SetDescription](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1drawingstateblock1-setdescription)

## See also

- [CID2D1RenderTarget](CID2D1RenderTarget), the members every render target class here inherits
- [CD2D1Factory](CD2D1Factory), which creates window and DC render targets and state blocks
- [sys/win/direct2d](SysWin-Direct2D)
- [Direct2D brushes](SysWin-Direct2D-Brushes) and [Direct2D bitmaps](SysWin-Direct2D-Bitmaps)
- [Direct2D helpers](SysWin-Direct2D-Helpers) for `D2D1_RenderTargetProperties`, `D2D1_HwndRenderTargetProperties` and `D2D1_SizeU`
