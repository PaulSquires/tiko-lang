[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **StableSortBy**

# StableSortBy

## Syntax

```freebasic
StableSortBy( a, less )
```

## Examples

```freebasic
#import "std/containers"
using containers

type Rec
    as ustring surname
    as int32   seq
end type

dim v as Array( of Rec )
dim r as Rec
r.surname = "lovelace" : r.seq = 1 : v.Push( r )
r.surname = "hopper"   : r.seq = 2 : v.Push( r )
r.surname = "lovelace" : r.seq = 3 : v.Push( r )

'' Stable, with a caller-supplied '<' -- no operator on Rec needed
StableSortBy( v, function( byref x as Rec, byref y as Rec ) as boolean
    return x.surname < y.surname
end function )

for i as int32 = 0 to v.Count - 1
    print v[ i ].surname & " " & v[ i ].seq
next                     '' hopper 2 / lovelace 1 / lovelace 3

'' O(n log n) worst AND best case, at the cost of an n-element scratch
'' buffer -- which is why it is not the default
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Sorting  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
