[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Items**

# Items

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Items( ) as Array( of T )
```

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )
for i as integer = 1 to 3
    seen.Add( i )
next

'' A snapshot as an Array, not a live view
dim xs as Array( of integer ) = seen.Items( )
print xs.Count               '' 3

'' ITERATION ORDER IS UNSPECIFIED -- sort the snapshot when the output
'' has to be reproducible
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the tiko-lang repository.
