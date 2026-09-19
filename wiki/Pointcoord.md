[Home](Home) › [Screen Functions](Category-Screen-Functions) › **PointCoord**

# PointCoord

Queries Draw's pen position in graphics mode

## Syntax

```freebasic
Declare Function PointCoord( ByVal func As Long ) As Single
```

## Description

The `PointCoord` function can be used to query x and y position of the [`Draw`](Draw) pen in graphics mode. The *result* value depends on the passed *func* value:

| func value: | return value: |
| --- | --- |
| 0 | x physical coordinate, same as PMap( PointCoord( 2 ), 0 ) |
| 1 | y physical coordinate, same as PMap( PointCoord( 3 ), 1 ) |
| 2 | x view coordinate |
| 3 | y view coordinate |

## Remarks

### Usage

`result = PointCoord( func )`

### Differences from QB

- New to FreeBASIC

### See also

- [`PMap`](Pmap)
- [`Window`](Window)

## Examples

```freebasic
Screen 12

Print "--- Default window coordinate mapping ---"

Print "DRAW pen position, at the default (0,0):"

Print "Physical:", PointCoord( 0 ), PointCoord( 1 )

Print "View:", PointCoord( 2 ), PointCoord( 3 )

Draw "BM 50,50"

Print "DRAW pen position, after being moved to (50,50):"

Print "Physical:", PointCoord( 0 ), PointCoord( 1 )

Print "View:", PointCoord( 2 ), PointCoord( 3 )

Print "--- Changing window coordinate mapping ---"

Window Screen (-100, -100) - (100, 100)

Draw "BM 0,0"

Print "DRAW pen position, after being moved to (0,0):"

Print "Physical:", PointCoord( 0 ), PointCoord( 1 )

Print "View:", PointCoord( 2 ), PointCoord( 3 )

Draw "BM 50,50"

Print "DRAW pen position, after being moved to (50,50):"

Print "Physical:", PointCoord( 0 ), PointCoord( 1 )

Print "View:", PointCoord( 2 ), PointCoord( 3 )

Sleep
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
