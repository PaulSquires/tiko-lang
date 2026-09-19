[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **DefDbl**

# DefDbl

Specifies a default data type for a range of variable names

## Syntax

```freebasic
DefDbl start_letter[-end_letter ][, ...]
```

## Parameters

- `start_letter`
- `end_letter`

## Description

`DefDbl` specifies that variables and arrays which aren't declared with a data type - or not declared at all - are implicitly declared of type [`Double`](Double) if the first letter of their names matches a certain letter or lies within an inclusive range of letters.

## Remarks

### Dialect Differences

- Only available in the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.

### Differences from QB

- None

### See also

- [`DefInt`](Defint)
- [`DefSng`](Defsng)
- [`Dim`](Dim)
- [`Double`](Double)

## Examples

This will make `aNum` a [`Double`](Double)-precision decimal number since it is in the range of `a`-`d`:

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

DefDbl a-d

Dim aNum 'implicit: As Double

Print Len(aNum) ' Prints 8, the number of bytes in a double.
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
