[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Push**

# Push

amortised O(1)

## Syntax

```freebasic
Push( byref v as T )
```

## Notes

- amortised O(1)

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of int32 )

'' Amortised O(1): the storage doubles rather than reallocating per push,
'' which is what the `redim preserve` append idiom gets wrong
for i as int32 = 1 to 5
    v.Push( i * i )
next

print v.Count            '' 5
print v[ 4 ]             '' 25
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members
