[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **Pset (Statement)**

# Pset (Statement)

Plots a single pixel

## Syntax

```freebasic
PSet [target ,] [STEP] (x, y) [,color]
```

## Parameters

- `target`
- `color`

## Description

`target` specifies buffer to draw on. `target` may be an image created with [`ImageCreate`](Imagecreate) or [`Get (Graphics)`](Get-Graphics). If omitted, `target` defaults to the screen's current work page.

 `(x, y)` are the coordinates of the pixel. `STEP` if present, indicates that `(x, y)` coordinates are relative to the graphics cursor position. If omitted, `(x, y)` are relative to the upper left-hand corner of `target`. The x and y coordinates are affected by the last call to the [`View (Graphics)`](View-Graphics) and [`Window`](Window) statements, and respect the current clipping region as set by the [`View (Graphics)`](View-Graphics) statement.

 `color` specifies the color attribute, as an 8-bit palette index in 8 bpp indexed modes, a 24-bit RGB value in 16 bpp modes (upper 8 bits of the integer unused, limited precision of R,G,B), and a 32-bit RGB or RGBA value in 32 bpp modes (upper 8 bits unused or holding Alpha). Note that it does NOT accept a 16-bit value (5 bits R + 6 bits G + 5 bits B). If omitted, `color` defaults to the current foreground color.

 Speed note: while `PSet` provides valid results, it is quite slow to call repeatedly due to the overhead of additional calculations and checks. Much better performance can be achieved by using direct memory access using the results obtained from [`ImageInfo`](Imageinfo) and [`ScreenInfo`](Screeninfo)/[`ScreenPtr`](Screenptr).

## Remarks

### Differences from QB

- `target` is new to FreeBASIC
- In 16 bpp and 32 bpp modes, a 32-bit value is required instead of an 8-bit palette index

### See also

- [`Point`](Point) - read out pixels
- [`PReset`](Preset)
- [`View (Graphics)`](View-Graphics)
- [`Window`](Window)

## Examples

```freebasic
' Set an appropriate screen mode - 320 x 240 x 8bpp indexed color

ScreenRes 320, 240, 8

' Plot a pixel at the coordinates 100, 100, Color 15. (white)

PSet (100, 100), 15

' Confirm the operation.

Locate 1: Print "Pixel plotted at 100, 100"

' Wait for a keypress.

Sleep

' Plot another pixel at the coordinates 150, 150, Color 4. (red)

PSet (150, 150), 4

' Confirm the operation.

Locate 1: Print "Pixel plotted at 150, 150"

' Wait for a keypress.

Sleep

' Plot a third pixel relative to the second, Color 15. (white)

' This pixel is given the coordinates 60, 60. It will be placed

' at 60, 60 plus the previous coordinates (150, 150), thus plotting at 210, 210.

PSet Step (60, 60), 15

' Confirm the operation.

Locate 1: Print "Pixel plotted at 150 + 60, 150 + 60"

' Wait for a keypress

Sleep

' Explicit end of program

End
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** statement

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
