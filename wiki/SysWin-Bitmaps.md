[Home](Home) › [All Categories](Categories) › [sys/win](Category-Sys-Win) › **Bitmaps**

# Bitmaps

Creates, loads, saves and draws bitmaps, captures the screen and saves icons.

Two kinds of image appear here. A **bitmap handle** (`HBITMAP`) is a GDI object: it is drawn
with a device context, measured with [GetBitmapWidth](#getbitmapwidth) and deleted with
`DeleteObject` when you are done. A **DIB in memory** is the contents of a `.bmp` file read into
one block, starting with its `BITMAPFILEHEADER`: [DibLoadImage](#dibloadimage) returns one, and
it is freed with `CoTaskMemFree`.

Every `HBITMAP` and `HICON` a function here creates is yours to delete. Nothing is deleted for
you, and a bitmap must not be selected into a device context when you delete it.

## Importing

```freebasic
#import "sys/win"
using win
```

## Example

A console program that captures the primary display, reports its size, draws a reduced copy
into a 32-bit DIB section and saves the system information icon as an `.ico` file:

```freebasic
#import "sys/win"
using win

dim hScreen as HBITMAP = CaptureDisplay()
dim as long w = GetBitmapWidth( hScreen ), h = GetBitmapHeight( hScreen )
print "captured"; w; " x"; h

dim hdcScreen as HDC = GetDC( NULL )
dim pBits as any ptr
dim hThumb as HBITMAP = CreateDIBSection( hdcScreen, w \ 4, h \ 4, 32, @pBits )
dim hdcThumb as HDC = CreateCompatibleDC( hdcScreen )
dim hdcSource as HDC = CreateCompatibleDC( hdcScreen )
dim hOldThumb as HGDIOBJ = SelectObject( hdcThumb, hThumb )
dim hOldSource as HGDIOBJ = SelectObject( hdcSource, hScreen )
SetStretchBltMode( hdcThumb, HALFTONE )
StretchBlt( hdcThumb, 0, 0, w \ 4, h \ 4, hdcSource, 0, 0, w, h, SRCCOPY )
SelectObject( hdcSource, hOldSource ) : SelectObject( hdcThumb, hOldThumb )
DeleteDC( hdcSource ) : DeleteDC( hdcThumb )
ReleaseDC( NULL, hdcScreen )
print "thumbnail"; GetBitmapWidth( hThumb ); " x"; GetBitmapHeight( hThumb )

dim hIcon as HICON = LoadIconW( NULL, cast( wstring ptr, IDI_INFORMATION ) )
if SaveIconToFile( hIcon, "information.ico" ) = S_OK then print "saved information.ico"

DeleteObject( hThumb )
DeleteObject( hScreen )
```

## Functions

| Function | Does |
| --- | --- |
| [CreateDIBSection](#createdibsection) | Creates a bitmap whose pixels you can write directly. |
| [DibLoadImage](#dibloadimage) | Reads a `.bmp` file into memory. |
| [DibSaveImage](#dibsaveimage) | Writes a DIB in memory to a `.bmp` file. |
| [GetBitmapWidth](#getbitmapwidth) | Returns the width of a bitmap. |
| [GetBitmapHeight](#getbitmapheight) | Returns the height of a bitmap. |
| [CaptureDisplay](#capturedisplay) | Copies the primary display into a new bitmap. |
| [DrawBitmap](#drawbitmap) | Draws a bitmap at its own size. |
| [SaveIconToFile](#saveicontofile) | Saves an icon as a 32-bit `.ico` file. |

## Reference

### CreateDIBSection

```freebasic
function CreateDIBSection overload( byval hDC as HDC, byval nWidth as DWORD, byval nHeight as DWORD, byval bpp as long = 0, byval ppvBits as any ptr ptr = NULL ) as HBITMAP
```

Creates a device-independent bitmap of `nWidth` × `nHeight` pixels, uncompressed RGB, whose
pixel memory your program can read and write directly through the pointer it hands back. The
rows are stored **bottom-up**: the first row in memory is the bottom row of the image. Each row
is padded to a multiple of 4 bytes, so a 32-bit row is exactly `nWidth * 4` bytes. A 32-bit
pixel read as a `ulong` is `&hAARRGGBB`, the layout of an `ARGB_*` colour, not of a `COLORREF`.

The Windows function of the same name, which takes a `BITMAPINFO`, is still there with six
arguments.

| Parameter | Meaning |
| --- | --- |
| `hDC` | A device context; with `bpp` 0 its colour depth is used. |
| `nWidth`, `nHeight` | The size in pixels. |
| `bpp` | Bits per pixel: 1, 4, 8, 16, 24 or 32. 0 (the default) takes the depth of `hDC`, which is 32 on today's displays. |
| `ppvBits` | Optional: a variable that receives the address of the pixels. |

**Returns** the bitmap, which you delete with `DeleteObject`, or `NULL` on failure (and
`*ppvBits` is then `NULL`).

**Example**

```freebasic
dim hdc as HDC = GetDC( hwnd )
dim pBits as ulong ptr
dim hbm as HBITMAP = CreateDIBSection( hdc, 64, 64, 32, cast( any ptr ptr, @pBits ) )
ReleaseDC( hwnd, hdc )
if hbm then pBits[0] = &hFFFF0000   ' the bottom-left pixel, opaque red
```

Microsoft Learn: [CreateDIBSection](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createdibsection)

### DibLoadImage

```freebasic
function DibLoadImage( byval pwszFileName as wstring ptr ) as BITMAPFILEHEADER ptr
```

Reads a whole `.bmp` file into one block of memory and returns its address. The block starts
with the `BITMAPFILEHEADER`; the `BITMAPINFOHEADER` follows it, and the pixels are at
`bfOffBits` bytes from the start.

The file must begin with `BM` and be smaller than 4 GB. Free the block with `CoTaskMemFree`.

| Parameter | Meaning |
| --- | --- |
| `pwszFileName` | The path of the file. |

**Returns** the block, or `NULL` when the file does not exist, cannot be read in full or is not a
bitmap file.

**Example**

```freebasic
dim pbmfh as BITMAPFILEHEADER ptr = DibLoadImage( "photo.bmp" )
if pbmfh then
    dim pih as BITMAPINFOHEADER ptr = cast( any ptr, pbmfh + 1 )
    print pih->biWidth; " x"; pih->biHeight; ","; pih->biBitCount; " bits"
    CoTaskMemFree( pbmfh )
end if
```

Microsoft Learn: [BITMAPFILEHEADER](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-bitmapfileheader)

### DibSaveImage

```freebasic
function DibSaveImage( byval pwszFileName as wstring ptr, byval pbmfh as BITMAPFILEHEADER ptr ) as boolean
```

Writes `bfSize` bytes starting at `pbmfh` to a file, replacing a file of that name. A file that
could not be written in full is deleted again.

| Parameter | Meaning |
| --- | --- |
| `pwszFileName` | The path of the file to write. |
| `pbmfh` | A DIB in memory, as [DibLoadImage](#dibloadimage) returns, with `bfSize` set to its total size. |

**Returns** `true` when the whole image was written; `false` when `pbmfh` is `NULL` or the file
could not be created or written.

**Example**

```freebasic
dim pbmfh as BITMAPFILEHEADER ptr = DibLoadImage( "photo.bmp" )
if pbmfh then
    if DibSaveImage( "copy.bmp", pbmfh ) then print "saved"
    CoTaskMemFree( pbmfh )
end if
```

### GetBitmapWidth

```freebasic
function GetBitmapWidth( byval hBitmap as HBITMAP ) as long
```

Returns the width of a bitmap in pixels.

**Returns** the width, or 0 for `NULL` or a handle that is not a bitmap.

**Example**

```freebasic
dim hbm as HBITMAP = CaptureDisplay()
print "width:"; GetBitmapWidth( hbm )
DeleteObject( hbm )
```

Microsoft Learn: [GetObject](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-getobject)

### GetBitmapHeight

```freebasic
function GetBitmapHeight( byval hBitmap as HBITMAP ) as long
```

Returns the height of a bitmap in pixels.

**Returns** the height, or 0 for `NULL` or a handle that is not a bitmap.

**Example**

```freebasic
dim hbm as HBITMAP = CaptureDisplay()
print "height:"; GetBitmapHeight( hbm )
DeleteObject( hbm )
```

### CaptureDisplay

```freebasic
function CaptureDisplay() as HBITMAP
```

Copies what is on the **primary display** into a new bitmap of the same size and colour depth.
Layered (translucent) windows are included. Other monitors are not; the size is the primary
display's, which for a program that is not DPI aware is the scaled-down size Windows reports
to it.

**Returns** the bitmap, which you delete with `DeleteObject`, or `NULL` on failure.

**Example**

```freebasic
dim hShot as HBITMAP = CaptureDisplay()
if hShot then print GetBitmapWidth( hShot ); " x"; GetBitmapHeight( hShot )
DeleteObject( hShot )
```

Microsoft Learn: [BitBlt](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-bitblt)

### DrawBitmap

```freebasic
function DrawBitmap( byval _hDC as HDC, byval xStart as long, byval yStart as long, byval hBitmap as HBITMAP ) as boolean
```

Draws a bitmap at its own size with its top-left corner at (`xStart`, `yStart`) in logical
units of the destination device context. The pixels are copied as they are (`SRCCOPY`): no
stretching and no transparency. The bitmap must not be selected into another device context.

| Parameter | Meaning |
| --- | --- |
| `_hDC` | The device context to draw on, such as the one `BeginPaint` returns. |
| `xStart`, `yStart` | Where the top-left corner goes. |
| `hBitmap` | The bitmap. It is not deleted. |

**Returns** `true` when the bitmap was drawn; `false` when either handle is `NULL` or the bitmap
cannot be read.

**Example**

```freebasic
dim ps as PAINTSTRUCT
dim hdc as HDC = BeginPaint( hwnd, @ps )
dim hbm as HBITMAP = CaptureDisplay()
DrawBitmap( hdc, 10, 10, hbm )
DeleteObject( hbm )
EndPaint( hwnd, @ps )
```

### SaveIconToFile

```freebasic
function SaveIconToFile( byval hIcon as HICON, byref fileName as wstring ) as HRESULT
```

Writes an icon to an `.ico` file holding one image: the icon's colour pixels at 32 bits per
pixel, with their alpha channel, at the icon's own size. The AND mask is written as all zeros
(opaque), so transparency comes only from the alpha channel. An existing file of that name is
replaced. The icon itself is left as it is.

| Parameter | Meaning |
| --- | --- |
| `hIcon` | The icon or cursor. |
| `fileName` | The path of the file to write. |

**Returns** `S_OK` on success, `E_POINTER` (`&h80004003`) when `hIcon` is `NULL`, or the
`HRESULT` of the Windows error otherwise. Monochrome icons, which have no colour bitmap, are not
supported.

**Example**

```freebasic
dim hIcon as HICON = LoadIconW( NULL, cast( wstring ptr, IDI_WARNING ) )
dim hr as HRESULT = SaveIconToFile( hIcon, "warning.ico" )
if hr <> S_OK then print "failed: &h"; hex( hr )
```

Microsoft Learn: [GetIconInfo](https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-geticoninfo)

## See also

- [Category: sys/win](Category-Sys-Win)
- [Clipboard](SysWin-Clipboard) for passing a DIB to another program
- [Colours](SysWin-Colors) for `COLORREF` and ARGB byte order
- [CMemBmp](CMemBmp), a memory bitmap with its own device context
- [Images (GDI+)](SysWin-GdiPlus-Images) for loading PNG, JPEG and other formats
