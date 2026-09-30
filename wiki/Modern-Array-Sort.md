[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Sort**

# Sort

introsort, ascending, by '<' on T

## Syntax

```freebasic
Sort( a )
```

## Notes

- introsort, ascending, by '<' on T

## Examples

```freebasic
#include once "fb/array.bi"
#include once "fb/sort.bi"
using FB

dim v as Array( of long )
v.Push( 5 ) : v.Push( 1 ) : v.Push( 4 ) : v.Push( 1 )

Sort( v )                '' introsort, ascending, by T's own '<'
for i as long = 0 to v.Count - 1
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
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
