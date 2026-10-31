[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **Direct2D bitmaps and colour contexts**

# Direct2D bitmaps and colour contexts
Holds pixel images for a Direct2D render target, and the colour profiles they are in.

<!-- scope: CID2D1Bitmap -->
<!-- scope: CID2D1Bitmap1 -->
<!-- scope: CID2D1ColorContext -->
<!-- scope: CID2D1ColorContext1 -->

Holds pixel images for a Direct2D render target, and the colour profiles they are in.

A Direct2D **bitmap** is an image in the memory of the device a render target draws with. It is
made by that render target and works only with it (or one sharing its device): from pixels in
memory with `CreateBitmap`, from a decoded image file with `CreateBitmapFromWicBitmap`, or as the
contents of a bitmap render target. Draw it with `DrawBitmap`, paint with it through a
[bitmap brush](SysWin-Direct2D-Brushes#cid2d1bitmapbrush), and update it with the `CopyFrom…`
members below. The render-target side is on [CID2D1RenderTarget](CID2D1RenderTarget).

| Class | Wraps | Made by |
| --- | --- | --- |
| [CID2D1Bitmap](#cid2d1bitmap) | `ID2D1Bitmap` | `CreateBitmap`, `CreateBitmapFromWicBitmap`, `CreateSharedBitmap` of a render target |
| [CID2D1Bitmap1](#cid2d1bitmap1) | `ID2D1Bitmap1`: a bitmap with options, a colour context and CPU access | `CreateBitmap` and the other bitmap calls of a device context |
| [CID2D1ColorContext](#cid2d1colorcontext) | `ID2D1ColorContext`: the colour space of a bitmap's pixels | `CreateColorContext…` of a device context |
| [CID2D1ColorContext1](#cid2d1colorcontext1) | `ID2D1ColorContext1`: a colour context also described by a simple profile or a DXGI colour space | `CreateColorContextFrom…` of `ID2D1DeviceContext5` |

A device context is the `ID2D1DeviceContext` interface of a render target, which render targets
also implement on Windows 8 and later: ask for it with `QueryInterface`, as the examples below do,
and release it when done.

**Size and DPI.** A bitmap has a size in pixels and a DPI, 96 unless its properties say
otherwise. Drawing works in device-independent pixels (DIPs, 1/96 inch), and the bitmap's size in
DIPs is its pixel size × 96 / DPI: a 4 × 4 bitmap at 192 DPI measures 2 × 2 DIPs.

**Pixel format.** `D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED )`
is the format to use for pixels in memory: four bytes a pixel, blue first, so the `ulong`
`&hAARRGGBB` is one pixel, with the colour already multiplied by alpha. `D2D1_ALPHA_MODE_IGNORE`
treats every pixel as opaque.

**Ownership.** Construct the wrapper from the pointer a `Create…` call returns, at the
declaration: the object takes over the reference that came with it and releases it in its
destructor. The `…1` classes add a reference in their constructor and release one in each
destructor, so they take over the reference in the same way. To wrap a pointer you go on using
yourself, call its `AddRef` first. Never copy or assign a wrapper (`b = a`, or a `byval`
parameter): the classes have no copy constructor or assignment, so both objects would release the
same pointer. Members that return an interface pointer (`GetFactory`, `GetColorContext`,
`GetSurface`) add a reference: release what they return, or construct a wrapper from it.

**Empty objects.** The default constructors make an object that holds nothing. Getters on it
return 0, `NULL` or a zeroed structure and the `CopyFrom…` members return `E_POINTER`; `Unmap` and
`GetProfile` return `S_OK` without doing anything. `GetFactory` of `CID2D1ColorContext` is not
guarded and needs an object that holds a colour context. A default-constructed `CID2D1Bitmap1` or
`CID2D1ColorContext1` whose field `m_pBitmap1` or `m_pColorContext1` is filled in afterwards
still has an empty base field (`m_pBitmap`, `m_pColorContext`), so the inherited members see no
object: construct these from the pointer instead.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A window that shows one 16 × 16 bitmap enlarged eight times, once with nearest-neighbour and once
with linear resampling. The bitmap is made from pixels computed in memory, and a white square is
then copied into its middle:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/direct2d"
using win, gui, direct2d

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

' Draws a small bitmap twice, enlarged, into a GDI device context
function RenderScene( byval hDC as HDC, byval nWidth as long, byval nHeight as long ) as HRESULT
    dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
    if GetLastError() <> S_OK then return GetLastError()
    dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
    if *rt = NULL then return GetLastError()
    rt.BindDC( hDC, 0, 0, nWidth, nHeight )

    ' 16 x 16 opaque pixels, &hAARRGGBB: red grows to the right, blue downwards
    dim pixels(255) as ulong
    for y as long = 0 to 15
        for x as long = 0 to 15
            pixels(y * 16 + x) = &hFF000000 or ( x * 17 ) shl 16 or ( y * 17 )
        next
    next
    dim bmp as CID2D1Bitmap = rt.CreateBitmap( 16, 16, @pixels(0), 16 * 4, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
    if *bmp = NULL then return GetLastError()

    ' a white 4 x 4 square into the middle; the source rows are 4 pixels long
    dim white(15) as ulong
    for i as long = 0 to 15
        white(i) = &hFFFFFFFF
    next
    bmp.CopyFromMemory( 6, 6, 10, 10, @white(0), 4 * 4 )

    dim sz as D2D1_SIZE_F = bmp.GetSize()                 ' 16 x 16 DIPs at 96 DPI
    dim sharp as D2D1_RECT_F = D2D1_RectF( 20, 20, 20 + sz.width * 8, 20 + sz.height * 8 )
    dim smooth as D2D1_RECT_F = D2D1_RectF( 168, 20, 168 + sz.width * 8, 20 + sz.height * 8 )
    rt.BeginDraw()
    rt.Clear( D2D1_ColorF( D2D1_White ) )
    rt.DrawBitmap( bmp, @sharp, 1.0, D2D1_BITMAP_INTERPOLATION_MODE_NEAREST_NEIGHBOR, NULL )
    rt.DrawBitmap( bmp, @smooth, 1.0, D2D1_BITMAP_INTERPOLATION_MODE_LINEAR, NULL )
    return rt.EndDraw()
end function

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim pWindow as CWindow = "D2DBitmapDemo"
    dim hWin as HWND = pWindow.Create( NULL, "Direct2D bitmaps", @WndProc )
    pWindow.SetClientSize( 316, 168 )
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

`DrawBitmap` takes the `CID2D1Bitmap` object directly: it converts to `ID2D1Bitmap ptr` by
itself.

## Members

| Member | Does |
| --- | --- |
| **CID2D1Bitmap** | |
| [Constructor](#constructor) | Creates an empty object, or wraps a bitmap. |
| [Destructor](#destructor) | Releases the bitmap. |
| [Cast, Operator @, Operator *](#cast-operator--operator-) | Give the bitmap pointer, or its address. |
| [GetFactory](#getfactory) | Returns the factory the bitmap belongs to. |
| [GetSize](#getsize) | Returns the size in DIPs. |
| [GetPixelSize](#getpixelsize) | Returns the size in pixels. |
| [GetPixelFormat](#getpixelformat) | Returns the pixel format and alpha mode. |
| [GetDpi](#getdpi) | Reads the horizontal and vertical DPI. |
| [CopyFromBitmap](#copyfrombitmap) | Copies pixels from another bitmap. |
| [CopyFromRenderTarget](#copyfromrendertarget) | Copies pixels from a render target. |
| [CopyFromMemory](#copyfrommemory) | Copies pixels from memory. |
| **CID2D1Bitmap1** | |
| [Constructor](#constructor-1) | Creates an empty object, or wraps a device-context bitmap. |
| [Destructor](#destructor-1) | Releases the bitmap. |
| [Cast, Operator @, Operator *](#cast-operator--operator--1) | Give the `ID2D1Bitmap1` pointer, or its address. |
| [GetColorContext](#getcolorcontext) | Returns the bitmap's colour context. |
| [GetOptions](#getoptions) | Returns the options the bitmap was made with. |
| [GetSurface](#getsurface) | Returns the DXGI surface behind the bitmap. |
| [Map](#map) | Gives the CPU read access to the pixels. |
| [Unmap](#unmap) | Ends the access [Map](#map) gave. |
| **CID2D1ColorContext** | |
| [Constructor](#constructor-2) | Creates an empty object, or wraps a colour context. |
| [Destructor](#destructor-2) | Releases the colour context. |
| [Cast, Operator @, Operator *](#cast-operator--operator--2) | Give the colour-context pointer, or its address. |
| [GetFactory](#getfactory-1) | Returns the factory the colour context belongs to. |
| [GetColorSpace](#getcolorspace) | Tells which colour space it describes. |
| [GetProfileSize](#getprofilesize) | Returns the size of its ICC profile. |
| [GetProfile](#getprofile) | Copies its ICC profile into memory. |
| **CID2D1ColorContext1** | |
| [Constructor](#constructor-3) | Creates an empty object, or wraps a newer colour context. |
| [Destructor](#destructor-3) | Releases the colour context. |
| [Cast, Operator @, Operator *](#cast-operator--operator--3) | Give the `ID2D1ColorContext1` pointer, or its address. |
| [GetFactory](#getfactory-2) | Declared, but a call to it does not link. |
| [GetColorContextType](#getcolorcontexttype) | Tells how the colour context is described. |
| [GetDXGIColorSpace](#getdxgicolorspace) | Returns its DXGI colour space. |
| [GetSimpleColorProfile](#getsimplecolorprofile) | Returns its simple colour profile. |

## Reference

## CID2D1Bitmap

### Constructor

```freebasic
constructor
constructor( byval pBitmap as ID2D1Bitmap ptr )
```

With a pointer the object holds that bitmap and takes over the reference that came with it; it
does not add one. Without one it is empty until a pointer is stored in its public field
`m_pBitmap`.

| Parameter | Meaning |
| --- | --- |
| `pBitmap` | The bitmap, normally straight from `CreateBitmap` or `CreateBitmapFromWicBitmap`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 4, 4, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
if *bmp = NULL then print "no bitmap: &h"; hex( GetLastError() )
```

Microsoft Learn: [ID2D1Bitmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1bitmap)

### Destructor

```freebasic
destructor
```

Releases the bitmap, if the object holds one. Brushes made with the bitmap keep their own
reference to it.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
scope
    dim bmp as CID2D1Bitmap = rt.CreateBitmap( 4, 4, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
end scope                                ' released here
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1Bitmap ptr
operator cast() as ID2D1Image ptr
operator @() as ID2D1Bitmap ptr ptr
operator *( byref bitmap as CID2D1Bitmap ) as ID2D1Bitmap ptr
```

The two `cast`s give the bitmap pointer, as the `ID2D1Bitmap ptr` that `DrawBitmap` and
`CreateBitmapBrush` take or as the `ID2D1Image ptr` that an image brush and the device-context
calls take; `*bmp` gives the `ID2D1Bitmap` pointer for calling an interface method directly.
None adds a reference.

`@` returns the address of `m_pBitmap`, for a call that writes a new bitmap pointer into an
output parameter; it does not release a bitmap the object already holds. Applying `@` to one of
these objects currently stops the build with an internal compiler error; until it builds, pass
the field `m_pBitmap` itself.

**Returns** the bitmap pointer (`NULL` for an empty object), or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap
rt.m_pRenderTarget->CreateBitmap( D2D1_SizeU( 8, 2 ), NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ), bmp.m_pBitmap )
dim pImage as ID2D1Image ptr = bmp                        ' cast
dim pf as D2D1_PIXEL_FORMAT
( *bmp )->GetPixelFormat( pf )                            ' the interface itself
print pf.format                                           ' 87
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Returns the factory that made the bitmap's render target. The pointer carries a new reference:
release it.

**Returns** the factory, or `NULL` for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 4, 4, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pFactory as ID2D1Factory ptr = bmp.GetFactory()
print ( pFactory = *factory )            ' -1 (true)
pFactory->Release()
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### GetSize

```freebasic
function GetSize() as D2D1_SIZE_F
```

Returns the size of the bitmap in DIPs, the unit drawing calls use: the pixel size × 96 / DPI.

**Returns** the size as `width` and `height`; for an empty object, 0 × 0.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 4, 4, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ), 192, 192 ) )
dim sz as D2D1_SIZE_F = bmp.GetSize()
print sz.width; sz.height                ' 2 2
```

Microsoft Learn: [ID2D1Bitmap::GetSize](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmap-getsize)

### GetPixelSize

```freebasic
function GetPixelSize() as D2D1_SIZE_U
```

Returns the size of the bitmap in pixels, whatever its DPI.

**Returns** the size as `width` and `height`; for an empty object, 0 × 0.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 4, 4, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ), 192, 192 ) )
dim px as D2D1_SIZE_U = bmp.GetPixelSize()
print px.width; " x "; px.height         ' 4 x 4
```

Microsoft Learn: [ID2D1Bitmap::GetPixelSize](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmap-getpixelsize)

### GetPixelFormat

```freebasic
function GetPixelFormat() as D2D1_PIXEL_FORMAT
```

Returns the layout of the bitmap's pixels: `format`, a `DXGI_FORMAT_…` value such as
`DXGI_FORMAT_B8G8R8A8_UNORM` (87), and `alphaMode`, a `D2D1_ALPHA_MODE_…` value such as
`D2D1_ALPHA_MODE_PREMULTIPLIED` (1) or `D2D1_ALPHA_MODE_IGNORE` (3).

**Returns** the format; for an empty object, a zeroed one.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 4, 4, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pf as D2D1_PIXEL_FORMAT = bmp.GetPixelFormat()
print pf.format; pf.alphaMode            ' 87 1
```

Microsoft Learn: [ID2D1Bitmap::GetPixelFormat](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmap-getpixelformat)

### GetDpi

```freebasic
sub GetDpi( byref DpiX as FLOAT, byref DpiY as FLOAT )
sub GetDpi( byval DpiX as FLOAT ptr, byval DpiY as FLOAT ptr )
```

Reads the horizontal and vertical DPI of the bitmap into two variables, or through two pointers.
`D2D1_BitmapProperties` gives 96 unless told otherwise.

| Parameter | Meaning |
| --- | --- |
| `DpiX` | Receives the horizontal DPI. |
| `DpiY` | Receives the vertical DPI. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 4, 4, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim as single dpiX, dpiY
bmp.GetDpi( dpiX, dpiY )
print dpiX; dpiY                         ' 96 96
```

Microsoft Learn: [ID2D1Bitmap::GetDpi](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmap-getdpi)

### CopyFromBitmap

```freebasic
function CopyFromBitmap( byref destPoint as const D2D1_POINT_2U, byval bitmap as ID2D1Bitmap ptr, byref srcRect as const D2D1_RECT_U ) as HRESULT
function CopyFromBitmap( byval destPoint as const D2D1_POINT_2U ptr, byval bitmap as ID2D1Bitmap ptr, byval srcRect as const D2D1_RECT_U ptr ) as HRESULT
function CopyFromBitmap( byval as const UINT32, byval destPointY as const UINT32, byval bitmap as ID2D1Bitmap ptr, byval srcRectLeft as UINT32, byval srcRectTop as UINT32, byval srcRectRight as UINT32, byval srcRectBottom as UINT32 ) as HRESULT
```

Copies the pixels inside `srcRect` of `bitmap` into this bitmap, with their top-left corner at
`destPoint`. Both bitmaps must have the same pixel format: there is no
conversion and no scaling, and Direct2D documents the call as failing when the region does not
fit in this bitmap. In the pointer form, `NULL` for `destPoint` means (0, 0) and `NULL`
for `srcRect` the whole of `bitmap`. In the form with separate coordinates the first parameter,
which the declaration leaves unnamed, is the x of the destination point.

| Parameter | Meaning |
| --- | --- |
| `destPoint` (or the first two values) | Where the copied pixels go in this bitmap, in pixels. |
| `bitmap` | The bitmap to copy from. |
| `srcRect` (or the last four values) | The pixels of `bitmap` to copy. |

**Returns** `S_OK` (0) on success; `E_INVALIDARG` (&h80070057) when the formats differ;
`E_POINTER` for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim src as CID2D1Bitmap = rt.CreateBitmap( 4, 4, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim dst as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
print dst.CopyFromBitmap( 2, 2, src, 0, 0, 4, 4 )         ' 0
```

Microsoft Learn: [ID2D1Bitmap::CopyFromBitmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmap-copyfrombitmap)

### CopyFromRenderTarget

```freebasic
function CopyFromRenderTarget( byref destPoint as const D2D1_POINT_2U, byval renderTarget as ID2D1RenderTarget ptr, byref srcRect as const D2D1_RECT_U ) as HRESULT
function CopyFromRenderTarget( byval destPoint as const D2D1_POINT_2U ptr, byval renderTarget as ID2D1RenderTarget ptr, byval srcRect as const D2D1_RECT_U ptr ) as HRESULT
function CopyFromRenderTarget( byval destPointX as const UINT32, byval destPointY as const UINT32, byval renderTarget as ID2D1RenderTarget ptr, byval srcRectLeft as UINT32, byval srcRectTop as UINT32, byval srcRectRight as UINT32, byval srcRectBottom as UINT32 ) as HRESULT
```

Copies the pixels inside `srcRect` of what has been drawn on `renderTarget` into this bitmap, at
`destPoint`. The render target must be the one the bitmap came from (or share its device), and
its pixel format and alpha mode must match the bitmap's: a target that ignores alpha needs a
bitmap made with `D2D1_ALPHA_MODE_IGNORE`. No clip or layer may be pushed on the target at the
time. Pass a render-target wrapper as `*rt`.

| Parameter | Meaning |
| --- | --- |
| `destPoint` (or `destPointX`, `destPointY`) | Where the copied pixels go in this bitmap. |
| `renderTarget` | The render target to copy from. |
| `srcRect` (or the last four values) | The part of the target to copy, in pixels. |

**Returns** `S_OK` (0) on success; `E_INVALIDARG` (&h80070057) when the formats differ;
`E_POINTER` for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim hdcMem as HDC = CreateCompatibleDC( NULL )
dim hbm as HBITMAP = CreateBitmap( 8, 8, 1, 32, NULL )
dim hOld as HGDIOBJ = SelectObject( hdcMem, hbm )
rt.BindDC( hdcMem, 0, 0, 8, 8 )
dim snap as CID2D1Bitmap = rt.CreateBitmap( 8, 8, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_IGNORE ) ) )
rt.BeginDraw()
rt.Clear( D2D1_ColorF( D2D1_Red ) )
print snap.CopyFromRenderTarget( 0, 0, *rt, 0, 0, 8, 8 )  ' 0
rt.EndDraw()
SelectObject( hdcMem, hOld ) : DeleteObject( hbm ) : DeleteDC( hdcMem )
```

Microsoft Learn: [ID2D1Bitmap::CopyFromRenderTarget](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmap-copyfromrendertarget)

### CopyFromMemory

```freebasic
function CopyFromMemory( byref dstRect as const D2D1_RECT_U, byval srcData as any ptr, byval pitch as UINT32 ) as HRESULT
function CopyFromMemory( byval dstRect as const D2D1_RECT_U ptr, byval srcData as any ptr, byval pitch as UINT32 ) as HRESULT
function CopyFromMemory( byval dstRectLeft as UINT32, byval dstRectTop as UINT32, byval dstRectRight as UINT32, byval dstRectBottom as UINT32, byval srcData as any ptr, byval pitch as UINT32 ) as HRESULT
```

Copies pixels from memory into the rectangle `dstRect` of the bitmap. The data must be in the
bitmap's pixel format; `pitch` is the number of bytes from the start of one row of the source to
the start of the next, so 4 × width for tightly packed 32-bit pixels. Keep the rectangle inside
the bitmap: Direct2D does not report one that runs past the edge (an 8 × 8 rectangle on a 4 × 4
bitmap returned `S_OK` in a test).

| Parameter | Meaning |
| --- | --- |
| `dstRect` (or the four values) | The rectangle of the bitmap to fill, in pixels. |
| `srcData` | The first pixel of the source. |
| `pitch` | The bytes per row of the source. |

**Returns** `S_OK` (0) on success, `E_POINTER` (&h80004003) for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim bmp as CID2D1Bitmap = rt.CreateBitmap( 4, 4, NULL, 0, D2D1_BitmapProperties( D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) ) )
dim pixels(3) as ulong = { &hFFFF0000, &hFF00FF00, &hFF0000FF, &hFFFFFFFF }
print bmp.CopyFromMemory( 0, 0, 2, 2, @pixels(0), 2 * 4 )   ' 0: a 2 x 2 block at the top left
```

Microsoft Learn: [ID2D1Bitmap::CopyFromMemory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1bitmap-copyfrommemory)

## CID2D1Bitmap1

A bitmap made by a device context, with **options** that say what it can be used for, an optional
**colour context**, and, with the right options, read access from the CPU. It extends
[CID2D1Bitmap](#cid2d1bitmap), whose members all work on it. The options are
`D2D1_BITMAP_OPTIONS_…` flags: `TARGET` (1, can be drawn into), `CANNOT_DRAW` (2, cannot be drawn
from), `CPU_READ` (4, can be mapped for reading; needs `CANNOT_DRAW`) and `GDI_COMPATIBLE` (8).
`D2D1_BitmapProperties1( options, pixelFormat, dpiX, dpiY, colorContext )` builds the properties.
The examples below share these lines, which ask the render target for its device context and
make a 4 × 4 bitmap the CPU can read:

```freebasic
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pixels(15) as ulong
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_CPU_READ or D2D1_BITMAP_OPTIONS_CANNOT_DRAW, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) )
dim pBitmap1 as ID2D1Bitmap1 ptr
pDC->CreateBitmap( D2D1_SizeU( 4, 4 ), @pixels(0), 16, props, pBitmap1 )
```

### Constructor

```freebasic
constructor
constructor( byval pBitmap1 as ID2D1Bitmap1 ptr )
```

With a pointer the object holds the bitmap in `m_pBitmap1`, and the same object in the inherited
`m_pBitmap`, and takes over the reference that came with it. Without one it is empty; see
**Empty objects** above for why it should then not be filled through `m_pBitmap1` alone.

| Parameter | Meaning |
| --- | --- |
| `pBitmap1` | The bitmap from a device context. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pixels(15) as ulong
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_CPU_READ or D2D1_BITMAP_OPTIONS_CANNOT_DRAW, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) )
dim pBitmap1 as ID2D1Bitmap1 ptr
pDC->CreateBitmap( D2D1_SizeU( 4, 4 ), @pixels(0), 16, props, pBitmap1 )
dim bmp as CID2D1Bitmap1 = pBitmap1
dim px as D2D1_SIZE_U = bmp.GetPixelSize()                ' inherited
print px.width; " x "; px.height                          ' 4 x 4
pDC->Release()
```

Microsoft Learn: [ID2D1Bitmap1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1bitmap1)

### Destructor

```freebasic
destructor
```

Releases the bitmap; with the inherited destructor this gives back the one reference the object
took over.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pixels(15) as ulong
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_CPU_READ or D2D1_BITMAP_OPTIONS_CANNOT_DRAW, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) )
dim pBitmap1 as ID2D1Bitmap1 ptr
pDC->CreateBitmap( D2D1_SizeU( 4, 4 ), @pixels(0), 16, props, pBitmap1 )
scope
    dim bmp as CID2D1Bitmap1 = pBitmap1
end scope                                ' released here
pDC->Release()
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1Bitmap1 ptr
operator cast() as ID2D1Image ptr
operator @() as ID2D1Bitmap1 ptr ptr
operator *( byref bitmap1 as CID2D1Bitmap1 ) as ID2D1Bitmap1 ptr
```

As for [CID2D1Bitmap](#cast-operator--operator-), for the `ID2D1Bitmap1` pointer in
`m_pBitmap1`; the inherited `cast` to `ID2D1Bitmap ptr` still works, so the object can be passed
to `DrawBitmap`. `@` currently stops the build with an internal compiler error.

**Returns** the bitmap pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pixels(15) as ulong
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_CPU_READ or D2D1_BITMAP_OPTIONS_CANNOT_DRAW, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) )
dim pBitmap1 as ID2D1Bitmap1 ptr
pDC->CreateBitmap( D2D1_SizeU( 4, 4 ), @pixels(0), 16, props, pBitmap1 )
dim bmp as CID2D1Bitmap1 = pBitmap1
print ( *bmp )->GetOptions()             ' 6
pDC->Release()
```

### GetColorContext

```freebasic
function GetColorContext() as ID2D1ColorContext ptr
```

Returns the colour context the bitmap was made with, with a new reference: release it, or wrap
it in a [CID2D1ColorContext](#cid2d1colorcontext).

**Returns** the colour context, or `NULL` when the bitmap has none or the object is empty.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pixels(15) as ulong
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_CPU_READ or D2D1_BITMAP_OPTIONS_CANNOT_DRAW, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) )
dim pBitmap1 as ID2D1Bitmap1 ptr
pDC->CreateBitmap( D2D1_SizeU( 4, 4 ), @pixels(0), 16, props, pBitmap1 )
dim bmp as CID2D1Bitmap1 = pBitmap1
dim cc as CID2D1ColorContext = bmp.GetColorContext()
print ( *cc = NULL )                     ' -1: made without one
pDC->Release()
```

Microsoft Learn: [ID2D1Bitmap1::GetColorContext](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1bitmap1-getcolorcontext)

### GetOptions

```freebasic
function GetOptions() as D2D1_BITMAP_OPTIONS
```

Returns the `D2D1_BITMAP_OPTIONS_…` flags the bitmap was made with, combined with `or`.

**Returns** the flags, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pixels(15) as ulong
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_CPU_READ or D2D1_BITMAP_OPTIONS_CANNOT_DRAW, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) )
dim pBitmap1 as ID2D1Bitmap1 ptr
pDC->CreateBitmap( D2D1_SizeU( 4, 4 ), @pixels(0), 16, props, pBitmap1 )
dim bmp as CID2D1Bitmap1 = pBitmap1
if bmp.GetOptions() and D2D1_BITMAP_OPTIONS_CPU_READ then print "readable"   ' readable
pDC->Release()
```

Microsoft Learn: [ID2D1Bitmap1::GetOptions](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1bitmap1-getoptions)

### GetSurface

```freebasic
function GetSurface() as IDXGISurface ptr
```

Returns the DXGI surface that holds the bitmap's pixels, with a new reference: release it. A
bitmap of a render target that does not draw on a DXGI device has none: a bitmap made through a
DC render target returns `NULL`.

**Returns** the surface, or `NULL`.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pixels(15) as ulong
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_CPU_READ or D2D1_BITMAP_OPTIONS_CANNOT_DRAW, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) )
dim pBitmap1 as ID2D1Bitmap1 ptr
pDC->CreateBitmap( D2D1_SizeU( 4, 4 ), @pixels(0), 16, props, pBitmap1 )
dim bmp as CID2D1Bitmap1 = pBitmap1
dim pSurface as IDXGISurface ptr = bmp.GetSurface()
if pSurface then pSurface->Release() else print "no DXGI surface"   ' no DXGI surface
pDC->Release()
```

Microsoft Learn: [ID2D1Bitmap1::GetSurface](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1bitmap1-getsurface)

### Map

```freebasic
function Map( byval options as D2D1_MAP_OPTIONS ) as D2D1_MAPPED_RECT
```

Makes the bitmap's pixels readable by the CPU and returns where they are: `bits`, a pointer to
the first pixel, and `pitch`, the bytes from one row to the next. The bitmap must have been made
with `D2D1_BITMAP_OPTIONS_CPU_READ` and `CANNOT_DRAW`; pass `D2D1_MAP_OPTIONS_READ`. The
`HRESULT` is stored with `SetLastError`: read `GetLastError()` straight after the call. The
pointer is valid until [Unmap](#unmap), which must follow. On an empty object the result is
zeroed and the last error is left as it was.

| Parameter | Meaning |
| --- | --- |
| `options` | `D2D1_MAP_OPTIONS_READ`. |

**Returns** the mapped rectangle; zeroed on failure (`GetLastError()` is `E_INVALIDARG`,
&h80070057, for a bitmap without CPU access).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pixels(15) as ulong = { &hFF336699 }
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_CPU_READ or D2D1_BITMAP_OPTIONS_CANNOT_DRAW, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) )
dim pBitmap1 as ID2D1Bitmap1 ptr
pDC->CreateBitmap( D2D1_SizeU( 4, 4 ), @pixels(0), 16, props, pBitmap1 )
dim bmp as CID2D1Bitmap1 = pBitmap1
dim mr as D2D1_MAPPED_RECT = bmp.Map( D2D1_MAP_OPTIONS_READ )
if GetLastError() = S_OK then print mr.pitch; " "; hex( *cast( ulong ptr, mr.bits ) )   ' 16 FF336699
bmp.Unmap()
pDC->Release()
```

Microsoft Learn: [ID2D1Bitmap1::Map](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1bitmap1-map)

### Unmap

```freebasic
function Unmap() as HRESULT
```

Ends the CPU access [Map](#map) gave; the pointer it returned is no longer valid.

**Returns** `S_OK` (0) on success, `D2DERR_WRONG_STATE` (&h88990001) when the bitmap is not
mapped, and `S_OK` for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pixels(15) as ulong
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_CPU_READ or D2D1_BITMAP_OPTIONS_CANNOT_DRAW, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ) )
dim pBitmap1 as ID2D1Bitmap1 ptr
pDC->CreateBitmap( D2D1_SizeU( 4, 4 ), @pixels(0), 16, props, pBitmap1 )
dim bmp as CID2D1Bitmap1 = pBitmap1
bmp.Map( D2D1_MAP_OPTIONS_READ )
print bmp.Unmap(); " "; hex( bmp.Unmap() )                ' 0 88990001
pDC->Release()
```

Microsoft Learn: [ID2D1Bitmap1::Unmap](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1bitmap1-unmap)

## CID2D1ColorContext

Says which colour space a bitmap's pixels are in, so that Direct2D can convert between spaces,
for example with the colour-management effect. It is described by a `D2D1_COLOR_SPACE_…` value,
`SRGB` (1) or `SCRGB` (2, linear), or by an ICC profile (`CUSTOM`, 0). Make one with
`CreateColorContext`, `CreateColorContextFromFilename` or `CreateColorContextFromWicColorContext`
of a device context, and give it to a bitmap through `D2D1_BitmapProperties1`. The examples
below ask the render target for its device context, as for [CID2D1Bitmap1](#cid2d1bitmap1), and
make an sRGB context:

```freebasic
dim pColorContext as ID2D1ColorContext ptr
pDC->CreateColorContext( D2D1_COLOR_SPACE_SRGB, NULL, 0, pColorContext )
```

### Constructor

```freebasic
constructor
constructor( byval pColorContext as ID2D1ColorContext ptr )
```

With a pointer the object holds that colour context and takes over the reference that came with
it. Without one it is empty until a pointer is stored in its public field `m_pColorContext`.

| Parameter | Meaning |
| --- | --- |
| `pColorContext` | The colour context, normally straight from a `CreateColorContext…` call. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pColorContext as ID2D1ColorContext ptr
pDC->CreateColorContext( D2D1_COLOR_SPACE_SRGB, NULL, 0, pColorContext )
dim cc as CID2D1ColorContext = pColorContext
pDC->Release()
```

Microsoft Learn: [ID2D1ColorContext](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1colorcontext)

### Destructor

```freebasic
destructor
```

Releases the colour context, if the object holds one. Bitmaps made with it keep their own
reference.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pColorContext as ID2D1ColorContext ptr
pDC->CreateColorContext( D2D1_COLOR_SPACE_SRGB, NULL, 0, pColorContext )
scope
    dim cc as CID2D1ColorContext = pColorContext
end scope                                ' released here
pDC->Release()
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1ColorContext ptr
operator @() as ID2D1ColorContext ptr ptr
operator *( byref colorContext as CID2D1ColorContext ) as ID2D1ColorContext ptr
```

`cast` gives the colour-context pointer, so the object can be passed wherever an
`ID2D1ColorContext ptr` is expected, such as `D2D1_BitmapProperties1`; `*cc` gives the same
pointer for calling an interface method directly. Neither adds a reference. `@` returns the
address of `m_pColorContext`; applying it currently stops the build with an internal compiler
error, so pass the field itself.

**Returns** the pointer (`NULL` for an empty object), or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim cc as CID2D1ColorContext
pDC->CreateColorContext( D2D1_COLOR_SPACE_SRGB, NULL, 0, cc.m_pColorContext )
dim props as D2D1_BITMAP_PROPERTIES1 = D2D1_BitmapProperties1( D2D1_BITMAP_OPTIONS_NONE, D2D1_PixelFormat( DXGI_FORMAT_B8G8R8A8_UNORM, D2D1_ALPHA_MODE_PREMULTIPLIED ), 96, 96, cc )
print ( *cc )->GetColorSpace()           ' 1
pDC->Release()
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Returns the factory that made the colour context's render target, with a new reference: release
it. The object must hold a colour context: on an empty object this member is not guarded.

**Returns** the factory.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pColorContext as ID2D1ColorContext ptr
pDC->CreateColorContext( D2D1_COLOR_SPACE_SRGB, NULL, 0, pColorContext )
dim cc as CID2D1ColorContext = pColorContext
dim pFactory as ID2D1Factory ptr = cc.GetFactory()
print ( pFactory = *factory )            ' -1 (true)
pFactory->Release()
pDC->Release()
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### GetColorSpace

```freebasic
function GetColorSpace() as D2D1_COLOR_SPACE
```

Tells which colour space the context describes: `D2D1_COLOR_SPACE_SRGB` (1),
`D2D1_COLOR_SPACE_SCRGB` (2) or `D2D1_COLOR_SPACE_CUSTOM` (0) for one given by an ICC profile.

**Returns** the colour space, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pColorContext as ID2D1ColorContext ptr
pDC->CreateColorContext( D2D1_COLOR_SPACE_SRGB, NULL, 0, pColorContext )
dim cc as CID2D1ColorContext = pColorContext
print cc.GetColorSpace()                 ' 1
pDC->Release()
```

Microsoft Learn: [ID2D1ColorContext::GetColorSpace](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1colorcontext-getcolorspace)

### GetProfileSize

```freebasic
function GetProfileSize() as UINT32
```

Returns the size in bytes of the ICC profile behind the context, the buffer size
[GetProfile](#getprofile) needs. A context made for `D2D1_COLOR_SPACE_SRGB` has a profile
too: 3144 bytes on the machine these pages were tested on.

**Returns** the size, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pColorContext as ID2D1ColorContext ptr
pDC->CreateColorContext( D2D1_COLOR_SPACE_SRGB, NULL, 0, pColorContext )
dim cc as CID2D1ColorContext = pColorContext
print cc.GetProfileSize(); " bytes"
pDC->Release()
```

Microsoft Learn: [ID2D1ColorContext::GetProfileSize](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1colorcontext-getprofilesize)

### GetProfile

```freebasic
function GetProfile( byval profile as byte ptr, byval profileSize as UINT32 ) as HRESULT
```

Copies the ICC profile behind the context into the buffer at `profile`. Ask
[GetProfileSize](#getprofilesize) for the size first. An ICC profile carries the signature
`acsp` at byte offset 36.

| Parameter | Meaning |
| --- | --- |
| `profile` | The buffer that receives the profile. |
| `profileSize` | The size of the buffer, in bytes. |

**Returns** `S_OK` (0) on success; `&h8007007A` (the buffer is too small) when `profileSize` is
less than the profile; `S_OK` for an empty object, which copies nothing.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC as ID2D1DeviceContext ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext, @pDC )
dim pColorContext as ID2D1ColorContext ptr
pDC->CreateColorContext( D2D1_COLOR_SPACE_SRGB, NULL, 0, pColorContext )
dim cc as CID2D1ColorContext = pColorContext
dim n as UINT32 = cc.GetProfileSize()
dim buffer(n - 1) as ubyte
if cc.GetProfile( @buffer(0), n ) = S_OK then print chr( buffer(36), buffer(37), buffer(38), buffer(39) )   ' acsp
pDC->Release()
```

Microsoft Learn: [ID2D1ColorContext::GetProfile](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-id2d1colorcontext-getprofile)

## CID2D1ColorContext1

A colour context that can also be described by a **simple colour profile** (the red, green and
blue primaries, the white point and a gamma) or by a **DXGI colour space**, as used for HDR
output. It extends [CID2D1ColorContext](#cid2d1colorcontext), whose members (other than
`GetFactory`, see below) work on it. Make one with `CreateColorContextFromSimpleColorProfile` or
`CreateColorContextFromDxgiColorSpace` of `ID2D1DeviceContext5`, which a device context of
Windows 10 and later provides. The examples below share these lines:

```freebasic
dim pDC5 as ID2D1DeviceContext5 ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext5, @pDC5 )
dim pColorContext1 as ID2D1ColorContext1 ptr
pDC5->CreateColorContextFromDxgiColorSpace( DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709, pColorContext1 )
```

### Constructor

```freebasic
constructor
constructor( byval pColorContext1 as ID2D1ColorContext1 ptr )
```

With a pointer the object holds the colour context in `m_pColorContext1`, and the same object in
the inherited `m_pColorContext`, and takes over the reference that came with it. Without one it
is empty.

| Parameter | Meaning |
| --- | --- |
| `pColorContext1` | The colour context from `ID2D1DeviceContext5`. |

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC5 as ID2D1DeviceContext5 ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext5, @pDC5 )
dim pColorContext1 as ID2D1ColorContext1 ptr
pDC5->CreateColorContextFromDxgiColorSpace( DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709, pColorContext1 )
dim cc as CID2D1ColorContext1 = pColorContext1
print cc.GetColorSpace()                 ' 1 (inherited)
pDC5->Release()
```

Microsoft Learn: [ID2D1ColorContext1](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1colorcontext1)

### Destructor

```freebasic
destructor
```

Releases the colour context; with the inherited destructor this gives back the one reference the
object took over.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC5 as ID2D1DeviceContext5 ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext5, @pDC5 )
dim pColorContext1 as ID2D1ColorContext1 ptr
pDC5->CreateColorContextFromDxgiColorSpace( DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709, pColorContext1 )
scope
    dim cc as CID2D1ColorContext1 = pColorContext1
end scope                                ' released here
pDC5->Release()
```

### Cast, Operator @, Operator *

```freebasic
operator cast() as ID2D1ColorContext1 ptr
operator @() as ID2D1ColorContext1 ptr ptr
operator *( byref colorContext as CID2D1ColorContext1 ) as ID2D1ColorContext1 ptr
```

As for [CID2D1ColorContext](#cast-operator--operator--2), for the `ID2D1ColorContext1` pointer
in `m_pColorContext1`; the inherited `cast` to `ID2D1ColorContext ptr` still works. `@`
currently stops the build with an internal compiler error.

**Returns** the pointer, or its address.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC5 as ID2D1DeviceContext5 ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext5, @pDC5 )
dim pColorContext1 as ID2D1ColorContext1 ptr
pDC5->CreateColorContextFromDxgiColorSpace( DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709, pColorContext1 )
dim cc as CID2D1ColorContext1 = pColorContext1
print ( *cc )->GetColorContextType()     ' 2
pDC5->Release()
```

### GetFactory

```freebasic
function GetFactory() as ID2D1Factory ptr
```

Declared in the class but given no body, so a program that calls `GetFactory` on a
`CID2D1ColorContext1` builds but does not link (an undefined symbol). Call the interface method
instead, which returns the factory with a new reference.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC5 as ID2D1DeviceContext5 ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext5, @pDC5 )
dim pColorContext1 as ID2D1ColorContext1 ptr
pDC5->CreateColorContextFromDxgiColorSpace( DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709, pColorContext1 )
dim cc as CID2D1ColorContext1 = pColorContext1
dim pFactory as ID2D1Factory ptr
( *cc )->GetFactory( pFactory )          ' instead of cc.GetFactory()
print ( pFactory = *factory )            ' -1 (true)
pFactory->Release()
pDC5->Release()
```

Microsoft Learn: [ID2D1Resource::GetFactory](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-id2d1resource-getfactory)

### GetColorContextType

```freebasic
function GetColorContextType() as D2D1_COLOR_CONTEXT_TYPE
```

Tells how the colour context is described: `D2D1_COLOR_CONTEXT_TYPE_ICC` (0), by an ICC
profile; `D2D1_COLOR_CONTEXT_TYPE_SIMPLE` (1), by a simple colour profile; or
`D2D1_COLOR_CONTEXT_TYPE_DXGI` (2), by a DXGI colour space.

**Returns** the type, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC5 as ID2D1DeviceContext5 ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext5, @pDC5 )
dim pColorContext1 as ID2D1ColorContext1 ptr
pDC5->CreateColorContextFromDxgiColorSpace( DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709, pColorContext1 )
dim cc as CID2D1ColorContext1 = pColorContext1
print cc.GetColorContextType()           ' 2
pDC5->Release()
```

Microsoft Learn: [ID2D1ColorContext1::GetColorContextType](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-id2d1colorcontext1-getcolorcontexttype)

### GetDXGIColorSpace

```freebasic
function GetDXGIColorSpace() as DXGI_COLOR_SPACE_TYPE
```

Returns the DXGI colour space of the context, a `DXGI_COLOR_SPACE_…` value such as
`DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709` (0, sRGB). For a context described another way it is
`DXGI_COLOR_SPACE_CUSTOM` (&hFFFFFFFF, which prints as -1).

**Returns** the colour space, or 0 for an empty object.

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC5 as ID2D1DeviceContext5 ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext5, @pDC5 )
dim pColorContext1 as ID2D1ColorContext1 ptr
pDC5->CreateColorContextFromDxgiColorSpace( DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709, pColorContext1 )
dim cc as CID2D1ColorContext1 = pColorContext1
print cc.GetDXGIColorSpace()             ' 0
pDC5->Release()
```

Microsoft Learn: [ID2D1ColorContext1::GetDXGIColorSpace](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-id2d1colorcontext1-getdxgicolorspace)

### GetSimpleColorProfile

```freebasic
function GetSimpleColorProfile() as D2D1_SIMPLE_COLOR_PROFILE
```

Returns the simple colour profile of a context made from one: `redPrimary`, `greenPrimary` and
`bluePrimary` (chromaticity x and y), `whitePointXZ` and `gamma`. The `HRESULT` is stored with
`SetLastError`; for a context described another way the call fails with `E_INVALIDARG`
(&h80070057) and the result is zeroed.

**Returns** the profile; zeroed on failure or for an empty object (which leaves the last error
as it was).

**Example**

```freebasic
dim factory as CD2D1Factory = D2D1_FACTORY_TYPE_SINGLE_THREADED
dim rt as CID2D1DCRenderTarget = factory.CreateDCRenderTarget()
dim pDC5 as ID2D1DeviceContext5 ptr
(*rt)->QueryInterface( @IID_ID2D1DeviceContext5, @pDC5 )
dim sp as D2D1_SIMPLE_COLOR_PROFILE = ( ( 0.64, 0.33 ), ( 0.30, 0.60 ), ( 0.15, 0.06 ), ( 0.9505, 1.089 ), D2D1_GAMMA1_G22 )
dim pColorContext1 as ID2D1ColorContext1 ptr
pDC5->CreateColorContextFromSimpleColorProfile( sp, pColorContext1 )
dim cc as CID2D1ColorContext1 = pColorContext1
dim got as D2D1_SIMPLE_COLOR_PROFILE = cc.GetSimpleColorProfile()
if GetLastError() = S_OK then print got.redPrimary.x; got.redPrimary.y   ' 0.64 0.33
pDC5->Release()
```

Microsoft Learn: [ID2D1ColorContext1::GetSimpleColorProfile](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-id2d1colorcontext1-getsimplecolorprofile)

## See also

- [sys/win/direct2d](SysWin-Direct2D)
- [CID2D1RenderTarget](CID2D1RenderTarget) for `CreateBitmap`, `CreateBitmapFromWicBitmap` and `DrawBitmap`
- [Direct2D brushes](SysWin-Direct2D-Brushes) for painting with a bitmap or an image
- [Direct2D helpers](SysWin-Direct2D-Helpers) for `D2D1_BitmapProperties`, `D2D1_BitmapProperties1`, `D2D1_PixelFormat` and `D2D1_SizeU`
- [WIC interfaces](SysWin-WIC-Interfaces) for decoding image files into a bitmap source
- [Direct2D interfaces](SysWin-Direct2D-Interfaces) for `ID2D1DeviceContext` and the other raw interfaces
- [Bitmaps](SysWin-Bitmaps) for GDI bitmaps and DIB sections
