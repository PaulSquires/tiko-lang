[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **IsEmpty**

# IsEmpty

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using FB

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
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
