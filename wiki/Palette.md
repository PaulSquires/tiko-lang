[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **Palette**

# Palette

Sets or reads the colours of a palette mode, or restores the default palette.

## Syntax

```freebasic
Palette [Get] [index, color]
Palette [Get] [index, r, g, b]
Palette [Get] Using arrayname(idx)
```

## Parameters

- `index`
- `color`
- `r`
- `g`
- `b`
- `arrayname(idx)`

## Description

The `Palette` statement is used to retrieve or customize the current palette for graphics modes with a color depth of up to 8bpp; using `Palette` while in a mode with a higher color depth will have no effect. Calling `Palette` with no argument restores the default palette for current graphics mode, as set by the [`Screen (Graphics)`](Screen-Graphics) statement.  
 The GfxLib sets a [default palette](Default-Palettes) when a [`Screen`](Screen-Graphics) mode is initialized.

 **First form**

If you specify index and color, these are dependent on the current mode:

| Screen mode | index range | color range |
| --- | --- | --- |
| 1 | 0-3 | 0-15 |
| 2 | 0-1 | 0-15 |
| 7,8 | 0-15 | 0-15 |
| 9 | 0-15 | 0-63 |
| 11 | 0-1 | see below |
| 12 | 0-15 | see below |
| 13 to 21 | 0-255 | see below |

 In screen modes `1`, `2`, `7`, `8` and `9` you can assign to each color index one of the colors in the available range. In other screen modes, the color must be specified in the form `&hBBGGRR`, where `BB`, `GG` and `RR` are the blue, green and red components ranging `&h0`-`&h3F` in hexadecimal (`0`-`63` in decimal). If you don't like hexadecimal form, you can use the following formula to compute the integer value to pass to this parameter:  
 `color = red Or (green Shl 8) Or (blue Shl 16)`  
 Where red, green and blue must range `0`-`63`. Please note that color values accepted by `Palette` are **not** the in the same form as returned by the [`RGB`](Rgb) macro (the red and blue fields are inverted, and the range is different); this is for backward compatibility with QB.

**Second form**

In the second form, you specify the red, green and blue components for a palette entry directly, by calling `Palette` with 4 parameters. In this case `r`, `g` and `b` must be in the range `0`-`255`.

**Third form**

Calling `Palette Using` allows to set a list of color values all at once; you should pass an array holding enough elements as the color indices available for your current graphics mode color depth (2 for 1bpp, 4 for 2bpp, 16 for 4bpp or 256 for 8bpp). The array elements must be integer color values in the form described above. The colors stored into `arrayname` starting with given `idx` index are then assigned to each palette index, starting with index `0`.

Form 1 and 3 are for backward compatibility with QB; form 2 is meant to ease palette handling. Any change to the palette is immediately visible on screen.

 If the `Get` option is specified, `Palette` retrieves instead of setting color values for the current palette. The parameters have the same meaning as specified for the form being used, but in this case color, `r`, `g` and `b` must be variables passed by reference that will hold the color RGB values on function exit.

## Remarks

### Differences from QB

- QBasic did not support PALETTE GET to retrieve a palette.
- QBasic did not allow passing individual red/green/blue values.

### See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`Color`](Color)
- [`Using`](Using-Namespaces)
- [Default Palettes](Default-Palettes)

## Examples

```freebasic
' Setting a single color, form 1.

Screen 15

Locate 1,1: Color 15

Print "Press any key to change my color!"

Sleep

' Now change color 15 hues to bright red

Palette 15, &h00003F

Sleep
```

```freebasic
' Getting a single color, form 2.

Dim As ULong r, g, b

Screen 13

Palette Get 32, r, g, b

Print "Color 32 hues:"

Print Using "Red:### Green:### Blue:###"; r; g; b

Sleep
```

```freebasic
' Getting whole palette, form 3.

Dim pal(0 To 255) As ULong

Screen 13

Palette Get Using pal

For i As Integer = 0 To 15

    Print Using "Color ## = &"; i; Hex(pal(i), 6)

Next i

Sleep
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
