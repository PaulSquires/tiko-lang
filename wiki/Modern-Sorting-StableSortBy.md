[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **StableSortBy**

# StableSortBy

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Sorting](Category-Sorting), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n log n) always  O(n) scratch, STABLE

## Syntax

```freebasic
StableSortBy( a, less )
```

## Notes

- O(n log n) always — O(n) scratch, STABLE

## Examples

```freebasic
#include once "fb/array.bi"
#include once "fb/sort.bi"
using FB

type Rec
    as string surname
    as long   seq
end type

dim v as Array( of Rec )
dim r as Rec
r.surname = "lovelace" : r.seq = 1 : v.Push( r )
r.surname = "hopper"   : r.seq = 2 : v.Push( r )
r.surname = "lovelace" : r.seq = 3 : v.Push( r )

StableSortBy( v, function( byref x as Rec, byref y as Rec ) as boolean
    return x.surname < y.surname
end function )

for i as long = 0 to v.Count - 1
    print v[ i ].surname & " " & v[ i ].seq
next                         '' hopper 2 / lovelace 1 / lovelace 3

'' A bottom-up merge sort: O(n log n) worst AND best case, at the cost of
'' an n-element scratch buffer. That buffer is why it is not the default.
```

---

**Library:** [Sorting](Category-Sorting) ✨  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures  
**Source:** `docs/sort/sort.txt` in the tiko-lang repository.
