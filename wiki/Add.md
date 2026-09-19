[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **Add**

# Add

Parameter to the Put graphics statement which selects addition as the blitting method

## Syntax

```freebasic
Put [ target, ] [ STEP ] ( x,y ), source [ ,( x1,y1 )-( x2,y2 ) ], Add[ ,multiplier ]
```

## Parameters

- `multiplier`

## Description

`Add` selects addition as the method for blitting an image buffer. For each source and target pixel, the values of each respective component are added together to produce the result.  
 The addition is saturated - i.e. if the sum of the two values is 256 or more, then it will be cropped down to 255.

 This method will work in all color modes. Mask colors (color 0 for indexed images, magenta (`RGB(255, 0, 255)`) for full color images) will be skipped, though full color values of 0 (`RGBA(0, 0, 0, 0)`) will have also have no effect.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Trans`](Trans)
- [`Alpha`](Alpha)
- [`Custom`](Custom)
- [`Put (Graphics)`](Put-Graphics)

## Examples

```freebasic
''open a graphics window

ScreenRes 320, 200, 16

''create a sprite containing a circle

Const As Integer r = 32

Dim c As Any Ptr = ImageCreate(r * 2 + 1, r * 2 + 1, 0)

Circle c, (r, r), r, RGB(255, 255, 192), , , 1, f

''put the sprite at three different multipier

''levels, overlapping each other in the middle

Put (146 - r, 108 - r), c, Add,  64

Put (174 - r, 108 - r), c, Add, 128

Put (160 - r,  84 - r), c, Add, 192

''free the memory used by the sprite

ImageDestroy c

''pause the program before closing

Sleep
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
