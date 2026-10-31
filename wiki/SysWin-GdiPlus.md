[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **sys/win/gdiplus**

# sys/win/gdiplus

Draws shapes, gradients, text and images with GDI+, and loads and saves image files.

GDI+ is the Windows graphics library that sits between GDI and Direct2D: it draws with
antialiasing and transparency, fills with gradients and textures, transforms coordinates, renders
text with any installed font and reads and writes BMP, PNG, JPEG, GIF and TIFF files. It runs
on the processor and draws onto a window, a device context, a printer or an image in memory.
This module wraps it in classes whose names start with `CGp`, and adds procedures that turn image
files into icons and bitmaps for the rest of a Windows program.

The model:

- **A drawing surface and the tools you pass to it.** A [CGpGraphics](CGpGraphics) draws; pens,
  brushes, fonts, string formats, paths, regions, matrices and images are separate objects that
  you create once and pass **by address** (`@pen`) to its methods.
- **Each object owns one GDI+ object** and deletes it in its destructor. Never copy one by value
  (no `=` from another object, no `byval` parameter): both copies would delete the same GDI+
  object. Copy with the pointer constructor (`dim b as CGpPen = @a`) or `Clone`.
- **GDI+ starts and stops by itself.** The first `CGp*` object created starts GDI+ and the last
  one destroyed shuts it down. To keep it running for the whole program, call `gdiplus.Init()`
  at start-up and `gdiplus.Uninit( token )` at the end, after every object is gone, as the
  example does; see [GDI+ procedures and types](SysWin-GdiPlus-Procedures).
- **Colours are `ARGB`**: `&hAARRGGBB`, alpha first, which is not the byte order of a GDI
  `COLORREF`. Use the `ARGB_*` constants of [Colours](SysWin-Colors) or `GDIP_ARGB( a, r, g, b )`.
- **Status.** The methods return a `GpStatus`, `Ok` (0) on success, and store it; every object's
  `GetLastStatus()` returns the last one, including the outcome of its constructor.

The whole GDI+ flat API (`GdipCreateFromHDC`, `GdipDrawLine` …) is declared as well, and every
object keeps its GDI+ handle in a public field (`m_pGraphics`, `m_pImage`, `m_pPen` …), so the
classes and the flat functions can be mixed.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus
```

The `ARGB_*` colour constants come with the module. A program that creates windows imports
`sys/win/gui` too.

## Example

A window painted with a vertical gradient, a dashed, antialiased ellipse and a caption centred
in it, all sized for the display's DPI:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/gdiplus"
using win, gui, gdiplus

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim token as ULONG_PTR = gdiplus.Init()
    dim pWindow as CWindow = "GdiPlusDemo"
    pWindow.Create( NULL, "sys/win/gdiplus", @WndProc )
    pWindow.SetClientSize( 400, 220 )
    pWindow.Center
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
                dim g as CGpGraphics = hdc
                g.ScaleTransformForDpi()
                g.SetSmoothingMode( SmoothingModeAntiAlias )
                g.SetTextRenderingHint( TextRenderingHintAntiAlias )

                ' background: a gradient from white to light blue
                dim rcAll as GpRectF = GDIP_RECTF( 0, 0, 400, 220 )
                dim sky as CGpLinearGradientBrush = CGpLinearGradientBrush( @rcAll, ARGB_White, ARGB_LightSkyBlue, LinearGradientModeVertical )
                g.FillRectangle( @sky, @rcAll )

                ' a translucent ellipse with a dashed outline
                dim rcEllipse as GpRectF = GDIP_RECTF( 50, 30, 300, 160 )
                dim glass as CGpSolidBrush = CGpSolidBrush( GDIP_ARGB_SetAlpha( ARGB_White, 120 ) )
                g.FillEllipse( @glass, @rcEllipse )
                dim outline as CGpPen = CGpPen( ARGB_SteelBlue, 3 )
                outline.SetDashStyle( DashStyleDash )
                g.DrawEllipse( @outline, @rcEllipse )

                ' a caption centred in the ellipse
                dim fnt as CGpFont = CGpFont( "Segoe UI", 22, FontStyleBold )
                dim ink as CGpSolidBrush = CGpSolidBrush( ARGB_MidnightBlue )
                dim centred as CGpStringFormat
                centred.SetAlignment( StringAlignmentCenter )
                centred.SetLineAlignment( StringAlignmentCenter )
                g.DrawString( "Hello, GDI+", -1, @fnt, @rcEllipse, @centred, @ink )
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

The `scope` block destroys the graphics object and the tools before `EndPaint` releases the
device context. More programs, one per class, are in the toolchain's
`examples/win64/GdiPlus Examples/` folder.

## Pages

| Page | Covers |
| --- | --- |
| [CGpGraphics](CGpGraphics) | The drawing surface: lines, curves, shapes, text and images on a window, a DC or an image; transformations, clipping, quality settings, containers. |
| [Graphics paths](CGpGraphicsPath) | `CGpGraphicsPath`, shapes built from lines, curves, figures and text, and `CGpGraphicsPathIterator`, which walks their points. |
| [CGpRegion](CGpRegion) | Areas made from rectangles and paths and combined, for filling, clipping and hit-testing. |
| [CGpMatrix](CGpMatrix) | The affine matrix that moves, scales, rotates and shears points, used by graphics objects, pens, brushes and paths. |
| [GDI+ images](SysWin-GdiPlus-Images) | `CGpImage`, `CGpBitmap`, `CGpMetafile` and `CGpCachedBitmap`: loading, creating, editing pixels, frames, metadata, thumbnails and saving. |
| [CGpImageAttributes](CGpImageAttributes) | How an image's colours are changed as it is drawn: colour matrices, gamma, thresholds, colour keys and remap tables. |
| [GDI+ effects](SysWin-GdiPlus-Effects) | `CGpEffect` and the effect classes (blur, sharpen, brightness and contrast, hue, levels, tint, colour balance, curves, lookup tables, red-eye) applied to bitmaps. |
| [CGpPen](CGpPen) | Pens: colour or brush, width, alignment, dash patterns, joins, caps and transformations. |
| [GDI+ brushes](SysWin-GdiPlus-Brushes) | `CGpBrush` and its kinds: solid, hatch, texture, linear gradient and path gradient. |
| [GDI+ line caps](SysWin-GdiPlus-Line-Caps) | `CGpCustomLineCap` and `CGpAdjustableArrowCap`: arrow heads and shapes of your own at the ends of lines. |
| [GDI+ fonts](SysWin-GdiPlus-Fonts) | `CGpFont`, `CGpFontFamily` and the installed and private font collections. |
| [CGpStringFormat](CGpStringFormat) | Text layout: alignment, wrapping, trimming, tab stops, hot-key prefixes and measurable ranges. |
| [GDI+ procedures and types](SysWin-GdiPlus-Procedures) | Starting GDI+, colour and rectangle helpers, image files to icons and bitmaps, saving and printing, OpenGL textures; `CGpBase`; the structures, enumerations, status codes, pixel formats and GUIDs. |

## See also

- [Category: sys/win](Category-Sys-Win)
- [Colours](SysWin-Colors) for the `ARGB_*` constants
- [sys/win/direct2d](SysWin-Direct2D), hardware-accelerated drawing
- [Bitmaps](SysWin-Bitmaps) for GDI bitmaps and DIB sections
