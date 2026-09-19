[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **ExceptWith**

# ExceptWith

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Removes every element of `other` from this set.

## Syntax

```freebasic
ExceptWith( byref other as Set( of T ) )
```

## Notes

- Modifies the receiver. `other` is left untouched.
- The set difference: what is left is in this set and not in `other`.
- Removing `other`'s elements one at a time is O(|other|), which beats scanning this set when `other` is the smaller side.

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim a as Set( of integer )
dim b as Set( of integer )

for i as integer = 1 to 5 : a.Add( i ) : next     '' { 1, 2, 3, 4, 5 }
for i as integer = 4 to 9 : b.Add( i ) : next     '' { 4, 5, 6, 7, 8, 9 }

a.ExceptWith( b )
print a.Count            '' 3 -- { 1, 2, 3 }
print b.Count            '' 6 -- `other` is left alone

'' Elements of `other` that were never in the set are simply not there
'' to remove -- no error, no effect
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the tiko-lang repository.
