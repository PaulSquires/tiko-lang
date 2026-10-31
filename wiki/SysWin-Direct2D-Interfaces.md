[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/direct2d](SysWin-Direct2D) › **Direct2D interfaces and types**

# Direct2D interfaces and types

Lists the Direct2D interfaces, structures and enumerations that sys/win/direct2d declares.

These are the Windows Direct2D declarations themselves, from Direct2D 1.0 to the latest
`ID2D1Factory8`, the built-in effects and the SVG interfaces, so any method Microsoft documents
can be called. The [wrapper classes](SysWin-Direct2D) hold the most used ones and release them
for you; this page is for everything else.

**Interfaces.** Each interface is a type that extends its base interface and declares the
methods in their vtable order, down to `ComUnknown`, the `IUnknown` of `sys/win/com`. The type
itself is named with a trailing underscore, `ID2D1Factory_`, and the plain name is an alias of
it, so write `ID2D1Factory ptr`. Call methods with `->`: `pFactory->CreateEllipseGeometry( ... )`.
A pointer converts to its base interface on its own, so an `ID2D1SolidColorBrush ptr` can be
passed where an `ID2D1Brush ptr` is wanted. Every interface you are handed — by a factory, a
`Create` method or `QueryInterface` — holds a reference you must give back with
`->Release()` or [D2D1_SafeRelease](SysWin-Direct2D-Helpers#d2d1_saferelease).

Each interface has its identifier as a shared `GUID`, `IID_` followed by its name
(`IID_ID2D1Factory1`), for `D2D1CreateFactory` and `QueryInterface`.

**Methods that return a structure.** Where the Windows method returns a structure by value
(`GetSize`, `GetPixelSize`, `GetPixelFormat`, `GetColor` …), the tiko declaration is a `sub`
that fills a variable you pass: `pTarget->GetSize( sz )`.

**Out parameters.** An interface a method creates comes back through a `byref` pointer
argument; pass the pointer variable itself, as in the example below.

`IDWriteTextFormat`, `IDWriteFontFace`, `IWICBitmap`, `IWICBitmapSource`, `IDXGISurface` and
the other DirectWrite, WIC and DXGI names that Direct2D methods take are declared on their own
pages: [DirectWrite interfaces](SysWin-DirectWrite-Interfaces), [WIC interfaces](SysWin-WIC-Interfaces)
and [DXGI interfaces](SysWin-DXGI-Interfaces).

## Importing

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d
```

## Example

A factory, a geometry measured without any window, and a newer factory interface asked for
with `QueryInterface`:

```freebasic
#import "sys/win"
#import "sys/win/direct2d"
using win, direct2d

dim pFactory as ID2D1Factory ptr
if D2D1CreateFactory( D2D1_FACTORY_TYPE_SINGLE_THREADED, IID_ID2D1Factory, byval NULL, pFactory ) <> S_OK then end 1

' a factory resource: an ellipse geometry, measured without any window
dim pEllipse as ID2D1EllipseGeometry ptr
pFactory->CreateEllipseGeometry( D2D1_EllipseF( 100, 100, 50, 25 ), pEllipse )

dim bounds as D2D1_RECT_F, area as single
pEllipse->GetBounds( D2D1_IdentityMatrix(), bounds )
pEllipse->ComputeArea( D2D1_IdentityMatrix(), D2D1_DEFAULT_FLATTENING_TOLERANCE, area )
print "bounds"; bounds.left; bounds.top; bounds.right; bounds.bottom
print "area"; int( area )

' the same interface under a newer version: ask the factory for ID2D1Factory1
dim pFactory1 as ID2D1Factory1 ptr
if pFactory->QueryInterface( @IID_ID2D1Factory1, cast( any ptr ptr, @pFactory1 ) ) = S_OK then print "ID2D1Factory1 available"

D2D1_SafeRelease( pFactory1 )
D2D1_SafeRelease( pEllipse )
D2D1_SafeRelease( pFactory )
```

On Windows 11 it prints:

```
bounds 50 75 150 125
area 3910
ID2D1Factory1 available
```

The area is a little under π · 50 · 25 ≈ 3927 because the ellipse is measured as flattened
line segments.

## Types

### Interfaces

**Direct2D 1.0**

| Interface | Declared as | Extends | Wrapper | What it is |
| --- | --- | --- | --- | --- |
| [`ID2D1Resource`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1resource) | `ID2D1Resource_` | `ComUnknown` |  | Base of every Direct2D resource; reports the factory that made it. |
| [`ID2D1Image`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1image) | `ID2D1Image_` | `ID2D1Resource` |  | Base of anything that can be drawn as an image: bitmaps, effects, command lists. |
| [`ID2D1Bitmap`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1bitmap) | `ID2D1Bitmap_` | `ID2D1Image` | [Bitmaps](SysWin-Direct2D-Bitmaps) | A bitmap bound to a render target. |
| [`ID2D1GradientStopCollection`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1gradientstopcollection) | `ID2D1GradientStopCollection_` | `ID2D1Resource` | [Brushes](SysWin-Direct2D-Brushes) | The colours and positions of a gradient, shared by gradient brushes. |
| [`ID2D1Brush`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1brush) | `ID2D1Brush_` | `ID2D1Resource` |  | Base of all brushes: opacity and brush transform. |
| [`ID2D1BitmapBrush`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1bitmapbrush) | `ID2D1BitmapBrush_` | `ID2D1Brush` | [Brushes](SysWin-Direct2D-Brushes) | Paints with a bitmap, tiled or clamped. |
| [`ID2D1SolidColorBrush`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1solidcolorbrush) | `ID2D1SolidColorBrush_` | `ID2D1Brush` | [Brushes](SysWin-Direct2D-Brushes) | Paints with one colour. |
| [`ID2D1LinearGradientBrush`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1lineargradientbrush) | `ID2D1LinearGradientBrush_` | `ID2D1Brush` | [Brushes](SysWin-Direct2D-Brushes) | Paints a gradient along a line. |
| [`ID2D1RadialGradientBrush`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1radialgradientbrush) | `ID2D1RadialGradientBrush_` | `ID2D1Brush` | [Brushes](SysWin-Direct2D-Brushes) | Paints a gradient out from a centre to an ellipse. |
| [`ID2D1StrokeStyle`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1strokestyle) | `ID2D1StrokeStyle_` | `ID2D1Resource` | [Stroke styles](SysWin-Direct2D-Stroke-Styles) | Caps, joins and dashes used when an outline is stroked. |
| [`ID2D1Geometry`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1geometry) | `ID2D1Geometry_` | `ID2D1Resource` | [CID2D1Geometry](CID2D1Geometry) | Base of all geometries: bounds, hit tests, combining, measuring. |
| [`ID2D1RectangleGeometry`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1rectanglegeometry) | `ID2D1RectangleGeometry_` | `ID2D1Geometry` | [Geometries](SysWin-Direct2D-Geometries) | A rectangle as a geometry. |
| [`ID2D1RoundedRectangleGeometry`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1roundedrectanglegeometry) | `ID2D1RoundedRectangleGeometry_` | `ID2D1Geometry` | [Geometries](SysWin-Direct2D-Geometries) | A rounded rectangle as a geometry. |
| [`ID2D1EllipseGeometry`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1ellipsegeometry) | `ID2D1EllipseGeometry_` | `ID2D1Geometry` | [Geometries](SysWin-Direct2D-Geometries) | An ellipse as a geometry. |
| [`ID2D1GeometryGroup`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1geometrygroup) | `ID2D1GeometryGroup_` | `ID2D1Geometry` | [Geometries](SysWin-Direct2D-Geometries) | Several geometries filled as one. |
| [`ID2D1TransformedGeometry`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1transformedgeometry) | `ID2D1TransformedGeometry_` | `ID2D1Geometry` | [Geometries](SysWin-Direct2D-Geometries) | Another geometry seen through a transform. |
| [`ID2D1SimplifiedGeometrySink`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1simplifiedgeometrysink) | `ID2D1SimplifiedGeometrySink_` | `ComUnknown` | [Geometries](SysWin-Direct2D-Geometries) | Receives lines and Bézier curves describing a geometry. |
| [`ID2D1GeometrySink`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1geometrysink) | `ID2D1GeometrySink_` | `ID2D1SimplifiedGeometrySink` | [Geometries](SysWin-Direct2D-Geometries) | Receives figures of lines, arcs and curves; fills a path geometry. |
| [`ID2D1TessellationSink`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1tessellationsink) | `ID2D1TessellationSink_` | `ComUnknown` |  | Receives the triangles of a tessellated geometry. |
| [`ID2D1PathGeometry`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1pathgeometry) | `ID2D1PathGeometry_` | `ID2D1Geometry` | [Geometries](SysWin-Direct2D-Geometries) | A geometry built from figures written through a geometry sink. |
| [`ID2D1Mesh`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1mesh) | `ID2D1Mesh_` | `ID2D1Resource` |  | A set of triangles, filled with a brush. |
| [`ID2D1Layer`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1layer) | `ID2D1Layer_` | `ID2D1Resource` |  | Off-screen surface used to clip, mask or fade a group of drawing calls. |
| [`ID2D1DrawingStateBlock`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1drawingstateblock) | `ID2D1DrawingStateBlock_` | `ID2D1Resource` | [Render targets](SysWin-Direct2D-Render-Targets) | Saved antialias mode, tags, transform and text parameters of a render target. |
| [`ID2D1RenderTarget`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1rendertarget) | `ID2D1RenderTarget_` | `ID2D1Resource` | [CID2D1RenderTarget](CID2D1RenderTarget) | Base of all render targets: makes resources and draws. |
| [`ID2D1BitmapRenderTarget`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1bitmaprendertarget) | `ID2D1BitmapRenderTarget_` | `ID2D1RenderTarget` | [Render targets](SysWin-Direct2D-Render-Targets) | Off-screen render target whose result is read back as a bitmap. |
| [`ID2D1HwndRenderTarget`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1hwndrendertarget) | `ID2D1HwndRenderTarget_` | `ID2D1RenderTarget` | [Render targets](SysWin-Direct2D-Render-Targets) | Renders into a window. |
| [`ID2D1GdiInteropRenderTarget`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1gdiinteroprendertarget) | `ID2D1GdiInteropRenderTarget_` | `ComUnknown` | [Render targets](SysWin-Direct2D-Render-Targets) | Lends a GDI device context for a render target, for mixed drawing. |
| [`ID2D1DCRenderTarget`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1dcrendertarget) | `ID2D1DCRenderTarget_` | `ID2D1RenderTarget` | [Render targets](SysWin-Direct2D-Render-Targets) | Renders into a GDI device context. |
| [`ID2D1Factory`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nn-d2d1-id2d1factory) | `ID2D1Factory_` | `ComUnknown` | [CD2D1Factory](CD2D1Factory) | Creates render targets, geometries, stroke styles and drawing state blocks. |

**Direct2D 1.1 (Windows 8)**

| Interface | Declared as | Extends | Wrapper | What it is |
| --- | --- | --- | --- | --- |
| [`ID2D1GdiMetafileSink`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1gdimetafilesink) | `ID2D1GdiMetafileSink_` | `ComUnknown` |  | Receives the records of an enhanced metafile. |
| [`ID2D1GdiMetafile`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1gdimetafile) | `ID2D1GdiMetafile_` | `ID2D1Resource` |  | An enhanced metafile that can be drawn. |
| [`ID2D1CommandSink`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1commandsink) | `ID2D1CommandSink_` | `ComUnknown` |  | Receives the drawing commands played back from a command list. |
| [`ID2D1CommandList`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1commandlist) | `ID2D1CommandList_` | `ID2D1Image` |  | Records drawing commands to replay or stream later. |
| [`ID2D1PrintControl`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1printcontrol) | `ID2D1PrintControl_` | `ComUnknown` |  | Sends Direct2D drawing to a print document target. |
| [`ID2D1ImageBrush`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1imagebrush) | `ID2D1ImageBrush_` | `ID2D1Brush` | [Brushes](SysWin-Direct2D-Brushes) | Paints with any image, not only a bitmap. |
| [`ID2D1BitmapBrush1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1bitmapbrush1) | `ID2D1BitmapBrush1_` | `ID2D1BitmapBrush` | [Brushes](SysWin-Direct2D-Brushes) | Bitmap brush with high-quality interpolation modes. |
| [`ID2D1StrokeStyle1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1strokestyle1) | `ID2D1StrokeStyle1_` | `ID2D1StrokeStyle` | [Stroke styles](SysWin-Direct2D-Stroke-Styles) | Stroke style that can keep a fixed width under transforms. |
| [`ID2D1PathGeometry1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1pathgeometry1) | `ID2D1PathGeometry1_` | `ID2D1PathGeometry` | [Geometries](SysWin-Direct2D-Geometries) | Path geometry that can report a point and tangent along its length. |
| [`ID2D1Properties`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1properties) | `ID2D1Properties_` | `ComUnknown` |  | Reads and sets the named, typed properties of an effect. |
| [`ID2D1Effect`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1effect) | `ID2D1Effect_` | `ID2D1Properties` |  | An image effect: inputs, properties and an output image. |
| [`ID2D1Bitmap1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1bitmap1) | `ID2D1Bitmap1_` | `ID2D1Bitmap` | [Bitmaps](SysWin-Direct2D-Bitmaps) | Bitmap with options, colour context and CPU mapping. |
| [`ID2D1ColorContext`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1colorcontext) | `ID2D1ColorContext_` | `ID2D1Resource` | [Bitmaps](SysWin-Direct2D-Bitmaps) | A colour space, from an ICC profile or a known space. |
| [`ID2D1GradientStopCollection1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1gradientstopcollection1) | `ID2D1GradientStopCollection1_` | `ID2D1GradientStopCollection` | [Brushes](SysWin-Direct2D-Brushes) | Gradient stops with colour-space and buffer-precision control. |
| [`ID2D1DrawingStateBlock1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1drawingstateblock1) | `ID2D1DrawingStateBlock1_` | `ID2D1DrawingStateBlock` | [Render targets](SysWin-Direct2D-Render-Targets) | Drawing state with primitive blend and unit mode. |
| [`ID2D1DeviceContext`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1devicecontext) | `ID2D1DeviceContext_` | `ID2D1RenderTarget` |  | Render target for effects, command lists and DXGI surfaces. |
| [`ID2D1Device`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1device) | `ID2D1Device_` | `ID2D1Resource` |  | A Direct2D device over a DXGI device; makes device contexts. |
| [`ID2D1Factory1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1factory1) | `ID2D1Factory1_` | `ID2D1Factory` | [CD2D1Factory](CD2D1Factory) (`CD2D1Factory1`) | Factory that makes devices, registers custom effects and makes Direct2D 1.1 resources. |
| [`ID2D1Multithread`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nn-d2d1_1-id2d1multithread) | `ID2D1Multithread_` | `ComUnknown` | [Stroke styles and multithreading](SysWin-Direct2D-Stroke-Styles) | Locks a multithreaded factory against other threads. |

