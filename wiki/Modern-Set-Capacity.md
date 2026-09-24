[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Capacity**

# Capacity

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Capacity( ) as long
```

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )
print seen.Capacity          '' 0 -- nothing allocated yet

dim as integer x = 1
seen.Add( x )
print seen.Capacity          '' 8 -- the minimum

'' Power-of-two capacity, doubling at a load factor of 0.75
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
