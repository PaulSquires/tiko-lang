[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MinOf**

# MinOf

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The smallest value in the array.

## Syntax

```freebasic
MinOf( a( ) as T ) as double
```

## Notes

- Distinct from `Min`, which compares two values -- this reduces an array.
- An empty array gives 0.
- `Range` is `MaxOf` minus this.

## Examples

```freebasic
#include once "fb/stats.bi"
using FB

dim as double a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print MinOf( a( ) )          '' 2
print MaxOf( a( ) )          '' 6
print Range( a( ) )          '' 4 -- the difference
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
