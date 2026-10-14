[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **StableSort**

# StableSort

merge sort -- equal elements keep their order

## Syntax

```freebasic
StableSort( a )
```

## Notes

- merge sort -- equal elements keep their order

## Examples

```freebasic
#import "std/containers"
using containers

'' Stability only means something when T carries more than the key.
'' For scalars StableSort and Sort produce identical output.
type Rec
    as ustring surname
    as int32   seq
end type

operator < ( byref x as Rec, byref y as Rec ) as boolean
    return x.surname < y.surname
end operator

dim v as Array( of Rec )
dim r as Rec
r.surname = "lovelace" : r.seq = 1 : v.Push( r )
r.surname = "hopper"   : r.seq = 2 : v.Push( r )
r.surname = "lovelace" : r.seq = 3 : v.Push( r )

StableSort( v )          '' merge sort: equal elements keep their order
for i as int32 = 0 to v.Count - 1
    print v[ i ].surname & " " & v[ i ].seq
next                     '' hopper 2 / lovelace 1 / lovelace 3
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Sorting
