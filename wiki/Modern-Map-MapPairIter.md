[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **MapPairIter**

# MapPairIter

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The iterator type behind `Map.Pairs( )`.

## Syntax

```freebasic
MapPairIter( of TK, TV )
```

## Notes

- The RFC-0002 protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- It yields a **tuple** instead of a named pair, so a loop can destructure into two variables -- at the cost of one extra copy of both.
- Iteration order is unspecified, like the map's own.

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of string, integer )
ages.Put( "ada", 36 )

'' The named-halves form
for each kv in ages
    print kv.key & " " & kv.value             '' ada 36
next

'' The destructuring form, through Pairs( )
for each (who, age) in ages.Pairs( )
    print who & " is " & age                  '' ada is 36
next
```

---

**Library:** [Map](Category-Map) ✨  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the tiko-lang repository.
