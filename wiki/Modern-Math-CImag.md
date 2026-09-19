[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CImag**

# CImag

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The imaginary part.

## Syntax

```freebasic
CImag( byref z as Complex ) as double
```

## Notes

- Returns the **coefficient** of i, not `im·i`. `CImag( CSet( 3, 4 ) )` is `4`.
- See `CReal` for why the accessor exists beside the field.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )

print CImag( z )           '' 4
print CImag( CConj( z ) )  '' -4   -- the conjugate flips it
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
