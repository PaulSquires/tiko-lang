[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **PReset**

# PReset

Plots one pixel, in the given colour or the current background colour.

## Syntax

```freebasic
PReset [target ,] [STEP] (x, y) [,color]
```

## Parameters

- `target`
- `color`

## Description

`target` specifies buffer to draw on. `target` may be an image created with [`ImageCreate`](Imagecreate) or [`Get (Graphics)`](Get-Graphics). If omitted, *target* defaults to the screen's current work page.

 `(x, y)` are the coordinates of the pixel. STEP if present, indicates that `(x, y)` coordinates are relative to the graphics cursor position. If omitted, `(x, y)` are relative to the upper left-hand corner of `target`. The x and y coordinates are affected by the last call to the [`View (Graphics)`](View-Graphics) and [`Window`](Window) statements, and respect the current clipping region as set by the [`View (Graphics)`](View-Graphics) statement.

 `color` specifies the color attribute. If omitted, `color` defaults to the current background color. See [`Color`](Color). `color` is graphics mode specific, see [`Color`](Color) and [`Screen (Graphics)`](Screen-Graphics) for details.

## Remarks

### Differences from QB

- `target` is new to FreeBASIC

### See also

- [`PSet`](Pset-Statement)

## Examples

```freebasic
Screen 13

'Set background color to 15

Color , 15

'Draw a pixel with the background color at 10, 10

PReset (10,10)

'Draw a pixel with the background color at Last x cord +10, Last y cord +10

PReset Step (10,10)

Sleep
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
