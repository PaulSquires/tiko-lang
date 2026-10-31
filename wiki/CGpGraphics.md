[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gdiplus](SysWin-GdiPlus) › **CGpGraphics**

# CGpGraphics

Draws lines, shapes, text and images with GDI+ on a window, a device context or an image.

A `CGpGraphics` is the GDI+ drawing surface: it wraps one GDI+ `Graphics` object, which it
creates from a device context, a window or an image and deletes in its destructor. Pens
([CGpPen](CGpPen)), brushes ([brushes](SysWin-GdiPlus-Brushes)), fonts
([fonts](SysWin-GdiPlus-Fonts)), paths, regions, matrices and images are separate objects that
you pass by address (`@pen`) to the drawing methods.

**Starting GDI+.** GDI+ must be started before any of its objects is created and shut down after
the last one is gone. Every `CGp*` class does this by itself: its base class keeps a count of
live objects, starts GDI+ when the first one is created and shuts it down when the count drops
back to 0. A program that creates and destroys its objects in each `WM_PAINT` therefore starts
and stops GDI+ on every paint. To keep it running for the whole program, call `gdiplus.Init()`
once at start-up and pass the token it returns to `gdiplus.Uninit()` after the last GDI+ object
has been destroyed, as the example below does; see [GDI+ procedures](SysWin-GdiPlus-Procedures).

**Lifetime.** A `CGpGraphics` made from a device context must be destroyed before that DC is
released (before `EndPaint` or `ReleaseDC`): put it in a `scope` block, as the example does.
Never copy one (no `=` from another `CGpGraphics`, no `byval` parameter): the copy would delete
the same GDI+ object a second time. Pass its address instead.

