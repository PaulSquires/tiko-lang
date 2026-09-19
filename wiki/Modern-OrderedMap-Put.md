[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Put**

# OrderedMap.Put

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedMap), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Put( k, v ) as boolean
```

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of string, integer )

print ages.Put( "bob", 41 )      '' true -- the key was new
print ages.Put( "bob", 42 )      '' false -- existed, and was OVERWRITTEN
print ages[ "bob" ]              '' 42

'' The ordering contract is '<' on TK and nothing else -- no HashOf and
'' no '=' are needed, unlike FB.Map
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap) ✨  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
