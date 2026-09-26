[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Clear**

# Clear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)   drops elements, KEEPS capacity

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n) — drops elements, KEEPS capacity

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of ustring )
v.Push( "a" ) : v.Push( "b" )

v.Clear( )
print v.Count            '' 0
print v.Capacity         '' 8 -- the capacity is KEPT, so a refill loop
                         '' does not reallocate

'' The slots are reset, so a T holding a resource releases it now rather
'' than at the array's destruction
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
