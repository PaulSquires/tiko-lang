[Home](Home) › [Console Functions](Category-Console-Functions) › **Screen (Console)**

# Screen (Console)

Returns the character, or its colour, at a row and column of the console.

## Syntax

```freebasic
Declare Function Screen ( ByVal row As Long, ByVal column As Long, ByVal colorflag As Long = 0 ) As ULong
```

## Parameters

- `row`
- `column`
- `colorflag`

## Description

`Screen` returns the character or the color attribute found at a given position of a console output. It works in console mode and in graphics mode.

 The format of the color attribute depends on the current color depth:

 If the color type is a palette type with up to 4 bits per pixel (such as the Win32 console), then the color attribute is an 8-bit value, where the higher four bits hold the cell background color and the lower four bits hold the foreground (character) color.

 If the color type is an 8-bit palette, then the color attribute is a 16-bit value, where the high byte holds the background color and the low byte holds the foreground color.

 If the color type is full color, then the color attribute is a 32-bit integer, holding a single color value. If `colorflag` is equal to 1, then the foreground color is returned; if `colorflag` is equal to 2, then the background color is returned.

 The color values for the standard 16 color palette are:

| Value | Color | Value | Color |
| --- | --- | --- | --- |
| 0 | Black | 8 | Gray |
| 1 | Blue | 9 | Bright Blue |
| 2 | Green | 10 | Bright Green |
| 3 | Cyan | 11 | Bright Cyan |
| 4 | Red | 12 | Bright Red |
| 5 | Magenta | 13 | Pink |
| 6 | Brown | 14 | Yellow |
| 7 | White | 15 | Bright White |

## Return Value

The ASCII or color attribute of the character.

## Remarks

### Usage

`result = Screen( row, column [, colorflag ] )`

### Platform Differences

- On the Linux version, the value returned can differ from the character shown on the console. For example, unprintable control codes - such as the `LF` character (`10`) that implicitly occurs after the end of [`Print`](Print)ed text - may be picked up instead of the untouched character in its place.

### Differences from QB

- In QB `Screen` triggered an error if the coordinates were out of screen.

### See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`Color`](Color)

## Examples

```freebasic
Dim character_ascii_value As ULong

Dim attribute As ULong

Dim background As ULong

Dim cell_color As ULong

Dim row As Long, col As Long

character_ascii_value = Screen( row, col )

attribute = Screen( row, col, 1 )

background = attribute Shr 4

cell_color = attribute And &hf
```

```freebasic
'' open a graphics screen with 4 bits per pixel

'' (alternatively, omit this line to use the console)

ScreenRes 320, 200, 4

'' print a character

Color 7, 1

Print "A"

Dim As ULong char, col, fg, bg

'' get the ASCII value of the character we've just printed

char = Screen(1, 1, 0)

''get the color attributes

col = Screen(1, 1, 1)

fg = col And &HF

bg = (col Shr 4) And &HF

Print Using "ASCII value: ### (""!"")"; char; Chr(char)

Print Using "Foreground color: ##"; fg

Print Using "Background color: ##"; bg

Sleep
```

```freebasic
'' open a graphics screen with 8 bits per pixel

ScreenRes 320, 200, 8

'' print a character

Color 30, 16

Print "Z"

Dim As ULong char, col, fg, bg

'' get the ASCII value of the character we've just printed

char = Screen(1, 1, 0)

''get the color attributes

col = Screen(1, 1, 1)

fg = col And &HFF

bg = (col Shr 8) And &HFF

Print Using "ASCII value: ### (""!"")"; char; Chr(char)

Print Using "Foreground color: ###"; fg

Print Using "Background color: ###"; bg

Sleep
```

```freebasic
'' open a full-color graphics screen

ScreenRes 320, 200, 32

'' print a character

Color RGB(255, 255, 0), RGB(0, 0, 255) 'yellow on blue

Print "M"

Dim As ULong char, fg, bg

'' get the ASCII value of the character we've just printed

char = Screen(1, 1, 0)

''get the color attributes

fg = Screen(1, 1, 1)

bg = Screen(1, 1, 2)

Print Using "ASCII value: ### (""!"")"; char; Chr(char)

Print Using "Foreground color: &"; Hex(fg, 8)

Print Using "Background color: &"; Hex(bg, 8)

Sleep
```

---

**Category:** [Console Functions](Category-Console-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
