[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **DefLongInt**

# DefLongInt

Specifies a default data type for a range of variable names

## Syntax

```freebasic
DefLongInt start_letter[-end_letter ][, ...]
```

## Parameters

- `start_letter`
- `end_letter`

## Description

`DefLongInt` specifies that variables and arrays which aren't declared with a data type - or not declared at all - are implicitly declared of type [`LongInt`](Longint) if the first letter of their names matches a certain letter or lies within an inclusive range of letters.

## Remarks

### Dialect Differences

- Available in the *[-lang fblite](Compiler-Option-Lang)* dialect.
- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Deflongint`.

### Differences from QB

- New to FreeBASIC

### See also

- [`DefInt`](Defint)
- [`Defulongint`](Defulongint)
- [`Dim`](Dim)
- [`LongInt`](Longint)

## Examples

This will make `lNumber` a [`LongInt`](Longint) number since it's first letter starts with `l`.

```freebasic
'' Compile with -lang fblite

#lang "fblite"

DefLongInt l

Dim lNumber
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
