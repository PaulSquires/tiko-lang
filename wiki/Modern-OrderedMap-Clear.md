[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Clear**

# OrderedMap.Clear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedMap), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of ustring, integer )
ages.Put( "ada", 36 )
ages.Put( "bob", 41 )

ages.Clear( )                     '' frees every node
print ages.Count                  '' 0
print ages.Contains( "ada" )      '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap) ✨  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
