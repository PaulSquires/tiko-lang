[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Put**

# Put

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

true if the key was new

## Syntax

```freebasic
Put( k, v ) as boolean
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of string, integer )

print ages.Put( "ada", 36 )      '' true -- the key was new
print ages.Put( "ada", 37 )      '' false -- existed, and was OVERWRITTEN
print ages[ "ada" ]              '' 37

'' Add is the same call that refuses to overwrite
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the tiko-lang repository.
