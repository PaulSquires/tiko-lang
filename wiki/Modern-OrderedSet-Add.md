[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.Add**

# OrderedSet.Add

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedSet), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Add( v ) as boolean
```

## Examples

```freebasic
#include once "fb/orderedset.bi"
using FB

dim s as OrderedSet( of integer )

print s.Add( 42 )        '' true -- inserted
print s.Add( 42 )        '' false -- already present
print s.Count            '' 1

'' Like FB.Set, that FALSE is the natural "have I seen this before" --
'' but iteration here comes out in ascending order
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet) ✨  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
