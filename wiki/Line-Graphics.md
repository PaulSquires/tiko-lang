[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **Line (Graphics)**

# Line (Graphics)

Draws a line between two points, or a box or filled box with B or BF.

## Syntax

```freebasic
Line [target,] [[STEP]|(x1, y1)]-[STEP] (x2, y2) [, [color][, [B|BF][, style]]]
Line - (x2, y2) [, [color][, [B|BF][, style]]]
```

## Parameters

- `target`
- `(x1, y1)`
- `(x2, y2)`
- `color`
- `style`

## Description

Graphics statement that draws a straight line or a box between two points. The action will take place on the current work page set via [`ScreenSet`](Screenset), or onto the buffer [`Get`](Get-Graphics)/[`Put`](Put-Graphics) buffer if specified.

 `Line` coordinates are affected by custom coordinates system set via [`Window`](Window) and [`View (Graphics)`](View-Graphics) statements, and respect clipping rectangle set by [View (Graphics)](View-Graphics). If a pair of coordinates is preceded by the `STEP` keyword, the coordinates are assumed to be relative to the last graphics cursor position. If the `B` flag is specified, a rectangle will be drawn instead of a line, with `(x1,y1)-(x2,y2)` as the coordinates of the opposite rectangle corners. If `BF` is specified, a filled rectangle will be drawn.

 `Color` denotes the color attribute, which is mode specific (see [`Color`](Color) and [`Screen (Graphics)`](Screen-Graphics) for details). If omitted, the current foreground color as set by the [`Color`](Color) statement is used.

 `Style`, if specified, allows styled line drawing; its value is interpreted as a 16-bit bitmask, and `Line` will use it to skip pixel drawing. Starting at `(x1,y1)`, the most significant bit of the style mask is checked: if `1`, the pixel is drawn, if `0`, it's skipped. This repeats for all the line pixels with the other bits, with the mask being reused when the 16 bits are all checked.

 When `Line` is used as `Line - (x2, y2)`, a line is drawn from the current cursor position to the `(x2,y2)` coordinates specified by `Line`. Alternatively, [`Point`](Point) can be used to get the current cursor position.

 **Note:** Either chained use or boxes drawn with `Line` can induce pixels overdrawn at some locations. Thus, the resultant (blended) color of these overdrawn pixels is affected if a transparent color (in conjunction with the `GFX_ALPHA_PRIMITIVES` option flag) is used.

## Remarks

### Differences from QB

- `target` is new to FreeBASIC

### See also

- [Circle](Circle)
- [Window](Window)
- [View (Graphics)](View-Graphics)

## Examples

```freebasic
'' draws a diagonal red line with a white box, and waits for 3 seconds

Screen 13

Line (20, 20)-(300, 180), 4

Line (140, 80)-(180, 120), 15, b

Line - ( 200, 200 ), 15

Sleep 3000
```

```freebasic
' Draws 2 lines with 2 different line styles in 2 different colors

ScreenRes 320, 240

Line (10, 100)-(309, 140),  4, B, &b1010101010101010 ' red box with dashed border

Line (20, 115)-(299, 115),  9,  , &b1111000011111111 ' blue dashed line

Line (20, 125)-(299, 125), 10,  , &b0000000011110000 ' green dashed line

Sleep
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
