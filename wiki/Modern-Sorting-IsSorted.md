[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **IsSorted**

# IsSorted

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Sorting](Category-Sorting), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsSorted( a ) as boolean
```

## Examples

```freebasic
#include once "fb/array.bi"
#include once "fb/sort.bi"
using FB

dim v as Array( of long )
v.Push( 1 ) : v.Push( 2 ) : v.Push( 2 ) : v.Push( 3 )

print IsSorted( v )          '' true -- equal neighbours are still sorted

v.Push( 0 )
print IsSorted( v )          '' false

'' O(n) and allocation-free, so it is cheap as a guard before a sort
'' that is usually redundant
if not IsSorted( v ) then Sort( v )
print IsSorted( v )          '' true
```

---

**Library:** [Sorting](Category-Sorting) ✨  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures  
**Source:** `docs/sort/sort.txt` in the tiko-lang repository.
