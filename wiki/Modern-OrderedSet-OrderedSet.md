[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedSet](Category-OrderedSet) › **OrderedSet**

# OrderedSet

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedSet](Category-OrderedSet), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A red-black tree set: always sorted.

## Syntax

```freebasic
OrderedSet( of T )
```

## Notes

- Iteration is in **ascending order, always** -- and `Items( )` comes back sorted, so it needs no sort afterwards.
- The ordering contract is `<` on T, with no hash and no `=` required.
- `FB.Set` unless the order is what you need: O(1) against O(log n).
- It also offers what a hash set cannot: `TryFirst`, `TryLast`, `TryFloor` and `TryCeiling`.

## Examples

```freebasic
#include once "fb/orderedset.bi"
using FB

dim s as OrderedSet( of integer )
s.Add( 30 ) : s.Add( 10 ) : s.Add( 20 )

for each v in s
    print v;                 '' 10 20 30
next
print

'' The navigation a hash set cannot offer
dim as integer v
if s.TryCeiling( 15, v ) then print v         '' 20
```

---

**Library:** [OrderedSet](Category-OrderedSet) ✨  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
