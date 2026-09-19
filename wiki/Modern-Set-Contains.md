[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Contains**

# Contains

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Contains( byref v as T ) as boolean
```

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )
dim as integer x = 42
seen.Add( x )

print seen.Contains( x )     '' true

dim as integer y = 7
print seen.Contains( y )     '' false
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the tiko-lang repository.
