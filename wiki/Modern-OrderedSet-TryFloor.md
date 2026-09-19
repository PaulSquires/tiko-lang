[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.TryFloor**

# OrderedSet.TryFloor

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedSet), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryFloor( v, byref outv )
```

## Examples

```freebasic
#include once "fb/orderedset.bi"
using FB

dim s as OrderedSet( of integer )
s.Add( 10 ) : s.Add( 20 ) : s.Add( 30 )

dim as integer v

'' The largest element that is NOT GREATER than the argument
if s.TryFloor( 25, v ) then print v    '' 20
if s.TryFloor( 20, v ) then print v    '' 20 -- itself when present
print s.TryFloor( 5, v )               '' false -- everything is greater

'' Call first, THEN read: the operands of `a & b` are fetched before
'' the call in `a` has written its output argument
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet) ✨  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
