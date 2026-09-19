[Home](Home) › [Array Functions](Category-Array-Functions) › **$Dynamic**

# $Dynamic

Metacommand to change the way arrays are allocated

## Syntax

```freebasic
'$Dynamic
Rem $Dynamic
```

## Description

**'$Dynamic** is a metacommand that specifies that any following array declarations are variable-length, whether they are declared with constant subscript ranges or not. This remains in effect for the rest of the module in which **'$Dynamic** is used, and can be overridden with [`'$Static`](Static). It is equivalent to the [`Option Dynamic`](Option-Dynamic) statement.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- When used inside comments it must be the first token

### See also

- [`$Static`](Static)
- [`Dim`](Dim)
- [`ReDim`](Redim)
- [`Erase`](Erase)
- [`Option Dynamic`](Option-Dynamic)

## Examples

```freebasic
' compile with -lang fblite or qb

#lang "fblite"

'$DYNAMIC

Dim a(100)

'......

ReDim a(200)
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
