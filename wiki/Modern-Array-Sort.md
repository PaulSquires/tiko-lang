[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Sort**

# Sort

Sorts an Array in ascending order in place; equal elements may change places.

## Syntax

```freebasic
Sort( a )
```

## Notes

- introsort, ascending, by '<' on T

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of int32 )
v.Push( 5 ) : v.Push( 1 ) : v.Push( 4 ) : v.Push( 1 )

Sort( v )                '' introsort, ascending, by T's own '<'
for i as int32 = 0 to v.Count - 1
    print v[ i ];
next
print                    '' 1 1 4 5

'' O(n log n) WORST case and no allocation, but NOT stable -- use
'' StableSort when equal elements must keep their order
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Sorting
