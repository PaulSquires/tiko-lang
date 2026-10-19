[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **At**

# At

Returns a reference to the element at a position, like a[ i ].

## Syntax

```freebasic
At( i ) byref as T
```

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of int32 )
v.Push( 10 ) : v.Push( 20 )

print v.At( 1 )          '' 20

'' At returns BYREF, so it assigns in place
v.At( 0 ) = 99
print v[ 0 ]             '' 99

'' Identical to the [] operator; At reads better through a pointer:
'' p->At( 0 ) rather than (*p)[ 0 ]
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members
