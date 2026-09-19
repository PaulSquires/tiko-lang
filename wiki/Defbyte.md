[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **DefByte**

# DefByte

Specifies a default data type for a range of variable names

## Syntax

```freebasic
DefByte start_letter[-end_letter ][, ...]
```

## Parameters

- `start_letter`
- `end_letter`

## Description

`DefByte` specifies that variables and arrays which aren't declared with a data type - or not declared at all - are implicitly declared of type [`Byte`](Byte) if the first letter of their names matches a certain letter or lies within an inclusive range of letters.

## Remarks

### Dialect Differences

- Available in the *[-lang fblite](Compiler-Option-Lang)* dialect.
- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Defbyte`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Byte`](Byte)
- [`DefInt`](Defint)
- [`DefUByte`](Defubyte)
- [`Dim`](Dim)

## Examples

This will make `bNumber` a [`Byte`](Byte) number since it's first letter starts with `b`:

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

DefByte b

Dim bNumber
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
