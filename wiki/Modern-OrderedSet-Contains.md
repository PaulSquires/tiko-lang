[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.Contains**

# OrderedSet.Contains

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedSet), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Contains( v ) as boolean
```

## Examples

```freebasic
#include once "fb/orderedset.bi"
using FB

dim s as OrderedSet( of integer )
s.Add( 42 )

print s.Contains( 42 )   '' true
print s.Contains( 7 )    '' false

'' O(log n), against FB.Set's average O(1) -- the price of the ordering
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet) ✨  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
