[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Capacity**

# Capacity

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Capacity( ) as long
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of string, integer )
print ages.Capacity              '' 0 -- nothing allocated yet

ages.Put( "ada", 36 )
print ages.Capacity              '' 8 -- the minimum

'' Capacity is a power of two and doubles at a load factor of 0.75,
'' so it is always well above Count
for i as integer = 1 to 7
    ages.Put( "k" & i, i )
next
print ages.Count & " of " & ages.Capacity    '' 8 of 16
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the tiko-lang repository.
