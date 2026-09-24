[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **StableSort**

# StableSort

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Sorting](Category-Sorting), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n log n) always  O(n) scratch, STABLE

## Syntax

```freebasic
StableSort( a )
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

operator < ( byref x as Rec, byref y as Rec ) as boolean
    return x.surname < y.surname
end operator

dim v as Array( of Rec )
dim r as Rec
r.surname = "lovelace" : r.seq = 1 : v.Push( r )
r.surname = "hopper"   : r.seq = 2 : v.Push( r )
r.surname = "lovelace" : r.seq = 3 : v.Push( r )

StableSort( v )              '' equal elements keep their original order
for i as long = 0 to v.Count - 1
    print v[ i ].surname & " " & v[ i ].seq
next                         '' hopper 2 / lovelace 1 / lovelace 3

'' For SCALARS this and Sort produce identical output -- stability only
'' means something when T carries more than the key
```

---

**Library:** [Sorting](Category-Sorting) ✨  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures  
**Source:** `docs/sort/sort.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
