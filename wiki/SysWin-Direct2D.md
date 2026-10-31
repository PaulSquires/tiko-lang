[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **sys/win/direct2d**

# sys/win/direct2d

Draws hardware-accelerated 2D graphics with Direct2D, DirectWrite text and WIC images.

`sys/win/direct2d` brings Direct2D to tiko in three layers:

- **The Windows declarations**: every Direct2D interface from version 1.0 to the latest
  factory, the built-in effects, SVG, and the DirectWrite, DXGI and WIC interfaces Direct2D
  works with, plus the functions those libraries export (`D2D1CreateFactory`,
  `DWriteCreateFactory` …).
- **Helper functions** that fill the small structures every call takes: points, rectangles,
  colours, matrices and property records (`D2D1_ColorF`, `D2D1_RectF`, `D2D1_MatrixRotation` …).
- **Wrapper classes**, `CD2D1Factory`, `CID2D1RenderTarget`, the geometry, brush and bitmap
  classes, that hold an interface, release it when they go out of scope and turn the
  out-parameter methods into functions that return the new object.

**The model.** Everything starts from a **factory**. The factory makes the device-independent
resources, geometries and stroke styles, which last as long as you keep them, and the **render
target** that draws into a window, a GDI device context or a bitmap. The render target makes the
device-dependent resources, brushes, bitmaps and layers, which belong to it. Drawing happens
between `BeginDraw` and `EndDraw`; when `EndDraw` returns `D2DERR_RECREATE_TARGET` the display
device was lost, and the render target and everything it made must be released and made again.

Every interface is reference-counted: release each one you are given, the render target's
resources before the render target and the render target before the factory. The wrapper
classes do this for you; with raw interface pointers call `->Release()` or
[D2D1_SafeRelease](SysWin-Direct2D-Helpers#d2d1_saferelease).

Coordinates are **device-independent pixels** (DIPs, 1/96 inch). A render target made with the
default properties in a DPI-aware program takes the desktop DPI, so drawing in DIPs comes out
the same physical size on every display.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

A program with a window also imports `sys/win/gui` for `CWindow`. `sys/win/direct2d` imports
`sys/win/com` itself.

## Example

A window that draws a rotated rounded rectangle and a circle with Direct2D, keeps them sized to
the window and recreates its render target if the display device is lost:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/direct2d"
using win, gui, direct2d

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

dim shared pFactory as ID2D1Factory ptr
dim shared pTarget as ID2D1HwndRenderTarget ptr
dim shared pBrush as ID2D1SolidColorBrush ptr

sub RenderScene( byval hwnd as HWND )
    if pTarget = NULL then
        ' device-dependent resources: made on first paint and again after D2DERR_RECREATE_TARGET
        var (l, t, r, b) = GetWindowClientRect( hwnd )
        pFactory->CreateHwndRenderTarget( D2D1_RenderTargetProperties(), _
            D2D1_HwndRenderTargetProperties( hwnd, D2D1_SizeU( r, b ) ), pTarget )
        if pTarget = NULL then exit sub
        pTarget->CreateSolidColorBrush( D2D1_ColorF( D2D1_SteelBlue ), D2D1_BrushProperties(), pBrush )
    end if
    dim sz as D2D1_SIZE_F
    pTarget->GetSize( sz )
    pTarget->BeginDraw()
    pTarget->Clear( D2D1_ColorF( D2D1_White ) )
    pTarget->SetTransform( D2D1_MatrixRotation( 15, D2D1_Point2F( sz.width / 2, sz.height / 2 ) ) )
    pTarget->FillRoundedRectangle( D2D1_RoundedRect( 40, 40, sz.width - 40, sz.height - 40, 12, 12 ), pBrush )
    pTarget->SetTransform( D2D1_IdentityMatrix() )
    pTarget->DrawEllipse( D2D1_EllipseF( sz.width / 2, sz.height / 2, 60, 60 ), pBrush, 4 )
    if pTarget->EndDraw() = D2DERR_RECREATE_TARGET then
        D2D1_SafeRelease( pBrush )
        D2D1_SafeRelease( pTarget )
    end if
end sub

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    if D2D1CreateFactory( D2D1_FACTORY_TYPE_SINGLE_THREADED, IID_ID2D1Factory, byval NULL, pFactory ) <> S_OK then return 1
    dim pWindow as CWindow = "Direct2DDemo"
    dim hWin as HWND = pWindow.Create( NULL, "sys/win/direct2d", @WndProc )
    SetWindowClientSizeForDpi( hWin, 400, 300 )
    CenterWindow( hWin )
    function = pWindow.DoEvents( SW_NORMAL )
    D2D1_SafeRelease( pBrush )
    D2D1_SafeRelease( pTarget )
    D2D1_SafeRelease( pFactory )
end function

function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT
    select case uMsg
        case WM_PAINT
            dim ps as PAINTSTRUCT
            BeginPaint( hwnd, @ps )
            RenderScene( hwnd )
            EndPaint( hwnd, @ps )
            return 0
        case WM_SIZE
            if pTarget then pTarget->Resize( D2D1_SizeU( LOWORD( lParam ), HIWORD( lParam ) ) )
            return 0
        case WM_ERASEBKGND
            return 1
        case WM_DESTROY
            PostQuitMessage( 0 )
            return 0
    end select
    return DefWindowProcW( hwnd, uMsg, wParam, lParam )
end function

end main()
```

`WM_ERASEBKGND` returns 1 so that Windows does not paint the background before Direct2D does,
which would flicker. The toolchain's `examples/win64/D2D1 Examples` folder has dozens more
programs, from lines and ellipses to gradient brushes and path geometries.

## Pages

| Page | Covers |
| --- | --- |
| [CD2D1Factory](CD2D1Factory) | The factory classes `CD2D1Factory` to `CD2D1Factory8`: render targets, geometries, stroke styles and drawing state blocks. |
| [Direct2D stroke styles and multithreading](SysWin-Direct2D-Stroke-Styles) | `CID2D1StrokeStyle`, `CID2D1StrokeStyle1` and `CID2D1Multithread`: caps, joins and dashes, and locking a multithreaded factory. |
| [CID2D1RenderTarget](CID2D1RenderTarget) | The base render target class: drawing shapes, bitmaps and text, transforms, clips and layers, and making brushes and bitmaps. |
| [Direct2D render targets](SysWin-Direct2D-Render-Targets) | Window, device-context and bitmap render targets, GDI interop, and drawing state blocks. |
| [CID2D1Geometry](CID2D1Geometry) | The base geometry class: bounds, hit tests, combining, widening, area and length. |
| [Direct2D geometries](SysWin-Direct2D-Geometries) | Rectangle, rounded-rectangle, ellipse, group, transformed and path geometries, and the geometry sinks that build paths. |
| [Direct2D brushes](SysWin-Direct2D-Brushes) | Solid-colour, linear and radial gradient, bitmap and image brushes, and gradient stop collections. |
| [Direct2D bitmaps and colour contexts](SysWin-Direct2D-Bitmaps) | `CID2D1Bitmap`, `CID2D1Bitmap1` and the colour context classes. |
| [Direct2D helpers](SysWin-Direct2D-Helpers) | The functions that build points, rectangles, colours, matrices and property structures, and the named colours. |
| [Direct2D interfaces and types](SysWin-Direct2D-Interfaces) | Every Direct2D interface, structure and enumeration declared, the effect property indices, and the `d2d1.dll` functions. |
| [DirectWrite interfaces](SysWin-DirectWrite-Interfaces) | The DirectWrite declarations: factories, text formats and layouts, fonts and font collections, text analysis and rendering. |
| [DXGI interfaces](SysWin-DXGI-Interfaces) | The DXGI declarations: factories, adapters, outputs, devices, surfaces and swap chains. |
| [WIC interfaces](SysWin-WIC-Interfaces) | The Windows Imaging Component declarations: decoders, encoders, frames, bitmaps, format converters and metadata. |

## See also

- [Category: sys/win](Category-Sys-Win)
- [sys/win/gdiplus](SysWin-GdiPlus), the older GDI+ drawing classes
- [CGraphCtx](CGraphCtx), a control whose memory device context a DC render target can draw into
