[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **Get (Graphics)**

# Get (Graphics)

Gets a copy of a portion of the current work page or an image buffer

## Syntax

```freebasic
Get [source,] [STEP](x1, y1) - [STEP](x2, y2), dest
```

## Parameters

- `source`
- `x2`
- `y2`
- `x1`
- `y1`
- `dest`

## Description

`Get` copies a rectangular portion of the current work page specified by the co-ordinates (`x1`, `y1`) and (`x2`, `y2`), which represent the upper-left and lower-right corners of the rectangle, respectively. `STEP` specifies that the upper-left co-ordinates are relative to the current graphics pen location, and/or that the lower-right co-ordinates are relative to the upper-left co-ordinates. The new image buffer is formatted to match the current screen mode pixel format.

 `dest` can be an address, an array (name not followed by empty parentheses), or a reference to the first element in an array that will receive the new image buffer. This memory must be sufficiently allocated to hold the image buffer (the number of bytes required varies with the [-lang dialect](Compiler-Option-Lang) used to compile the program). Valid image buffers can be created simply by using preferably the [`ImageCreate`](Imagecreate) statement.

 `source` can be an address, an array (name not followed by empty parentheses), or a reference to the first element in an array that holds an image buffer to retrieve a portion of. `x1`, `y1`, `x2`, `y2`, `Step` and `dest` have the same meaning in this case.

 The co-ordinates of the rectangle are affected by the most recent [`Window`](Window) and [`View (Graphics)`](View-Graphics) statements, and must both be within the current clipping region set by [`View (Graphics)`](View-Graphics) (or within the default viewport), otherwise an illegal function call runtime error will be triggered, and the function will have no effect.

 **Runtime errors:**
 `Get` throws one of the following [runtime errors](Error-Handling):

 *(`1`) Illegal function call*

## Remarks

### Dialect Differences

 There are 2 types of buffers (details see GfxInternalFormats) depending from FB dialect used:

- In the *[-lang fb](Compiler-Option-Lang)* dialect, `dest` receives a new-style image buffer, which consists of a 32-byte image header followed by pixel data which is row-padded to the next paragraph boundary (16 bytes). Use the following formula to calculate the total size, in bytes, required to store the image buffer, where `w` and `h` are the respective width and height of the rectangular portion of the current work page or source image buffer, and `bpp` is the number of bytes per pixel of the current screen mode:

`size = 32 + (((w * bpp + &hF) and not &hF) * h)`

- In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, `dest` receives a QB-style image buffer, which consists of a 4-byte image header followed by pixel data which is not row-padded. Use the following formula to calculate the total size, in bytes, required to store the image buffer, where `w` and `h` are the respective width and height of the rectangular portion of the current work page or source image buffer, and `bpp` is the number of bytes per pixel of the current screen mode:

`size = 4 + (w * h * bpp)`

### See also

- [`Put (Graphics)`](Put-Graphics)
- [`ImageCreate`](Imagecreate)
- [`Get (File I/O)`](Get-File-I-O)
- [`Screen (Graphics)`](Screen-Graphics)
- [`Window`](Window)
- [`View (Graphics)`](View-Graphics)

## Examples

```freebasic
#include Once "fbgfx.bi"

'' Setup a 400x300 32bit screen

ScreenRes 400, 300, 32

'' First draw funny stuff...

Line (10,10)-(140,30), RGB(255,255,0), bf

Draw String (30, 20), "Hello there!", RGB(255,0,0)

'' Now capture a 150x50 block from the top-left of the screen into an image

'' buffer with GET...

Dim As fb.Image Ptr image = ImageCreate(150, 50)

Get (0,0)-(150-1,50-1), image

'' And duplicate it all over the place!

Put (0,50), image

Put (0,100), image

Put (0,150), image

Put (0,200), image

Put (0,250), image

Put (150,0), image

Put (150,50), image

Put (150,100), image

Put (150,150), image

Put (150,200), image

Put (150,250), image

ImageDestroy(image)

'' And a frame around a whole screen..

Line (0,0)-(400-1,300-1), RGB(255,255,0), b

'' Now get the whole screen...

Dim As fb.Image Ptr big = ImageCreate(400, 300)

Get (0,0)-(400-1,300-1), big

'' And display that "screenshot" as if it was scrolling by...

Dim As Integer x = -350

While ((Inkey() = "") And (x < 350))

    ScreenLock

        Cls

        Put (x,0), big

    ScreenUnlock

    Sleep 100, 1

    x += 10

Wend

ImageDestroy(big)
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
