[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Step**

# Step

Statement modifier.

## Syntax

```freebasic
For iterator = initial_value To end_value Step increment
Line [ buffer, ] Step ( x1, y1 ) - Step ( x2, y2 ) [, [ color ][, [ B|BF ][, style ] ] ]
Circle [ target, ] Step ( x, y ), radius [, [ color ][, [ start ][, [ end ][, [ aspect ][, F] ] ] ] ]
Paint [ target, ] STEP ( x, y ) [, [ paint ][, [ border_color ] ] ]
```

## Description

In a [`For`](For-Next) statement, `Step` specifies the increment of the loop iterator with each loop.

 In a [`Line`](Line-Graphics), [`Circle`](Circle) or [`Paint`](Paint) statement, `Step` indicates that the following coordinate has values relative to the graphics cursor.

## Remarks

### See also

- [`For...Next`](For-Next)
- [`Line`](Line-Graphics)
- [`Circle`](Circle)
- [`Paint`](Paint)

## Examples

```freebasic
Dim i As Integer

For I=10 To 1 Step -1

Next
```

 `Line -Step(10,10),13`

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