**Direct2D 1.2 (Windows 8.1)**

| Interface | Declared as | Extends | Wrapper | What it is |
| --- | --- | --- | --- | --- |
| [`ID2D1GeometryRealization`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_2/nn-d2d1_2-id2d1geometryrealization) | `ID2D1GeometryRealization_` | `ID2D1Resource` |  | A geometry pre-tessellated for fast repeated drawing. |
| [`ID2D1DeviceContext1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_2/nn-d2d1_2-id2d1devicecontext1) | `ID2D1DeviceContext1_` | `ID2D1DeviceContext` |  | Device context that makes and draws geometry realizations. |
| [`ID2D1Device1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_2/nn-d2d1_2-id2d1device1) | `ID2D1Device1_` | `ID2D1Device` |  | Device with a rendering priority. |
| [`ID2D1Factory2`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_2/nn-d2d1_2-id2d1factory2) | `ID2D1Factory2_` | `ID2D1Factory1` | [CD2D1Factory](CD2D1Factory) (`CD2D1Factory2`) | Factory that makes ID2D1Device1 devices. |
| [`ID2D1CommandSink1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_2/nn-d2d1_2-id2d1commandsink1) | `ID2D1CommandSink1_` | `ID2D1CommandSink` |  | Command sink that receives primitive blend changes. |

**Direct2D 1.3 and later (Windows 10 and 11)**

| Interface | Declared as | Extends | Wrapper | What it is |
| --- | --- | --- | --- | --- |
| [`ID2D1InkStyle`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1inkstyle) | `ID2D1InkStyle_` | `ID2D1Resource` |  | The nib shape and transform of ink strokes. |
| [`ID2D1Ink`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1ink) | `ID2D1Ink_` | `ID2D1Resource` |  | An ink stroke of variable width. |
| [`ID2D1GradientMesh`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1gradientmesh) | `ID2D1GradientMesh_` | `ID2D1Resource` |  | A gradient mesh of tensor patches. |
| [`ID2D1ImageSource`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1imagesource) | `ID2D1ImageSource_` | `ID2D1Image` |  | An image source that can release and reload its memory. |
| [`ID2D1ImageSourceFromWic`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1imagesourcefromwic) | `ID2D1ImageSourceFromWic_` | `ID2D1ImageSource` |  | Image source made from a WIC bitmap source, decoded on demand. |
| [`ID2D1TransformedImageSource`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1transformedimagesource) | `ID2D1TransformedImageSource_` | `ID2D1Image` |  | An image source drawn scaled and oriented. |
| [`ID2D1LookupTable3D`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1lookuptable3d) | `ID2D1LookupTable3D_` | `ID2D1Resource` |  | A 3D colour lookup table for the lookup-table effect. |
| [`ID2D1DeviceContext2`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1devicecontext2) | `ID2D1DeviceContext2_` | `ID2D1DeviceContext1` |  | Device context for ink, gradient meshes and image sources. |
| [`ID2D1Device2`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1device2) | `ID2D1Device2_` | `ID2D1Device1` |  | Device that flushes its contexts and returns its DXGI device. |
| [`ID2D1Factory3`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1factory3) | `ID2D1Factory3_` | `ID2D1Factory2` | [CD2D1Factory](CD2D1Factory) (`CD2D1Factory3`) | Factory that makes ID2D1Device2 devices. |
| [`ID2D1CommandSink2`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1commandsink2) | `ID2D1CommandSink2_` | `ID2D1CommandSink1` |  | Command sink that receives ink, gradient mesh and metafile commands. |
| [`ID2D1GdiMetafile1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1gdimetafile1) | `ID2D1GdiMetafile1_` | `ID2D1GdiMetafile` |  | Enhanced metafile with DPI and source bounds. |
| [`ID2D1GdiMetafileSink1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1gdimetafilesink1) | `ID2D1GdiMetafileSink1_` | `ID2D1GdiMetafileSink` |  | Metafile sink that also receives record flags. |
| [`ID2D1SpriteBatch`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1spritebatch) | `ID2D1SpriteBatch_` | `ID2D1Resource` |  | A batch of sprites from one bitmap, drawn in one call. |
| [`ID2D1DeviceContext3`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1devicecontext3) | `ID2D1DeviceContext3_` | `ID2D1DeviceContext2` |  | Device context that makes and draws sprite batches. |
| [`ID2D1Device3`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1device3) | `ID2D1Device3_` | `ID2D1Device2` |  | Device that makes ID2D1DeviceContext3 contexts. |
| [`ID2D1Factory4`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1factory4) | `ID2D1Factory4_` | `ID2D1Factory3` | [CD2D1Factory](CD2D1Factory) (`CD2D1Factory4`) | Factory that makes ID2D1Device3 devices. |
| [`ID2D1CommandSink3`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1commandsink3) | `ID2D1CommandSink3_` | `ID2D1CommandSink2` |  | Command sink that receives sprite batch commands. |
| [`ID2D1SvgGlyphStyle`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1svgglyphstyle) | `ID2D1SvgGlyphStyle_` | `ID2D1Resource` |  | Fill and stroke used for SVG colour glyphs. |
| [`ID2D1DeviceContext4`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1devicecontext4) | `ID2D1DeviceContext4_` | `ID2D1DeviceContext3` |  | Device context that draws colour and SVG glyphs. |
| [`ID2D1Device4`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1device4) | `ID2D1Device4_` | `ID2D1Device3` |  | Device with a limit on its colour glyph cache. |
| [`ID2D1Factory5`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1factory5) | `ID2D1Factory5_` | `ID2D1Factory4` | [CD2D1Factory](CD2D1Factory) (`CD2D1Factory5`) | Factory that makes ID2D1Device4 devices. |
| [`ID2D1CommandSink4`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1commandsink4) | `ID2D1CommandSink4_` | `ID2D1CommandSink3` |  | Command sink that receives the extended primitive blend modes. |
| [`ID2D1ColorContext1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1colorcontext1) | `ID2D1ColorContext1_` | `ID2D1ColorContext` | [Bitmaps](SysWin-Direct2D-Bitmaps) | Colour context from a DXGI colour space or a simple profile. |
| [`ID2D1DeviceContext5`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1devicecontext5) | `ID2D1DeviceContext5_` | `ID2D1DeviceContext4` |  | Device context that makes and draws SVG documents and makes colour contexts. |
| [`ID2D1Device5`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1device5) | `ID2D1Device5_` | `ID2D1Device4` |  | Device that makes ID2D1DeviceContext5 contexts. |
| [`ID2D1Factory6`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1factory6) | `ID2D1Factory6_` | `ID2D1Factory5` | [CD2D1Factory](CD2D1Factory) (`CD2D1Factory6`) | Factory that makes ID2D1Device5 devices. |
| [`ID2D1CommandSink5`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1commandsink5) | `ID2D1CommandSink5_` | `ID2D1CommandSink4` |  | Command sink that receives blend-image commands. |
| [`ID2D1DeviceContext6`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1devicecontext6) | `ID2D1DeviceContext6_` | `ID2D1DeviceContext5` |  | Device context that draws an image with a blend mode. |
| [`ID2D1Device6`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1device6) | `ID2D1Device6_` | `ID2D1Device5` |  | Device that makes ID2D1DeviceContext6 contexts. |
| [`ID2D1Factory7`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1factory7) | `ID2D1Factory7_` | `ID2D1Factory6` | [CD2D1Factory](CD2D1Factory) (`CD2D1Factory7`) | Factory that makes ID2D1Device6 devices. |
| [`ID2D1DeviceContext7`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1devicecontext7) | `ID2D1DeviceContext7_` | `ID2D1DeviceContext6` |  | Device context with paint feature levels for COLR fonts. |
| [`ID2D1Device7`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1device7) | `ID2D1Device7_` | `ID2D1Device6` |  | Device that makes ID2D1DeviceContext7 contexts. |
| [`ID2D1Factory8`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nn-d2d1_3-id2d1factory8) | `ID2D1Factory8_` | `ID2D1Factory7` | [CD2D1Factory](CD2D1Factory) (`CD2D1Factory8`) | Factory that makes ID2D1Device7 devices. |

