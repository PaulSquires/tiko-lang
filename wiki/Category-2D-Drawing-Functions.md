[Home](Home) › [All Categories](Categories) › **2D Drawing Functions**

# 2D Drawing Functions

<!-- finder:start -->

Grouped by task. [Graphics and windows](Functions-Graphics) lists them beside the rest of the area.

## Draw lines, shapes and pixels

| Function | What it does | From |
|---|---|---|
| [PSet](Pset-Statement) | Plots one pixel, in the given colour or the current foreground colour. | built-in |
| [PReset](Preset) | Plots one pixel, in the given colour or the current background colour. | built-in |
| [Line](Line-Graphics) | Draws a line between two points, or a box or filled box with B or BF. | built-in |
| [Circle](Circle) | Draws a circle, ellipse or arc, optionally filled. | built-in |
| [Paint](Paint) | Fills the area enclosed by a border colour with a colour or a pattern. | built-in |
| [Point](Point) | Returns the colour of a pixel, or -1 if it is off the screen or image. | built-in |

## Draw text

| Function | What it does | From |
|---|---|---|
| [Draw String](Draw-String) | Draws text at a pixel position, on a transparent background, with an optional font. | built-in |

## Make colours

| Function | What it does | From |
|---|---|---|
| [RGB](Rgb) | Returns an opaque colour value from red, green and blue parts of 0 to 255. | built-in |
| [RGBA](Rgba) | Returns a colour value from red, green, blue and alpha parts of 0 to 255. | built-in |
| [Palette](Palette) | Sets or reads the colours of a palette mode, or restores the default palette. | built-in |

## Create and inspect images

| Function | What it does | From |
|---|---|---|
| [ImageCreate](Imagecreate) | Creates an image of a given size filled with one colour; returns 0 on failure. | built-in |
| [ImageDestroy](Imagedestroy) | Frees an image made by ImageCreate. | built-in |
| [ImageInfo](Imageinfo) | Fills in an image's width, height, bytes per pixel, pitch and pixel pointer. | built-in |
| [ImageConvertRow](Imageconvertrow) | Copies a row of pixels to another buffer, converting its colour depth. | built-in |

## Copy images to and from the screen

| Function | What it does | From |
|---|---|---|
| [Get](Get-Graphics) | Copies a rectangle of the screen or an image into an image buffer. | built-in |
| [Put](Put-Graphics) | Draws an image onto the screen or another image, with a choice of blending method. | built-in |

## Choose how Put combines pixels

| Function | What it does | From |
|---|---|---|
| [PSet](Pset-Graphics-Put) (Put method) | Copies source pixels over the destination unchanged, as a Put method. | built-in |
| [Trans](Trans) | Copies pixels with Put but skips the mask colour, magenta or index 0. | built-in |
| [Alpha](Alpha) | Blends pixels with Put by each pixel's alpha, or by one alpha value you give. | built-in |
| [Add](Add) | Adds source and destination colour values with Put, capped at 255. | built-in |
| [And](And-Graphics-Put) | Combines source and destination pixels with a bitwise And, as a Put method. | built-in |
| [Or](Or-Graphics-Put) | Combines source and destination pixels with a bitwise Or, as a Put method. | built-in |
| [Xor](Xor-Graphics-Put) | Combines source and destination pixels with a bitwise Xor, as a Put method. | built-in |
| [Custom](Custom) | Calls your own function for each pixel to combine source and destination in Put. | built-in |

## Load and save images

| Function | What it does | From |
|---|---|---|
| [BLoad](Bload) | Loads a BMP file or BSave data onto the screen or into memory. | built-in |
| [BSave](Bsave) | Saves memory or the screen to a file, as a BMP image if the name ends in .bmp. | built-in |

## Also in this category

- [2D Drawing Functions](2d-Drawing-Functions)

<!-- finder:end -->

---

[Home](Home) · [Keyword Index](Keyword-Index)
