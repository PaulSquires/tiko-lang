[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **IsEmpty**

# IsEmpty

Returns true if the array has no elements.

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of int32 )
print v.IsEmpty          '' true

v.Push( 1 )
print v.IsEmpty          '' false

v.Clear( )
print v.IsEmpty          '' true -- Clear drops the elements
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members
