[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Shrink**

# Shrink

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)   release unused capacity

## Syntax

```freebasic
Shrink( )
```

## Notes

- O(n) — release unused capacity

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
v.Reserve( 1000 )
v.Push( 1 ) : v.Push( 2 )

print v.Capacity         '' 1024
v.Shrink( )
print v.Capacity         '' 2 -- capacity cut down to Count

'' Shrinking an empty array releases the storage entirely
v.Clear( )
v.Shrink( )
print v.Capacity         '' 0
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
