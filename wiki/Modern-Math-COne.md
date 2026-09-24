[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **COne**

# COne

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The complex number one.

## Syntax

```freebasic
COne( ) as Complex
```

## Notes

- A function rather than a constant — see `CZero`.
- `z * CReciprocal( z )` is `COne( )` to within rounding, which is the identity most worth asserting about a complex division.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( COne( ) )                 '' 1+0i
print CToString( CSet( 3, 4 ) * COne( ) )  '' 3+4i   -- the multiplicative identity
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
