[Home](Home) › [Screen Functions](Category-Screen-Functions) › **View (Graphics)**

# View (Graphics)

Sets the rectangle that drawing is clipped to, or resets it to the whole screen.

## Syntax

```freebasic
View
View ( x1, y1 )-( x2, y2 ) [ [, fill_color ] [, border_color ] ]
View Screen ( x1, y1 )-( x2, y2 ) [ [, fill_color ] [, border_color ] ]
```

## Parameters

- `x1`
- `y1`
- `x2`
- `y2`
- `fill_color`
- `border_color`

## Description

The *viewport*, or clipping region, is a rectangular area of the graphics screen, outside of which no graphics drawing will be done. That is, only graphics drawing done within this area will be shown. A graphics screen must be created with [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres) before calling `View` or `View Screen`.

 The first statement (`View`) sets the viewport to encompass the entire screen, which is the default viewport for a new graphics screen.

 The second and third statements (`View` `parameters` and `View Screen` `parameters`) both allow a new viewport to be defined. The indicated effects for each parameter only occur if that parameter is specified:

## Remarks

### Differences from QB

- QBASIC preserves the `WINDOW` coordinate mapping after subsequent calls to `VIEW`.
  FreeBASIC's current behavior is to preserve the `WINDOW` coordinates after calls to `VIEW`, or when working on images, meaning that the coordinate mapping may undergo scaling/translations if the viewport changes. (If a `WINDOW` hasn't been set, there is no coordinate mapping, and so it doesn't change after calls to `VIEW`.) The behavior may change in future, but consistent behavior can be assured over inconstent viewport coordinates by re-calling `WINDOW` whenever you change the `VIEW`.

### See also

- [`View Print`](View-Print)
- [`Screen (Graphics)`](Screen-Graphics)
- [`Window`](Window)
- [`PMap`](Pmap)

## Examples

```freebasic
Screen 12

Dim ip As Any Ptr

Dim As Integer x, y

'simple sprite

ip = ImageCreate(64,64)

For y = 0 To 63

  For x = 0 To 63

    PSet ip, (x, y), (x\4) Xor (y\4)

  Next x

Next y

'viewport with blue border

Line (215,135)-(425,345), 1, bf

View (220,140)-(420,340)

'move sprite around the viewport

Do

  x = 100*Sin(Timer*2.0)+50

  y = 100*Sin(Timer*2.7)+50

  ScreenSync

  ScreenLock

  'clear viewport and put image

  Cls 1

  Put (x, y), ip, PSet

  ScreenUnlock

Loop While Inkey = ""

ImageDestroy(ip)
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
