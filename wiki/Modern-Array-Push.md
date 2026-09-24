[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Push**

# Push

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

amortised O(1)

## Syntax

```freebasic
Push( byref v as T )
```

## Notes

- amortised O(1)

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )

'' Amortised O(1): the storage doubles rather than reallocating per push,
'' which is what the `redim preserve` append idiom gets wrong
for i as long = 1 to 5
    v.Push( i * i )
next

print v.Count            '' 5
print v[ 4 ]             '' 25
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
