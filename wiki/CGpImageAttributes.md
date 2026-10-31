[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › [sys/win/gdiplus](SysWin-GdiPlus) › **CGpImageAttributes**

# CGpImageAttributes

Adjusts the colours of an image as it is drawn: colour matrices, gamma, keys, remapping.

A `CGpImageAttributes` holds a set of colour adjustments. It does nothing by itself: you pass its
address to one of the [CGpGraphics](CGpGraphics) `DrawImage` overloads that take a
`pImageAttributes` argument (or to [DrawImageFX](CGpGraphics#drawimagefx), or to a texture
brush), and the image is drawn through the adjustments. The image itself is never changed.

**Categories.** Each adjustment is kept separately for five categories, chosen by the `nType`
argument (a `ColorAdjustType`):

| `nType` | Applies to |
| --- | --- |
| `ColorAdjustTypeDefault` (the default) | every category that has no setting of its own for that adjustment |
| `ColorAdjustTypeBitmap` | bitmaps |
| `ColorAdjustTypeBrush` | brushes in metafiles |
| `ColorAdjustTypePen` | pens in metafiles |
| `ColorAdjustTypeText` | text in metafiles |

As soon as a category has any adjustment of its own, the default category no longer applies to
it at all. For a bitmap, setting everything in the default category is the usual choice.

**Lifetime.** The object owns one GDI+ image-attributes object, created by the constructor and
disposed of by the destructor. Do not copy one with `=` or pass it `byval`: pass its address, or
make an independent copy with [Clone](#clone) or the copy constructor.

**Status.** Every method returns a `GpStatus`, `Ok` (0) on success, and stores it for
`GetLastStatus()`.

## Importing

```freebasic
#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus
```

## Example

A console program that draws a red, a magenta and a blue pixel through a grey-scale colour
matrix and a magenta colour key, onto white:

```freebasic
#import "sys/win"
#import "sys/win/gdiplus"
using win, gdiplus

function main() as long
    ' a three-pixel source: red, magenta, blue
    dim src as CGpBitmap = CGpBitmap( 3, 1, PixelFormat32bppARGB )
    src.SetPixel( 0, 0, ARGB_Red )
    src.SetPixel( 1, 0, ARGB_Magenta )
    src.SetPixel( 2, 0, ARGB_Blue )

    ' grey scale: each of R, G and B becomes 0.3 R + 0.59 G + 0.11 B
    dim cm as ColorMatrix
    for col as long = 0 to 2
        cm.m( 0, col ) = 0.3 : cm.m( 1, col ) = 0.59 : cm.m( 2, col ) = 0.11
    next
    cm.m( 3, 3 ) = 1 : cm.m( 4, 4 ) = 1

    dim attr as CGpImageAttributes
    attr.SetColorMatrix( @cm )
    attr.SetColorKey( ARGB_Magenta, ARGB_Magenta )   ' magenta pixels are not drawn

    ' draw the source through the attributes onto white
    dim dst as CGpBitmap = CGpBitmap( 3, 1, PixelFormat32bppARGB )
    scope
        dim g as CGpGraphics = @dst
        g.Clear( ARGB_White )
        dim rc as GpRect = ( 0, 0, 3, 1 )
        g.DrawImage( @src, @rc, 0, 0, 3, 1, UnitPixel, @attr )
    end scope
    for x as long = 0 to 2
        print "pixel"; x; ": &h"; hex( dst.GetPixel( x, 0 ) )
    next
    return 0
end function

end main()
```

It prints:

```text
pixel 0: &hFF4D4D4D
pixel 1: &hFFFFFFFF
pixel 2: &hFF1C1C1C
```

Red and blue come out as greys of 30 % and 11 %; the magenta pixel is skipped, so the white
background shows through.

## Members

| Member | Does |
| --- | --- |
| [Constructor](#constructor) | Creates an empty set of adjustments, or a copy of another. |
| [Destructor](#destructor) | Disposes of the GDI+ object. |
| [Clone](#clone) | Copies these adjustments into another object. |
| [SetToIdentity](#settoidentity) | Sets a category's colour matrix to the identity matrix. |
| [Reset](#reset) | Removes every adjustment of a category. |
| [SetColorMatrix, ClearColorMatrix](#setcolormatrix-clearcolormatrix) | Sets or removes the colour matrix of a category. |
| [SetColorMatrices, ClearColorMatrices](#setcolormatrices-clearcolormatrices) | Sets or removes a colour matrix and a grey-scale matrix. |
| [SetThreshold, ClearThreshold](#setthreshold-clearthreshold) | Sets or removes a threshold that makes each channel all or nothing. |
| [SetGamma, ClearGamma](#setgamma-cleargamma) | Sets or removes gamma correction. |
| [SetNoOp, ClearNoOp](#setnoop-clearnoop) | Switches a category's adjustments off and back on. |
| [SetColorKey, ClearColorKey](#setcolorkey-clearcolorkey) | Sets or removes a range of colours that are not drawn. |
| [SetOutputChannel, ClearOutputChannel](#setoutputchannel-clearoutputchannel) | Draws one CMYK channel as a grey-scale image. |
| [SetOutputChannelColorProfile, ClearOutputChannelColorProfile](#setoutputchannelcolorprofile-clearoutputchannelcolorprofile) | Sets or removes the colour profile used for CMYK channel output. |
| [SetRemapTable, ClearRemapTable](#setremaptable-clearremaptable) | Sets or removes a table that replaces given colours. |
| [SetBrushRemapTable, ClearBrushRemapTable](#setbrushremaptable-clearbrushremaptable) | The same, for the brush category. |
| [SetWrapMode](#setwrapmode) | Sets how an image is repeated or clamped outside its edges. |
| [GetAdjustedPalette](#getadjustedpalette) | Applies a category's adjustments to a palette. |

## Reference

### Constructor

```freebasic
constructor
constructor( byval pImgAttr as CGpImageAttributes ptr )
```

With no argument, creates a set with no adjustments: an image drawn through it looks as it would
without one. With `pImgAttr`, creates an independent copy of that object's adjustments, and
`GetLastStatus()` tells whether the copy succeeded. The first form does not record a status, so
`GetLastStatus()` reads `Ok` after it whatever happened.

| Parameter | Meaning |
| --- | --- |
| `pImgAttr` | The object to copy. It must not be `NULL`. |

**Example**

```freebasic
dim attr as CGpImageAttributes
attr.SetGamma( 1.8 )
dim copy as CGpImageAttributes = CGpImageAttributes( @attr )   ' gamma 1.8 as well
```

Microsoft Learn: [ImageAttributes::ImageAttributes](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-imageattributes)

### Destructor

```freebasic
destructor
```

Disposes of the GDI+ object. Images drawn through it earlier are not affected.

**Example**

```freebasic
dim pAttr as CGpImageAttributes ptr = new CGpImageAttributes
pAttr->SetGamma( 2.2 )
delete pAttr
```

### Clone

```freebasic
function Clone( byval pCloneImgAttr as CGpImageAttributes ptr ) as GpStatus
```

Makes `pCloneImgAttr` an independent copy of this object: whatever GDI+ object it held is
disposed of first, then replaced by a copy of this one's adjustments.

**Returns** `Ok` on success; `InvalidParameter` when `pCloneImgAttr` is `NULL`.

**Example**

```freebasic
dim attr as CGpImageAttributes, other as CGpImageAttributes
attr.SetColorKey( ARGB_White, ARGB_White )
if attr.Clone( @other ) = Ok then other.SetGamma( 2 )   ' attr keeps no gamma
```

Microsoft Learn: [ImageAttributes::Clone](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clone)

### SetToIdentity

```freebasic
function SetToIdentity( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

Sets the colour matrix of a category to the identity matrix, which leaves colours as they are.
Use it to give a category a matrix of its own that changes nothing, so that the default
category's matrix no longer applies to it.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim attr as CGpImageAttributes
attr.SetToIdentity( ColorAdjustTypeBitmap )
```

Microsoft Learn: [ImageAttributes::SetToIdentity](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-settoidentity)

### Reset

```freebasic
function Reset( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

Removes every adjustment of one category: matrices, threshold, gamma, colour key, remap table and
the others. The other categories keep theirs.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim attr as CGpImageAttributes
attr.SetGamma( 2.2 )
attr.SetThreshold( 0.5 )
attr.Reset()          ' the default category has no adjustments again
```

Microsoft Learn: [ImageAttributes::Reset](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-reset)

### SetColorMatrix, ClearColorMatrix

```freebasic
function SetColorMatrix( byval pColorMatrix as ColorMatrix ptr, byval nMode as ColorMatrixFlags = ColorMatrixFlagsDefault, byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
function ClearColorMatrix( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

`SetColorMatrix` gives a category a 5 × 5 colour matrix. Each pixel is taken as the row vector
(R, G, B, A, 1), with the channels from 0 to 1, and multiplied by the matrix: `m( row, col )` is
how much of input channel `row` goes into output channel `col`, and row 4 adds a constant.
The identity matrix (1 on the diagonal, 0 elsewhere) changes nothing; `ColorMatrix` starts out
all zeros, so set every diagonal element you need.

`ClearColorMatrix` removes the category's colour matrix and any grey-scale matrix set with
[SetColorMatrices](#setcolormatrices-clearcolormatrices).

| Parameter | Meaning |
| --- | --- |
| `pColorMatrix` | The matrix. GDI+ copies it; the variable can go once the call returns. |
| `nMode` | Which pixels the matrix applies to: `ColorMatrixFlagsDefault` (all), `ColorMatrixFlagsSkipGrays` (all but greys). |
| `nType` | The category. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim cm as ColorMatrix
cm.m( 0, 0 ) = 1 : cm.m( 1, 1 ) = 1 : cm.m( 2, 2 ) = 1 : cm.m( 4, 4 ) = 1
cm.m( 3, 3 ) = 0.5            ' half as opaque
dim attr as CGpImageAttributes
attr.SetColorMatrix( @cm )
```

Microsoft Learn: [ImageAttributes::SetColorMatrix](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setcolormatrix), [ImageAttributes::ClearColorMatrix](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clearcolormatrix), [ColorMatrix](https://learn.microsoft.com/en-us/windows/win32/api/gdipluscolormatrix/ns-gdipluscolormatrix-colormatrix)

### SetColorMatrices, ClearColorMatrices

```freebasic
function SetColorMatrices( byval pColorMatrix as ColorMatrix ptr, byval pGrayMatrix as ColorMatrix ptr, byval nMode as ColorAdjustType = ColorMatrixFlagsDefault, byval nType as long = ColorAdjustTypeDefault ) as GpStatus
function ClearColorMatrices( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

`SetColorMatrices` gives a category a colour matrix and a second matrix for grey pixels (pixels
whose red, green and blue are equal). `nMode` says which applies where:

| `nMode` | Effect |
| --- | --- |
| `ColorMatrixFlagsDefault` | `pColorMatrix` applies to every pixel; `pGrayMatrix` is not used. |
| `ColorMatrixFlagsSkipGrays` | `pColorMatrix` applies to colours; greys are left alone. |
| `ColorMatrixFlagsAltGray` | `pColorMatrix` applies to colours and `pGrayMatrix` to greys. |

`nMode` is declared as a `ColorAdjustType` and `nType` as a `long`, but they take a
`ColorMatrixFlags` and a `ColorAdjustType` value as their names and defaults say.

`ClearColorMatrices` removes both matrices; it does exactly what
[ClearColorMatrix](#setcolormatrix-clearcolormatrix) does.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim colourM as ColorMatrix, greyM as ColorMatrix
for i as long = 0 to 4
    colourM.m( i, i ) = 1 : greyM.m( i, i ) = 1
next
greyM.m( 0, 0 ) = 0.5 : greyM.m( 1, 1 ) = 0.5 : greyM.m( 2, 2 ) = 0.5   ' darker greys
dim attr as CGpImageAttributes
attr.SetColorMatrices( @colourM, @greyM, ColorMatrixFlagsAltGray )
```

Microsoft Learn: [ImageAttributes::SetColorMatrices](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setcolormatrices), [ImageAttributes::ClearColorMatrices](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clearcolormatrices)

### SetThreshold, ClearThreshold

```freebasic
function SetThreshold( byval threshold as single, byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
function ClearThreshold( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

`SetThreshold` turns each colour channel fully on or fully off: a channel above `threshold`
(from 0 to 1) becomes 255, the others 0. With 0.5, a pixel with red 200, green 100 and blue 50
is drawn as pure red. `ClearThreshold` removes it.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim attr as CGpImageAttributes
attr.SetThreshold( 0.5 )      ' a poster effect in eight colours
```

Microsoft Learn: [ImageAttributes::SetThreshold](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setthreshold), [ImageAttributes::ClearThreshold](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clearthreshold)

### SetGamma, ClearGamma

```freebasic
function SetGamma( byval gamma as single, byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
function ClearGamma( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

`SetGamma` applies gamma correction: each channel, taken from 0 to 1, is raised to the power
`gamma`. 1 changes nothing, values above 1 darken the mid-tones and values below 1 lighten them (0.6
turns a mid-grey of 128 into 169). `ClearGamma` switches the correction off.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim attr as CGpImageAttributes
attr.SetGamma( 0.6 )          ' lighter mid-tones
```

Microsoft Learn: [ImageAttributes::SetGamma](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setgamma), [ImageAttributes::ClearGamma](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-cleargamma)

### SetNoOp, ClearNoOp

```freebasic
function SetNoOp( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
function ClearNoOp( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

`SetNoOp` switches every adjustment of a category off without removing it; `ClearNoOp` switches
them back on, as they were. Use it to draw the same image with and without its adjustments.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim attr as CGpImageAttributes
attr.SetGamma( 2.2 )
attr.SetNoOp()                ' draw as if no gamma were set
attr.ClearNoOp()              ' gamma 2.2 again
```

Microsoft Learn: [ImageAttributes::SetNoOp](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setnoop), [ImageAttributes::ClearNoOp](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clearnoop)

### SetColorKey, ClearColorKey

```freebasic
function SetColorKey( byval colorLow as ARGB, byval colorHigh as ARGB, byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
function ClearColorKey( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

`SetColorKey` makes a range of colours transparent: a pixel whose red, green and blue each lie
between those of `colorLow` and `colorHigh` is not drawn, so what is underneath shows through.
The alpha bytes of the two colours are not used. Pass the same colour twice for a single colour,
as the [example](#example) does with magenta. `ClearColorKey` removes the key.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim attr as CGpImageAttributes
attr.SetColorKey( &hFFF0F0F0, ARGB_White )   ' white and near-white are not drawn
```

Microsoft Learn: [ImageAttributes::SetColorKey](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setcolorkey), [ImageAttributes::ClearColorKey](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clearcolorkey)

### SetOutputChannel, ClearOutputChannel

```freebasic
function SetOutputChannel( byval channelFlags as long, byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
function ClearOutputChannel( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

`SetOutputChannel` converts each pixel to cyan, magenta, yellow and black and draws only one of
the four, as a grey-scale image: the more of that ink, the darker the pixel. `ClearOutputChannel`
goes back to normal colour output.

| Parameter | Meaning |
| --- | --- |
| `channelFlags` | `ColorChannelFlagsC`, `ColorChannelFlagsM`, `ColorChannelFlagsY` or `ColorChannelFlagsK`. |
| `nType` | The category. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim attr as CGpImageAttributes
attr.SetOutputChannel( ColorChannelFlagsC )   ' the cyan separation
```

Microsoft Learn: [ImageAttributes::SetOutputChannel](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setoutputchannel), [ImageAttributes::ClearOutputChannel](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clearoutputchannel)

### SetOutputChannelColorProfile, ClearOutputChannelColorProfile

```freebasic
function SetOutputChannelColorProfile( byval pwszColorProfileFilename as wstring ptr, byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
function ClearOutputChannelColorProfile( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

`SetOutputChannelColorProfile` names the colour profile (`.icm` file) used for the CMYK conversion
of [SetOutputChannel](#setoutputchannel-clearoutputchannel). A bare file name is looked for in
the system's colour folder. The file is read here, so a name that cannot be opened makes the call
fail. `ClearOutputChannelColorProfile` goes back to the built-in conversion.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim attr as CGpImageAttributes
if attr.SetOutputChannelColorProfile( "printer.icm" ) = Ok then attr.SetOutputChannel( ColorChannelFlagsK )
```

Microsoft Learn: [ImageAttributes::SetOutputChannelColorProfile](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setoutputchannelcolorprofile), [ImageAttributes::ClearOutputChannelColorProfile](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clearoutputchannelcolorprofile)

### SetRemapTable, ClearRemapTable

```freebasic
function SetRemapTable( byval mapSize as UINT, byval map as GpColorMap ptr, byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
function ClearRemapTable( byval nType as ColorAdjustType = ColorAdjustTypeDefault ) as GpStatus
```

`SetRemapTable` gives a category a table of colour replacements: a pixel whose colour (alpha
included) equals an `oldColor` in the table is drawn as the matching `newColor`. Other colours
are drawn as they are. `ClearRemapTable` removes the table.

| Parameter | Meaning |
| --- | --- |
| `mapSize` | The number of entries in `map`. |
| `map` | An array of `GpColorMap` (`oldColor`, `newColor`), copied by the call. |
| `nType` | The category. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim swaps(1) as GpColorMap
swaps(0).oldColor = ARGB_Red  : swaps(0).newColor = ARGB_Blue
swaps(1).oldColor = ARGB_Blue : swaps(1).newColor = ARGB_Red
dim attr as CGpImageAttributes
attr.SetRemapTable( 2, @swaps(0) )
```

Microsoft Learn: [ImageAttributes::SetRemapTable](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setremaptable), [ImageAttributes::ClearRemapTable](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clearremaptable)

### SetBrushRemapTable, ClearBrushRemapTable

```freebasic
function SetBrushRemapTable( byval mapSize as UINT, byval map as GpColorMap ptr ) as GpStatus
function ClearBrushRemapTable() as GpStatus
```

[SetRemapTable and ClearRemapTable](#setremaptable-clearremaptable) for the brush category,
`ColorAdjustTypeBrush`: the table applies to the brushes a metafile fills with.

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim fills(0) as GpColorMap
fills(0).oldColor = ARGB_Yellow : fills(0).newColor = ARGB_Gold
dim attr as CGpImageAttributes
attr.SetBrushRemapTable( 1, @fills(0) )
```

Microsoft Learn: [ImageAttributes::SetBrushRemapTable](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setbrushremaptable), [ImageAttributes::ClearBrushRemapTable](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-clearbrushremaptable)

### SetWrapMode

```freebasic
function SetWrapMode( byval nWrap as WrapMode, byval colour as ARGB = &hFF000000, byval clamp as BOOL = false ) as GpStatus
```

Sets what is drawn when the destination is larger than the image or the source rectangle reaches
outside it: with `WrapModeTile` and its flipped variants the image repeats; with `WrapModeClamp`
the area outside is filled with `colour`. Without a wrap mode, an image scaled up has its edge
pixels blended with the background, which shows as a faint border; `WrapModeTileFlipXY` keeps
the edges solid.

| Parameter | Meaning |
| --- | --- |
| `nWrap` | `WrapModeTile`, `WrapModeTileFlipX`, `WrapModeTileFlipY`, `WrapModeTileFlipXY` or `WrapModeClamp`. |
| `colour` | The colour outside the image with `WrapModeClamp`; opaque black by default. |
| `clamp` | Passed to GDI+, which does not use it. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim attr as CGpImageAttributes
attr.SetWrapMode( WrapModeTileFlipXY )   ' no pale border when scaling up
```

Microsoft Learn: [ImageAttributes::SetWrapMode](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-setwrapmode)

### GetAdjustedPalette

```freebasic
function GetAdjustedPalette( byval pColorPalette as ColorPalette ptr, byval colorAdjustType as long ) as GpStatus
```

Runs the colours of a palette through the adjustments of one category and writes the results
back into the palette. Use it to see what an indexed image will look like, or to adjust a palette
once instead of on every draw.

| Parameter | Meaning |
| --- | --- |
| `pColorPalette` | The palette, changed in place. `Count` says how many entries it has. |
| `colorAdjustType` | The category whose adjustments are used: a `ColorAdjustType` value, with no default. |

**Returns** `Ok` on success, otherwise the error.

**Example**

```freebasic
dim remap(0) as GpColorMap
remap(0).oldColor = ARGB_Red : remap(0).newColor = ARGB_Green
dim attr as CGpImageAttributes
attr.SetRemapTable( 1, @remap(0) )
dim pal as ColorPalette
pal.Count = 1 : pal.Entries(0) = ARGB_Red
attr.GetAdjustedPalette( @pal, ColorAdjustTypeBitmap )
print hex( pal.Entries(0) )                 ' FF008000, ARGB_Green
```

Microsoft Learn: [ImageAttributes::GetAdjustedPalette](https://learn.microsoft.com/en-us/windows/win32/api/gdiplusimageattributes/nf-gdiplusimageattributes-imageattributes-getadjustedpalette)

## See also

- [GDI+ images](SysWin-GdiPlus-Images): the bitmaps and metafiles you draw through these adjustments
- [CGpGraphics](CGpGraphics): `DrawImage` and `DrawImageFX`, which take a `CGpImageAttributes`
- [GDI+ effects](SysWin-GdiPlus-Effects): blur, sharpen, tint and colour corrections applied to a bitmap
- [sys/win/gdiplus](SysWin-GdiPlus)
