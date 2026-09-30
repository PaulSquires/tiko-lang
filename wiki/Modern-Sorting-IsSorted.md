[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **IsSorted**

# IsSorted

## Syntax

```freebasic
IsSorted( a ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using FB

dim v as Array( of int32 )
v.Push( 1 ) : v.Push( 2 ) : v.Push( 2 ) : v.Push( 3 )

print IsSorted( v )          '' true -- equal neighbours are still sorted

v.Push( 0 )
print IsSorted( v )          '' false

'' O(n) and allocation-free, so it is cheap as a guard before a sort
'' that is usually redundant
if not IsSorted( v ) then Sort( v )
print IsSorted( v )          '' true
```

---

**Library:** [Sorting](Category-Sorting)  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures  
**Source:** `docs/sort/sort.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
