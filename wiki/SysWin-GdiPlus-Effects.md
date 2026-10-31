[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gdiplus](SysWin-GdiPlus) › **GDI+ effects**

# GDI+ effects
Blurs, sharpens, tints and corrects the colours of bitmaps with the GDI+ effect classes.

<!-- scope: CGpEffect -->
<!-- scope: CGpEFfect -->
<!-- scope: CGpBlur -->
<!-- scope: CGpBrightnessContrast -->
<!-- scope: CGpColorBalance -->
<!-- scope: CGpColorCurve -->
<!-- scope: CGpColorLUT -->
<!-- scope: CGpColorMatrixEffect -->
<!-- scope: CGpHueSaturationLightness -->
<!-- scope: CGpLevels -->
<!-- scope: CGpRedEyeCorrection -->
<!-- scope: CGpSharpen -->
<!-- scope: CGpTint -->

Blurs, sharpens, tints and corrects the colours of bitmaps with the GDI+ effect classes.

Each effect is a class derived from `CGpEffect`. Using one takes three steps:

1. Create it: `dim blur as CGpBlur`. The constructor creates the GDI+ effect object.
2. Set its parameters with `SetParameters`, either as separate values or as the matching
   `…Params` structure. Values outside the documented range are refused with
   `InvalidParameter` and the effect keeps its previous parameters; an effect whose parameters
   were never set uses GDI+'s defaults.
