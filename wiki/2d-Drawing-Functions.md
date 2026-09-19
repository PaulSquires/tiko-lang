[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **2D Drawing Functions**

# 2D Drawing Functions

Statements and procedures for working with 2D graphics.

Description

The statements and procedures listed here provide ways of drawing to the screen. Image buffers can be created and blitted to the screen using a variety of blending methods. Palette colors can be retrieved or set in graphics modes that support them.

**Working with Color**

Procedures that control the color used by other drawing procedures.

**Drawing to Image Buffers**

Procedures that draw shapes and text onto image buffers or to the screen.

**Image Buffer Creation**

Procedures that create, free and save image buffers.

**Blitting Image Buffers**

Procedures that draw image buffers onto other image buffers or to the screen.

***Working with Color***

**[Color](Color)**

Sets the foreground and background color to use with the drawing procedures.

**[Palette](Palette)**

Gets or sets color table information in paletted modes.

**[RGB](Rgb)**

Returns a color value for hi/truecolor modes.

**[RGBA](Rgba)**

Returns a color value including alpha (transparency) for hi/truecolor modes.

**[Point](Point)**

Gets a pixel value from an image buffer or screen.

***Drawing to Image Buffers***

**[PSet](Pset-Statement) and [PReset](Preset)**

Plots a single pixel on an image buffer or screen.

**[Line (Graphics)](Line-Graphics)**

Plots a line of pixels on an image buffer or screen.

**[Circle](Circle)**

Plots circles and ellipses on an image buffer or screen.

**[Draw](Draw)**

Draws in a sequence of commands on an image buffer or screen.

**[Draw String](Draw-String)**

Writes text to an image buffer or screen.

**[Paint](Paint)**

Fills an area with color on an image buffer or screen.

***Image Buffer Creation***

**[Get (Graphics)](Get-Graphics)**

Creates an image buffer from a portion of another image buffer or screen.

**[ImageCreate](Imagecreate)**

Creates an image buffer of a certain size and pixel depth.

**[ImageDestroy](Imagedestroy)**

Frees an image buffer resource.

**[ImageConvertRow](Imageconvertrow)**

Converts a row of pixels in an image buffer to a different color depth.

**[ImageInfo](Imageinfo)**

Retrieves useful information about an image buffer

**[BLoad](Bload)**

Creates an image buffer from a file.

**[BSave](Bsave)**

Saves an image buffer to a file.

***Blitting Image Buffers***

**[Put (Graphics)](Put-Graphics)**

Blits an image buffer to another image buffer or screen.

**Blending Methods**

**[Add](Add)**

Saturated addition of the source and target components.

**[Alpha](Alpha)**

Blend using a uniform transparency or the image buffer's alpha channel.

**[And (Graphics Put)](And-Graphics-Put)**

Combine the source and target components using a bitwise [`And`](Operator-and-Conjunction)

**[Or](Or-Graphics-Put)**

Combine the source and target components using a bitwise [`Or`](Operator-or-Inclusive-Disjunction)

**[PSet](Pset-Graphics-Put)**

Directly copy pixel colors from the source to the destination.

**[Trans](Trans)**

Pixels matching the transparent mask color are not blitted.

**[Custom](Custom)**

Allows a custom blending procedure to be used.

**[Xor](Xor-Graphics-Put)**

Combine the source and target components using a bitwise [`Xor`](Operator-Xor-Exclusive-Disjunction)

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
