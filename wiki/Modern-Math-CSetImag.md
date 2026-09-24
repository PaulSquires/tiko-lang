[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSetImag**

# CSetImag

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Assigns the imaginary part in place.

## Syntax

```freebasic
CSetImag( byref z as Complex, byval y as double )
```

## Notes

- A **sub**, not a function — see `CSetReal`.
- `y` is the coefficient of i, so `CSetImag( z, 4 )` makes the imaginary part `4i`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )
CSetImag( z, -2 )

print CToString( z )  '' 3-2i   -- after CSetImag( z, -2 )
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
