[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **IsEmpty**

# IsEmpty

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )
print seen.IsEmpty           '' true

dim as integer x = 1
seen.Add( x )
print seen.IsEmpty           '' false

seen.Clear( )
print seen.IsEmpty           '' true
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the tiko-lang repository.
