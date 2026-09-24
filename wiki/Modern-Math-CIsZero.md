[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CIsZero**

# CIsZero

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

True when both components are zero.

## Syntax

```freebasic
CIsZero( byref z as Complex ) as boolean
```

## Notes

- True for either sign of zero in either component — see `CIsReal`.
- `CReciprocal` and `CSgn` both check this first, and both return zero rather than an infinity or a NaN when it holds.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CIsZero( CZero( ) )           '' true
print CIsZero( CSet( -0.0, 0.0 ) )  '' true
print CIsZero( CSet( 0, 1e-320 ) )  '' false
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