**Custom effects**

| Interface | Declared as | Extends | Wrapper | What it is |
| --- | --- | --- | --- | --- |
| [`ID2D1VertexBuffer`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1vertexbuffer) | `ID2D1VertexBuffer_` | `ComUnknown` |  | Vertex data for a custom effect transform. |
| [`ID2D1ResourceTexture`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1resourcetexture) | `ID2D1ResourceTexture_` | `ComUnknown` |  | Texture data a custom effect shader can read. |
| [`ID2D1RenderInfo`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1renderinfo) | `ID2D1RenderInfo_` | `ComUnknown` |  | Base of the render information a transform fills in. |
| [`ID2D1DrawInfo`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1drawinfo) | `ID2D1DrawInfo_` | `ID2D1RenderInfo` |  | Pixel and vertex shader set-up of a draw transform. |
| [`ID2D1ComputeInfo`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1computeinfo) | `ID2D1ComputeInfo_` | `ID2D1RenderInfo` |  | Compute shader set-up of a compute transform. |
| [`ID2D1TransformNode`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1transformnode) | `ID2D1TransformNode_` | `ComUnknown` |  | Base of a node in an effect's transform graph. |
| [`ID2D1TransformGraph`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1transformgraph) | `ID2D1TransformGraph_` | `ComUnknown` |  | The graph of transforms a custom effect is built from. |
| [`ID2D1Transform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1transform) | `ID2D1Transform_` | `ID2D1TransformNode` |  | A transform node that maps rectangles between input and output. |
| [`ID2D1DrawTransform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1drawtransform) | `ID2D1DrawTransform_` | `ID2D1Transform` |  | Transform that renders with a pixel or vertex shader. |
| [`ID2D1ComputeTransform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1computetransform) | `ID2D1ComputeTransform_` | `ID2D1Transform` |  | Transform that renders with a compute shader. |
| [`ID2D1AnalysisTransform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1analysistransform) | `ID2D1AnalysisTransform_` | `ComUnknown` |  | Transform that receives its input's analysis data. |
| [`ID2D1SourceTransform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1sourcetransform) | `ID2D1SourceTransform_` | `ID2D1Transform` |  | Transform that produces image data on the CPU. |
| [`ID2D1ConcreteTransform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1concretetransform) | `ID2D1ConcreteTransform_` | `ID2D1TransformNode` |  | Built-in transform node with output buffer settings. |
| [`ID2D1BlendTransform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1blendtransform) | `ID2D1BlendTransform_` | `ID2D1ConcreteTransform` |  | Built-in transform that blends its inputs. |
| [`ID2D1BorderTransform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1bordertransform) | `ID2D1BorderTransform_` | `ID2D1ConcreteTransform` |  | Built-in transform that extends its input's edges. |
| [`ID2D1OffsetTransform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1offsettransform) | `ID2D1OffsetTransform_` | `ID2D1TransformNode` |  | Built-in transform that shifts its input by whole pixels. |
| [`ID2D1BoundsAdjustmentTransform`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1boundsadjustmenttransform) | `ID2D1BoundsAdjustmentTransform_` | `ID2D1TransformNode` |  | Built-in transform that changes its input's bounds. |
| [`ID2D1EffectImpl`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1effectimpl) | `ID2D1EffectImpl_` | `ComUnknown` |  | What a custom effect implements to be hosted by Direct2D. |
| [`ID2D1EffectContext`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nn-d2d1effectauthor-id2d1effectcontext) | `ID2D1EffectContext_` | `ComUnknown` |  | The services Direct2D gives a custom effect while it runs. |
| [`ID2D1EffectContext1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor_1/nn-d2d1effectauthor_1-id2d1effectcontext1) | (same) | `ID2D1EffectContext` |  | Effect context that can make 3D lookup tables. |
| [`ID2D1EffectContext2`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor_1/) | (same) | `ID2D1EffectContext1` |  | Effect context with colour contexts from DXGI spaces and simple profiles. |

