[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CZero**

# CZero

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The complex number zero.

## Syntax

```freebasic
CZero( ) as Complex
```

## Notes

- **A function, not a constant.** `const as Complex` cannot be initialised from a division by zero, so the whole family is spelled with parentheses for consistency with `CNaN` and `CInfinity`, which have no choice.
- `CIsZero( CZero( ) )` is true, and so is `CIsReal( CZero( ) )`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CZero( ) )  '' 0+0i
print CIsZero( CZero( ) )    '' true
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
