[Home](Home) › [Array Functions](Category-Array-Functions) › **Option Dynamic**

# Option Dynamic

Specifies variable-length array declarations

## Syntax

```freebasic
Option Dynamic
```

## Description

`Option Dynamic` is a statement that specifies that any following array declarations are variable-length, whether they are declared with constant subscript ranges or not. This remains in effect for the rest of the module in which `Option Dynamic` is used, and can be overridden with [`Option Static`](Option-Static). It is equivalent to the [`'$Dynamic`](Dynamic) metacommand.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OPTION_DYNAMIC__`](Fb-Option-Dynamic)
- [`'$Dynamic`](Dynamic)
- [`'$Static`](Dynamic)
- [`Option Static`](Option-Static)
- [`Dim`](Dim)
- [`ReDim`](Redim)

## Examples

```freebasic
'' Compile with "-lang fblite" compiler switch

#lang "fblite"

Dim foo(99) As Integer      ' declares a fixed-length array

Option Dynamic

Dim bar(99) As Integer      ' declares a variable-length array

' ...

ReDim bar(199)              ' resize the array
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
