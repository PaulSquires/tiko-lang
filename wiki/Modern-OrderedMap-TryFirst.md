[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.TryFirst**

# OrderedMap.TryFirst

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedMap), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(log n)  smallest key

## Syntax

```freebasic
TryFirst( byref outk, byref outv )
```

## Notes

- O(log n) — smallest key

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of string, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

dim as string k
dim as integer v
if ages.TryFirst( k, v ) then print k & " " & v     '' ada 36

'' FALSE on an empty map, and both outputs are left alone -- which is
'' why this is not a Front( ) returning a blank
dim e as OrderedMap( of string, integer )
print e.TryFirst( k, v )               '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap) ✨  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
