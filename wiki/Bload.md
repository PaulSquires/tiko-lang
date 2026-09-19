[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **BLoad**

# BLoad

Loads arbitrary data from a file created with BSave, or a compatible BMP image file.

## Syntax

```freebasic
Declare Function BLoad ( ByRef filename As Const String, ByVal dest As Any Ptr = 0, ByVal pal As Any Ptr = 0 ) As Long
```

## Parameters

- `filename`
- `dest`
- `pal`

## Description

`BLoad` can be used to load image data or any other data from a file created with [`BSave`](Bsave), and store that data in an array or paste it to the screen. If `dest` is absent or null (`0`), the image data is pasted to the current graphics screen work page. Otherwise it is loaded as image data to the address given by `dest`.  
 `BLoad` must be called only if a graphics mode is initialized, else the program crashes (see [`BLOAD/BSAVE text mode work-around`](Bload-Bsave-Text-Mode-Work-Around) to work in text mode).

 `BLoad` can load 3 different types of files:

QB-like data files and BMP files are converted to an FB-compatible image format when opened.

 Image files with 8-bit per pixel resolution or lower contain a palette that describes the color values used in the images. If `pal` is not null (`0`), the palette is copied to memory starting at the address specified. Otherwise, if the current graphics screen uses a palette then its palette is changed to match that of the image file.

 When using one of the 2 "non-BMP" file formats to save images, the image files must have been created with [`BSave`](Bsave) in the same graphics screen mode as it is being loaded into. When using the BMP file format, this restriction doesn't apply.

 When loading a BMP file using `BLoad`, the images must be true-color (15-, 16-, 24- or 32-bits per pixel) or palettized/indexed (8-bit or lower). The image data will be converted to the proper pixel format for the current color depth, except that true-color can't be reduced to a palettized image. `BLoad` doesn't support BMP files using RLE compression or other image file types (PNG, JPG, GIF, ...). `BLoad` will load alpha channel information, if available, from 32-bit BMP files with `BITMAPV4HEADER` or `BITMAPV5HEADER` file headers.

 The error code returned by `BLoad` can be checked using [`Err`](Err) in the next line. The function version of `BLoad` returns directly the error code as a 32 bit [`Long`](Long).

 **Runtime errors:**
 `BLoad` throws one of the following [runtime errors](Error-Handling):

*(`1`) Illegal function call*

*(`2`) File not found*

*(`3`) File I/O error*

*Note: When you use `BLoad` to load a BMP file into an image buffer, the original dimensions of the image are not changed. If you want the image buffer to have the same dimensions as the BMP file, you have to find out the dimensions beforehand, and create an image of the right size yourself. See the example below for an example of how to do this.*

## Return Value

Returns zero (`0`) if successful, or a non-zero error code to indicate a failure. *[(throws a runtime error)](Error-Handling)*

## Remarks

### Usage

`result = BLoad( filename [, [ dest ] [, pal ] ] )`

### Differences from QB

- Support for loading BMP files is new to FreeBASIC.
  Support for retrieving the palette from BMP files is new to FreeBASIC.  
  FreeBASIC uses a different file format from QBASIC internally, which doesn't have the 64 KiB limit, and is unsupported by QBASIC.

### See also

- [`BSave`](Bsave)
- [`Palette`](Palette)
- [`ImageCreate`](Imagecreate)
- [`ImageDestroy`](Imagedestroy)
- [Internal Graphics Formats](Internal-Graphics-Formats)

## Examples

```freebasic
'Load a graphic to current work page

Screen 18, 32

Cls

BLoad "picture.bmp"

Sleep
```

```freebasic
'Load a 48x48 bitmap into an image

ScreenRes 320, 200, 32

Dim myImage As Any Ptr = ImageCreate( 48, 48 )

BLoad "picture.bmp", myImage

Put (10,10), myImage

ImageDestroy( myImage )

Sleep
```

```freebasic
ScreenRes 640, 480, 8 '' 8-bit palette graphics mode

Dim pal(0 To 256-1) As Integer '' 32-bit integer array with room for 256 colors

'' load bitmap to screen, put palette into pal() array

BLoad "picture.bmp", , @pal(0)

WindowTitle "Old palette"

Sleep

'' set new palette from pal() array

Palette Using pal(0)

WindowTitle "New palette"

Sleep
```

```freebasic
'' A function that creates an image buffer with the same

'' dimensions as a BMP image, and loads a file into it.

Const NULL As Any Ptr = 0

Function bmp_load( ByRef filename As Const String ) As Any Ptr

    Dim As Long filenum, bmpwidth, bmpheight

    Dim As Any Ptr img

    '' open BMP file

    filenum = FreeFile()

    If Open( filename For Binary Access Read As #filenum ) <> 0 Then Return NULL

        '' retrieve BMP dimensions

        Get #filenum, 19, bmpwidth

        Get #filenum, 23, bmpheight

    Close #filenum

    '' create image with BMP dimensions

    img = ImageCreate( bmpwidth, Abs(bmpheight) )

    If img = NULL Then Return NULL

    '' load BMP file into image buffer

    If BLoad( filename, img ) <> 0 Then ImageDestroy( img ): Return NULL

    Return img

End Function

Dim As Any Ptr img

ScreenRes 640, 480, 32

img = bmp_load( "picture.bmp" )

If img = NULL Then

    Print "bmp_load failed"

Else

    Put (10, 10), img

    ImageDestroy( img )

End If

Sleep
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
