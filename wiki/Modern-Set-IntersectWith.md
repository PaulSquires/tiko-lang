[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **IntersectWith**

# IntersectWith

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Keeps only the elements that are also in `other`.

## Syntax

```freebasic
IntersectWith( byref other as Set( of T ) )
```

## Notes

- Modifies the receiver. `other` is left untouched.
- Collects the doomed elements first and removes them afterwards, so the set is not mutated while it is being scanned.
- O(capacity of *this*), plus one lookup in `other` per element.

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim a as Set( of integer )
dim b as Set( of integer )

for i as integer = 1 to 4 : a.Add( i ) : next     '' { 1, 2, 3, 4 }
for i as integer = 3 to 6 : b.Add( i ) : next     '' { 3, 4, 5, 6 }

a.IntersectWith( b )
print a.Count            '' 2 -- { 3, 4 }
print b.Count            '' 4 -- `other` is left alone

'' Intersecting with a disjoint set empties the receiver
dim d as Set( of integer )
dim as integer far = 99
d.Add( far )
a.IntersectWith( d )
print a.IsEmpty          '' true
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the tiko-lang repository.
