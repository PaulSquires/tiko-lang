[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **Xor (Graphics Put)**

# Xor (Graphics Put)

Combines source and destination pixels with a bitwise Xor, as a Put method.

## Syntax

```freebasic
Put [ target, ] [ STEP ] ( x,y ), source [ ,( x1,y1 )-( x2,y2 ) ], Xor
```

## Description

The `Xor` method combines each source pixel with the corresponding destination pixel, using the bit-wise [`Xor`](Operator-Xor-Exclusive-Disjunction) function. The result of this is output as the destination pixel.  
 This method works in all graphics modes. There is no mask color, although color values of `0` (`RGBA(0, 0, 0, 0)` in full-color modes) will have no effect, because of the behavior of [`Xor`](Operator-Xor-Exclusive-Disjunction).

 In full-color modes, each component (red, green, blue and alpha) is kept in a discrete set of bits, so the operation can be made to only affect some of the channels, by making sure the all the values of the other channels are set to `0`.

## Remarks

### Differences from QB

- None

### See also

- [`Xor`](Operator-Xor-Exclusive-Disjunction)
- [`Put (Graphics)`](Put-Graphics)

## Examples

```freebasic
''open a graphics window

ScreenRes 320, 200, 16

''create a sprite containing a circle

Const As Integer r = 32

Dim c As Any Ptr = ImageCreate(r * 2 + 1, r * 2 + 1, 0)

Circle c, (r, r), r, RGBA(255, 255, 255, 0), , , 1, f

''put the three sprites, overlapping each other in the middle

Put (146 - r, 108 - r), c, Xor

Put (174 - r, 108 - r), c, Xor

Put (160 - r,  84 - r), c, Xor

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
