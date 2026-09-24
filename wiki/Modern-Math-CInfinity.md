[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CInfinity**

# CInfinity

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A complex infinity — both components positive infinity.

## Syntax

```freebasic
CInfinity( ) as Complex
```

## Notes

- A function rather than a constant — see `CNaN`.
- `CIsInfinite` is true for *any* complex number with an infinite component, not only for this one.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CIsInfinite( CInfinity( ) )              '' true
print CIsInfinite( CSet( 1.0, Infinity( ) ) )  '' true   -- one part is enough
print CAbs( CInfinity( ) )                     '' 1.#INF
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
