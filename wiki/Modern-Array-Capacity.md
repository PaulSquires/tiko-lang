[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Capacity**

# Capacity

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Array Container](Category-Array), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Capacity( ) as long
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

dim v as Array( of long )
print v.Capacity         '' 0 -- nothing allocated yet

v.Push( 1 )
print v.Capacity         '' 8 -- the minimum allocation

for i as long = 2 to 9
    v.Push( i )
next
print v.Count & " of " & v.Capacity     '' 9 of 16 -- doubled, not grown by one
```

---

**Library:** [Array Container](Category-Array) ✨  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the tiko-lang repository.
