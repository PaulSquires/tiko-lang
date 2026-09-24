[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSin**

# CSin

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The sine.

## Syntax

```freebasic
CSin( byref z as Complex ) as Complex
```

## Notes

- `sin(re)·cosh(im) + i·cos(re)·sinh(im)`, written out directly.
- **It overflows for a large imaginary part**, and correctly so: `cosh` of 750 is beyond `double`. The sine of a complex number really is unbounded — it is `CTan` that stays finite there, and `CTan` is the one with a guard.
- `CSin² + CCos² = 1` holds to within rounding for every operand.
- Spelled with the `C` prefix because a function of the unprefixed name in namespace `FB` would shadow the FreeBASIC intrinsic for every later header — measured, it broke `fb/random.bi` — after which the intrinsic cannot be called back.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )

print CToString( CSin( CZero( ) ) )        '' 0+0i   -- exactly zero
print CToString( CSin( z ) )               '' 3.853738037919377-27.016813258003936i
print CIsFinite( CSin( CSet( 1, 750 ) ) )  '' false   -- unbounded, and honestly so
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
