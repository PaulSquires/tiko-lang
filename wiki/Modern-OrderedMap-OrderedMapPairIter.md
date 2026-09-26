[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap](Category-OrderedMap) › **OrderedMapPairIter**

# OrderedMapPairIter

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap](Category-OrderedMap), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The iterator type behind `OrderedMap.Pairs( )`.

## Syntax

```freebasic
OrderedMapPairIter( of TK, TV )
```

## Notes

- The RFC-0002 protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- **In ascending key order**, which is the difference from the Map equivalents.
- An in-order walk of the tree, so it is O(n) overall and O(log n) in stack.

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of ustring, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

for each kv in ages
    print kv.key & " " & kv.value             '' ada 36 / bob 41
next

for each (who, age) in ages.Pairs( )
    print who                '' ada / bob
next
```

---

**Library:** [OrderedMap](Category-OrderedMap) ✨  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
