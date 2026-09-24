[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Reserve**

# Reserve

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)   grow to at least n

## Syntax

```freebasic
Reserve( byval n as long )
```

## Notes

- O(n) — grow to at least n

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )

'' Allocate once up front when the size is known
v.Reserve( 1000 )
print v.Capacity         '' 1024 -- rounded up by doubling
print v.Count            '' 0 -- Reserve allocates, it does not add elements

'' Never shrinks: a smaller request is ignored, so a push/pop loop sitting
'' on a capacity boundary cannot thrash
v.Reserve( 4 )
print v.Capacity         '' 1024
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
