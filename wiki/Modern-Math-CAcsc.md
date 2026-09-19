[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAcsc**

# CAcsc

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The inverse cosecant.

## Syntax

```freebasic
CAcsc( byref z as Complex ) as Complex
CAcsc( byval x as double ) as Complex
```

## Notes

- `CAsin( CReciprocal( z ) )`.
- The `double` overload is AfxNova's `CArcCscReal`.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CAcsc( CSet( 2, 1 ) ) )  '' 0.40158639166780613-0.21561241855582966i
print CToString( CAcsc( 0.5 ) )           '' 1.5707963267948966+1.3169578969248166i
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
