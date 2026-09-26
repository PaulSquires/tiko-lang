[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Contains**

# Contains

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Contains( k ) as boolean
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )

print ages.Contains( "ada" )     '' true
print ages.Contains( "alan" )    '' false

'' Contains does not insert. Reading through m[ "alan" ] would have.
print ages.Count                 '' 1
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
