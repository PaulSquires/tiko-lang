[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **At**

# At

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
At( i ) byref as T
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
v.Push( 10 ) : v.Push( 20 )

print v.At( 1 )          '' 20

'' At returns BYREF, so it assigns in place
v.At( 0 ) = 99
print v[ 0 ]             '' 99

'' Identical to the [] operator; At reads better through a pointer:
'' p->At( 0 ) rather than (*p)[ 0 ]
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
