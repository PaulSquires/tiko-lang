[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **RemoveSwap**

# RemoveSwap

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(1)   does NOT preserve order

## Syntax

```freebasic
RemoveSwap( byval i as long )
```

## Notes

- O(1) — does NOT preserve order

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of string )
v.Push( "a" ) : v.Push( "b" ) : v.Push( "c" ) : v.Push( "d" )

'' O(1), but the LAST element moves into the hole -- order is not preserved.
'' Named so it cannot be picked by accident.
v.RemoveSwap( 0 )
print v[ 0 ] & v[ 1 ] & v[ 2 ]     '' dbc
print v.Count            '' 3
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
