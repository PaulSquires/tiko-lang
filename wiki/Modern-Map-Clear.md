[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Clear**

# Clear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )
ages.Put( "grace", 45 )

ages.Clear( )
print ages.Count                 '' 0
print ages.Contains( "ada" )     '' false
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
