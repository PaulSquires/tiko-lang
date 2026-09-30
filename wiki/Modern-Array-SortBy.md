[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **SortBy**

# SortBy

introsort, ascending, by a comparer

## Syntax

```freebasic
SortBy( a, less )
```

## Notes

- introsort, ascending, by a comparer

## Examples

```freebasic
#import "std/containers"
using FB

dim v as Array( of int32 )
v.Push( 5 ) : v.Push( 1 ) : v.Push( 4 )

'' A caller-supplied strict '<'. Reverse it for descending order:
SortBy( v, function( byref x as int32, byref y as int32 ) as boolean
    return x > y
end function )

for i as int32 = 0 to v.Count - 1
    print v[ i ];
next
print                    '' 5 4 1

'' The comparison may capture, because it is taken as a generic rather
'' than as a procedure pointer -- a capturing lambda is a closure object
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Sorting  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
