[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Array**

# Array

## Syntax

```freebasic
Array( of Array( of int32 ) )
```

## Examples

```freebasic
#import "std/containers"
using FB

'' A growable array. Indices are ZERO-based -- a deliberate break with
'' `dim arr(1 to 10)` tradition, because Count and index arithmetic are
'' otherwise a permanent source of off-by-one.
dim v as Array( of ustring )

v.Push( "ada" )
v.Push( "grace" )

print v.Count            '' 2
print v[ 0 ]             '' ada

'' Copy and assignment are DEEP -- pass containers byref where it matters
dim w as Array( of ustring ) = v
w[ 0 ] = "alan"
print v[ 0 ] & " " & w[ 0 ]      '' ada alan
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Why Sort, Indexof And Contains Are Not Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
