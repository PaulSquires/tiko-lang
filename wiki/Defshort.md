[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **DefShort**

# DefShort

Specifies a default data type for a range of variable names

## Syntax

```freebasic
DefShort start_letter[-end_letter ][, ...]
```

## Parameters

- `start_letter`
- `end_letter`

## Description

`DefShort` specifies that variables and arrays which aren't declared with a data type - or not declared at all - are implicitly declared of type [`Short`](Short) if the first letter of their names matches a certain letter or lies within an inclusive range of letters.

## Remarks

### Dialect Differences

- Available in the *[-lang fblite](Compiler-Option-Lang)* dialect.
- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Defshort`.

### Differences from QB

- New to FreeBASIC
- In QBasic, to make variables default to a 2 byte integer, DEFINT is used.

### See also

- [`DefInt`](Defint)
- [`DefUShort`](Defushort)
- [`Dim`](Dim)
- [`Integer`](Integer)
- [`Short`](Short)

## Examples

This will make `sNumber` a [`Short`](Short) number since its first letter starts with `s`.

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

DefShort s

Dim sNumber
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
