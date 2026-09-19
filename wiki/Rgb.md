[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **RGB**

# RGB

Computes a valid color value for hi/truecolor modes

## Syntax

```freebasic
#define RGB(r,g,b) CULng((CUByte(r) Shl 16) Or (CUByte(g) Shl 8) Or CUByte(b) Or (&hFF000000ul))
```

## Parameters

- `red`
- `green`
- `blue`

## Description

`red`, `green` and `blue` are components ranging `0`-`255`.

 The `RGB` function can be used to compute a valid color value for use while in hi/truecolor modes. It returns an unsigned long, in the format `&hAARRGGBB`, where `RR`, `GG` and `BB` equal the values passed to this function, in hexadecimal format. `AA` is the implicit alpha value and is automatically set to `&hFF` (opaque).  
 It is possible to retrieve the red, green, blue and alpha values from a color value, by using a combination of [`And`](Operator-and-Conjunction) and [`Shr`](Operator-Shr-Shift-Right). The second example below shows how to [`#define`](Define) and use macros to do this.

 **Note for Windows API programmers**: The macro named `RGB` in the Windows references has been renamed `BGR` in the FB headers for Windows to avoid collisions.

## Return Value

The combined color.

## Remarks

### Usage

`result = RGB(red, green, blue)`

### Version

- Before fbc 1.08.0:

Syntax:

`#define RGB(r,g,b) ((CULng(r) Shl 16) Or (CULng(g) Shl 8) Or CULng(b) Or &hFF000000)`

`RGB` function returned an unsigned integer.

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Rgb`.

### Differences from QB

- New to FreeBASIC

### See also

- [`RGBA`](Rgba)
- [`Color`](Color)
- [`#define`](Define)

## Examples

See [`Put (Graphics)`](Put-Graphics) example in addition.

```freebasic
ScreenRes 640,480,32  '32 bit color

Line(0,0)-(319,479), RGB(255,0,0) 'draws a bright red box on the left side of the window

Line(639,0)-(320,479), RGB(0,0,255) 'draws a bright blue box on the right side of the window

Sleep 'wait before exiting
```

```freebasic
'' setting and retrieving Red, Green, Blue and Alpha values

#define RGBA_R( c ) ( CULng( c ) Shr 16 And 255 )

#define RGBA_G( c ) ( CULng( c ) Shr  8 And 255 )

#define RGBA_B( c ) ( CULng( c )        And 255 )

#define RGBA_A( c ) ( CULng( c ) Shr 24         )

Dim As UByte r, g, b, a

Dim As ULong col = RGB(128, 192, 64)

Print Using "Color: _&H\      \"; Hex(col, 8)

r = RGBA_R( col )

g = RGBA_G( col )

b = RGBA_B( col )

a = RGBA_A( col )

Print

Print Using "Red:         _&H\\ = ###"; Hex(r, 2); r

Print Using "Green:       _&H\\ = ###"; Hex(g, 2); g

Print Using "Blue:        _&H\\ = ###"; Hex(b, 2); b

Print Using "Alpha:       _&H\\ = ###"; Hex(a, 2); a
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
