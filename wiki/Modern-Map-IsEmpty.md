[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **IsEmpty**

# IsEmpty

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of string, integer )
print ages.IsEmpty               '' true

ages.Put( "ada", 36 )
print ages.IsEmpty               '' false

ages.Clear( )
print ages.IsEmpty               '' true
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the tiko-lang repository.
