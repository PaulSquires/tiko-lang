[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **MapIterator**

# MapIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Map](Category-Map), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The iterator type behind a `Map( of TK, TV )`.

## Syntax

```freebasic
MapIterator( of TK, TV )
```

## Notes

- The RFC-0002 protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- Iteration yields a **KeyValuePair**, read through `.key` and `.value`.
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
