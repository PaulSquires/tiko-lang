[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Pairs**

# OrderedMap.Pairs

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedMap), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(1)      the tuple view

## Syntax

```freebasic
Pairs( )
```

## Notes

- O(1) — the tuple view

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of string, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

'' Pairs( ) yields a TUPLE rather than a named pair, so the loop can
'' destructure -- still in ascending key order
for each (who, age) in ages.Pairs( )
    print who & " is " & age           '' ada is 36 / bob is 41
next
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap) ✨  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
