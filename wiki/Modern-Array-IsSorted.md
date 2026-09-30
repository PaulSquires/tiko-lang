[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **IsSorted**

# IsSorted

/ IsSortedBy( a, less )

## Syntax

```freebasic
IsSorted( a )
```

## Notes

- / IsSortedBy( a, less )

## Examples

```freebasic
#include once "fb/array.bi"
#include once "fb/sort.bi"
using FB

dim v as Array( of long )
v.Push( 1 ) : v.Push( 2 ) : v.Push( 2 ) : v.Push( 3 )

print IsSorted( v )      '' true -- equal neighbours are still sorted

v.Push( 0 )
print IsSorted( v )      '' false

'' Cheap enough to use as a guard before a sort that is usually redundant
if not IsSorted( v ) then Sort( v )
print IsSorted( v )      '' true
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Sorting  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
