[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **DefSng**

# DefSng

Specifies a default data type for a range of variable names

## Syntax

```freebasic
DefSng start_letter[-end_letter ][, ...]
```

## Parameters

- `start_letter`
- `end_letter`

## Description

`DefSng` specifies that variables and arrays which aren't declared with a data type - or not declared at all - are implicitly declared of type [`Single`](Single) if the first letter of their names matches a certain letter or lies within an inclusive range of letters.

## Remarks

### Dialect Differences

- Only available in the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.

### Differences from QB

- None

### See also

- [`DefInt`](Defint)
- [`DefDbl`](Defdbl)
- [`Single`](Single)

## Examples

This will make `sNumber` and `yNumber` a [`Single`](Single)-precision decimal number since it is in the range of `s`-`z`.

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

DefSng s-z

Dim sNumber, yNumber
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
