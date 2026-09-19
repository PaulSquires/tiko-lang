[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.TryGet**

# OrderedMap.TryGet

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedMap), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryGet( k, byref outv ) as boolean
```

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of string, integer )
ages.Put( "ada", 36 )

dim as integer got
if ages.TryGet( "ada", got ) then print got     '' 36

'' Reading through m[ k ] INSERTS a default value when k is absent;
'' TryGet does not. This is exactly FB.Map's rule.
got = -1
print ages.TryGet( "nobody", got )    '' false
print got                              '' -1, untouched
print ages.Count                       '' 1
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap) ✨  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
