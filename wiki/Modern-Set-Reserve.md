[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Reserve**

# Reserve

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Reserve( byval n as long )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )

seen.Reserve( 1000 )
print seen.Capacity          '' 2048 -- sized so the 0.75 load factor
                             '' still fits 1000 elements without a rehash
print seen.Count             '' 0
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
