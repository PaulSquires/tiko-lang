[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **Paint**

# Paint

Fills the area enclosed by a border colour with a colour or a pattern.

## Syntax

```freebasic
Paint [target,] [STEP] (x, y)[, [paint][, [border_color]]]
```

## Parameters

- `target`
- `paint`
- `border_color`

## Description

Graphics command to fill an area delimited by a border of specified color. Also known as 'flood-fill' or 'paint bucket'.

 `Paint` can operate on the current work page as set by the [`ScreenSet`](Screenset) statement or on the target [`Get`](Get-Graphics)/[`Put`](Put-Graphics) buffer, if specified.

 Filling starts at specified `(x,y)` coordinates; if `STEP` is specified, these are relative to the last graphics cursor position. Coordinates are also affected by custom coordinates system set up by [`Window`](Window) and/or [`View (Graphics)`](View-Graphics) statements; clipping set by [`View`](View-Graphics) also applies.

 If the `paint` argument is a number, it is assumed a color in the same format used by the [`Color`](Color) statement, and the region is flood-filled using that color. If `paint` is a [`String`](String), the region will be filled using a pattern; the pattern is always 8\*8 pixels, and the passed string must hold pixels data in a format dependent on the current color depth. The string holds pattern pixels row by row, and its size should be as follows:

 For color depths 1, 2, 4 and 8:  
 `size = 8 * 8 = 64`  
 For color depths 15 and 16:  
 `size = (8 * 8) * 2 = 128`  
 For color depths 24 and 32:  
 `size = (8 * 8) * 4 = 256`

 If the passed string is smaller, missing pixels will be 0. If the `paint` argument is omitted, normal filling is performed using the current foreground color set by [`Color`](Color). Flood-filling continues until pixels of the specified border color are found; if `border_color` is omitted, the current background color is assumed.

 **Warning:** If the border is drawn with a transparent color (in conjunction with the `GFX_ALPHA_PRIMITIVES` option flag) and some pixels are overdrawn on it, the resultant (blended) color of these overdrawn pixels can cause a leak point through which the fill color escapes outside the border. So drawing a border with a transparent color is not recommended.

## Remarks

### Differences from QB

- `target` is new to FreeBASIC
  In QB, the fill pattern was always 8-bits wide, and the height was the length of the string (up to 64). In FreeBASIC, the fill pattern is 8 pixels wide, independent of the color depth, and the height is always 8  
  The background color parameter supported by QB is not supported by the FreeBASIC version

### See also

- [`Screen (Graphics)`](Screen-Graphics)

## Examples

```freebasic
' draws a white circle painted blue inside

Screen 13

Circle (160, 100), 30, 15

Paint (160, 100), 1, 15

Sleep
```

```freebasic
' draws a circle and fills it with a checkered pattern

'' choose the bit depth for the Screen

'' try setting this to other values: 8, 16 or 32

Const bit_depth = 8

'' function for returning a pixel color, represented as a string

'' returns a the string in the appropriate format for the current bit depth

Function paint_pixel( ByVal c As ULong, ByVal bit_depth_ As Integer ) As String

    If bit_depth_ <= 8 Then '' 8-bit:

        Function =  Chr( CUByte(c) )

    ElseIf bit_depth_ <= 16 Then '' 16-bit:

        Function = MKShort( c Shr 3 And &h1f Or _

                            c Shr 5 And &h7e0 Or _

                            c Shr 8 And &hf800 )

    ElseIf bit_depth_ <= 32 Then '' 32-bit:

        Function = MKL(c)

    End If

End Function

'' open a graphics window at the chosen bit depth

ScreenRes 320, 200, bit_depth

'' declare variables for holding colors

Dim As ULong c, c1, c2, cb

'' declare string variable for holding the pattern used in Paint

Dim As String paint_pattern = ""

'' set colors

If bit_depth <= 8 Then

    c1 = 7  ''pattern color 1

    c2 = 8  ''pattern color 2

    cb = 15 ''border color

Else

    c1 = RGB(192, 192, 192) '' pattern color 1

    c2 = RGB(128, 128, 128) '' pattern color 2

    cb = RGB(255, 255, 255) '' border color

End If

'' make the pattern to be used in Paint

For y As UInteger = 0 To 7

    For x As UInteger = 0 To 7

        '' choose the color of the pixel (c)

        If (x \ 4 + y \ 4) Mod 2 > 0 Then

            c = c1

        Else

            c = c2

        End If

        '' add the pixel to the pattern

        paint_pattern = paint_pattern + paint_pixel(c, bit_depth)

        '' the following line can be used if you want to draw the

        '' pattern tile in the top left hand corner of the screen:

        ' pset (x, y), c

    Next x

Next y

'' draw a circle with the border color

Circle (160, 100), 50, cb, , , 1.0

'' paint the circle region with paint_pattern, stopping at the border color

Paint (160, 100), paint_pattern, cb

'' pause before ending the program

Sleep
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
