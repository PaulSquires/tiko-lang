[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **BSave**

# BSave

Saves an array of arbitrary data and palette information to a file on disk

## Syntax

```freebasic
Declare Function BSave ( ByRef filename As Const String, ByVal source As Any Ptr, ByVal size As ULong = 0, ByVal pal As Any Ptr = 0, ByVal bitsperpixel As Long = 0 ) As Long
```

## Parameters

- `filename`
- `source`
- `size`
- `pal`
- `bitsperpixel`
- `bitsperpixel`
- `pal`

## Description

`BSave` is used for saving arbitrary data from memory into a file, using a file format specific to FB, or saving images into a standard BMP image file, replacing an existing file if necessary.  
 `BSave` must be called only if a graphics mode is initialized, else the program crashes (see `BLOAD/BSAVE text mode work-around` to work in text mode).

 `BSave` outputs a *total* of `size` bytes of arbitrary data located at `source` to a specified file. If `source` is null (`0`), then `BSave` outputs a *maximum* of `size` bytes from the current work page's pixel buffer, which is structured in the current screen mode's internal pixel format. (This data is not compatible with the image buffer format as it has no header.) For 8-bit images, palette information is obtained from `pal` if present and non-null, or if `pal` omitted or null (`0`), from the current screen palette.

 A BMP image file can be created if `filename` has a file extension of "`.bmp`" (case insensitive). `source` is assumed to point to a valid image buffer whose entire pixel data will be stored in the BMP file. If `source` is null (`0`), the contents of the current work page will be stored instead. For 8-bit images, palette information is obtained from `pal` if non-null, or if null (`0`), from the current screen palette. The `size` parameter is ignored when saving BMP files.

 The default bit depth for BMP files is 8-bit for 8-bit (palette) images, 24-bit for 16-bit images, and 32-bit for 32-bit images. The `bitsperpixel` parameter can be used to request 24-bit output for 8-bit images, or 24-bit output for 32-bit images.

 The error code returned by `BSave` can be checked using [`Err`](Err) in the next line. The function version of `BSave` returns directly the error code as a 32 bit [`Long`](Long).

 **Runtime errors:**
 `BSave` throws one of the following [runtime errors](Error-Handling):

 *(`1`) Illegal function call*

*(`2`) File not found*

*(`3`) File I/O error*

## Return Value

Returns zero (`0`) if successful, or a non-zero error code to indicate a failure. *[(throws a runtime error)](Error-Handling)*

## Remarks

### Usage

`result = BSave( filename, source [,[ size ][,{ pal | pal, bitsperpixel }]] )`

### Differences from QB

- Support for saving more than 64KiB of arbitrary data is new to FreeBASIC.
  Support for saving BMP files is new to FreeBASIC.  
  QB cannot use [`BLoad`](Bload) to load files created with `BSave` in FreeBASIC, but FreeBASIC can use [`BLoad`](Bload) to load files created with `BSave` in QB

### See also

- [`BLoad`](Bload)
- [`Palette`](Palette)

## Examples

```freebasic
' Set gfx mode

ScreenRes 320, 200, 32

' Clear with black on white

Color RGB(0, 0, 0), RGB(255, 255, 255)

Cls

Locate 13, 15: Print "Hello world!"

' Save screen as BMP

BSave "hello.bmp", 0
```

 Save image buffer to bitmap file:

```freebasic
'set graphics screen 640 x 480 pixels, 32 bit colors

Const W = 640, H = 480 'width & hight

ScreenRes W, H, 32

'draw a smiley at screen center

Circle (W \ 2, H \ 2), 180, &h00ffff00, , , , f 'yellow circle

Circle (W \ 2 - 55, H \ 2 - 70), 35, &h00000000, , , 1.5, f 'left eye

Circle (W \ 2 + 55, H \ 2 - 60), 35, &h00000000, , , 1.5, f 'right eye

Circle (W \ 2, H \ 2 + 80), 70, &h00000000, , , 0.4, f 'mouth

'allocate memory for image buffer

Dim As Any Ptr pImageBuffer = ImageCreate(250, 250)

'copy screen section to buffer

Get (W \ 2 - 125, H \ 2 - 125)-Step(250 - 1, 250 - 1), pImageBuffer

'save image buffer to file

Dim As String fileName = "Smiley.bmp"

If BSave(fileName, pImageBuffer) = 0 Then

    Print "Saved succesful: " + fileName

Else

    Print "Error saving: " + fileName

End If

'free memory for image buffer

ImageDestroy(pImageBuffer)

'keep graphics screen open until key press

Sleep
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
