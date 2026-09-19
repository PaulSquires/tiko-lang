[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.TryLast**

# OrderedSet.TryLast

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedSet), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryLast( byref outv )
```

## Examples

```freebasic
#include once "fb/orderedset.bi"
using FB

dim s as OrderedSet( of integer )
s.Add( 30 ) : s.Add( 10 ) : s.Add( 20 )

dim as integer v
if s.TryLast( v ) then print v         '' 30 -- the largest

dim e as OrderedSet( of integer )
print e.TryLast( v )                   '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet) ✨  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
