[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Clear**

# Clear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )
dim as integer x = 42
seen.Add( x )

seen.Clear( )
print seen.Count             '' 0
print seen.Contains( x )     '' false
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the tiko-lang repository.
