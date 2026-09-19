[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **DefInt**

# DefInt

Specifies a default data type for a range of variable names

## Syntax

```freebasic
DefInt start_letter[-end_letter ][, ...]
```

## Parameters

- `start_letter`
- `end_letter`

## Description

`DefInt` specifies that variables and arrays which aren't declared with a data type - or not declared at all - are implicitly declared of type [`Integer`](Integer) if the first letter of their names matches a certain letter or lies within an inclusive range of letters.

## Remarks

### Dialect Differences

- Only available in the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.

### Differences from QB

- None

### See also

- [`DefByte`](Defbyte)
- [`DefDbl`](Defdbl)
- [`DefLng`](Deflng)
- [`DefLongInt`](Deflongint)
- [`DefShort`](Defshort)
- [`DefSng`](Defsng)
- [`DefStr`](Defstr)
- [`Integer`](Integer)

## Examples

This will make `iNumber` an [`Integer`](Integer) number since its first letter starts with `i`.

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

DefInt i

Dim iNumber
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
