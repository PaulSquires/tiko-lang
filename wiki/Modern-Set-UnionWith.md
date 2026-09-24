[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **UnionWith**

# UnionWith

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Adds every element of `other` to this set, in place.

## Syntax

```freebasic
UnionWith( byref other as Set( of T ) )
```

## Notes

- Modifies the receiver. `other` is left untouched.
- Elements already present are not duplicated -- this is `Add` per element, and `Add` refuses a duplicate.
- O(capacity of *other*), because it scans `other`'s slots rather than its elements.

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim a as Set( of integer )
dim b as Set( of integer )

for i as integer = 1 to 3 : a.Add( i ) : next     '' { 1, 2, 3 }
for i as integer = 3 to 5 : b.Add( i ) : next     '' { 3, 4, 5 }

a.UnionWith( b )
print a.Count            '' 5 -- { 1, 2, 3, 4, 5 }, 3 was not duplicated
print b.Count            '' 3 -- `other` is left alone

'' In place, so union the copy when the original is still needed
dim c as Set( of integer ) = a
c.UnionWith( b )
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
