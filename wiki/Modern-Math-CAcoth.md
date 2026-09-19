[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAcoth**

# CAcoth

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The inverse hyperbolic cotangent.

## Syntax

```freebasic
CAcoth( byref z as Complex ) as Complex
```

## Notes

- `CAtanh( CReciprocal( z ) )`, so it inherits the branch-cut handling of `CAtanh`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CAcoth( CSet( 2, 1 ) ) )  '' 0.4023594781085251-0.23182380450040307i
print CToString( CAcoth( CSet( 2, 0 ) ) )  '' 0.5493061443340549-0i   -- 1/2 is inside the real domain
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