**SVG**

| Interface | Declared as | Extends | Wrapper | What it is |
| --- | --- | --- | --- | --- |
| [`ID2D1SvgAttribute`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/nn-d2d1svg-id2d1svgattribute) | `ID2D1SvgAttribute_` | `ID2D1Resource` |  | Base of the object-valued SVG attributes. |
| [`ID2D1SvgPaint`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/nn-d2d1svg-id2d1svgpaint) | `ID2D1SvgPaint_` | `ID2D1SvgAttribute` |  | An SVG fill or stroke paint. |
| [`ID2D1SvgStrokeDashArray`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/nn-d2d1svg-id2d1svgstrokedasharray) | `ID2D1SvgStrokeDashArray_` | `ID2D1SvgAttribute` |  | An SVG stroke-dasharray value. |
| [`ID2D1SvgPointCollection`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/nn-d2d1svg-id2d1svgpointcollection) | `ID2D1SvgPointCollection_` | `ID2D1SvgAttribute` |  | The points of an SVG polyline or polygon. |
| [`ID2D1SvgPathData`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/nn-d2d1svg-id2d1svgpathdata) | `ID2D1SvgPathData_` | `ID2D1SvgAttribute` |  | The data of an SVG path element. |
| [`ID2D1SvgElement`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/nn-d2d1svg-id2d1svgelement) | `ID2D1SvgElement_` | `ID2D1Resource` |  | An element of an SVG document tree. |
| [`ID2D1SvgDocument`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/nn-d2d1svg-id2d1svgdocument) | `ID2D1SvgDocument_` | `ID2D1Resource` |  | An SVG document that can be drawn and edited. |

### Structures

