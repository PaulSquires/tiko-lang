[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.Clear**

# OrderedSet.Clear

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedSet), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/orderedset.bi"
using FB

dim s as OrderedSet( of integer )
s.Add( 1 ) : s.Add( 2 )

s.Clear( )               '' frees every node
print s.Count            '' 0
print s.Contains( 1 )    '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet) ✨  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
