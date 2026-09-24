[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Remove**

# Remove

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)   preserves order

## Syntax

```freebasic
Remove( byval i as long )
```

## Notes

- O(n) — preserves order

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of string )
v.Push( "a" ) : v.Push( "b" ) : v.Push( "c" )

v.Remove( 1 )            '' order-preserving, O(n)
print v[ 0 ] & v[ 1 ]    '' ac
print v.Count            '' 2

'' An out-of-range index is a no-op, not an error
v.Remove( 99 )
print v.Count            '' 2
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
