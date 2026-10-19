[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **IsSorted**

# IsSorted

Returns true if the Array is already in ascending order.

## Syntax

```freebasic
IsSorted( a )
```

## Notes

- / IsSortedBy( a, less )

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of int32 )
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
