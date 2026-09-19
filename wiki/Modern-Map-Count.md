[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Count**

# Count

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Count( ) as long
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of string, integer )
print ages.Count                 '' 0

ages.Put( "ada", 36 )
ages.Put( "ada", 37 )            '' an overwrite, not an insertion
print ages.Count                 '' 1

'' Watch for the indexer: reading an absent key INSERTS it
print ages[ "nobody" ]           '' 0
print ages.Count                 '' 2
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the tiko-lang repository.
