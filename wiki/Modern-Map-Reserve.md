[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Reserve**

# Reserve

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Reserve( byval n as long )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of ustring, integer )

'' Size it once up front and the fill does no rehashing
ages.Reserve( 1000 )
print ages.Capacity              '' 2048 -- power of two, with room for
                                 '' the 0.75 load factor
print ages.Count                 '' 0
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
