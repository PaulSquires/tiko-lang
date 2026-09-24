[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.IntersectWith**

# OrderedSet.IntersectWith

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap and OrderedSet](Category-OrderedSet), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n log m)

## Syntax

```freebasic
IntersectWith( other )
```

## Notes

- O(n log m)

## Examples

```freebasic
#include once "fb/orderedset.bi"
using FB

dim a as OrderedSet( of integer )
dim b as OrderedSet( of integer )

for i as integer = 1 to 4 : a.Add( i ) : next
for i as integer = 3 to 6 : b.Add( i ) : next

a.IntersectWith( b )     '' keep only what is in both
print a.Count            '' 2
for each v in a
    print v;
next
print                    '' 3 4
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet) ✨  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