3. Apply it. [CGpBitmap.ApplyEffect](SysWin-GdiPlus-Images#applyeffect) changes the pixels of a
   bitmap in place, all of it or a rectangle of it; [CGpGraphics.DrawImageFX](CGpGraphics#drawimagefx)
   draws an image through the effect and leaves the image as it was.

One effect object can be applied any number of times, to any number of bitmaps, and its
parameters changed in between. The destructor deletes the GDI+ effect.

**Status.** `SetParameters` and `GetParameters` return a `GpStatus`, `Ok` (0) on success, and
every method stores its result for `GetLastStatus()`, so after `dim fx as CGpTint`,
`fx.GetLastStatus()` tells whether the effect was created.

**Colour balance and colour curve.** In this release the constructors of
[CGpColorBalance](#cgpcolorbalance) and [CGpColorCurve](#cgpcolorcurve) do not create a GDI+
effect: `GetLastStatus()` is `Win32Error` (7) afterwards and their other calls return
`InvalidParameter`. Check the status before applying one, as their entries show: passing an
effect without a GDI+ object behind it to `ApplyEffect` stops the program.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus
```

## Example

A console program that paints a bitmap half black and half white, softens the edge between the
two with a blur, darkens the right half only and saves the result:

```freebasic
#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus

function main() as long
    ' black on the left half, white on the right
    dim bmp as CGpBitmap = CGpBitmap( 64, 64, PixelFormat32bppARGB )
    scope
        dim g as CGpGraphics = @bmp
        g.Clear( ARGB_White )
        dim ink as CGpSolidBrush = CGpSolidBrush( ARGB_Black )
        g.FillRectangle( @ink, 0, 0, 32, 64 )
    end scope
    print "before: &h"; hex( bmp.GetPixel( 30, 32 ) ); " &h"; hex( bmp.GetPixel( 33, 32 ) )

    ' soften the edge with a Gaussian blur
    dim blur as CGpBlur
    blur.SetParameters( 4, FALSE )
    if bmp.ApplyEffect( @blur ) <> Ok then return 1
    print "blur:   &h"; hex( bmp.GetPixel( 30, 32 ) ); " &h"; hex( bmp.GetPixel( 33, 32 ) )

    ' darken the right half only
    dim bc as CGpBrightnessContrast
    bc.SetParameters( -100, 0 )
    dim roi as RECT = ( 32, 0, 64, 64 )
    bmp.ApplyEffect( @bc, @roi )
    print "darker: &h"; hex( bmp.GetPixel( 10, 32 ) ); " &h"; hex( bmp.GetPixel( 60, 32 ) )

    dim png as GUID = GetEncoderClsid( "image/png" )
    if bmp.Save( "effects.png", @png, NULL ) = Ok then print "saved effects.png"
    return 0
end function

end main()
```

It prints:

```text
before: &hFF000000 &hFFFFFFFF
blur:   &hFF383838 &hFFC7C7C7
darker: &hFF000000 &hFF9B9B9B
saved effects.png
```

## Members

| Member | Does |
| --- | --- |
| **CGpEffect** | |
| [Constructor](#constructor) | Creates the base part of an effect, with no GDI+ effect. |
| [Destructor](#destructor) | Frees the auxiliary data and deletes the GDI+ effect. |
| [GetEffectPtr](#geteffectptr) | Returns the GDI+ effect handle. |
| [GetParameterSize](#getparametersize) | Returns the size of the effect's parameters in bytes. |
| [UseAuxData](#useauxdata) | Stores a flag that no other call reads. |
| [GetAuxData, GetAuxDataSize](#getauxdata-getauxdatasize) | Return the lookup tables an `ApplyEffect` call left in the object. |
| **CGpBlur** | |
| [Constructor](#constructor-1) | Creates a Gaussian blur. |
| [SetParameters, GetParameters](#setparameters-getparameters) | Set or read the radius and edge handling. |
| **CGpBrightnessContrast** | |
| [Constructor](#constructor-2) | Creates a brightness and contrast adjustment. |
| [SetParameters, GetParameters](#setparameters-getparameters-1) | Set or read the brightness and contrast levels. |
| **CGpColorBalance** | |
| [Constructor](#constructor-3) | Creates a colour balance adjustment. |
| [SetParameters, GetParameters](#setparameters-getparameters-2) | Set or read the cyan-red, magenta-green and yellow-blue shifts. |
| **CGpColorCurve** | |
| [Constructor](#constructor-4) | Creates a tone curve adjustment. |
| [SetParameters, GetParameters](#setparameters-getparameters-3) | Set or read the adjustment, the channel and the amount. |
| **CGpColorLUT** | |
| [Constructor](#constructor-5) | Creates a lookup-table colour mapping. |
| [SetParameters, GetParameters](#setparameters-getparameters-4) | Set or read the four 256-entry tables. |
| **CGpColorMatrixEffect** | |
| [Constructor](#constructor-6) | Creates a colour matrix effect. |
| [SetParameters, GetParameters](#setparameters-getparameters-5) | Set or read the 5 × 5 matrix. |
| **CGpHueSaturationLightness** | |
| [Constructor](#constructor-7) | Creates a hue, saturation and lightness adjustment. |
| [SetParameters, GetParameters](#setparameters-getparameters-6) | Set or read the three levels. |
| **CGpLevels** | |
| [Constructor](#constructor-8) | Creates a highlight, midtone and shadow adjustment. |
| [SetParameters, GetParameters](#setparameters-getparameters-7) | Set or read the three levels. |
| **CGpRedEyeCorrection** | |
| [Constructor](#constructor-9) | Creates a red-eye correction. |
| [SetParameters, GetParameters](#setparameters-getparameters-8) | Set or read the rectangles that hold eyes. |
| **CGpSharpen** | |
| [Constructor](#constructor-10) | Creates a sharpening effect. |
| [SetParameters, GetParameters](#setparameters-getparameters-9) | Set or read the radius and amount. |
| **CGpTint** | |
| [Constructor](#constructor-11) | Creates a tint. |
| [SetParameters, GetParameters](#setparameters-getparameters-10) | Set or read the hue and strength of the tint. |

## Reference

## CGpEffect

The base class of every effect. It holds the GDI+ effect handle and the auxiliary data, and
deletes both in its destructor. A `CGpEffect` made on its own has no GDI+ effect and is of no use;
create one of the derived classes instead.

### Constructor

```freebasic
constructor
```

Leaves the effect handle `NULL`. Each derived class's constructor then creates the GDI+ effect of
its kind.

**Example**

```freebasic
dim fx as CGpEffect
print fx.GetEffectPtr() = NULL      ' -1 (true): the base class creates nothing
```

Microsoft Learn: [Effect](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-effect)

### Destructor

```freebasic
destructor
```

Frees the auxiliary data held in the object, if any (see
[GetAuxData](#getauxdata-getauxdatasize)), and deletes the GDI+ effect. Derived classes have no
destructor of their own and use this one.

**Example**

```freebasic
dim pBlur as CGpBlur ptr = new CGpBlur
pBlur->SetParameters( 3, FALSE )
delete pBlur
```

### GetEffectPtr

```freebasic
function GetEffectPtr() as CGpEffect ptr
```

Returns the handle of the GDI+ effect object, for calling the GDI+ flat functions directly. The
return type says `CGpEffect ptr`, but the value is the GDI+ handle, not the address of a
`CGpEffect`: cast it to `any ptr` and never call a member through it.

**Returns** the handle, or `NULL` when no GDI+ effect was created.

**Example**

```freebasic
dim sharpen as CGpSharpen
dim size as UINT
GdipGetEffectParameterSize( cast( any ptr, sharpen.GetEffectPtr() ), @size )
```

### GetParameterSize

```freebasic
function GetParameterSize() as UINT
```

Returns the size in bytes of the effect's parameters: the buffer size [GetParameters](#setparameters-getparameters)
needs. For most effects it is the size of the `…Params` structure (8 for a blur, 12 for
hue-saturation-lightness, 100 for a colour matrix, 1024 for a lookup table); for a red-eye
correction it grows with the number of rectangles.

**Returns** the size, or 0 on failure (`GetLastStatus()` is then `InvalidParameter`).

**Example**

```freebasic
dim hsl as CGpHueSaturationLightness
hsl.SetParameters( 10, 20, 30 )
print hsl.GetParameterSize()        ' 12
```

Microsoft Learn: [Effect::GetParameterSize](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-effect-getparametersize)

### UseAuxData

```freebasic
sub UseAuxData( byval useAuxDataFlag as BOOL )
```

Stores `useAuxDataFlag` in the object. Nothing reads the flag: `ApplyEffect( @fx )` and
`ApplyEffect( @fx, @roi )` never ask GDI+ for auxiliary data, whatever it says. To get the
lookup tables, use the long form of `ApplyEffect` as [GetAuxData](#getauxdata-getauxdatasize)
shows.

**Example**

```freebasic
dim bc as CGpBrightnessContrast
bc.UseAuxData( TRUE )               ' recorded, but has no effect on ApplyEffect
```

Microsoft Learn: [Effect::UseAuxData](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-effect-useauxdata)

### GetAuxData, GetAuxDataSize

```freebasic
function GetAuxData() as any ptr
function GetAuxDataSize() as INT_
```

Return the auxiliary data held in the object and its size in bytes. For brightness-contrast,
hue-saturation-lightness, levels, colour balance and colour curve, GDI+ can hand back the lookup
tables it built while applying the effect: four tables of 256 bytes, for blue, green, red and
alpha in that order, 1024 bytes in all.

The object only holds them if you ask [ApplyEffect](SysWin-GdiPlus-Images#applyeffect) to store
them there, by passing the addresses of its `m_auxData` and `m_auxDataSize` fields to the long
form. The destructor then frees them; freeing them yourself, or calling the long form again with
the same fields, leaves the destructor freeing a buffer that is gone or loses the first one.

**Returns** the data pointer (`NULL` until `ApplyEffect` stored some) or its size (0 until then).

**Example**

```freebasic
dim bmp as CGpBitmap = CGpBitmap( 16, 16 )
dim bc as CGpBrightnessContrast
bc.SetParameters( 20, 10 )
bmp.ApplyEffect( @bc, NULL, TRUE, @bc.m_auxData, @bc.m_auxDataSize )
print bc.GetAuxDataSize()            ' 1024
dim lutRed as ubyte ptr = cast( ubyte ptr, bc.GetAuxData() ) + 512
```

Microsoft Learn: [Effect::GetAuxData](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-effect-getauxdata), [Effect::GetAuxDataSize](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-effect-getauxdatasize)

## CGpBlur

A Gaussian blur: each pixel becomes a weighted average of the pixels around it.

### Constructor

```freebasic
constructor
```

Creates the GDI+ blur effect. Until `SetParameters` is called it blurs with GDI+'s default
parameters.

**Example**

```freebasic
dim blur as CGpBlur
if blur.GetLastStatus() <> Ok then print "no blur effect"
```

Microsoft Learn: [Blur](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-blur)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as BlurParams ptr ) as GpStatus
function SetParameters( byval radius as single, byval expandEdge as BOOL ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` sets how far the blur reaches and what happens at the edges, from separate values
or from a `BlurParams` structure (`radius`, `expandEdge`). `GetParameters` copies the current
parameters into a `BlurParams`: set the `UINT` that `uSize` points to to the size of the
structure first. A size smaller than the parameters gives `InvalidParameter`.

| Parameter | Meaning |
| --- | --- |
| `radius` | The blur radius in pixels, from 0 to 255. The larger, the blurrier. |
| `expandEdge` | `TRUE` lets the blur spread past the image's edges when the image is drawn with `DrawImageFX`; `FALSE` keeps it inside. `ApplyEffect` never changes a bitmap's size. |
| `params` | A `BlurParams` to read the values from, or to receive them. |
| `uSize` | In: the size of the buffer at `params`. |

**Returns** `Ok` on success; `InvalidParameter` for a radius outside 0–255.

**Example**

```freebasic
dim blur as CGpBlur
blur.SetParameters( 6, FALSE )
dim bp as BlurParams, size as UINT = sizeof( BlurParams )
blur.GetParameters( @size, @bp )
print bp.radius                     ' 6
```

Microsoft Learn: [Blur::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-blur-setparameters), [Blur::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-blur-getparameters), [BlurParams](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/ns-gdipluseffects-blurparams)

## CGpBrightnessContrast

Makes a bitmap lighter or darker and its tones closer together or further apart.

### Constructor

```freebasic
constructor
```

Creates the GDI+ brightness-contrast effect.

**Example**

```freebasic
dim bc as CGpBrightnessContrast
if bc.GetLastStatus() = Ok then bc.SetParameters( 30, 0 )
```

Microsoft Learn: [BrightnessContrast](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-brightnesscontrast)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as BrightnessContrastParams ptr ) as GpStatus
function SetParameters( byval brightnessLevel as INT_, byval contrastLevel as INT_ ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` sets the two levels, from separate values or from a `BrightnessContrastParams`
(`brightnessLevel`, `contrastLevel`); 0 leaves that property as it is. `GetParameters` copies the
current levels into a `BrightnessContrastParams`; set `*uSize` to its size first.

| Parameter | Meaning |
| --- | --- |
| `brightnessLevel` | From -255 (much darker) to 255 (much lighter). |
| `contrastLevel` | From -100 (flat) to 100 (strong contrast). |
| `params`, `uSize` | The structure and, for `GetParameters`, the size of the buffer. |

**Returns** `Ok` on success; `InvalidParameter` for a level outside its range.

**Example**

```freebasic
dim bmp as CGpBitmap = "photo.jpg"
dim bc as CGpBrightnessContrast
bc.SetParameters( -40, 25 )         ' darker, more contrast
bmp.ApplyEffect( @bc )
```

Microsoft Learn: [BrightnessContrast::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-brightnesscontrast-setparameters), [BrightnessContrast::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-brightnesscontrast-getparameters)

## CGpColorBalance

Shifts the balance between each primary colour and its complement: cyan against red, magenta
against green, yellow against blue.

### Constructor

```freebasic
constructor
```

Asks GDI+ for a colour balance effect. In this release the request fails:
`GetLastStatus()` is `Win32Error` (7) afterwards and `GetEffectPtr()` is `NULL`, so test the
status before using the object, and never pass it to `ApplyEffect` or `DrawImageFX` without that
test.

**Example**

```freebasic
dim cb as CGpColorBalance
if cb.GetLastStatus() = Ok then
    dim bmp as CGpBitmap = "photo.jpg"
    if cb.SetParameters( 0, 0, 20 ) = Ok then bmp.ApplyEffect( @cb )
end if
```

Microsoft Learn: [ColorBalance](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-colorbalance)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as ColorBalanceParams ptr ) as GpStatus
function SetParameters( byval cyanRed as INT_, byval magentaGreen as INT_, byval yellowBlue as INT_ ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` sets the three shifts, from separate values or from a `ColorBalanceParams`
(`cyanRed`, `magentaGreen`, `yellowBlue`); `GetParameters` reads them back into one. Each shift
runs from -100 (all the way to the first colour of its name) to 100 (to the second), and 0
leaves that pair alone. While the constructor fails, as described above, both return
`InvalidParameter`.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim cb as CGpColorBalance
dim p as ColorBalanceParams = type( 0, 0, 30 )   ' towards blue
if cb.SetParameters( @p ) <> Ok then print "colour balance not available"
```

Microsoft Learn: [ColorBalance::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-colorbalance-setparameters), [ColorBalance::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-colorbalance-getparameters)

## CGpColorCurve

One of eight tone adjustments (exposure, density, contrast, highlight, shadow, midtone, white
saturation, black saturation) applied to one colour channel or all three.

### Constructor

```freebasic
constructor
```

Asks GDI+ for a colour curve effect. As with [CGpColorBalance](#cgpcolorbalance), in this release
the request fails: `GetLastStatus()` is `Win32Error` (7) afterwards and the object must not be
applied.

**Example**

```freebasic
dim cc as CGpColorCurve
if cc.GetLastStatus() <> Ok then print "colour curve not available"
```

Microsoft Learn: [ColorCurve](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-colorcurve)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as ColorCurveParams ptr ) as GpStatus
function SetParameters( byval adjustment as CurveAdjustments, byval channel as CurveChannel, byval adjustValue as INT_ ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` chooses the adjustment, the channel and the amount, from separate values or from
a `ColorCurveParams` (`adjustment`, `channel`, `adjustValue`); `GetParameters` reads them back.
While the constructor fails both return `InvalidParameter`.

| Parameter | Meaning |
| --- | --- |
| `adjustment` | `AdjustExposure`, `AdjustDensity`, `AdjustContrast`, `AdjustHighlight`, `AdjustShadow`, `AdjustMidtone`, `AdjustWhiteSaturation` or `AdjustBlackSaturation`. |
| `channel` | `CurveChannelAll`, `CurveChannelRed`, `CurveChannelGreen` or `CurveChannelBlue`. |
| `adjustValue` | The amount; its range depends on the adjustment: -255 to 255 for exposure and density, -100 to 100 for contrast, highlight, shadow and midtone, 0 to 255 for white and black saturation. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim cc as CGpColorCurve
if cc.SetParameters( AdjustMidtone, CurveChannelRed, 40 ) <> Ok then print "not applied"
```

Microsoft Learn: [ColorCurve::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-colorcurve-setparameters), [ColorCurve::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-colorcurve-getparameters), [CurveAdjustments](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/ne-gdipluseffects-curveadjustments)

## CGpColorLUT

Maps every value of each channel through a table of your own: the most general per-channel
adjustment.

### Constructor

```freebasic
constructor
```

Creates the GDI+ lookup-table effect.

**Example**

```freebasic
dim lut as CGpColorLUT
print lut.GetLastStatus()           ' 0 (Ok)
```

Microsoft Learn: [ColorLUT](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-colorlut)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as ColorLUTParams ptr ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` takes a `ColorLUTParams`: four arrays of 256 bytes, `lutB`, `lutG`, `lutR` and
`lutA`. A channel value `v` becomes `lut( v )` of its table, so an identity table (`lut( i ) = i`)
changes nothing. The elements are `byte`, so values from 128 to 255 are stored as their
negative equivalents (`255 - i` works as written). `GetParameters` copies the tables back; the
buffer is 1024 bytes.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim lp as ColorLUTParams
for i as long = 0 to 255
    lp.lutR( i ) = 255 - i : lp.lutG( i ) = 255 - i : lp.lutB( i ) = 255 - i : lp.lutA( i ) = i
next
dim lut as CGpColorLUT
lut.SetParameters( @lp )            ' a negative: &hFF102030 becomes &hFFEFDFCF
```

Microsoft Learn: [ColorLUT::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-colorlut-setparameters), [ColorLUT::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-colorlut-getparameters), [ColorLUTParams](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/ns-gdipluseffects-colorlutparams)

## CGpColorMatrixEffect

Multiplies every pixel by a 5 × 5 colour matrix, as
[CGpImageAttributes.SetColorMatrix](CGpImageAttributes#setcolormatrix-clearcolormatrix) does when
drawing, but changing the bitmap itself.

### Constructor

```freebasic
constructor
```

Creates the GDI+ colour matrix effect.

**Example**

```freebasic
dim cme as CGpColorMatrixEffect
if cme.GetLastStatus() <> Ok then print "no colour matrix effect"
```

Microsoft Learn: [ColorMatrixEffect](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-colormatrixeffect)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval matrix as ColorMatrix ptr ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval matrix as ColorMatrix ptr ) as GpStatus
```

`SetParameters` sets the matrix. Each pixel is taken as the row vector (R, G, B, A, 1), with the
channels from 0 to 1, and `m( row, col )` is how much of input channel `row` goes into output
channel `col`; row 4 adds a constant. `ColorMatrix` starts out all zeros, so set the diagonal
elements you want to keep. `GetParameters` copies the matrix back; the buffer is 100 bytes.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim cm as ColorMatrix
cm.m( 0, 2 ) = 1 : cm.m( 1, 1 ) = 1 : cm.m( 2, 0 ) = 1 : cm.m( 3, 3 ) = 1 : cm.m( 4, 4 ) = 1
dim cme as CGpColorMatrixEffect
cme.SetParameters( @cm )            ' swaps red and blue: &hFF102030 becomes &hFF302010
```

Microsoft Learn: [ColorMatrixEffect::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-colormatrixeffect-setparameters), [ColorMatrixEffect::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-colormatrixeffect-getparameters)

## CGpHueSaturationLightness

Turns the colours of a bitmap round the colour wheel and makes them more or less vivid and
lighter or darker.

### Constructor

```freebasic
constructor
```

Creates the GDI+ hue-saturation-lightness effect.

**Example**

```freebasic
dim hsl as CGpHueSaturationLightness
if hsl.GetLastStatus() = Ok then hsl.SetParameters( 0, -100, 0 )   ' grey scale
```

Microsoft Learn: [HueSaturationLightness](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-huesaturationlightness)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as HueSaturationLightnessParams ptr ) as GpStatus
function SetParameters( byval hueLevel as INT_, byval saturationLevel as INT_, byval lightnessLevel as INT_ ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` sets the three levels, from separate values or from a
`HueSaturationLightnessParams` (`hueLevel`, `saturationLevel`, `lightnessLevel`); 0 leaves that
property alone. `GetParameters` reads them back; the buffer is 12 bytes.

| Parameter | Meaning |
| --- | --- |
| `hueLevel` | Degrees round the colour wheel, from -180 to 180. 120 turns red into green. |
| `saturationLevel` | From -100 (grey) to 100 (more vivid). |
| `lightnessLevel` | From -100 (black) to 100 (white). |

**Returns** `Ok` on success; `InvalidParameter` for a level outside its range.

**Example**

```freebasic
dim hsl as CGpHueSaturationLightness
hsl.SetParameters( 10, 20, 30 )
dim hp as HueSaturationLightnessParams, size as UINT = sizeof( hp )
hsl.GetParameters( @size, @hp )
print hp.hueLevel; hp.saturationLevel; hp.lightnessLevel   ' 10 20 30
```

Microsoft Learn: [HueSaturationLightness::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-huesaturationlightness-setparameters), [HueSaturationLightness::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-huesaturationlightness-getparameters)

## CGpLevels

Adjusts the highlights, the midtones and the shadows of a bitmap.

### Constructor

```freebasic
constructor
```

Creates the GDI+ levels effect.

**Example**

```freebasic
dim lv as CGpLevels
if lv.GetLastStatus() <> Ok then print "no levels effect"
```

Microsoft Learn: [Levels](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-levels)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as LevelsParams ptr ) as GpStatus
function SetParameters( byval highlight as INT_, byval midtone as INT_, byval shadow as INT_ ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` sets the three levels, from separate values or from a `LevelsParams`
(`highlight`, `midtone`, `shadow`); `GetParameters` reads them back.

| Parameter | Meaning |
| --- | --- |
| `highlight` | From 0 to 100: channels above this percentage of full intensity are lightened (with 50, 192 became 255). 100 changes nothing. |
| `midtone` | From -100 to 100: darkens (negative) or lightens (positive) the midtones. 0 changes nothing. |
| `shadow` | From 0 to 100: channels below this percentage of full intensity are darkened (with 50, 64 became 0). 0 changes nothing. |

**Returns** `Ok` on success; `InvalidParameter` for a level outside its range.

**Example**

```freebasic
dim lv as CGpLevels
lv.SetParameters( 100, 50, 0 )      ' lighter midtones: &hFF808080 becomes &hFFB5B5B5
```

Microsoft Learn: [Levels::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-levels-setparameters), [Levels::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-levels-getparameters)

## CGpRedEyeCorrection

Removes the red from eyes in flash photographs, within rectangles you give.

### Constructor

```freebasic
constructor
```

Creates the GDI+ red-eye correction effect.

**Example**

```freebasic
dim re as CGpRedEyeCorrection
if re.GetLastStatus() <> Ok then print "no red-eye correction"
```

Microsoft Learn: [RedEyeCorrection](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-redeyecorrection)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as RedEyeCorrectionParams ptr ) as GpStatus
function SetParameters( byval numberOfAreas as UINT, byval areas as ..RECT ptr ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` gives the areas to correct, as a count and an array of `RECT` (in pixels of the
bitmap) or as a `RedEyeCorrectionParams` (`numberOfAreas`, `areas`) that points to such an
array. Pixels outside the rectangles are not changed. `GetParameters` copies the current
parameters; ask
[GetParameterSize](#getparametersize) for the buffer size, which is 16 bytes more than the
rectangles (48 for two).

| Parameter | Meaning |
| --- | --- |
| `numberOfAreas` | The number of rectangles. |
| `areas` | The first of the rectangles. |
| `params` | A `RedEyeCorrectionParams`; `NULL` gives `InvalidParameter`. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim eyes(1) as RECT
eyes(0) = type( 120, 80, 140, 100 ) : eyes(1) = type( 180, 82, 200, 102 )
dim re as CGpRedEyeCorrection
dim photo as CGpBitmap = "portrait.jpg"
if re.SetParameters( 2, @eyes(0) ) = Ok then photo.ApplyEffect( @re )
```

Microsoft Learn: [RedEyeCorrection::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-redeyecorrection-setparameters), [RedEyeCorrection::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-redeyecorrection-getparameters)

## CGpSharpen

Makes edges in a bitmap crisper.

### Constructor

```freebasic
constructor
```

Creates the GDI+ sharpen effect.

**Example**

```freebasic
dim sh as CGpSharpen
if sh.GetLastStatus() <> Ok then print "no sharpen effect"
```

Microsoft Learn: [Sharpen](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-sharpen)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as SharpenParams ptr ) as GpStatus
function SetParameters( byval radius as single, byval amount as single ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` sets how wide an area around each pixel is looked at and how strongly it is
sharpened, from separate values or from a `SharpenParams` (`radius`, `amount`); `GetParameters`
reads them back; the buffer is 8 bytes.

| Parameter | Meaning |
| --- | --- |
| `radius` | The radius in pixels, from 0 to 255. |
| `amount` | The strength, from 0 (none) to 100. |

**Returns** `Ok` on success; `InvalidParameter` for a value outside its range.

**Example**

```freebasic
dim sh as CGpSharpen
sh.SetParameters( 2, 50 )
dim sp as SharpenParams, size as UINT = sizeof( SharpenParams )
sh.GetParameters( @size, @sp )
print sp.radius; sp.amount          ' 2 50
```

Microsoft Learn: [Sharpen::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-sharpen-setparameters), [Sharpen::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-sharpen-getparameters), [SharpenParams](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/ns-gdipluseffects-sharpenparams)

## CGpTint

Pulls every colour of a bitmap towards one hue, or away from it.

### Constructor

```freebasic
constructor
```

Creates the GDI+ tint effect.

**Example**

```freebasic
dim tn as CGpTint
if tn.GetLastStatus() <> Ok then print "no tint effect"
```

Microsoft Learn: [Tint](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nl-gdipluseffects-tint)

### SetParameters, GetParameters

```freebasic
function SetParameters( byval params as TintParams ptr ) as GpStatus
function SetParameters( byval hue as INT_, byval amount as INT_ ) as GpStatus
function GetParameters( byval uSize as UINT ptr, byval params as any ptr ) as GpStatus
```

`SetParameters` sets the hue and the strength, from separate values or from a `TintParams`
(`hue`, `amount`); `GetParameters` reads them back; the buffer is 8 bytes.

| Parameter | Meaning |
| --- | --- |
| `hue` | The hue in degrees on the colour wheel, from -180 to 180: 0 is red, 60 yellow, 120 green, 180 (or -180) cyan, -120 blue, -60 magenta. |
| `amount` | From -100 to 100: positive values add the hue, negative values add its complement, 0 changes nothing. |

**Returns** `Ok` on success; `InvalidParameter` for a value outside its range.

**Example**

```freebasic
dim grey as CGpBitmap = CGpBitmap( 1, 1, PixelFormat32bppARGB )
grey.SetPixel( 0, 0, &hFF808080 )
dim tn as CGpTint
tn.SetParameters( 60, 50 )
grey.ApplyEffect( @tn )
print hex( grey.GetPixel( 0, 0 ) )   ' FF858546, a yellowish grey
```

Microsoft Learn: [Tint::SetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-tint-setparameters), [Tint::GetParameters](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/nf-gdipluseffects-tint-getparameters), [TintParams](https://learn.microsoft.com/en-us/windows/win32/api/gdipluseffects/ns-gdipluseffects-tintparams)

## See also

- [GDI+ images](SysWin-GdiPlus-Images): `CGpBitmap.ApplyEffect`, which applies an effect to a bitmap
- [CGpGraphics](CGpGraphics): `DrawImageFX`, which draws an image through an effect
- [CGpImageAttributes](CGpImageAttributes): colour adjustments made while drawing, without changing the image
- [sys/win/gdiplus](SysWin-GdiPlus)
