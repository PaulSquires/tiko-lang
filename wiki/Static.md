[Home](Home) › [Array Functions](Category-Array-Functions) › **$Static**

# $Static

Metacommand to change the way arrays are allocated

## Syntax

```freebasic
'$Static
Rem $Static
```

## Description

`'$Static` is a metacommand that overrides the behavior of [`$Dynamic`](Dynamic), that is, arrays declared with constant subscript ranges are fixed-length. This remains in effect for the rest of the module in which `'$Static` is used, and can be overridden with [`$Dynamic`](Dynamic). It is equivalent to the [`Option Static`](Option-Static) statement.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- When used inside comments it must be the first token

### See also

- [`$Dynamic`](Dynamic)
- [`Dim`](Dim)
- [`Erase`](Erase)
- [`ReDim`](Redim)
- [`Option Dynamic`](Option-Dynamic)
- [`Option Static`](Option-Static)

## Examples

```freebasic
' compile with -lang fblite or qb

#lang "fblite"

'$dynamic

Dim a(100)   '<<this array will be variable-length

'$static

Dim b(100)   '<<this array will be fixed-length
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