| Structure | What it holds |
| --- | --- |
| [`D3DCOLORVALUE`](https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/d3dcolorvalue) | A colour as four floats, red, green, blue and alpha, each 0 to 1; `D2D1_COLOR_F` is this type. |
| [`D2D_MATRIX_3X2_F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_matrix_3x2_f) | A 2D affine transform (`D2D1_MATRIX_3X2_F`). |
| [`D2D_MATRIX_4X3_F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_matrix_4x3_f) | A 4 × 3 matrix (`D2D1_MATRIX_4X3_F`). |
| [`D2D_MATRIX_4X4_F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_matrix_4x4_f) | A 4 × 4 matrix for 3D transforms (`D2D1_MATRIX_4X4_F`). |
| [`D2D_MATRIX_5X4_F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_matrix_5x4_f) | A 5 × 4 matrix, as used by the colour matrix effect (`D2D1_MATRIX_5X4_F`). |
| [`D2D_POINT_2F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_point_2f) | A point with `single` coordinates (`D2D1_POINT_2F`). |
| [`D2D_POINT_2U`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_point_2u) | A point with unsigned 32-bit coordinates (`D2D1_POINT_2U`). |
| [`D2D_RECT_F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_rect_f) | A rectangle with `single` edges (`D2D1_RECT_F`). |
| [`D2D_RECT_U`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_rect_u) | A rectangle with unsigned 32-bit edges (`D2D1_RECT_U`). |
| [`D2D_SIZE_F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_size_f) | A width and height as `single` (`D2D1_SIZE_F`). |
| [`D2D_SIZE_U`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_size_u) | A width and height as unsigned 32-bit values (`D2D1_SIZE_U`). |
| [`D2D_VECTOR_2F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_vector_2f) | Two `single` components (`D2D1_VECTOR_2F`). |
| [`D2D_VECTOR_3F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_vector_3f) | Three `single` components (`D2D1_VECTOR_3F`). |
| [`D2D_VECTOR_4F`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d_vector_4f) | Four `single` components (`D2D1_VECTOR_4F`). |
| [`DXGI_RATIONAL`](https://learn.microsoft.com/en-us/windows/win32/api/dxgicommon/ns-dxgicommon-dxgi_rational) | A rational number, numerator over denominator, such as a refresh rate. |
| [`DXGI_SAMPLE_DESC`](https://learn.microsoft.com/en-us/windows/win32/api/dxgicommon/ns-dxgicommon-dxgi_sample_desc) | Multisampling count and quality of a resource. |
| [`DXGI_RGB`](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/bb173071%28v%3Dvs.85%29) | Red, green and blue as floats, used in gamma control. |
| [`DXGI_GAMMA_CONTROL`](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/bb173061%28v%3Dvs.85%29) | A gamma curve with scale and offset for an output. |
| [`DXGI_GAMMA_CONTROL_CAPABILITIES`](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/bb173062%28v%3Dvs.85%29) | The gamma control an output supports. |
| [`DXGI_MODE_DESC`](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/bb173064%28v%3Dvs.85%29) | A display mode: size, refresh rate, format, scan-line order and scaling. |
| [`DXGI_JPEG_DC_HUFFMAN_TABLE`](https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dxgi-jpeg-dc-huffman-table) | A JPEG DC Huffman table. |
| [`DXGI_JPEG_AC_HUFFMAN_TABLE`](https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dxgi-jpeg-ac-huffman-table) | A JPEG AC Huffman table. |
| [`DXGI_JPEG_QUANTIZATION_TABLE`](https://learn.microsoft.com/en-us/windows/win32/direct3ddxgi/dxgi-jpeg-quantization-table) | A JPEG quantization table. |
| [`D2D1_PIXEL_FORMAT`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ns-dcommon-d2d1_pixel_format) | A pixel format and alpha mode for bitmaps and render targets. |
| [`DWRITE_GLYPH_OFFSET`](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_glyph_offset) | How far one glyph is moved from its normal position. |
| [`DWRITE_GLYPH_RUN`](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ns-dwrite-dwrite_glyph_run) | A run of glyphs of one font face and size, for `DrawGlyphRun`. |
| [`D2D1_BITMAP_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_bitmap_properties) | Pixel format and DPI of a bitmap. |
| [`D2D1_GRADIENT_STOP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_gradient_stop) | One colour of a gradient and where it sits, 0 to 1. |
| [`D2D1_BRUSH_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_brush_properties) | Opacity and transform of a brush. |
| [`D2D1_BITMAP_BRUSH_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_bitmap_brush_properties) | Extend modes and interpolation of a bitmap brush. |
| [`D2D1_LINEAR_GRADIENT_BRUSH_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_linear_gradient_brush_properties) | Start and end points of a linear gradient. |
| [`D2D1_RADIAL_GRADIENT_BRUSH_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_radial_gradient_brush_properties) | Centre, origin offset and radii of a radial gradient. |
| [`D2D1_BEZIER_SEGMENT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_bezier_segment) | A cubic Bézier segment: two control points and an end point. |
| [`D2D1_TRIANGLE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_triangle) | Three points of a triangle, as a tessellation sink receives them. |
| [`D2D1_ARC_SEGMENT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_arc_segment) | An elliptical arc segment: end point, radii, rotation, direction and size. |
| [`D2D1_QUADRATIC_BEZIER_SEGMENT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_quadratic_bezier_segment) | A quadratic Bézier segment: one control point and an end point. |
| [`D2D1_ELLIPSE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_ellipse) | An ellipse: centre and two radii. |
| [`D2D1_ROUNDED_RECT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_rounded_rect) | A rectangle and the radii of its corners. |
| [`D2D1_STROKE_STYLE_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_stroke_style_properties) | Caps, line join, miter limit and dash style of a stroke style. |
| [`D2D1_LAYER_PARAMETERS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_layer_parameters) | Bounds, mask, opacity and options of a layer being pushed. |
| [`D2D1_RENDER_TARGET_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_render_target_properties) | Type, pixel format, DPI, usage and minimum feature level of a render target. |
| [`D2D1_HWND_RENDER_TARGET_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_hwnd_render_target_properties) | The window, pixel size and present options of a window render target. |
| [`D2D1_DRAWING_STATE_DESCRIPTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_drawing_state_description) | Antialias modes, tags and transform saved by a drawing state block. |
| [`D2D1_FACTORY_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ns-d2d1-d2d1_factory_options) | The debug level asked for when a factory is created. |
| [`D2D1_BITMAP_PROPERTIES1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_bitmap_properties1) | Pixel format, DPI, options and colour context of an ID2D1Bitmap1. |
| [`D2D1_MAPPED_RECT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_mapped_rect) | Pitch and pointer of a bitmap mapped for CPU access. |
| [`D2D1_RENDERING_CONTROLS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_rendering_controls) | Buffer precision and tile size a device context renders with. |
| [`D2D1_EFFECT_INPUT_DESCRIPTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_effect_input_description) | An effect, one of its inputs and a rectangle on that input. |
| [`D2D1_POINT_DESCRIPTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_point_description) | A point along a path, its tangent and which segment and figure it is on. |
| [`D2D1_IMAGE_BRUSH_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_image_brush_properties) | Source rectangle, extend modes and interpolation of an image brush. |
| [`D2D1_BITMAP_BRUSH_PROPERTIES1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_bitmap_brush_properties1) | Extend modes and interpolation of an ID2D1BitmapBrush1. |
| [`D2D1_STROKE_STYLE_PROPERTIES1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_stroke_style_properties1) | Stroke style properties plus the stroke transform type. |
| [`D2D1_LAYER_PARAMETERS1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_layer_parameters1) | Layer parameters with the Direct2D 1.1 layer options. |
| [`D2D1_DRAWING_STATE_DESCRIPTION1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_drawing_state_description1) | Drawing state plus primitive blend and unit mode. |
| [`D2D1_PRINT_CONTROL_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_print_control_properties) | Font subsetting, raster DPI and colour space of a print control. |
| [`D2D1_CREATION_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ns-d2d1_1-d2d1_creation_properties) | Threading mode, debug level and options for a device or device context. |
| [`D2D1_TRANSFORMED_IMAGE_SOURCE_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ns-d2d1_3-d2d1_transformed_image_source_properties) | Orientation, scale, interpolation and options of a transformed image source. |
| [`D2D1_INK_POINT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ns-d2d1_3-d2d1_ink_point) | A point of an ink stroke and its radius. |
| [`D2D1_INK_BEZIER_SEGMENT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ns-d2d1_3-d2d1_ink_bezier_segment) | A cubic Bézier segment of an ink stroke. |
| [`D2D1_INK_STYLE_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ns-d2d1_3-d2d1_ink_style_properties) | Nib shape and nib transform of an ink style. |
| [`D2D1_GRADIENT_MESH_PATCH`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ns-d2d1_3-d2d1_gradient_mesh_patch) | One tensor patch of a gradient mesh: 16 points, 4 corner colours, 4 edge modes. |
| [`D2D1_SIMPLE_COLOR_PROFILE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ns-d2d1_3-d2d1_simple_color_profile) | A colour profile given by primaries, white point and gamma. |
| [`D2D1_PROPERTY_BINDING_`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_property_binding) | Binds a custom effect property name to its get and set functions (`D2D1_PROPERTY_BINDING`). |
| [`D2D1_RESOURCE_TEXTURE_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_resource_texture_properties) | Size, precision, filter and extend modes of a resource texture. |
| [`D2D1_INPUT_ELEMENT_DESC`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_input_element_desc) | One element of a custom vertex layout. |
| [`D2D1_VERTEX_BUFFER_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_vertex_buffer_properties) | Count, usage and data of a vertex buffer. |
| [`D2D1_CUSTOM_VERTEX_BUFFER_PROPERTIES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_custom_vertex_buffer_properties) | Shader signature and layout of a custom vertex buffer. |
| [`D2D1_VERTEX_RANGE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_vertex_range) | First vertex and count of a range in a vertex buffer. |
| [`D2D1_BLEND_DESCRIPTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_blend_description) | The blend state a draw transform renders with. |
| [`D2D1_INPUT_DESCRIPTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_input_description) | Filter and level of detail for a transform input. |
| [`D2D1_FEATURE_DATA_DOUBLES`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_feature_data_doubles) | Whether the device has double-precision shader operations. |
| [`D2D1_FEATURE_DATA_D3D10_X_HARDWARE_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ns-d2d1effectauthor-d2d1_feature_data_d3d10_x_hardware_options) | Whether the device has compute shaders on Direct3D 10.x hardware. |
| [`D2D1_SVG_LENGTH`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ns-d2d1svg-d2d1_svg_length) | An SVG length: a number and its unit. |
| [`D2D1_SVG_PRESERVE_ASPECT_RATIO`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ns-d2d1svg-d2d1_svg_preserve_aspect_ratio) | The SVG preserveAspectRatio value. |
| [`D2D1_SVG_VIEWBOX`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ns-d2d1svg-d2d1_svg_viewbox) | The SVG viewBox rectangle. |

### Enumerations

Each enumeration is a 32-bit type of that name (`type D2D1_CAP_STYLE as long`) with its constants at module level, so `D2D1_CAP_STYLE_ROUND` is written bare.

| Enumeration | Values for |
| --- | --- |
| [`DXGI_COLOR_SPACE_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/dxgicommon/ne-dxgicommon-dxgi_color_space_type) | Colour spaces of DXGI surfaces: range, gamma, siting and primaries. |
| [`DXGI_FORMAT`](https://learn.microsoft.com/en-us/windows/win32/api/dxgiformat/ne-dxgiformat-dxgi_format) | Pixel and resource formats (`DXGI_FORMAT_B8G8R8A8_UNORM` …). |
| [`DXGI_MODE_SCANLINE_ORDER`](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/bb173067%28v%3Dvs.85%29) | How a display mode draws scan lines. |
| [`DXGI_MODE_SCALING`](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/bb173066%28v%3Dvs.85%29) | How an image is stretched to a display mode. |
| [`DXGI_MODE_ROTATION`](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/bb173065%28v%3Dvs.85%29) | Rotation of an output. |
| [`D3D_FEATURE_LEVEL`](https://learn.microsoft.com/en-us/windows/win32/api/d3dcommon/ne-d3dcommon-d3d_feature_level) | Direct3D feature levels a device can target. |
| [`DWRITE_MEASURING_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ne-dcommon-dwrite_measuring_mode) | How text is measured: natural, GDI classic or GDI natural. |
| [`DWRITE_GLYPH_IMAGE_FORMATS`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ne-dcommon-dwrite_glyph_image_formats) | Image formats a glyph can have (outline, COLR, SVG, PNG …). |
| [`D2D1_ALPHA_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/dcommon/ne-dcommon-d2d1_alpha_mode) | How the alpha channel is read: premultiplied, straight, ignored. |
| [`D2D1_GAMMA`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_gamma) | Gamma space gradient colours are interpolated in. |
| [`D2D1_OPACITY_MASK_CONTENT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_opacity_mask_content) | What an opacity mask holds: graphics or text. |
| [`D2D1_EXTEND_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_extend_mode) | What a brush paints outside its area: clamp, wrap, mirror. |
| [`D2D1_ANTIALIAS_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_antialias_mode) | Antialiasing of geometry edges. |
| [`D2D1_TEXT_ANTIALIAS_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_text_antialias_mode) | Antialiasing of text: ClearType, grayscale, aliased. |
| [`D2D1_BITMAP_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_bitmap_interpolation_mode) | Interpolation when a bitmap is scaled or rotated. |
| [`D2D1_DRAW_TEXT_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_draw_text_options) | Options for drawing text: no snapping, clipping, colour fonts. |
| [`D2D1_ARC_SIZE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_arc_size) | Whether an arc sweeps more or less than 180 degrees. |
| [`D2D1_CAP_STYLE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_cap_style) | Shape at the end of a line or dash. |
| [`D2D1_DASH_STYLE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_dash_style) | Dash pattern of a stroke. |
| [`D2D1_LINE_JOIN`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_line_join) | How two stroked segments are joined. |
| [`D2D1_COMBINE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_combine_mode) | How two geometries are combined: union, intersect, xor, exclude. |
| [`D2D1_GEOMETRY_RELATION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_geometry_relation) | How one geometry relates to another: disjoint, contains … |
| [`D2D1_GEOMETRY_SIMPLIFICATION_OPTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_geometry_simplification_option) | Whether simplification keeps cubic curves or uses lines only. |
| [`D2D1_FIGURE_BEGIN`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_figure_begin) | Whether a new figure is filled or hollow. |
| [`D2D1_FIGURE_END`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_figure_end) | Whether a figure is closed or left open. |
| [`D2D1_PATH_SEGMENT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_path_segment) | Whether a segment is stroked and joined smoothly. |
| [`D2D1_SWEEP_DIRECTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_sweep_direction) | Direction an arc is drawn: clockwise or counter-clockwise. |
| [`D2D1_FILL_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_fill_mode) | Which parts of overlapping figures are inside: alternate or winding. |
| [`D2D1_LAYER_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_layer_options) | Options of a layer, such as ClearType text. |
| [`D2D1_WINDOW_STATE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_window_state) | Whether a window render target's window is occluded. |
| [`D2D1_RENDER_TARGET_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_render_target_type) | Whether a render target uses hardware or software. |
| [`D2D1_FEATURE_LEVEL`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_feature_level) | Minimum Direct3D feature level a render target needs. |
| [`D2D1_RENDER_TARGET_USAGE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_render_target_usage) | How a render target will be used: remoting, GDI compatible. |
| [`D2D1_PRESENT_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_present_options) | How a window render target presents: keep contents, do not wait for vsync. |
| [`D2D1_COMPATIBLE_RENDER_TARGET_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_compatible_render_target_options) | Whether a compatible render target must be GDI compatible. |
| [`D2D1_DC_INITIALIZE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_dc_initialize_mode) | Whether the GDI device context starts with the target's contents or cleared. |
| [`D2D1_DEBUG_LEVEL`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_debug_level) | How much debug output the Direct2D debug layer gives. |
| [`D2D1_FACTORY_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/ne-d2d1-d2d1_factory_type) | Whether a factory is single-threaded or multithreaded. |
| [`DWRITE_FACTORY_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/ne-dwrite-dwrite_factory_type) | Whether a DirectWrite factory is shared or isolated. |
| [`D2D1_PROPERTY_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_property_type) | Data type of an effect property. |
| [`D2D1_PROPERTY`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_property) | Properties every effect has: class id, name, author, inputs … |
| [`D2D1_SUBPROPERTY`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_subproperty) | Sub-properties of an effect property: display name, range, default … |
| [`D2D1_BITMAP_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_bitmap_options) | How an ID2D1Bitmap1 can be used: target, CPU read, GDI compatible … |
| [`D2D1_COMPOSITE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_composite_mode) | Porter-Duff composite modes for drawing an image. |
| [`D2D1_BUFFER_PRECISION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_buffer_precision) | Bits per channel of intermediate buffers. |
| [`D2D1_MAP_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_map_options) | Access asked for when a bitmap is mapped: read, write, discard. |
| [`D2D1_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_interpolation_mode) | Interpolation modes of Direct2D 1.1, cubic and high-quality included. |
| [`D2D1_UNIT_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_unit_mode) | Whether a device context works in DIPs or pixels. |
| [`D2D1_COLOR_SPACE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_color_space) | Colour spaces of colour conversion: custom, sRGB, scRGB. |
| [`D2D1_DEVICE_CONTEXT_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_device_context_options) | Options of a device context, such as multithreaded optimisations. |
| [`D2D1_STROKE_TRANSFORM_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_stroke_transform_type) | Whether a stroke scales with the transform, stays fixed or is a hairline. |
| [`D2D1_PRIMITIVE_BLEND`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_primitive_blend) | How drawn primitives blend with the target: source-over, copy, min, add, max. |
| [`D2D1_THREADING_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_threading_mode) | Threading of a device made with `D2D1CreateDevice`. |
| [`D2D1_COLOR_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_color_interpolation_mode) | Whether gradient colours interpolate straight or premultiplied. |
| [`D2D1_LAYER_OPTIONS1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_layer_options1) | Options of a Direct2D 1.1 layer: initialise from background, ignore alpha. |
| [`D2D1_PRINT_FONT_SUBSET_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/ne-d2d1_1-d2d1_print_font_subset_mode) | How fonts are subset when printing. |
| [`D2D1_RENDERING_PRIORITY`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_2/ne-d2d1_2-d2d1_rendering_priority) | Rendering priority of a device: normal or low. |
| [`D2D1_INK_NIB_SHAPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_ink_nib_shape) | Shape of an ink nib: round or square. |
| [`D2D1_ORIENTATION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_orientation) | Flips and rotations of an image (EXIF orientations). |
| [`D2D1_IMAGE_SOURCE_LOADING_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_image_source_loading_options) | Options for loading an image source from WIC. |
| [`D2D1_IMAGE_SOURCE_FROM_DXGI_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_image_source_from_dxgi_options) | Options for an image source made from DXGI surfaces. |
| [`D2D1_TRANSFORMED_IMAGE_SOURCE_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_transformed_image_source_options) | Options of a transformed image source, such as no DPI scaling. |
| [`D2D1_PATCH_EDGE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_patch_edge_mode) | How an edge of a gradient mesh patch is antialiased. |
| [`D2D1_SPRITE_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_sprite_options) | Options for drawing a sprite batch. |
| [`D2D1_COLOR_BITMAP_GLYPH_SNAP_OPTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_color_bitmap_glyph_snap_option) | Whether colour bitmap glyphs are snapped to pixels. |
| [`D2D1_GAMMA1`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_gamma1) | Gamma of a simple colour profile: 2.2, 1.0 or ST.2084. |
| [`D2D1_COLOR_CONTEXT_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/ne-d2d1_3-d2d1_color_context_type) | Where a colour context comes from: ICC, simple profile, DXGI. |
| [`D2D1_BLEND_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_blend_mode) | Blend modes of the blend effect and `BlendImage`: multiply, screen, darken … |
| [`DWRITE_PAINT_FEATURE_LEVEL`](https://learn.microsoft.com/en-us/windows/windows-app-sdk/api/win32/dwrite_3/ne-dwrite_3-dwrite_paint_feature_level) | Levels of COLR colour-font painting a device context supports. |
| [`D2D1_BORDER_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_border_mode) | Whether an effect softens or keeps hard edges at its output border. |
| [`D2D1_CHANNEL_SELECTOR`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_channel_selector) | A colour channel: R, G, B or A. |
| [`D2D1_BITMAPSOURCE_ORIENTATION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_bitmapsource_orientation) | Orientations the bitmap source effect can apply. |
| [`D2D1_GAUSSIANBLUR_OPTIMIZATION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_gaussianblur_optimization) | Speed and quality trade-off of the Gaussian blur effect. |
| [`D2D1_DIRECTIONALBLUR_OPTIMIZATION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_directionalblur_optimization) | Speed and quality trade-off of the directional blur effect. |
| [`D2D1_SHADOW_OPTIMIZATION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_shadow_optimization) | Speed and quality trade-off of the shadow effect. |
| [`D2D1_COLORMATRIX_ALPHA_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_colormatrix_alpha_mode) | Alpha mode of the colour matrix effect. |
| [`D2D1_BITMAPSOURCE_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_bitmapsource_interpolation_mode) | Interpolation of the bitmap source effect. |
| [`D2D1_BITMAPSOURCE_ALPHA_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_bitmapsource_alpha_mode) | Alpha mode of the bitmap source effect. |
| [`D2D1_3DTRANSFORM_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_3dtransform_interpolation_mode) | Interpolation of the 3D transform effect. |
| [`D2D1_3DPERSPECTIVETRANSFORM_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_3dperspectivetransform_interpolation_mode) | Interpolation of the 3D perspective transform effect. |
| [`D2D1_2DAFFINETRANSFORM_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_2daffinetransform_interpolation_mode) | Interpolation of the 2D affine transform effect. |
| [`D2D1_DPICOMPENSATION_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_dpicompensation_interpolation_mode) | Interpolation of the DPI compensation effect. |
| [`D2D1_SCALE_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_scale_interpolation_mode) | Interpolation of the scale effect. |
| [`D2D1_TURBULENCE_NOISE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_turbulence_noise) | Noise function of the turbulence effect. |
| [`D2D1_COLORMANAGEMENT_ALPHA_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_colormanagement_alpha_mode) | Alpha mode of the colour management effect. |
| [`D2D1_COLORMANAGEMENT_QUALITY`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_colormanagement_quality) | Quality level of the colour management effect. |
| [`D2D1_COLORMANAGEMENT_RENDERING_INTENT`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_colormanagement_rendering_intent) | ICC rendering intent of the colour management effect. |
| [`D2D1_POINTSPECULAR_SCALE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_pointspecular_scale_mode) | Interpolation of the point-specular effect's surface scale. |
| [`D2D1_SPOTSPECULAR_SCALE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_spotspecular_scale_mode) | Interpolation of the spot-specular effect's surface scale. |
| [`D2D1_DISTANTSPECULAR_SCALE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_distantspecular_scale_mode) | Interpolation of the distant-specular effect's surface scale. |
| [`D2D1_POINTDIFFUSE_SCALE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_pointdiffuse_scale_mode) | Interpolation of the point-diffuse effect's surface scale. |
| [`D2D1_SPOTDIFFUSE_SCALE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_spotdiffuse_scale_mode) | Interpolation of the spot-diffuse effect's surface scale. |
| [`D2D1_DISTANTDIFFUSE_SCALE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_distantdiffuse_scale_mode) | Interpolation of the distant-diffuse effect's surface scale. |
| [`D2D1_CONVOLVEMATRIX_SCALE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_convolvematrix_scale_mode) | Interpolation of the convolve matrix effect. |
| [`D2D1_BORDER_EDGE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_border_edge_mode) | How the border effect extends edges: clamp, wrap, mirror. |
| [`D2D1_MORPHOLOGY_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_morphology_mode) | Erode or dilate, for the morphology effect. |
| [`D2D1_YCBCR_CHROMA_SUBSAMPLING`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_1/ne-d2d1effects_1-d2d1_ycbcr_chroma_subsampling) | Chroma subsampling of the YCbCr effect's input. |
| [`D2D1_YCBCR_INTERPOLATION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_1/ne-d2d1effects_1-d2d1_ycbcr_interpolation_mode) | Interpolation of the YCbCr effect. |
| [`D2D1_RGBTOHUE_OUTPUT_COLOR_SPACE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_rgbtohue_output_color_space) | Output space of the RGB-to-hue effect: HSV or HSL. |
| [`D2D1_HUETORGB_INPUT_COLOR_SPACE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_huetorgb_input_color_space) | Input space of the hue-to-RGB effect: HSV or HSL. |
| [`D2D1_STRAIGHTEN_SCALE_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_straighten_scale_mode) | Interpolation of the straighten effect. |
| [`D2D1_EDGEDETECTION_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_edgedetection_mode) | Kernel of the edge detection effect: Sobel or Prewitt. |
| [`D2D1_HIGHLIGHTSANDSHADOWS_INPUT_GAMMA`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_highlightsandshadows_input_gamma) | Gamma of the highlights-and-shadows effect's input. |
| [`D2D1_HDRTONEMAP_DISPLAY_MODE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_hdrtonemap_display_mode) | Display the HDR tone map effect targets: SDR or HDR. |
| [`D2D1_CHANGE_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ne-d2d1effectauthor-d2d1_change_type) | What changed since a custom effect was last prepared. |
| [`D2D1_PIXEL_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ne-d2d1effectauthor-d2d1_pixel_options) | Options of a pixel shader in a draw transform. |
| [`D2D1_VERTEX_OPTIONS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ne-d2d1effectauthor-d2d1_vertex_options) | Options of a vertex buffer in a draw transform. |
| [`D2D1_VERTEX_USAGE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ne-d2d1effectauthor-d2d1_vertex_usage) | Whether a vertex buffer is static or dynamic. |
| [`D2D1_BLEND_OPERATION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ne-d2d1effectauthor-d2d1_blend_operation) | Blend operation of a blend transform: add, subtract, min, max. |
| [`D2D1_BLEND`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ne-d2d1effectauthor-d2d1_blend) | Blend factors of a blend transform. |
| [`D2D1_CHANNEL_DEPTH`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ne-d2d1effectauthor-d2d1_channel_depth) | Number of channels in a transform's output buffer. |
| [`D2D1_FILTER`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ne-d2d1effectauthor-d2d1_filter) | Texture filtering of a transform input. |
| [`D2D1_FEATURE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/ne-d2d1effectauthor-d2d1_feature) | Device features a custom effect can query. |
| [`D2D1_SVG_PAINT_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_paint_type) | Kind of an SVG paint: none, colour, current colour, URI. |
| [`D2D1_SVG_LENGTH_UNITS`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_length_units) | Units of an SVG length: number or percentage. |
| [`D2D1_SVG_DISPLAY`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_display) | The SVG display property: inline or none. |
| [`D2D1_SVG_VISIBILITY`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_visibility) | The SVG visibility property. |
| [`D2D1_SVG_OVERFLOW`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_overflow) | The SVG overflow property. |
| [`D2D1_SVG_LINE_CAP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_line_cap) | The SVG stroke-linecap property. |
| [`D2D1_SVG_LINE_JOIN`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_line_join) | The SVG stroke-linejoin property. |
| [`D2D1_SVG_ASPECT_ALIGN`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_aspect_align) | Alignment part of preserveAspectRatio. |
| [`D2D1_SVG_ASPECT_SCALING`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_aspect_scaling) | Meet or slice part of preserveAspectRatio. |
| [`D2D1_SVG_PATH_COMMAND`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_path_command) | Commands of SVG path data: move, line, curve, arc, close. |
| [`D2D1_SVG_UNIT_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_unit_type) | Coordinate system of SVG units: user space or bounding box. |
| [`D2D1_SVG_ATTRIBUTE_STRING_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_attribute_string_type) | Kind of string an SVG attribute holds. |
| [`D2D1_SVG_ATTRIBUTE_POD_TYPE`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1svg/ne-d2d1svg-d2d1_svg_attribute_pod_type) | Plain data types an SVG attribute can be read as. |

### Effect property indices

One enumeration per built-in effect: the index of each of its properties, for `ID2D1Properties` `SetValue` and `GetValue` (`D2D1_GAUSSIANBLUR_PROP_STANDARD_DEVIATION` …).

| Enumeration | Properties of the |
| --- | --- |
| [`D2D1_GAUSSIANBLUR_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_gaussianblur_prop) | Gaussian blur effect |
| [`D2D1_DIRECTIONALBLUR_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_directionalblur_prop) | directional blur effect |
| [`D2D1_SHADOW_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_shadow_prop) | shadow effect |
| [`D2D1_BLEND_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_blend_prop) | blend effect |
| [`D2D1_SATURATION_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_saturation_prop) | saturation effect |
| [`D2D1_HUEROTATION_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_huerotation_prop) | hue rotation effect |
| [`D2D1_COLORMATRIX_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_colormatrix_prop) | colour matrix effect |
| [`D2D1_BITMAPSOURCE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_bitmapsource_prop) | bitmap source effect |
| [`D2D1_COMPOSITE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_composite_prop) | composite effect |
| [`D2D1_3DTRANSFORM_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_3dtransform_prop) | 3D transform effect |
| [`D2D1_3DPERSPECTIVETRANSFORM_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_3dperspectivetransform_prop) | 3D perspective transform effect |
| [`D2D1_2DAFFINETRANSFORM_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_2daffinetransform_prop) | 2D affine transform effect |
| [`D2D1_DPICOMPENSATION_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_dpicompensation_prop) | DPI compensation effect |
| [`D2D1_SCALE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_scale_prop) | scale effect |
| [`D2D1_TURBULENCE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_turbulence_prop) | turbulence effect |
| [`D2D1_DISPLACEMENTMAP_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_displacementmap_prop) | displacement map effect |
| [`D2D1_COLORMANAGEMENT_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_colormanagement_prop) | colour management effect |
| [`D2D1_HISTOGRAM_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_histogram_prop) | histogram effect |
| [`D2D1_POINTSPECULAR_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_pointspecular_prop) | point-specular lighting effect |
| [`D2D1_SPOTSPECULAR_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_spotspecular_prop) | spot-specular lighting effect |
| [`D2D1_DISTANTSPECULAR_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_distantspecular_prop) | distant-specular lighting effect |
| [`D2D1_POINTDIFFUSE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_pointdiffuse_prop) | point-diffuse lighting effect |
| [`D2D1_SPOTDIFFUSE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_spotdiffuse_prop) | spot-diffuse lighting effect |
| [`D2D1_DISTANTDIFFUSE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_distantdiffuse_prop) | distant-diffuse lighting effect |
| [`D2D1_FLOOD_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_flood_prop) | flood effect |
| [`D2D1_LINEARTRANSFER_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_lineartransfer_prop) | linear transfer effect |
| [`D2D1_GAMMATRANSFER_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_gammatransfer_prop) | gamma transfer effect |
| [`D2D1_TABLETRANSFER_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_tabletransfer_prop) | table transfer effect |
| [`D2D1_DISCRETETRANSFER_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_discretetransfer_prop) | discrete transfer effect |
| [`D2D1_CONVOLVEMATRIX_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_convolvematrix_prop) | convolve matrix effect |
| [`D2D1_BRIGHTNESS_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_brightness_prop) | brightness effect |
| [`D2D1_ARITHMETICCOMPOSITE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_arithmeticcomposite_prop) | arithmetic composite effect |
| [`D2D1_CROP_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_crop_prop) | crop effect |
| [`D2D1_BORDER_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_border_prop) | border effect |
| [`D2D1_MORPHOLOGY_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_morphology_prop) | morphology effect |
| [`D2D1_TILE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_tile_prop) | tile effect |
| [`D2D1_ATLAS_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_atlas_prop) | atlas effect |
| [`D2D1_OPACITYMETADATA_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects/ne-d2d1effects-d2d1_opacitymetadata_prop) | opacity metadata effect |
| [`D2D1_YCBCR_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_1/ne-d2d1effects_1-d2d1_ycbcr_prop) | YCbCr effect |
| [`D2D1_CONTRAST_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_contrast_prop) | contrast effect |
| [`D2D1_RGBTOHUE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_rgbtohue_prop) | RGB-to-hue effect |
| [`D2D1_HUETORGB_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_huetorgb_prop) | hue-to-RGB effect |
| [`D2D1_CHROMAKEY_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_chromakey_prop) | chroma-key effect |
| [`D2D1_EMBOSS_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_emboss_prop) | emboss effect |
| [`D2D1_EXPOSURE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_exposure_prop) | exposure effect |
| [`D2D1_POSTERIZE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_posterize_prop) | posterize effect |
| [`D2D1_SEPIA_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_sepia_prop) | sepia effect |
| [`D2D1_SHARPEN_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_sharpen_prop) | sharpen effect |
| [`D2D1_STRAIGHTEN_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_straighten_prop) | straighten effect |
| [`D2D1_TEMPERATUREANDTINT_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_temperatureandtint_prop) | temperature and tint effect |
| [`D2D1_VIGNETTE_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_vignette_prop) | vignette effect |
| [`D2D1_EDGEDETECTION_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_edgedetection_prop) | edge detection effect |
| [`D2D1_HIGHLIGHTSANDSHADOWS_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_highlightsandshadows_prop) | highlights and shadows effect |
| [`D2D1_LOOKUPTABLE3D_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_lookuptable3d_prop) | 3D lookup table effect |
| [`D2D1_OPACITY_PROP`](https://learn.microsoft.com/en-us/windows/win32/direct2d/opacity-effect) | opacity effect |
| [`D2D1_CROSSFADE_PROP`](https://learn.microsoft.com/en-us/windows/win32/direct2d/cross-fade-effect) | cross-fade effect |
| [`D2D1_TINT_PROP`](https://learn.microsoft.com/en-us/windows/win32/direct2d/tint-effect) | tint effect |
| [`D2D1_WHITELEVELADJUSTMENT_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_whiteleveladjustment_prop) | white level adjustment effect |
| [`D2D1_HDRTONEMAP_PROP`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effects_2/ne-d2d1effects_2-d2d1_hdrtonemap_prop) | HDR tone map effect |

### Callback types

| Type | Is |
| --- | --- |
| [`PD2D1_EFFECT_FACTORY`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nc-d2d1_1-pd2d1_effect_factory) | `function( byref effectImpl as IUnknown ptr ) as HRESULT`: makes an instance of a custom effect, for `RegisterEffectFromString`. |
| [`PD2D1_PROPERTY_SET_FUNCTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nc-d2d1effectauthor-pd2d1_property_set_function) | Sets a custom effect property from raw bytes. |
| [`PD2D1_PROPERTY_GET_FUNCTION`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1effectauthor/nc-d2d1effectauthor-pd2d1_property_get_function) | Reads a custom effect property into raw bytes. |

### Functions

The functions Direct2D itself exports, declared alongside the types. The
[helpers](SysWin-Direct2D-Helpers) call several of them.

| Function | Does |
| --- | --- |
| [`D2D1CreateFactory`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-d2d1createfactory) | `( factoryType, riid, factoryOptions, pIFactory ) as HRESULT`: makes a factory, the start of every Direct2D program. Pass `byval NULL` for the options. |
| [`D2D1MakeRotateMatrix`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-d2d1makerotatematrix) | Fills a 3 × 2 rotation about a point. |
| [`D2D1MakeSkewMatrix`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-d2d1makeskewmatrix) | Fills a 3 × 2 skew about a point. |
| [`D2D1IsMatrixInvertible`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-d2d1ismatrixinvertible) | Tells whether a 3 × 2 matrix can be inverted. |
| [`D2D1InvertMatrix`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1/nf-d2d1-d2d1invertmatrix) | Inverts a 3 × 2 matrix in place; `false` if it cannot. |
| [`D2D1CreateDevice`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-d2d1createdevice) | Makes an `ID2D1Device` over a DXGI device. |
| [`D2D1CreateDeviceContext`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-d2d1createdevicecontext) | Makes an `ID2D1DeviceContext` over a DXGI surface. |
| [`D2D1ConvertColorSpace`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-d2d1convertcolorspace) | Declared as a `sub` with the colour spaces `byref` and the result in a fourth argument; called that way it leaves the result argument at 0 and writes over the source colour-space variable. |
| [`D2D1SinCos`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-d2d1sincos) | Returns the sine and cosine of an angle in radians: `D2D1SinCos( pi / 6, s, c )` gives 0.5 and 0.8660254. |
| [`D2D1Tan`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-d2d1tan) | Returns the tangent of an angle in radians. |
| [`D2D1Vec3Length`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_1/nf-d2d1_1-d2d1vec3length) | Returns the length of a 3D vector: `D2D1Vec3Length( 2, 3, 6 )` is 7. |
| [`D2D1ComputeMaximumScaleFactor`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_2/nf-d2d1_2-d2d1computemaximumscalefactor) | Returns the largest scale a 3 × 2 transform applies in any direction. |
| [`D2D1GetGradientMeshInteriorPointsFromCoonsPatch`](https://learn.microsoft.com/en-us/windows/win32/api/d2d1_3/nf-d2d1_3-d2d1getgradientmeshinteriorpointsfromcoonspatch) | Works out the four inner points of a Coons patch; [D2D1_GradientMeshPatchFromCoonsPatch](SysWin-Direct2D-Helpers#d2d1_gradientmeshpatchfromcoonspatch) calls it. |
| [`DWriteCreateFactory`](https://learn.microsoft.com/en-us/windows/win32/api/dwrite/nf-dwrite-dwritecreatefactory) | Makes a DirectWrite factory, for text formats and layouts. |

## See also

- [sys/win/direct2d](SysWin-Direct2D)
- [Direct2D helpers](SysWin-Direct2D-Helpers) to fill the structures
- [CD2D1Factory](CD2D1Factory), [CID2D1RenderTarget](CID2D1RenderTarget), [CID2D1Geometry](CID2D1Geometry)
- [DirectWrite interfaces](SysWin-DirectWrite-Interfaces), [DXGI interfaces](SysWin-DXGI-Interfaces), [WIC interfaces](SysWin-WIC-Interfaces)
