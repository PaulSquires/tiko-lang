[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Pop**

# Pop

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Pop( ) as T
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
v.Push( 10 ) : v.Push( 20 ) : v.Push( 30 )

print v.Pop( )           '' 30 -- removes and returns the last element
print v.Count            '' 2

'' Popping an empty array is not an error: it yields a default-constructed T
dim e as Array( of long )
print e.Pop( )           '' 0
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the tiko-lang repository.