**Coordinates.** Drawing coordinates are *world* coordinates. The world transformation
([TranslateTransform](#translatetransform), [RotateTransform](#rotatetransform) …) maps them
to page coordinates and the page transformation ([page unit and scale](#getpageunit-setpageunit))
maps those to device pixels. Overloads take `single` values or `GpPointF` / `GpRectF`
(fractional) as well as `GpPoint` / `GpRect` (whole pixels). Angles are in degrees, measured
clockwise from the x-axis, because y grows downwards.

**Status.** The methods that do something return a `GpStatus`: `Ok` (also `StatusOk`, 0) on
success, otherwise the reason, such as `InvalidParameter` (2). The status is also stored, and
the getters that return a value store theirs too, so `GetLastStatus()` (inherited by every
`CGp*` class) reports the outcome of the last call. A `CGpGraphics` made with the default
constructor holds no GDI+ object until one of the `From…` methods attaches one; until then every
call returns `InvalidParameter`.

In the signatures `CGpGraphicsPath_` is another name for [CGpGraphicsPath](CGpGraphicsPath).
Pointer parameters to pens, brushes, fonts, string formats, paths, regions and images are read
without a check for `NULL`, unless an entry says otherwise.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus
```

## Example

A window that paints an outlined ellipse and a line of text with antialiasing, sized for the
display's DPI. GDI+ is kept running from start-up to exit with `Init` and `Uninit`:

```freebasic
#import "sys/win"
#import "sys/win/gui"
#import "sys/win/gdiplus"
using win, gui, gdiplus

declare function WndProc( byval hwnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM ) as LRESULT

function main() as long
    SetProcessDpiAwareness( PROCESS_SYSTEM_DPI_AWARE )
    dim token as ULONG_PTR = gdiplus.Init()
    dim pWindow as CWindow = "GpGraphicsDemo"
    pWindow.Create( NULL, "CGpGraphics", @WndProc )
    pWindow.SetClientSize( 400, 160 )
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
                g.Clear( ARGB_White )
                dim fill as CGpSolidBrush = CGpSolidBrush( ARGB_SkyBlue )
                g.FillEllipse( @fill, 20, 20, 160, 110 )
                dim pen as CGpPen = CGpPen( ARGB_Navy, 3 )
                g.DrawEllipse( @pen, 20, 20, 160, 110 )
                dim fnt as CGpFont = CGpFont( "Segoe UI", 14 )
                dim ink as CGpSolidBrush = CGpSolidBrush( ARGB_Black )
                g.DrawString( "Hello, GDI+", -1, @fnt, 205.0!, 60.0!, @ink )
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

`ScaleTransformForDpi` makes the 96-DPI coordinates come out the same physical size on any
display; the `scope` block destroys `g` and the other objects before `EndPaint` releases the DC.

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates a drawing surface for a DC, a window or an image. |
| [Destructor](#destructor) | Deletes the GDI+ object. |
| [FromHDC](#fromhdc) | Attaches a drawing surface for a device context. |
| [FromHWND](#fromhwnd) | Attaches a drawing surface for a window. |
| [FromImage](#fromimage) | Attaches a drawing surface for an image. |
| [Flush](#flush) | Sends pending drawing operations to the device. |
| [GetHDC, ReleaseHDC](#gethdc-releasehdc) | Borrows the device context for GDI calls and gives it back. |
| [GetRenderingOrigin, SetRenderingOrigin](#getrenderingorigin-setrenderingorigin) | Reads or sets the origin of hatch brushes and dithering. |
| [GetCompositingMode, SetCompositingMode](#getcompositingmode-setcompositingmode) | Reads or sets whether drawing blends with or replaces the background. |
| [GetCompositingQuality, SetCompositingQuality](#getcompositingquality-setcompositingquality) | Reads or sets the quality of blending. |
| [GetTextRenderingHint, SetTextRenderingHint](#gettextrenderinghint-settextrenderinghint) | Reads or sets how text is antialiased. |
| [GetTextContrast, SetTextContrast](#gettextcontrast-settextcontrast) | Reads or sets the gamma used for antialiased text. |
| [GetInterpolationMode, SetInterpolationMode](#getinterpolationmode-setinterpolationmode) | Reads or sets how images are resampled when scaled or rotated. |
| [GetSmoothingMode, SetSmoothingMode](#getsmoothingmode-setsmoothingmode) | Reads or sets antialiasing of lines and shapes. |
| [GetPixelOffsetMode, SetPixelOffsetMode](#getpixeloffsetmode-setpixeloffsetmode) | Reads or sets the half-pixel offset used when rendering. |
| [GetTransform, SetTransform](#gettransform-settransform) | Reads or replaces the world transformation. |
| [ResetTransform](#resettransform) | Clears the world transformation. |
| [MultiplyTransform](#multiplytransform) | Combines the world transformation with a matrix. |
| [TranslateTransform](#translatetransform) | Moves the coordinate system. |
| [ScaleTransform](#scaletransform) | Scales the coordinate system. |
| [ScaleTransformForDpi](#scaletransformfordpi) | Scales the coordinate system so 96-DPI units fit the device. |
| [RotateTransform](#rotatetransform) | Rotates the coordinate system. |
| [GetPageUnit, SetPageUnit](#getpageunit-setpageunit) | Reads or sets the unit of page coordinates. |
| [GetPageScale, SetPageScale](#getpagescale-setpagescale) | Reads or sets the scale of the page transformation. |
| [GetDpiX, GetDpiY](#getdpix-getdpiy) | Return the resolution of the device. |
| [TransformPoints](#transformpoints) | Converts points between world, page and device coordinates. |
| [GetNearestColor](#getnearestcolor) | Replaces a colour by the nearest one the device can show. |
| [DrawLine](#drawline) | Draws a line between two points. |
| [DrawLines](#drawlines) | Draws connected lines through a list of points. |
| [DrawArc](#drawarc) | Draws an arc of an ellipse. |
| [DrawBezier](#drawbezier) | Draws a Bézier spline. |
| [DrawBeziers](#drawbeziers) | Draws connected Bézier splines. |
| [DrawRectangle](#drawrectangle) | Draws the outline of a rectangle. |
| [DrawRectangles](#drawrectangles) | Draws the outlines of several rectangles. |
| [DrawEllipse](#drawellipse) | Draws the outline of an ellipse. |
| [DrawPie](#drawpie) | Draws the outline of a pie slice. |
| [DrawPolygon](#drawpolygon) | Draws the outline of a polygon. |
| [DrawPath](#drawpath) | Draws the outline of a path. |
| [DrawCurve](#drawcurve) | Draws a cardinal spline through points. |
| [DrawClosedCurve](#drawclosedcurve) | Draws a closed cardinal spline through points. |
| [Clear](#clear) | Fills the whole surface with one colour. |
| [FillRectangle](#fillrectangle) | Fills a rectangle. |
| [FillRectangles](#fillrectangles) | Fills several rectangles. |
| [FillPolygon](#fillpolygon) | Fills a polygon. |
| [FillEllipse](#fillellipse) | Fills an ellipse. |
| [FillPie](#fillpie) | Fills a pie slice. |
| [FillPath](#fillpath) | Fills a path. |
| [FillClosedCurve](#fillclosedcurve) | Fills a closed cardinal spline. |
| [FillRegion](#fillregion) | Fills a region. |
| [DrawString](#drawstring) | Draws text at a point or inside a rectangle. |
| [MeasureString](#measurestring) | Measures the space a string takes. |
| [MeasureCharacterRanges](#measurecharacterranges) | Measures ranges of characters in a string, as regions. |
| [DrawDriverString](#drawdriverstring) | Draws characters at positions you supply. |
| [MeasureDriverString](#measuredriverstring) | Measures characters placed at positions you supply. |
| [DrawCachedBitmap](#drawcachedbitmap) | Draws a cached bitmap. |
| [DrawImage](#drawimage) | Draws an image or part of one. |
| [DrawImageFX](#drawimagefx) | Draws part of an image with an effect applied. |
| [EnumerateMetafileDestPoint, EnumerateMetafileDestRect, EnumerateMetafileDestPoints](#enumeratemetafiledestpoint-enumeratemetafiledestrect-enumeratemetafiledestpoints) | Pass each record of a metafile to a callback. |
| [EnumerateMetafileSrcRectDestPoint, EnumerateMetafileSrcRectDestRect, EnumerateMetafileSrcRectDestPoints](#enumeratemetafilesrcrectdestpoint-enumeratemetafilesrcrectdestrect-enumeratemetafilesrcrectdestpoints) | Pass the records of part of a metafile to a callback. |
| [SetClip](#setclip) | Sets or combines the clipping region. |
| [IntersectClip](#intersectclip) | Narrows the clipping region to its overlap with a shape. |
| [ExcludeClip](#excludeclip) | Removes a shape from the clipping region. |
| [ResetClip](#resetclip) | Removes all clipping. |
| [TranslateClip](#translateclip) | Moves the clipping region. |
| [GetClip](#getclip) | Copies the clipping region into a region object. |
| [GetClipBounds](#getclipbounds) | Returns the rectangle around the clipping region. |
| [IsClipEmpty](#isclipempty) | Tells whether the clipping region is empty. |
| [GetVisibleClipBounds](#getvisibleclipbounds) | Returns the rectangle around the visible clipping region. |
| [IsVisibleClipEmpty](#isvisibleclipempty) | Tells whether the visible clipping region is empty. |
| [IsVisible](#isvisible) | Tells whether a point or rectangle is inside the visible clipping region. |
| [Save, Restore](#save-restore) | Saves the state of the surface and restores it later. |
| [BeginContainer, EndContainer](#begincontainer-endcontainer) | Opens and closes a nested graphics container. |
| [AddMetafileComment](#addmetafilecomment) | Adds a comment to a metafile being recorded. |
| [GetHalftonePalette](#gethalftonepalette) | Creates the Windows halftone palette. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval hdc as HDC )
constructor( byval hdc as HDC, byval hDevice as HANDLE )
constructor( byval hwnd as HWND, byval icm as boolean = FALSE )
constructor( byval pImage as CGpImage ptr )
```

Creates the drawing surface and the GDI+ object behind it.

- With an `HDC` it draws on that device context: the DC from `BeginPaint`, a memory DC, a
  printer DC. Destroy the `CGpGraphics` before the DC is released.
- With an `HDC` and a device handle it draws on the DC and takes the device information (for a
  printer, say) from `hDevice`.
- With an `HWND` it draws on the window's client area through a DC of its own. `icm = TRUE`
  applies colour correction from the display's ICC profile.
- With an image (a [CGpBitmap](SysWin-GdiPlus-Images) or a metafile being recorded) it draws
  into the image. It fails for an image opened from a file as a metafile and for indexed,
  16-bit grey-scale and 16-bit ARGB1555 pixel formats.
- With no argument it holds nothing until [FromHDC](#fromhdc), [FromHWND](#fromhwnd) or
  [FromImage](#fromimage) attaches a GDI+ object.

Whichever form you use, `GetLastStatus()` tells whether the GDI+ object was created.

| Parameter | Meaning |
| --- | --- |
| `hdc` | The device context to draw on. |
| `hDevice` | A handle to the device the DC belongs to. |
| `hwnd` | The window to draw on. |
| `icm` | `TRUE` to apply ICC colour correction; `FALSE` (the default) not to. |
| `pImage` | The image to draw into. |

**Example**

```freebasic
dim g as CGpGraphics = hwnd                 ' the window's client area
dim bmp as CGpBitmap = CGpBitmap( 200, 100 )
dim gImg as CGpGraphics = @bmp              ' draws into the bitmap
if gImg.GetLastStatus() = Ok then gImg.Clear( ARGB_White )
```

Microsoft Learn: [Graphics::Graphics](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-graphics%28hdc%29)

### Destructor

```freebasic
destructor
```

Deletes the GDI+ object, if there is one. The device context, window or image it drew on is not
touched. When this is the last live `CGp*` object and GDI+ was not started with `Init`, GDI+ is
shut down as well.

**Example**

```freebasic
dim pG as CGpGraphics ptr = new CGpGraphics( hwnd )
pG->Clear( ARGB_White )
delete pG
```

### FromHDC

```freebasic
function FromHDC( byval hdc as HDC ) as GpStatus
function FromHDC( byval hdc as HDC, byval hDevice as HANDLE ) as GpStatus
```

Creates a GDI+ object for a device context, as the matching constructor does, and attaches it
to an object made with the default constructor. Call it once: a GDI+ object that is already
attached is replaced without being deleted.

| Parameter | Meaning |
| --- | --- |
| `hdc` | The device context to draw on. |
| `hDevice` | A handle to the device the DC belongs to. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics
dim hdc as HDC = GetDC( hwnd )
if g.FromHDC( hdc ) = Ok then g.Clear( ARGB_White )
```

Microsoft Learn: [Graphics::FromHDC](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fromhdc%28hdc%29)

### FromHWND

```freebasic
function FromHWND( byval hwnd as HWND, byval icm as boolean = FALSE ) as GpStatus
```

Creates a GDI+ object for a window's client area, as the `HWND` constructor does, and attaches
it. As with [FromHDC](#fromhdc), call it once per object.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics
if g.FromHWND( hwnd ) = Ok then g.Clear( ARGB_White )
```

Microsoft Learn: [Graphics::FromHWND](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fromhwnd)

### FromImage

```freebasic
function FromImage( byval pImage as CGpImage ptr ) as GpStatus
```

Creates a GDI+ object that draws into an image, as the image constructor does, and attaches it.
As with [FromHDC](#fromhdc), call it once per object.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim bmp as CGpBitmap = CGpBitmap( 64, 64 )
dim g as CGpGraphics
if g.FromImage( @bmp ) = Ok then g.Clear( ARGB_Yellow )
```

Microsoft Learn: [Graphics::FromImage](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fromimage)

### Flush

```freebasic
sub Flush( byval intention as FlushIntention = FlushIntentionFlush )
```

Starts the drawing operations GDI+ has queued. With `FlushIntentionFlush` (the default) it
returns at once; with `FlushIntentionSync` it waits until they are finished. The status is not
recorded.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.Clear( ARGB_White )
g.Flush( FlushIntentionSync )
```

Microsoft Learn: [Graphics::Flush](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-flush)

### GetHDC, ReleaseHDC

```freebasic
function GetHDC() as HDC
sub ReleaseHDC( byval hdc as HDC )
```

`GetHDC` lends you the device context behind the surface so that you can draw on it with GDI;
`ReleaseHDC` gives it back. Between the two calls do not call any other method of the
`CGpGraphics`: while the DC is out they fail with `ObjectBusy` (4). Always pair the calls. `ReleaseHDC` does
not record a status.

**Returns** (`GetHDC`) the device context, or `NULL` on failure.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim hdc as HDC = g.GetHDC()
TextOutW( hdc, 10, 10, "GDI text", 8 )
g.ReleaseHDC( hdc )
```

Microsoft Learn: [Graphics::GetHDC](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-gethdc), [Graphics::ReleaseHDC](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-releasehdc)

### GetRenderingOrigin, SetRenderingOrigin

```freebasic
function GetRenderingOrigin( byval x as long ptr, byval y as long ptr ) as GpStatus
function SetRenderingOrigin( byval x as INT_, byval y as INT_ ) as GpStatus
```

The rendering origin is the point, in device pixels, where hatch-brush patterns and the dither
patterns of 8- and 16-bit displays start. It is (0, 0) until you change it.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetRenderingOrigin( 5, 7 )
dim as long ox, oy
g.GetRenderingOrigin( @ox, @oy )            ' 5, 7
```

Microsoft Learn: [Graphics::SetRenderingOrigin](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-setrenderingorigin)

### GetCompositingMode, SetCompositingMode

```freebasic
function GetCompositingMode() as CompositingMode
function SetCompositingMode( byval nCompositingMode as CompositingMode ) as GpStatus
```

Chooses what happens to the pixels already there. `CompositingModeSourceOver` (the default)
blends semi-transparent colours with them; `CompositingModeSourceCopy` replaces them, alpha
included.

**Returns** the mode (`Get`), or `Ok` or the error (`Set`).

**Example**

```freebasic
dim bmp as CGpBitmap = CGpBitmap( 100, 100 )
dim g as CGpGraphics = @bmp
g.SetCompositingMode( CompositingModeSourceCopy )
dim br as CGpSolidBrush = CGpSolidBrush( &h80FF0000 )   ' writes half-transparent red as is
g.FillRectangle( @br, 0, 0, 50, 50 )
```

Microsoft Learn: [Graphics::SetCompositingMode](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-setcompositingmode)

### GetCompositingQuality, SetCompositingQuality

```freebasic
function GetCompositingQuality() as CompositingQuality
function SetCompositingQuality( byval nQuality as CompositingQuality ) as GpStatus
```

Sets how carefully blended colours are computed: `CompositingQualityHighSpeed`,
`CompositingQualityHighQuality`, `CompositingQualityGammaCorrected`,
`CompositingQualityAssumeLinear` or `CompositingQualityDefault` (0, what a new surface has).

**Returns** the quality (`Get`), or `Ok` or the error (`Set`).

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetCompositingQuality( CompositingQualityGammaCorrected )
```

Microsoft Learn: [Graphics::SetCompositingQuality](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-setcompositingquality)

### GetTextRenderingHint, SetTextRenderingHint

```freebasic
function GetTextRenderingHint() as TextRenderingHint
function SetTextRenderingHint( byval newMode as TextRenderingHint ) as GpStatus
```

Chooses how text is rendered: `TextRenderingHintSystemDefault` (0, the default, follows the
system's font smoothing), `TextRenderingHintAntiAlias`, `TextRenderingHintClearTypeGridFit`,
`TextRenderingHintSingleBitPerPixel` and their grid-fitted variants.

**Returns** the hint (`Get`), or `Ok` or the error (`Set`).

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetTextRenderingHint( TextRenderingHintClearTypeGridFit )
```

Microsoft Learn: [Graphics::SetTextRenderingHint](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-settextrenderinghint)

### GetTextContrast, SetTextContrast

```freebasic
function GetTextContrast() as UINT
function SetTextContrast( byval contrast as UINT ) as GpStatus
```

The gamma correction applied to antialiased and ClearType text, from 0 to 12; a new surface has
4. A value above 12 returns `InvalidParameter` and leaves the contrast as it was.

**Returns** the contrast (`Get`), or `Ok` or the error (`Set`).

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetTextContrast( 8 )
print g.GetTextContrast()                   ' 8
```

Microsoft Learn: [Graphics::SetTextContrast](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-settextcontrast)

### GetInterpolationMode, SetInterpolationMode

```freebasic
function GetInterpolationMode() as InterpolationMode
function SetInterpolationMode( byval interpolationMode as long ) as GpStatus
```

Chooses how pixels are computed when an image is stretched, shrunk or rotated:
`InterpolationModeNearestNeighbor` (blocky, fastest), `InterpolationModeBilinear` (what a
bitmap surface starts with), `InterpolationModeHighQualityBicubic` (best for photographs) and
the others of the `InterpolationMode` enumeration. The setter takes a `long`, so any
`InterpolationMode` value can be passed.

**Returns** the mode (`Get`), or `Ok` or the error (`Set`).

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetInterpolationMode( InterpolationModeHighQualityBicubic )
```

Microsoft Learn: [Graphics::SetInterpolationMode](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-setinterpolationmode)

### GetSmoothingMode, SetSmoothingMode

```freebasic
function GetSmoothingMode() as SmoothingMode
function SetSmoothingMode( byval smoothingMode as long ) as GpStatus
```

Turns antialiasing of lines, curves and the edges of filled shapes on or off.
`SmoothingModeAntiAlias` (4) smooths them; `SmoothingModeNone` (3), `SmoothingModeHighSpeed`
and `SmoothingModeDefault` do not. A new bitmap surface reports `SmoothingModeNone`. It does not
affect text, which [SetTextRenderingHint](#gettextrenderinghint-settextrenderinghint) controls.

**Returns** the mode (`Get`), or `Ok` or the error (`Set`).

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetSmoothingMode( SmoothingModeAntiAlias )
print g.GetSmoothingMode()                  ' 4
```

Microsoft Learn: [Graphics::SetSmoothingMode](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-setsmoothingmode)

### GetPixelOffsetMode, SetPixelOffsetMode

```freebasic
function GetPixelOffsetMode() as PixelOffsetMode
function SetPixelOffsetMode( byval nMode as PixelOffsetMode ) as GpStatus
```

Chooses whether pixel centres are at whole coordinates or offset by half a pixel.
`PixelOffsetModeHalf` (or `PixelOffsetModeHighQuality`) gives sharper antialiased edges and
makes scaled images line up with their destination rectangle; `PixelOffsetModeDefault` (0) is
what a new surface has.

**Returns** the mode (`Get`), or `Ok` or the error (`Set`).

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetPixelOffsetMode( PixelOffsetModeHalf )
```

Microsoft Learn: [Graphics::SetPixelOffsetMode](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-setpixeloffsetmode)

### GetTransform, SetTransform

```freebasic
function GetTransform( byval pMatrix as CGpMatrix ptr ) as GpStatus
function SetTransform( byval pMatrix as CGpMatrix ptr ) as GpStatus
```

`SetTransform` replaces the world transformation with a copy of `pMatrix`; `GetTransform`
copies the current one into an existing [CGpMatrix](CGpMatrix). Neither accepts `NULL`.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim m as CGpMatrix = CGpMatrix( 1, 0, 0, 1, 50, 20 )   ' move by (50, 20)
g.SetTransform( @m )
dim cur as CGpMatrix
g.GetTransform( @cur )
```

Microsoft Learn: [Graphics::SetTransform](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-settransform), [Graphics::GetTransform](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-gettransform)

### ResetTransform

```freebasic
function ResetTransform() as GpStatus
```

Sets the world transformation back to the identity, so world coordinates equal page
coordinates again. This also undoes [ScaleTransformForDpi](#scaletransformfordpi).

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.RotateTransform( 30 )
g.ResetTransform()
```

Microsoft Learn: [Graphics::ResetTransform](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-resettransform)

### MultiplyTransform

```freebasic
function MultiplyTransform( byval pMatrix as CGpMatrix ptr, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Multiplies the world transformation by `pMatrix`. With `MatrixOrderPrepend` (the default) the
new matrix acts first, before the transformations already set; with `MatrixOrderAppend` it acts
after them. The same `order` parameter appears on every transform method below.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim shear as CGpMatrix = CGpMatrix( 1, 0, 0.5, 1, 0, 0 )
g.MultiplyTransform( @shear, MatrixOrderAppend )
```

Microsoft Learn: [Graphics::MultiplyTransform](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-multiplytransform)

### TranslateTransform

```freebasic
function TranslateTransform( byval dx as single, byval dy as single, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Moves the coordinate system by `dx`, `dy`: after `TranslateTransform( 10, 20 )` the world
point (1, 1) lands on device point (11, 21).

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.TranslateTransform( 10, 20 )
dim pen as CGpPen = CGpPen( ARGB_Black )
g.DrawRectangle( @pen, 0, 0, 50, 50 )       ' appears at (10, 20)
```

Microsoft Learn: [Graphics::TranslateTransform](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-translatetransform)

### ScaleTransform

```freebasic
function ScaleTransform( byval sx as single, byval sy as single, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Multiplies x coordinates by `sx` and y coordinates by `sy`. Pen widths are scaled too.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.ScaleTransform( 2, 2 )                    ' everything twice as large
```

Microsoft Learn: [Graphics::ScaleTransform](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-scaletransform)

### ScaleTransformForDpi

```freebasic
function ScaleTransformForDpi( byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Scales the coordinate system by `GetDpiX() / 96` horizontally and `GetDpiY() / 96` vertically,
so that a program can draw in 96-DPI units and get the same physical size on every display: at
150 % a 100-unit line is 150 pixels long. The ratios come from this surface's own device, so a
bitmap surface (96 DPI) is not scaled; the process must be DPI aware for a screen DC to report
more than 96. Call it once, before drawing; a second call scales again.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.ScaleTransformForDpi()
```

### RotateTransform

```freebasic
function RotateTransform( byval angle as single, byval order as MatrixOrder = MatrixOrderPrepend ) as GpStatus
```

Rotates the coordinate system by `angle` degrees about its origin, clockwise on screen. To turn
a shape about its own centre, translate to the centre first, rotate, then draw around (0, 0).

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.TranslateTransform( 100, 100 )
g.RotateTransform( 45 )
dim pen as CGpPen = CGpPen( ARGB_Red, 2 )
g.DrawRectangle( @pen, -30, -30, 60, 60 )   ' a diamond centred on (100, 100)
```

Microsoft Learn: [Graphics::RotateTransform](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-rotatetransform)

### GetPageUnit, SetPageUnit

```freebasic
function GetPageUnit() as GpUnit
function SetPageUnit( byval unit as GpUnit ) as GpStatus
```

The unit page coordinates are measured in: `UnitPixel`, `UnitPoint`, `UnitInch`,
`UnitMillimeter`, `UnitDocument` (1/300 inch) or `UnitDisplay` (1, what a new surface has: pixels
on a screen, 1/100 inch on a printer). Setting `UnitWorld` returns `InvalidParameter` and keeps
the unit as it was.

**Returns** the unit (`Get`), or `Ok` or the error (`Set`).

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetPageUnit( UnitMillimeter )
dim pen as CGpPen = CGpPen( ARGB_Black, 0.5 )
g.DrawRectangle( @pen, 10, 10, 50, 30 )     ' 50 x 30 mm
```

Microsoft Learn: [Graphics::SetPageUnit](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-setpageunit)

### GetPageScale, SetPageScale

```freebasic
function GetPageScale() as single
function SetPageScale( byval nScale as single ) as GpStatus
```

A factor applied to page coordinates after the page unit; a new surface has 1. With
`UnitPixel` and a scale of 2 the page point (5, 5) is the device point (10, 10).

**Returns** the scale (`Get`), or `Ok` or the error (`Set`).

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetPageUnit( UnitPixel )
g.SetPageScale( 2 )
```

Microsoft Learn: [Graphics::SetPageScale](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-setpagescale)

### GetDpiX, GetDpiY

```freebasic
function GetDpiX() as single
function GetDpiY() as single
```

Return the horizontal and vertical resolution, in dots per inch, of the device this surface draws
on. A screen DC reports the display's DPI to a DPI-aware process and 96 otherwise; a new
bitmap reports 96 in both directions.

**Returns** the resolution.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
print "scaling:"; g.GetDpiX() / 96 * 100; " %"
```

Microsoft Learn: [Graphics::GetDpiX](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-getdpix), [Graphics::GetDpiY](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-getdpiy)

### TransformPoints

```freebasic
function TransformPoints( byval destSpace as CoordinateSpace, byval srcSpace as CoordinateSpace, byval pts as GpPointF ptr, byval nCount as long ) as GpStatus
function TransformPoints( byval destSpace as CoordinateSpace, byval srcSpace as CoordinateSpace, byval pts as GpPoint ptr, byval nCount as long ) as GpStatus
```

Converts `nCount` points in place from one coordinate space to another, through the current
world and page transformations. The spaces are `CoordinateSpaceWorld`, `CoordinateSpacePage`
and `CoordinateSpaceDevice`. Use it to turn a mouse position (device) into drawing coordinates
(world), or the reverse.

| Parameter | Meaning |
| --- | --- |
| `destSpace` | The space to convert to. |
| `srcSpace` | The space the points are in. |
| `pts` | The first of the points; they are overwritten. |
| `nCount` | The number of points. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.TranslateTransform( 10, 20 )
dim pt as GpPointF = type<GpPointF>( 1, 1 )
g.TransformPoints( CoordinateSpaceDevice, CoordinateSpaceWorld, @pt, 1 )   ' pt is (11, 21)
```

Microsoft Learn: [Graphics::TransformPoints](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-transformpoints%28coordinatespace_coordinatespace_pointf_int%29)

### GetNearestColor

```freebasic
function GetNearestColor( byval colour as ARGB ptr ) as GpStatus
```

Replaces the colour at `colour` with the nearest colour the device can show. This matters only
on 8-bit palette displays; on a true-colour surface the colour comes back unchanged. The alpha
value is ignored.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim c as ARGB = &hFF123456
g.GetNearestColor( @c )
```

Microsoft Learn: [Graphics::GetNearestColor](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-getnearestcolor)

### DrawLine

```freebasic
function DrawLine( byval pPen as CGpPen ptr, byval x1 as single, byval y1 as single, byval x2 as single, byval y2 as single ) as GpStatus
function DrawLine( byval pPen as CGpPen ptr, byval pt1 as GpPointF ptr, byval pt2 as GpPointF ptr ) as GpStatus
function DrawLine( byval pPen as CGpPen ptr, byval pt1 as GpPoint ptr, byval pt2 as GpPoint ptr ) as GpStatus
```

Draws a straight line from (`x1`, `y1`) to (`x2`, `y2`), or from `pt1` to `pt2`, with the pen's
colour, width, dash style and line caps.

| Parameter | Meaning |
| --- | --- |
| `pPen` | The pen to draw with. |
| `x1`, `y1`, `pt1` | The start point. |
| `x2`, `y2`, `pt2` | The end point. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Blue, 2 )
g.DrawLine( @pen, 10, 10, 200, 80 )
```

Microsoft Learn: [Graphics::DrawLine](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawline%28constpen_real_real_real_real%29)

### DrawLines

```freebasic
function DrawLines( byval pPen as CGpPen ptr, byval pts as GpPointF ptr, byval nCount as long ) as GpStatus
function DrawLines( byval pPen as CGpPen ptr, byval pts as GpPoint ptr, byval nCount as long ) as GpStatus
```

Draws connected lines through `nCount` points: from the first to the second, the second to the
third and so on. The joins between the lines follow the pen's line join. The figure is not
closed; use [DrawPolygon](#drawpolygon) for that.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Green, 3 )
dim pts(2) as GpPoint = { (10, 80), (60, 10), (110, 80) }
g.DrawLines( @pen, @pts(0), 3 )
```

Microsoft Learn: [Graphics::DrawLines](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawlines%28constpen_constpointf_int%29)

### DrawArc

```freebasic
function DrawArc( byval pPen as CGpPen ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function DrawArc( byval pPen as CGpPen ptr, byval rc as GpRectF ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function DrawArc( byval pPen as CGpPen ptr, byval rc as GpRect ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
```

Draws part of the outline of the ellipse that fills the rectangle (`x`, `y`, `nWidth`,
`nHeight`) or `rc`. The arc starts `startAngle` degrees clockwise from the x-axis and runs for
`sweepAngle` degrees (counter-clockwise when negative).

| Parameter | Meaning |
| --- | --- |
| `pPen` | The pen to draw with. |
| `x`, `y`, `nWidth`, `nHeight`, `rc` | The rectangle that bounds the ellipse. |
| `startAngle` | Where the arc starts, in degrees. |
| `sweepAngle` | How far it runs, in degrees. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Red, 2 )
g.DrawArc( @pen, 20, 20, 100, 60, 180, 180 )   ' the top half
```

Microsoft Learn: [Graphics::DrawArc](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawarc%28constpen_real_real_real_real_real_real%29)

### DrawBezier

```freebasic
function DrawBezier( byval pPen as CGpPen ptr, byval x1 as single, byval y1 as single, byval x2 as single, byval y2 as single, byval x3 as single, byval y3 as single, byval x4 as single, byval y4 as single ) as GpStatus
function DrawBezier( byval pPen as CGpPen ptr, byval pt1 as GpPointF ptr, byval pt2 as GpPointF ptr, byval pt3 as GpPointF ptr, byval pt4 as GpPointF ptr ) as GpStatus
function DrawBezier( byval pPen as CGpPen ptr, byval pt1 as GpPoint ptr, byval pt2 as GpPoint ptr, byval pt3 as GpPoint ptr, byval pt4 as GpPoint ptr ) as GpStatus
```

Draws a cubic Bézier curve from the first point to the fourth; the second and third points are
control points that pull the curve towards them without being on it.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Purple, 2 )
g.DrawBezier( @pen, 10, 100, 60, 10, 140, 190, 190, 100 )
```

Microsoft Learn: [Graphics::DrawBezier](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawbezier%28constpen_real_real_real_real_real_real_real_real%29)

### DrawBeziers

```freebasic
function DrawBeziers( byval pPen as CGpPen ptr, byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function DrawBeziers( byval pPen as CGpPen ptr, byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
```

Draws a chain of Bézier curves. The first curve uses points 1 to 4; each further curve uses the
end of the previous one and three more points, so `nCount` must be 4, 7, 10 …

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Black )
dim pts(6) as GpPoint = { (10, 50), (30, 10), (50, 90), (70, 50), (90, 10), (110, 90), (130, 50) }
g.DrawBeziers( @pen, @pts(0), 7 )
```

Microsoft Learn: [Graphics::DrawBeziers](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawbeziers%28constpen_constpointf_int%29)

### DrawRectangle

```freebasic
function DrawRectangle( byval pPen as CGpPen ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as GpStatus
function DrawRectangle( byval pPen as CGpPen ptr, byval rc as GpRectF ptr ) as GpStatus
function DrawRectangle( byval pPen as CGpPen ptr, byval rc as GpRect ptr ) as GpStatus
```

Draws the outline of the rectangle whose top-left corner is (`x`, `y`). Unlike GDI, the size is a
width and a height, not a right and bottom edge.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Black, 1 )
dim rc as GpRect = type<GpRect>( 10, 10, 120, 60 )
g.DrawRectangle( @pen, @rc )
```

Microsoft Learn: [Graphics::DrawRectangle](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawrectangle%28constpen_real_real_real_real%29)

### DrawRectangles

```freebasic
function DrawRectangles( byval pPen as CGpPen ptr, byval rects as GpRectF ptr, byval nCount as INT_ ) as GpStatus
function DrawRectangles( byval pPen as CGpPen ptr, byval rects as GpRect ptr, byval nCount as INT_ ) as GpStatus
```

Draws the outlines of `nCount` rectangles from an array, in one call.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Gray )
dim rcs(1) as GpRect = { (10, 10, 50, 30), (70, 10, 50, 30) }
g.DrawRectangles( @pen, @rcs(0), 2 )
```

Microsoft Learn: [Graphics::DrawRectangles](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawrectangles%28constpen_constrectf_int%29)

### DrawEllipse

```freebasic
function DrawEllipse( byval pPen as CGpPen ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as GpStatus
function DrawEllipse( byval pPen as CGpPen ptr, byval rc as GpRectF ptr ) as GpStatus
function DrawEllipse( byval pPen as CGpPen ptr, byval rc as GpRect ptr ) as GpStatus
```

Draws the outline of the ellipse that fills the given rectangle; equal width and height give a
circle.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Navy, 2 )
g.DrawEllipse( @pen, 20, 20, 80, 80 )       ' a circle
```

Microsoft Learn: [Graphics::DrawEllipse](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawellipse%28constpen_real_real_real_real%29)

### DrawPie

```freebasic
function DrawPie( byval pPen as CGpPen ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function DrawPie( byval pPen as CGpPen ptr, byval rc as GpRectF ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function DrawPie( byval pPen as CGpPen ptr, byval rc as GpRect ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
```

Draws the outline of a pie slice: an arc, as in [DrawArc](#drawarc), plus the two radii joining
its ends to the centre of the ellipse.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Black )
g.DrawPie( @pen, 20, 20, 100, 100, 0, 90 )  ' the lower-right quarter
```

Microsoft Learn: [Graphics::DrawPie](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawpie%28constpen_real_real_real_real_real_real%29)

### DrawPolygon

```freebasic
function DrawPolygon( byval pPen as CGpPen ptr, byval pts as GpPointF ptr, byval nCount as long ) as GpStatus
function DrawPolygon( byval pPen as CGpPen ptr, byval pts as GpPoint ptr, byval nCount as long ) as GpStatus
```

Draws the outline of a polygon through `nCount` points, closing it from the last point back to
the first.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_DarkGreen, 2 )
dim pts(2) as GpPoint = { (60, 10), (110, 90), (10, 90) }
g.DrawPolygon( @pen, @pts(0), 3 )           ' a triangle
```

Microsoft Learn: [Graphics::DrawPolygon](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawpolygon%28constpen_constpointf_int%29)

### DrawPath

```freebasic
function DrawPath( byval pPen as CGpPen ptr, byval pPath as CGpGraphicsPath_ ptr ) as GpStatus
```

Draws the outline of every figure in a [CGpGraphicsPath](CGpGraphicsPath): its lines, curves
and shapes in one stroke.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim path as CGpGraphicsPath
path.AddEllipse( 10, 10, 100, 50 )
dim pen as CGpPen = CGpPen( ARGB_Black, 2 )
g.DrawPath( @pen, @path )
```

Microsoft Learn: [Graphics::DrawPath](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawpath)

### DrawCurve

```freebasic
function DrawCurve( byval pPen as CGpPen ptr, byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function DrawCurve( byval pPen as CGpPen ptr, byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
function DrawCurve( byval pPen as CGpPen ptr, byval pts as GpPointF ptr, byval nCount as INT_, byval tension as single ) as GpStatus
function DrawCurve( byval pPen as CGpPen ptr, byval pts as GpPoint ptr, byval nCount as INT_, byval tension as single ) as GpStatus
function DrawCurve( byval pPen as CGpPen ptr, byval pts as GpPointF ptr, byval nCount as INT_, byval offset as INT_, byval numberOfSegments as INT_, byval tension as single = 0.5 ) as GpStatus
function DrawCurve( byval pPen as CGpPen ptr, byval pts as GpPoint ptr, byval nCount as INT_, byval offset as INT_, byval numberOfSegments as INT_, byval tension as single = 0.5 ) as GpStatus
```

Draws a smooth curve (a cardinal spline) that passes through every point. `tension` sets how
tightly it bends: 0 gives straight lines between the points, 0.5 (the default) a natural curve,
higher values a looser one. The last form draws only `numberOfSegments` segments, starting at
point `offset`, while the other points still shape the curve.

| Parameter | Meaning |
| --- | --- |
| `pPen` | The pen to draw with. |
| `pts`, `nCount` | The points and how many there are. |
| `tension` | How the curve bends; 0.5 when not given. |
| `offset` | The index of the point where drawing starts. |
| `numberOfSegments` | How many segments to draw from there. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Teal, 2 )
dim pts(3) as GpPointF = { (10, 80), (60, 20), (110, 80), (160, 20) }
g.DrawCurve( @pen, @pts(0), 4, 0.8 )
```

Microsoft Learn: [Graphics::DrawCurve](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawcurve%28constpen_constpointf_int_real%29)

### DrawClosedCurve

```freebasic
function DrawClosedCurve( byval pPen as CGpPen ptr, byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function DrawClosedCurve( byval pPen as CGpPen ptr, byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
function DrawClosedCurve( byval pPen as CGpPen ptr, byval pts as GpPointF ptr, byval nCount as INT_, byval tension as single ) as GpStatus
function DrawClosedCurve( byval pPen as CGpPen ptr, byval pts as GpPoint ptr, byval nCount as INT_, byval tension as single ) as GpStatus
```

Draws a cardinal spline through the points, as [DrawCurve](#drawcurve) does, and continues it
smoothly from the last point back to the first. Without `tension`, 0.5 is used.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim pen as CGpPen = CGpPen( ARGB_Maroon, 2 )
dim pts(3) as GpPoint = { (60, 10), (110, 60), (60, 110), (10, 60) }
g.DrawClosedCurve( @pen, @pts(0), 4 )
```

Microsoft Learn: [Graphics::DrawClosedCurve](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawclosedcurve%28constpen_constpointf_int%29)

### Clear

```freebasic
function Clear( byval colour as ARGB ) as GpStatus
```

Fills the surface with `colour`. The world transformation does not apply, but the clipping
region does: with a clip set, only the area inside it is painted.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.Clear( ARGB_White )
```

Microsoft Learn: [Graphics::Clear](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-clear)

### FillRectangle

```freebasic
function FillRectangle( byval pBrush as CGpBrush ptr, byval rc as GpRectF ptr ) as GpStatus
function FillRectangle( byval pBrush as CGpBrush ptr, byval rc as GpRect ptr ) as GpStatus
function FillRectangle( byval pBrush as CGpBrush ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as GpStatus
```

Fills the inside of a rectangle with a brush: a solid colour, a hatch, a gradient or a texture
(see [brushes](SysWin-GdiPlus-Brushes)).

| Parameter | Meaning |
| --- | --- |
| `pBrush` | The brush to fill with. |
| `rc`, `x`, `y`, `nWidth`, `nHeight` | The rectangle. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim br as CGpSolidBrush = CGpSolidBrush( ARGB_LightBlue )
g.FillRectangle( @br, 10, 10, 150, 80 )
```

Microsoft Learn: [Graphics::FillRectangle](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fillrectangle%28constbrush_real_real_real_real%29)

### FillRectangles

```freebasic
function FillRectangles( byval pBrush as CGpBrush ptr, byval rects as GpRectF ptr, byval nCount as INT_ ) as GpStatus
function FillRectangles( byval pBrush as CGpBrush ptr, byval rects as GpRect ptr, byval nCount as INT_ ) as GpStatus
```

Fills `nCount` rectangles from an array with one brush.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim br as CGpSolidBrush = CGpSolidBrush( ARGB_Orange )
dim rcs(1) as GpRectF = { (10, 10, 40, 40), (60, 10, 40, 40) }
g.FillRectangles( @br, @rcs(0), 2 )
```

Microsoft Learn: [Graphics::FillRectangles](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fillrectangles%28constbrush_constrectf_int%29)

### FillPolygon

```freebasic
function FillPolygon( byval pBrush as CGpBrush ptr, byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function FillPolygon( byval pBrush as CGpBrush ptr, byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
function FillPolygon( byval pBrush as CGpBrush ptr, byval pts as GpPointF ptr, byval nCount as INT_, byval nFillMode as FillMode ) as GpStatus
function FillPolygon( byval pBrush as CGpBrush ptr, byval pts as GpPoint ptr, byval nCount as INT_, byval nFillMode as FillMode ) as GpStatus
```

Fills the polygon through `nCount` points. Where its edges cross, `nFillMode` decides what is
inside: `FillModeAlternate` (used when the mode is left out) leaves every other overlapping area
empty, `FillModeWinding` fills them all.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim br as CGpSolidBrush = CGpSolidBrush( ARGB_Gold )
dim star(4) as GpPointF = { (60, 0), (95, 110), (0, 40), (120, 40), (25, 110) }
g.FillPolygon( @br, @star(0), 5, FillModeWinding )
```

Microsoft Learn: [Graphics::FillPolygon](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fillpolygon%28constbrush_constpointf_int_fillmode%29)

### FillEllipse

```freebasic
function FillEllipse( byval pBrush as CGpBrush ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as GpStatus
function FillEllipse( byval pBrush as CGpBrush ptr, byval rc as GpRectF ptr ) as GpStatus
function FillEllipse( byval pBrush as CGpBrush ptr, byval rc as GpRect ptr ) as GpStatus
```

Fills the ellipse that fills the given rectangle.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim br as CGpSolidBrush = CGpSolidBrush( ARGB_Tomato )
g.FillEllipse( @br, 20, 20, 120, 80 )
```

Microsoft Learn: [Graphics::FillEllipse](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fillellipse%28constbrush_real_real_real_real%29)

### FillPie

```freebasic
function FillPie( byval pBrush as CGpBrush ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function FillPie( byval pBrush as CGpBrush ptr, byval rc as GpRectF ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
function FillPie( byval pBrush as CGpBrush ptr, byval rc as GpRect ptr, byval startAngle as single, byval sweepAngle as single ) as GpStatus
```

Fills a pie slice, with the angles as in [DrawArc](#drawarc). A pie chart is a series of
`FillPie` calls whose start angles add up.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim br as CGpSolidBrush = CGpSolidBrush( ARGB_SeaGreen )
g.FillPie( @br, 20, 20, 120, 120, -90, 120 )   ' a third, starting at 12 o'clock
```

Microsoft Learn: [Graphics::FillPie](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fillpie%28constbrush_real_real_real_real_real_real%29)

### FillPath

```freebasic
function FillPath( byval pBrush as CGpBrush ptr, byval pPath as CGpGraphicsPath_ ptr ) as GpStatus
```

Fills the inside of a [CGpGraphicsPath](CGpGraphicsPath), using the path's fill mode. A figure
that is not closed is filled as if a straight line joined its last point to its first.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim path as CGpGraphicsPath
path.AddRectangle( 10, 10, 80, 40 )
path.AddEllipse( 60, 30, 80, 40 )
dim br as CGpSolidBrush = CGpSolidBrush( ARGB_CornflowerBlue )
g.FillPath( @br, @path )
```

Microsoft Learn: [Graphics::FillPath](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fillpath)

### FillClosedCurve

```freebasic
function FillClosedCurve( byval pBrush as CGpBrush ptr, byval pts as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function FillClosedCurve( byval pBrush as CGpBrush ptr, byval pts as GpPoint ptr, byval nCount as INT_ ) as GpStatus
function FillClosedCurve( byval pBrush as CGpBrush ptr, byval pts as GpPointF ptr, byval nCount as long, byval nFillMode as FillMode, byval tension as single = 0.5 ) as GpStatus
function FillClosedCurve( byval pBrush as CGpBrush ptr, byval pts as GpPoint ptr, byval nCount as long, byval nFillMode as FillMode, byval tension as single = 0.5 ) as GpStatus
```

Fills the closed cardinal spline that [DrawClosedCurve](#drawclosedcurve) would draw through
the points. The short forms use `FillModeAlternate` and a tension of 0.5.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim br as CGpSolidBrush = CGpSolidBrush( ARGB_Plum )
dim pts(3) as GpPointF = { (60, 10), (110, 60), (60, 110), (10, 60) }
g.FillClosedCurve( @br, @pts(0), 4, FillModeAlternate, 1.0 )
```

Microsoft Learn: [Graphics::FillClosedCurve](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fillclosedcurve%28constbrush_constpointf_int_fillmode_real%29)

### FillRegion

```freebasic
function FillRegion( byval pBrush as CGpBrush ptr, byval pRegion as CGpRegion ptr ) as GpStatus
```

Fills the inside of a [CGpRegion](CGpRegion). Regions have no outline, so this is the only way
to draw one.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim rgn as CGpRegion = CGpRegion( 10.0!, 10.0!, 100.0!, 60.0! )
dim br as CGpSolidBrush = CGpSolidBrush( ARGB_Khaki )
g.FillRegion( @br, @rgn )
```

Microsoft Learn: [Graphics::FillRegion](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-fillregion)

### DrawString

```freebasic
function DrawString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval rc as GpRectF ptr, byval pBrush as CGpBrush ptr ) as GpStatus
function DrawString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single, byval pBrush as CGpBrush ptr ) as GpStatus
function DrawString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval layoutRect as GpRectF ptr, byval pStringFormat as CGpStringFormat ptr, byval pBrush as CGpBrush ptr ) as GpStatus
function DrawString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single, byval pStringFormat as CGpStringFormat ptr, byval pBrush as CGpBrush ptr ) as GpStatus
function DrawString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval origin as GpPointF ptr, byval pBrush as CGpBrush ptr ) as GpStatus
function DrawString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval x as single, byval y as single, byval pBrush as CGpBrush ptr ) as GpStatus
function DrawString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval origin as GpPointF ptr, byval pStringFormat as CGpStringFormat ptr, byval pBrush as CGpBrush ptr ) as GpStatus
function DrawString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval x as single, byval y as single, byval pStringFormat as CGpStringFormat ptr, byval pBrush as CGpBrush ptr ) as GpStatus
```

Draws text with a [font](SysWin-GdiPlus-Fonts) and a brush. Given a point (`origin`, or `x`,
`y`), the text starts there on one line per line break, with no wrapping. Given a rectangle
(`rc` / `layoutRect`, or `x`, `y`, `nWidth`, `nHeight`), the text wraps at word boundaries to
fit its width and is cut off at its edges. A [CGpStringFormat](CGpStringFormat) adds alignment,
trimming, direction and tab stops; the forms that take one need a real object, not `NULL`, and
the others use the default format.

| Parameter | Meaning |
| --- | --- |
| `pwszString` | The text: a literal, a `ustring` or a `wstring` buffer. |
| `length` | The number of characters, or -1 when the text ends with a null character. |
| `pFont` | The font. |
| `rc`, `layoutRect`, `x`, `y`, `nWidth`, `nHeight` | The rectangle to lay the text out in. |
| `origin`, `x`, `y` | The point where the text starts. |
| `pStringFormat` | The layout options. |
| `pBrush` | The brush the characters are filled with. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim fnt as CGpFont = CGpFont( "Segoe UI", 12, FontStyleBold )
dim ink as CGpSolidBrush = CGpSolidBrush( ARGB_Black )
dim sf as CGpStringFormat
sf.SetAlignment( StringAlignmentCenter )
g.DrawString( "Centred heading", -1, @fnt, 0.0!, 10.0!, 300.0!, 30.0!, @sf, @ink )
```

Microsoft Learn: [Graphics::DrawString](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawstring%28constwchar_int_constfont_constrectf__conststringformat_constbrush%29)

### MeasureString

```freebasic
function MeasureString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval layoutRect as GpRectF ptr, byval pStringFormat as CGpStringFormat ptr, byval boundingBox as GpRectF ptr, byref codepointsFitted as INT_, byref linesFilled as INT_ ) as GpStatus
function MeasureString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval layoutRectSize as GpSizeF ptr, byval pStringFormat as CGpStringFormat ptr, byval size as GpSizeF ptr, byref codepointsFitted as INT_, byref linesFilled as INT_ ) as GpStatus
function MeasureString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval origin as GpPointF ptr, byval pStringFormat as CGpStringFormat ptr, byval boundingBox as GpRectF ptr ) as GpStatus
function MeasureString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval layoutRect as GpRectF ptr, byval pStringFormat as CGpStringFormat ptr, byval boundingBox as GpRectF ptr ) as GpStatus
function MeasureString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval layoutRect as GpRectF ptr, byval boundingBox as GpRectF ptr ) as GpStatus
function MeasureString( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval origin as GpPointF ptr, byval boundingBox as GpRectF ptr ) as GpStatus
```

Works out the rectangle the text would cover if [DrawString](#drawstring) drew it with the same
font, format and layout rectangle or origin, and writes it to `boundingBox`. Nothing is drawn.
The two long forms also report how many characters fit in the layout rectangle and on how many
lines. The `GpSizeF` form lays the text out in a rectangle of that size at (0, 0) and writes
only the width and height to `size`, and only when the call succeeds. The forms with a
`pStringFormat` parameter need a real object; the others use the default format.

| Parameter | Meaning |
| --- | --- |
| `pwszString`, `length` | The text and its length in characters, or -1 up to a null character. |
| `pFont` | The font. |
| `layoutRect`, `layoutRectSize`, `origin` | Where the text would be laid out. |
| `pStringFormat` | The layout options. |
| `boundingBox`, `size` | Receive the measured rectangle or size. |
| `codepointsFitted` | Receives the number of characters that fit. |
| `linesFilled` | Receives the number of lines. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim fnt as CGpFont = CGpFont( "Segoe UI", 12 )
dim layout as GpRectF = type<GpRectF>( 0, 0, 1000, 100 )
dim box as GpRectF
g.MeasureString( "Hello", -1, @fnt, @layout, @box )
print box.Width; " x"; box.Height
```

Microsoft Learn: [Graphics::MeasureString](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-measurestring%28constwchar_int_constfont_constrectf__conststringformat_rectf_int_int%29)

### MeasureCharacterRanges

```freebasic
function MeasureCharacterRanges( byval pwszString as wstring ptr, byval length as INT_, byval pFont as CGpFont ptr, byval layoutRect as GpRectF ptr, byval pStringFormat as CGpStringFormat ptr, byval regionCount as INT_, byval regions as CGpRegion ptr ) as GpStatus
```

Measures where ranges of characters land when the text is laid out in `layoutRect`, giving one
[CGpRegion](CGpRegion) per range. Set the ranges first with the string format's
`SetMeasurableCharacterRanges`; `regions` is an array of `regionCount` existing `CGpRegion`
objects, one per range, which receive the results. Use it to find the box of a word for
highlighting or hit testing.

| Parameter | Meaning |
| --- | --- |
| `pwszString`, `length` | The text and its length, or -1 up to a null character. |
| `pFont` | The font. |
| `layoutRect` | The layout rectangle. |
| `pStringFormat` | The format that holds the ranges. |
| `regionCount` | The number of ranges, and of regions in `regions`. |
| `regions` | The first of the regions that receive the results. |

**Returns** `Ok` on success, otherwise the error; `InvalidParameter` without calling GDI+ when
the text, font, rectangle, format or regions pointer is `NULL`.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim fnt as CGpFont = CGpFont( "Segoe UI", 12 )
dim layout as GpRectF = type<GpRectF>( 0, 0, 300, 50 )
dim sf as CGpStringFormat
dim ranges(0) as GpCharacterRange = { (6, 5) }    ' "world"
sf.SetMeasurableCharacterRanges( 1, @ranges(0) )
dim rgn(0) as CGpRegion
g.MeasureCharacterRanges( "Hello world", -1, @fnt, @layout, @sf, 1, @rgn(0) )
```

Microsoft Learn: [Graphics::MeasureCharacterRanges](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-measurecharacterranges)

### DrawDriverString

```freebasic
function DrawDriverString( byval rgText as UINT16 ptr, byval length as long, byval pFont as CGpFont ptr, byval pBrush as CGpBrush ptr, byval positions as any ptr, byval flags as long, byval pMatrix as CGpMatrix ptr = NULL ) as GpStatus
```

Draws characters or glyphs at positions you give, one `GpPointF` per character in the
`positions` array, with no layout of its own. `flags` combines `DriverStringOptions*` values:
`DriverStringOptionsCmapLookup` treats `rgText` as characters rather than glyph indices,
`DriverStringOptionsRealizedAdvance` uses only the first position and advances by the font's
widths, `DriverStringOptionsVertical` draws top to bottom. `pMatrix`, when given, transforms
each glyph.

| Parameter | Meaning |
| --- | --- |
| `rgText`, `length` | The UTF-16 text or glyph indices and their count. |
| `pFont`, `pBrush` | The font and the fill brush. |
| `positions` | An array of `GpPointF`, the origin of each character. |
| `flags` | `DriverStringOptions*` flags. |
| `pMatrix` | An optional transformation for the glyphs. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim w as wstring * 4 = "AB"
dim xy(1) as GpPointF = { (10, 40), (40, 40) }
dim fnt as CGpFont = CGpFont( "Segoe UI", 16 )
dim ink as CGpSolidBrush = CGpSolidBrush( ARGB_Black )
g.DrawDriverString( cast( UINT16 ptr, @w ), 2, @fnt, @ink, @xy(0), DriverStringOptionsCmapLookup )
```

Microsoft Learn: [Graphics::DrawDriverString](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawdriverstring)

### MeasureDriverString

```freebasic
function MeasureDriverString( byval pText as UINT16 ptr, byval length as long, byval pFont as CGpFont ptr, byval positions as any ptr, byval flags as long, byval pMatrix as CGpMatrix ptr, byval boundingBox as GpRectF ptr ) as GpStatus
function MeasureDriverString( byval pText as UINT16 ptr, byval length as long, byval pFont as CGpFont ptr, byval positions as any ptr, byval flags as long, byval pMatrix as CGpMatrix ptr = NULL ) as GpRectF
```

Returns the rectangle that [DrawDriverString](#drawdriverstring) would cover with the same
arguments, without drawing. `pMatrix` may be `NULL`. The first form writes the rectangle to
`boundingBox` and returns the status; the second returns the rectangle, and `GetLastStatus()`
tells whether it is valid.

**Returns** the status, or the bounding rectangle.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim w as wstring * 4 = "AB"
dim xy(1) as GpPointF = { (10, 40), (40, 40) }
dim fnt as CGpFont = CGpFont( "Segoe UI", 16 )
dim box as GpRectF = g.MeasureDriverString( cast( UINT16 ptr, @w ), 2, @fnt, @xy(0), DriverStringOptionsCmapLookup )
```

Microsoft Learn: [Graphics::MeasureDriverString](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-measuredriverstring)

### DrawCachedBitmap

```freebasic
function DrawCachedBitmap( byval gpCachedBitmap as CGpCachedBitmap ptr, byval x as long, byval y as long ) as GpStatus
```

Draws a cached bitmap with its top-left corner at (`x`, `y`). A cached bitmap is a copy of a
bitmap already converted to the format of one particular surface, so it draws quickly but
cannot be scaled; it fails with `WrongState` when this surface's format differs from the one it
was made for. `NULL` is passed on to GDI+, which rejects it.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim bmp as CGpBitmap = CGpBitmap( 32, 32 )
dim cached as CGpCachedBitmap = CGpCachedBitmap( @bmp, @g )
g.DrawCachedBitmap( @cached, 10, 10 )
```

Microsoft Learn: [Graphics::DrawCachedBitmap](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawcachedbitmap)

### DrawImage

```freebasic
function DrawImage( byval pImage as CGpImage ptr, byval pt as GpPointF ptr ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval x as single, byval y as single ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval rcf as GpRectF ptr ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval pt as GpPoint ptr ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval x as INT_, byval y as INT_ ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval x as INT_, byval y as INT_, byval nWidth as INT_, byval nHeight as INT_ ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval rc as GpRect ptr ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destPoints as GpPointF ptr, byval nCount as INT_ ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destPoints as GpPoint ptr, byval nCount as INT_ ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval x as single, byval y as single, byval srcx as single, byval srcy as single, byval srcwidth as single, byval srcheight as single, byval srcUnit as gpUnit ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval x as single, byval y as single, byval srcrect as GpRectF ptr, byval srcUnit as GpUnit ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval x as INT_, byval y as INT_, byval srcrect as GpRect ptr, byval srcUnit as GpUnit ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destRect as GpRectF ptr, byval srcx as single, byval srcy as single, byval srcwidth as single, byval srcheight as single, byval srcUnit as GpUnit, byval pImageAttributes as CGpImageAttributes ptr = NULL, byval pcallback as DrawImageAbort = NULL, byval pcallbackData as any ptr = NULL ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destRect as GpRect ptr, byval srcx as INT_, byval srcy as INT_, byval srcwidth as INT_, byval srcheight as INT_, byval srcUnit as GpUnit, byval pImageAttributes as CGpImageAttributes ptr = NULL, byval pcallback as DrawImageAbort = NULL, byval pcallbackData as any ptr = NULL ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destPoints as GpPointF ptr, byval nCount as INT_, byval srcx as single, byval srcy as single, byval srcwidth as single, byval srcheight as single, byval srcUnit as GpUnit, byval pImageAttributes as CGpImageAttributes ptr = NULL, byval pcallback as DrawImageAbort = NULL, byval pcallbackData as any ptr = NULL ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destPoints as GpPoint ptr, byval nCount as INT_, byval srcx as INT_, byval srcy as INT_, byval srcwidth as INT_, byval srcheight as INT_, byval srcUnit as GpUnit, byval pImageAttributes as CGpImageAttributes ptr = NULL, byval pcallback as DrawImageAbort = NULL, byval pcallbackData as any ptr = NULL ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destx as single, byval desty as single, byval destWidth as single, byval destHeight as single, byval srcx as single, byval srcy as single, byval srcwidth as single, byval srcheight as single, byval srcUnit as GpUnit, byval pImageAttributes as CGpImageAttributes ptr = NULL, byval pcallback as DrawImageAbort = NULL, byval pcallbackData as any ptr = NULL ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destRect as GpRectF ptr, byval sourceRect as GpRectF ptr, byval srcUnit as GpUnit, byval pImageAttributes as CGpImageAttributes ptr = NULL ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destRect as GpRect ptr, byval sourceRect as GpRect ptr, byval srcUnit as GpUnit, byval pImageAttributes as CGpImageAttributes ptr = NULL ) as GpStatus
function DrawImage( byval pImage as CGpImage ptr, byval destx as single, byval desty as single, byval destWidth as single, byval destHeight as single, byval srcx as single, byval srcy as single, byval srcWidth as single, byval srcHeight as single, byval srcUnit as GpUnit, byval pImageAttributes as CGpImageAttributes ptr = NULL ) as GpStatus
```

Draws an image ([CGpImage, CGpBitmap or a metafile](SysWin-GdiPlus-Images)) or part of it. The
forms fall into four groups:

- **At a point** (`pt`, or `x`, `y`): the whole image with its top-left corner there, at its
  physical size, which comes from its own resolution. A 96-DPI image on a 96-DPI surface keeps
  its pixel size; give a width and height to be sure of it.
- **In a rectangle** (`x`, `y`, `nWidth`, `nHeight`, or `rcf` / `rc`): the whole image,
  stretched or shrunk to fill it. [SetInterpolationMode](#getinterpolationmode-setinterpolationmode)
  sets the quality.
- **On a parallelogram** (`destPoints`, `nCount`): the upper-left, upper-right and lower-left
  corners of the destination, so the image can be skewed, rotated or mirrored. `nCount` must
  be 3; any count other than 3 or 4 returns `InvalidParameter` without calling GDI+, and GDI+
  answers 4 with `NotImplemented`.
- **Part of the image** (the forms with `srcx`, `srcy`, `srcwidth`, `srcheight`, `srcrect` or
  `sourceRect`): only that source rectangle, measured in `srcUnit` (usually `UnitPixel`), is
  drawn at the point, in the rectangle or on the parallelogram. These forms can also take a
  [CGpImageAttributes](CGpImageAttributes) to recolour the image (colour matrix, gamma,
  transparent colour key). `pcallback` and `pcallbackData` are passed on to GDI+ as given.

| Parameter | Meaning |
| --- | --- |
| `pImage` | The image to draw. |
| `pt`, `x`, `y` | The top-left corner of the destination. |
| `nWidth`, `nHeight`, `rcf`, `rc`, `destRect`, `destx` … `destHeight` | The destination rectangle. |
| `destPoints`, `nCount` | The destination parallelogram and its point count. |
| `srcx`, `srcy`, `srcwidth`, `srcheight`, `srcrect`, `sourceRect` | The part of the image to draw. |
| `srcUnit` | The unit of the source rectangle. |
| `pImageAttributes` | Optional colour adjustments; `NULL` for none. |
| `pcallback`, `pcallbackData` | Passed on to GDI+. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim img as CGpImage = CGpImage( "photo.png" )
if img.GetLastStatus() = Ok then
    g.SetInterpolationMode( InterpolationModeHighQualityBicubic )
    g.DrawImage( @img, 10.0!, 10.0!, 160.0!, 120.0! )
end if
```

Microsoft Learn: [Graphics::DrawImage](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawimage%28image_real_real_real_real%29)

### DrawImageFX

```freebasic
function DrawImageFX( byval pImage as CGpImage ptr, byval sourceRect as GpRectF ptr, byval pMatrix as CGpMatrix ptr, byval pEffect as CGpEffect ptr, byval pImageAttributes as CGpImageAttributes ptr, byval srcUnit as GpUnit ) as GpStatus
```

Draws the `sourceRect` part of an image through an [effect](SysWin-GdiPlus-Effects) (blur,
sharpen, tint, colour balance …) and the transformation `pMatrix`, which places it on the
surface. `pMatrix` must be a real [CGpMatrix](CGpMatrix): pass an identity matrix for no
transformation. `pEffect` and `pImageAttributes` may be `NULL`.

| Parameter | Meaning |
| --- | --- |
| `pImage` | The image. |
| `sourceRect` | The part of the image to draw, in `srcUnit`. |
| `pMatrix` | The transformation from the source rectangle to the surface. |
| `pEffect` | The effect to apply, or `NULL`. |
| `pImageAttributes` | Colour adjustments, or `NULL`. |
| `srcUnit` | The unit of `sourceRect`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim bmp as CGpBitmap = CGpBitmap( 100, 100 )
dim blur as CGpBlur
blur.SetParameters( 5, FALSE )
dim m as CGpMatrix                         ' identity
dim src as GpRectF = type<GpRectF>( 0, 0, 100, 100 )
g.DrawImageFX( @bmp, @src, @m, @blur, NULL, UnitPixel )
```

Microsoft Learn: [Graphics::DrawImage](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-drawimage%28image_rectf_matrix_effect_imageattributes_unit%29)

### EnumerateMetafileDestPoint, EnumerateMetafileDestRect, EnumerateMetafileDestPoints

```freebasic
function EnumerateMetafileDestPoint( byval pMetafile as CGpMetafile ptr, byval destPoint as GpPointF ptr, byval pCallback as EnumerateMetafileProc = NULL, byval pCallbackData as any ptr = NULL, byval pImageAttributes as CGpImageAttributes ptr = NULL ) as GpStatus
function EnumerateMetafileDestRect( byval pMetafile as CGpMetafile ptr, byval destRect as GpRectF ptr, byval pCallback as EnumerateMetafileProc, byval pCallbackData as any ptr = NULL, byval pImageAttributes as CGpImageAttributes ptr = NULL ) as GpStatus
function EnumerateMetafileDestPoints( byval pMetafile as CGpMetafile ptr, byval destPoints as GpPointF ptr, byval nCount as long, byval pCallback as EnumerateMetafileProc, byval pCallbackData as any ptr = NULL, byval pImageAttributes as CGpImageAttributes ptr = NULL ) as GpStatus
```

Walks through the records of a metafile placed at `destPoint`, in `destRect` or on the
parallelogram `destPoints`, and calls `pCallback` once per record with its type, flags, size and
data. To display the metafile while you inspect it, call the metafile's `PlayRecord` from the
callback; return `TRUE` to go on, `FALSE` to stop. A callback is required: with `NULL`, the
default of `EnumerateMetafileDestPoint`, GDI+ returns `InvalidParameter`.

| Parameter | Meaning |
| --- | --- |
| `pMetafile` | The metafile. |
| `destPoint`, `destRect`, `destPoints`, `nCount` | Where the metafile is placed. |
| `pCallback` | The function called for each record. |
| `pCallbackData` | Passed to the callback as its last argument. |
| `pImageAttributes` | Colour adjustments, or `NULL`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
function CountRecord( byval recordType as EmfPlusRecordType, byval flags as UINT, byval dataSize as UINT, byval pData as const UBYTE ptr, byval pUser as any ptr ) as BOOL
    *cast( long ptr, pUser ) += 1
    return TRUE
end function

sub CountRecords( byval g as CGpGraphics ptr, byval pMeta as CGpMetafile ptr )
    dim as long n
    dim pt as GpPointF = type<GpPointF>( 0, 0 )
    g->EnumerateMetafileDestPoint( pMeta, @pt, @CountRecord, @n )
    print n; " records"
end sub
```

Microsoft Learn: [Graphics::EnumerateMetafile](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-enumeratemetafile%28constmetafile_constpointf__enumeratemetafileproc_void_constimageattributes%29)

### EnumerateMetafileSrcRectDestPoint, EnumerateMetafileSrcRectDestRect, EnumerateMetafileSrcRectDestPoints

```freebasic
function EnumerateMetafileSrcRectDestPoint( byval pMetafile as CGpMetafile ptr, byval destPoint as GpPointF ptr, byval srcRect as GpRectF ptr, byval srcUnit as GpUnit, byval pCallback as EnumerateMetafileProc, byval pCallbackData as any ptr = NULL, byval pImageAttributes as CGpImageAttributes ptr = NULL ) as GpStatus
function EnumerateMetafileSrcRectDestRect( byval pMetafile as CGpMetafile ptr, byval destRect as GpRectF ptr, byval srcRect as GpRectF ptr, byval srcUnit as GpUnit, byval pCallback as EnumerateMetafileProc, byval pCallbackData as any ptr = NULL, byval pImageAttributes as CGpImageAttributes ptr = NULL ) as GpStatus
function EnumerateMetafileSrcRectDestPoints( byval pMetafile as CGpMetafile ptr, byval destPoints as GpPointF ptr, byval nCount as INT_, byval srcRect as GpRectF ptr, byval srcUnit as GpUnit, byval pCallback as EnumerateMetafileProc, byval pCallbackData as any ptr = NULL, byval pImageAttributes as CGpImageAttributes ptr = NULL ) as GpStatus
```

The same as the three calls above, for the part of the metafile inside `srcRect`, measured in
`srcUnit`.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
function OnRecord( byval recordType as EmfPlusRecordType, byval flags as UINT, byval dataSize as UINT, byval pData as const UBYTE ptr, byval pUser as any ptr ) as BOOL
    return TRUE
end function

sub EnumTopLeft( byval g as CGpGraphics ptr, byval pMeta as CGpMetafile ptr )
    dim src as GpRectF = type<GpRectF>( 0, 0, 50, 50 )
    dim dst as GpRectF = type<GpRectF>( 0, 0, 100, 100 )
    g->EnumerateMetafileSrcRectDestRect( pMeta, @dst, @src, UnitPixel, @OnRecord )
end sub
```

Microsoft Learn: [Graphics::EnumerateMetafile](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-enumeratemetafile%28constmetafile_constrectf__constrectf__unit_enumeratemetafileproc_void_constimageattributes%29)

### SetClip

```freebasic
function SetClip( byval pGraphics as CGpGraphics ptr, byval nCombineMode as CombineMode = CombineModeReplace ) as GpStatus
function SetClip( byval rc as GpRectF ptr, byval nCombineMode as CombineMode = CombineModeReplace ) as GpStatus
function SetClip( byval rc as GpRect ptr, byval nCombineMode as CombineMode = CombineModeReplace ) as GpStatus
function SetClip( byval x as single, byval y as single, byval nWidth as single, byval nHeight as single, byval nCombineMode as CombineMode = CombineModeReplace ) as GpStatus
function SetClip( byval x as INT_, byval y as INT_, byval nWidth as INT_, byval nHeight as INT_, byval nCombineMode as CombineMode = CombineModeReplace ) as GpStatus
function SetClip( byval pPath as CGpGraphicsPath_ ptr, byval nCombineMode as CombineMode = CombineModeReplace ) as GpStatus
function SetClip( byval pRegion as CGpRegion ptr, byval nCombineMode as CombineMode = CombineModeReplace ) as GpStatus
function SetClip( byval hRgn as HRGN, byval nCombineMode as CombineMode = CombineModeReplace ) as GpStatus
```

Sets the clipping region, the area drawing is limited to, from the clip of another surface, a
rectangle, a path, a region or a GDI `HRGN`. `CombineModeReplace` (the default) makes it the new
clip; `CombineModeIntersect`, `CombineModeUnion`, `CombineModeXor`, `CombineModeExclude` and
`CombineModeComplement` combine it with the current one. The shapes are in world coordinates,
except the `HRGN`, which is taken as device pixels and not transformed. A path that is not
closed is treated as closed.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetClip( 10.0!, 10.0!, 50.0!, 20.0! )
dim br as CGpSolidBrush = CGpSolidBrush( ARGB_Red )
g.FillEllipse( @br, 0, 0, 100, 100 )        ' only the 50 x 20 strip shows
```

Microsoft Learn: [Graphics::SetClip](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-setclip%28constrectf__combinemode%29)

### IntersectClip

```freebasic
function IntersectClip( byval rcf as GpRectF ptr ) as GpStatus
function IntersectClip( byval rc as GpRect ptr ) as GpStatus
function IntersectClip( byval pRegion as CGpRegion ptr ) as GpStatus
function IntersectClip( byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as GpStatus
```

Narrows the clipping region to the part that is also inside the rectangle or region: `SetClip`
with `CombineModeIntersect`. Clipping to (0, 0, 20, 20) and then to (10, 10, 20, 20) leaves
(10, 10, 10, 10).

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.IntersectClip( 0.0!, 0.0!, 20.0!, 20.0! )
g.IntersectClip( 10.0!, 10.0!, 20.0!, 20.0! )
```

Microsoft Learn: [Graphics::IntersectClip](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-intersectclip%28constrectf_%29)

### ExcludeClip

```freebasic
function ExcludeClip( byval rcf as GpRectF ptr ) as GpStatus
function ExcludeClip( byval rc as GpRect ptr ) as GpStatus
function ExcludeClip( byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as GpStatus
function ExcludeClip( byval pRegion as CGpRegion ptr ) as GpStatus
```

Takes the rectangle or region out of the clipping region, so that later drawing leaves it alone:
`SetClip` with `CombineModeExclude`.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.ExcludeClip( 40.0!, 40.0!, 20.0!, 20.0! )   ' leave a hole
g.Clear( ARGB_Silver )
```

Microsoft Learn: [Graphics::ExcludeClip](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-excludeclip%28constrectf_%29)

### ResetClip

```freebasic
function ResetClip() as GpStatus
```

Removes all clipping: the clipping region becomes infinite again.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetClip( 0.0!, 0.0!, 10.0!, 10.0! )
g.ResetClip()
```

Microsoft Learn: [Graphics::ResetClip](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-resetclip)

### TranslateClip

```freebasic
function TranslateClip( byval dx as single, byval dy as single ) as GpStatus
```

Moves the clipping region by `dx`, `dy` without changing its shape.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetClip( 5.0!, 5.0!, 10.0!, 10.0! )
g.TranslateClip( 10, 0 )                    ' now at (15, 5)
```

Microsoft Learn: [Graphics::TranslateClip](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-translateclip%28real_real%29)

### GetClip

```freebasic
function GetClip( byval pRegion as CGpRegion ptr ) as GpStatus
```

Copies the clipping region into an existing [CGpRegion](CGpRegion).

**Returns** `Ok` on success, otherwise the error; `InvalidParameter` when `pRegion` is `NULL`.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim rgn as CGpRegion
g.GetClip( @rgn )
```

Microsoft Learn: [Graphics::GetClip](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-getclip)

### GetClipBounds

```freebasic
function GetClipBounds( byval rc as GpRectF ptr ) as GpStatus
function GetClipBounds( byval rc as GpRect ptr ) as GpStatus
```

Writes the smallest rectangle that encloses the clipping region, in world coordinates, to `rc`.
With no clip set the region is infinite, and the rectangle is very large: left and top
-4194304, width and height 8388608.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetClip( 10.0!, 10.0!, 50.0!, 20.0! )
dim rc as GpRectF
g.GetClipBounds( @rc )                      ' 10, 10, 50, 20
```

Microsoft Learn: [Graphics::GetClipBounds](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-getclipbounds%28rectf%29)

### IsClipEmpty

```freebasic
function IsClipEmpty() as boolean
```

Tells whether the clipping region is empty, so that nothing drawn would show; for example
after excluding the whole of it.

**Returns** `true` when the clip is empty.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
g.SetClip( 10.0!, 10.0!, 50.0!, 20.0! )
g.ExcludeClip( 10.0!, 10.0!, 50.0!, 20.0! )
print g.IsClipEmpty()                       ' true
```

Microsoft Learn: [Graphics::IsClipEmpty](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-isclipempty)

### GetVisibleClipBounds

```freebasic
function GetVisibleClipBounds( byval rc as GpRectF ptr ) as GpStatus
function GetVisibleClipBounds( byval rc as GpRect ptr ) as GpStatus
```

Writes the rectangle around the *visible* clipping region to `rc`: the clipping region cut down
to the device's own area (the window's client area, the bitmap). With no clip on a 200 × 100
bitmap it is (0, 0, 200, 100).

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim rc as GpRect
g.GetVisibleClipBounds( @rc )
print rc.Width; " x"; rc.Height
```

Microsoft Learn: [Graphics::GetVisibleClipBounds](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-getvisibleclipbounds%28rectf%29)

### IsVisibleClipEmpty

```freebasic
function IsVisibleClipEmpty() as boolean
```

Tells whether the visible clipping region is empty: whether anything drawn now could show at
all.

**Returns** `true` when it is empty.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
if g.IsVisibleClipEmpty() = false then g.Clear( ARGB_White )
```

Microsoft Learn: [Graphics::IsVisibleClipEmpty](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-isvisibleclipempty)

### IsVisible

```freebasic
function IsVisible( byval pt as GpPointF ptr ) as boolean
function IsVisible( byval pt as GpPoint ptr ) as boolean
function IsVisible( byval x as single, byval y as single ) as boolean
function IsVisible( byval rcf as GpRectF ptr ) as boolean
function IsVisible( byval rc as GpRect ptr ) as boolean
function IsVisible( byval x as single, byval y as single, byval nWidth as single, byval nHeight as single ) as boolean
```

Tells whether a point, or any part of a rectangle, lies inside the visible clipping region. Use
it to skip drawing things that would not show.

**Returns** `true` when the point or part of the rectangle is visible.

**Example**

```freebasic
dim bmp as CGpBitmap = CGpBitmap( 200, 100 )
dim g as CGpGraphics = @bmp
print g.IsVisible( 10.0!, 10.0! ); g.IsVisible( 500.0!, 10.0! )   ' true false
```

Microsoft Learn: [Graphics::IsVisible](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-isvisible%28real_real%29)

### Save, Restore

```freebasic
function Save() as GraphicsState
function Restore( byval gstate as GraphicsState ) as GpStatus
```

`Save` records the transformations, the clipping region and the quality settings, and returns a
value that identifies the record; `Restore` puts them back. Records stack: restoring one also
discards every `Save` and [BeginContainer](#begincontainer-endcontainer) made after it.

**Returns** (`Save`) the state to pass to `Restore`; (`Restore`) `Ok` or the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim st as GraphicsState = g.Save()
g.TranslateTransform( 10, 20 )
g.Restore( st )                             ' back to no translation
```

Microsoft Learn: [Graphics::Save](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-save), [Graphics::Restore](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-restore)

### BeginContainer, EndContainer

```freebasic
function BeginContainer() as GraphicsContainer
function BeginContainer( byval destrect as GpRectF ptr, byval srcrect as GpRectF ptr, byval nUnit as GpUnit ) as GraphicsContainer
function BeginContainer( byval destrect as GpRect ptr, byval srcrect as GpRect ptr, byval nUnit as GpUnit ) as GraphicsContainer
function EndContainer( byval state as GraphicsContainer ) as GpStatus
```

A container is a nested drawing state: inside it you can change transformations, clipping and
quality settings freely, and `EndContainer` puts back everything as it was at `BeginContainer`.
Unlike [Save](#save-restore), the container starts with a clean world transformation of its
own, which combines with the outer one. The second and third forms also map `srcrect`
(measured in `nUnit`) onto `destrect`, so a drawing made for one rectangle fills another.
Containers nest, and share one stack with `Save`.

**Returns** (`BeginContainer`) the container to pass to `EndContainer`; (`EndContainer`) `Ok`
or the error.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim c as GraphicsContainer = g.BeginContainer()
g.RotateTransform( 30 )
dim pen as CGpPen = CGpPen( ARGB_Red, 2 )
g.DrawRectangle( @pen, 100, 0, 60, 30 )
g.EndContainer( c )
```

Microsoft Learn: [Graphics::BeginContainer](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-begincontainer-r3), [Graphics::EndContainer](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-endcontainer)

### AddMetafileComment

```freebasic
function AddMetafileComment( byval pdata as byte ptr, byval sizeData as UINT ) as GpStatus
```

Adds `sizeData` bytes of private data as a comment record to the metafile this surface is
recording. It applies only to a `CGpGraphics` made from a metafile being recorded.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim hdcRef as HDC = GetDC( hwnd )
dim meta as CGpMetafile = CGpMetafile( hdcRef )
dim g as CGpGraphics = cast( CGpImage ptr, @meta )
dim note as string = "made by tiko"
g.AddMetafileComment( cast( byte ptr, strptr( note ) ), len( note ) )
```

Microsoft Learn: [Graphics::AddMetafileComment](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-addmetafilecomment)

### GetHalftonePalette

```freebasic
function GetHalftonePalette() as HPALETTE
```

Creates a GDI halftone palette, for drawing images on 8-bit palette displays: select it into
the DC and realise it before drawing. The palette does not depend on this surface, and the call
does not record a status. The caller owns the palette and must free it with `DeleteObject`.

**Returns** the new palette.

**Example**

```freebasic
dim g as CGpGraphics = hwnd
dim hPal as HPALETTE = g.GetHalftonePalette()
DeleteObject( hPal )
```

Microsoft Learn: [Graphics::GetHalftonePalette](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-gethalftonepalette)

## See also

- [sys/win/gdiplus](SysWin-GdiPlus) for the module and the classes it holds
- [GDI+ procedures](SysWin-GdiPlus-Procedures) for `Init`, `Uninit` and the colour helpers
- [CGpPen](CGpPen), [brushes](SysWin-GdiPlus-Brushes) and [fonts](SysWin-GdiPlus-Fonts) for
  what the drawing methods take
- [CGpGraphicsPath](CGpGraphicsPath), [CGpRegion](CGpRegion) and [CGpMatrix](CGpMatrix)
- [Images](SysWin-GdiPlus-Images), [CGpImageAttributes](CGpImageAttributes) and
  [effects](SysWin-GdiPlus-Effects) for drawing pictures
- [CGpStringFormat](CGpStringFormat) for text layout
- [CGraphCtx](CGraphCtx), a control with a memory DC to draw on
- [Display, screen and DPI](SysWin-Display-and-DPI)
