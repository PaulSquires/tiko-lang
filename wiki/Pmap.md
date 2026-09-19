[Home](Home) › [Screen Functions](Category-Screen-Functions) › **PMap**

# PMap

Maps coordinates between view and physical mapping.

## Syntax

```freebasic
Declare Function PMap ( ByVal coord As Single, ByVal func As Long ) As Single
```

## Parameters

- `coord`
- `func`

## Description

This function converts a coordinate between view (as defined by the [`Window`](Window) statement) and physical (as set by the [`View (Graphics)`](View-Graphics) statement) mappings. Depending on the value of `func`, `expr` is used to compute a different mapping to be returned by `PMap`:

| func value: | return value: |
| --- | --- |
| 0 | Treats expr as x view coordinate and returns corresponding x physical coordinate. |
| 1 | Treats expr as y view coordinate and returns corresponding y physical coordinate. |
| 2 | Treats expr as x physical coordinate and returns corresponding x view coordinate. |
| 3 | Treats expr as y physical coordinate and returns corresponding y view coordinate. |

## Return Value

The mapped coordinate value.

## Remarks

### Usage

`result = PMap( coord, func )`

### Differences from QB

- None

### See also

- [`Window`](Window)
- [`View (Graphics)`](View-Graphics)

## Examples

```freebasic
ScreenRes 640, 480

Window Screen (0, 0)-(100, 100)

Print "Logical x=50, Physical x="; PMap(50, 0)   '' 320

Print "Logical y=50, Physical y="; PMap(50, 1)   '' 240

Print "Physical x=160, Logical x="; PMap(160, 2) '' 25

Print "Physical y=60, Logical y="; PMap(60, 3)   '' 12.5

Sleep
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
