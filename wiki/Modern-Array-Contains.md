[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Contains**

# Contains

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Contains( a, v ) as boolean
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
v.Push( 10 ) : v.Push( 20 )

'' T is inferred from the array, so the value must already BE a T --
'' a bare `20` is an INTEGER literal and gives error 340
dim as long wanted = 20
print Contains( v, wanted )      '' true

dim as long absent = 99
print Contains( v, absent )      '' false

'' Exactly IndexOf( ) >= 0, for the common case where the position is
'' not wanted
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
