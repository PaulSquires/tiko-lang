[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.TryFloor**

# OrderedMap.TryFloor

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedMap), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
TryFloor( k, byref outk ) as boolean
```

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim m as OrderedMap( of integer, ustring )
m.Put( 10, "ten" ) : m.Put( 20, "twenty" ) : m.Put( 30, "thirty" )

dim as integer k

'' The largest key that is NOT GREATER than the argument
if m.TryFloor( 25, k ) then print k    '' 20
if m.TryFloor( 20, k ) then print k    '' 20 -- k itself when present
print m.TryFloor( 5, k )               '' false -- every key is greater

'' Call first, THEN read: `print m.TryFloor( 25, k ) & " " & k` prints
'' the OLD k, because the operand is fetched before the call runs
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap) ✨  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
