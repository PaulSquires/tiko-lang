[Home](Home) › [Array Functions](Category-Array-Functions) › **Option Static**

# Option Static

Reverts to default array declaration behavior

## Syntax

```freebasic
Option Static
```

## Description

`Option Static` is a statement that overrides the behavior of [`Option Dynamic`](Option-Dynamic), that is, arrays declared with constant subscript ranges are fixed-length. This remains in effect for the rest of the module in which `Option Static` is used, and can be overridden with [`Option Dynamic`](Option-Dynamic). It is equivalent to the [`'$Static`](Static) metacommand.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`'$Dynamic`](Dynamic)
- [`'$Static`](Static)
- [`Dim`](Dim)
- [`Erase`](Erase)
- [`ReDim`](Redim)
- [`Option Dynamic`](Option-Dynamic)
- [`Static`](procedures-Static)

## Examples

```freebasic
'' Compile with the "-lang fblite" compiler switch

#lang "fblite"

Option Dynamic

Dim foo(100) As Integer            ' declares a variable-length array

Option Static

Dim bar(100) As Integer            ' declares a fixed-length array
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
