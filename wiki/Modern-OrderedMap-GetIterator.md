[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.GetIterator**

# OrderedMap.GetIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedMap), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(log n)

## Syntax

```freebasic
GetIterator( )
```

## Notes

- O(log n)

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of string, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

'' ASCENDING KEY ORDER, always -- the entire reason to choose this over
'' FB.Map, whose order is unspecified and changes as it grows
for each kv in ages
    print kv.key & " " & kv.value      '' ada 36 / bob 41
next

dim it as OrderedMapIterator( of string, integer ) = ages.GetIterator( )
print it.Value( ).key                  '' ada -- the smallest key
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap) ✨  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
