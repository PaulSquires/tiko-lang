[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **SetIterator**

# SetIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The iterator `for each` uses over a `Set( of T )`.

## Syntax

```freebasic
SetIterator( of T )
```

## Notes

- The RFC-0002 protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- `Value( )` is byref, but **do not modify an element through it** -- changing a value changes its hash, and the set would no longer find it.
- Iteration order is unspecified.

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )
for i as integer = 1 to 3
    seen.Add( i )
next

dim it as SetIterator( of integer ) = seen.GetIterator( )
dim as integer total
while it.IsValid( )
    total += it.Value( )
    it.MoveNext( )
wend
print total                  '' 6
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
