[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **Sort**

# Sort

O(n log n) worst   in place, unstable

## Syntax

```freebasic
Sort( a )
```

## Notes

- O(n log n) worst — in place, unstable

## Examples

```freebasic
#include once "fb/array.bi"
#include once "fb/sort.bi"
using FB

dim v as Array( of long )
v.Push( 5 ) : v.Push( 1 ) : v.Push( 4 )

Sort( v )                    '' introsort, ascending, by T's own '<'
for i as long = 0 to v.Count - 1
    print v[ i ];
next
print                        '' 1 4 5

'' O(n log n) WORST case -- introsort switches to heapsort when the
'' recursion runs too deep, so the quicksort worst case cannot happen.
'' In place, no allocation, and NOT stable.
```

---

**Library:** [Sorting](Category-Sorting)  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures  
**Source:** `docs/sort/sort.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
