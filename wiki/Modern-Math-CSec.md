[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSec**

# CSec

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The secant — one over the cosine.

## Syntax

```freebasic
CSec( byref z as Complex ) as Complex
```

## Notes

- `CReciprocal( CCos( z ) )`. It is infinite where the cosine is zero, and this returns a large finite number rather than an exact infinity because the cosine there is merely tiny, not zero.
- One of the six reciprocal trigonometric functions AfxNova supplies and .NET does not.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 0.5, 0.25 )

print CToString( CSec( z ) )                 '' 1.085358604751614+0.14522062866143562i
print CToString( CReciprocal( CCos( z ) ) )  '' 1.085358604751614+0.14522062866143562i   -- the same thing
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
