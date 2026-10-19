[Home](Home) › [2D Drawing Functions](Category-2D-Drawing-Functions) › **Or (Graphics Put)**

# Or (Graphics Put)

Combines source and destination pixels with a bitwise Or, as a Put method.

## Syntax

```freebasic
Put [ target, ] [ STEP ] ( x,y ), source [ ,( x1,y1 )-( x2,y2 ) ], Or
```

## Description

The `Or` method combines each source pixel with the corresponding destination pixel, using the bit-wise [`Or`](Operator-or-Inclusive-Disjunction) function. The result of this is output as the destination pixel.  
 This method works in all graphics modes. There is no mask color, although color values of `0` (`RGBA(0, 0, 0, 0)` in full-color modes) will have no effect, because of the behavior of [`Or`](Operator-or-Inclusive-Disjunction).

 In full-color modes, each component (red, green, blue and alpha) is kept in a discrete set of bits, so the operation can be made to only affect some of the channels, by making sure the all the values of the other channels are set to `0`.

## Remarks

### Differences from QB

- None

### See also

- [`Or`](Operator-or-Inclusive-Disjunction)
- [`Put (Graphics)`](Put-Graphics)

## Examples

```freebasic
''open a graphics window

ScreenRes 320, 200, 16

''create 3 sprites containing red, green and blue circles

Const As Long r = 32

Dim As Any Ptr cr, cg, cb

cr = ImageCreate(r * 2 + 1, r * 2 + 1, RGBA(0, 0, 0, 0))

cg = ImageCreate(r * 2 + 1, r * 2 + 1, RGBA(0, 0, 0, 0))

cb = ImageCreate(r * 2 + 1, r * 2 + 1, RGBA(0, 0, 0, 0))

Circle cr, (r, r), r, RGB(255, 0, 0), , , 1, f

Circle cg, (r, r), r, RGB(0, 255, 0), , , 1, f

Circle cb, (r, r), r, RGB(0, 0, 255), , , 1, f

''put the sprite at three different multipier

''levels, overlapping each other in the middle

Put (146 - r, 108 - r), cr, Or

Put (174 - r, 108 - r), cg, Or

Put (160 - r,  84 - r), cb, Or

''free the memory used by the sprites

ImageDestroy cr

ImageDestroy cg

ImageDestroy cb

''pause the program before closing

Sleep
```

---

**Category:** [2D Drawing Functions](Category-2D-Drawing-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
