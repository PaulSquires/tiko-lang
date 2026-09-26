[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Count**

# Count

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Count( ) as long
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of ustring )
print v.Count            '' 0

v.Push( "a" ) : v.Push( "b" )
print v.Count            '' 2

'' The valid indices are 0 to Count-1
for i as long = 0 to v.Count - 1
    print i & ": " & v[ i ]
next
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
