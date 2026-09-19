[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **IsEmpty**

# IsEmpty

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
print v.IsEmpty          '' true

v.Push( 1 )
print v.IsEmpty          '' false

v.Clear( )
print v.IsEmpty          '' true -- Clear drops the elements
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the tiko-lang repository.
