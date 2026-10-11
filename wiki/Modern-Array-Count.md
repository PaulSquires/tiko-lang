[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Count**

# Count

## Syntax

```freebasic
Count( ) as int32
```

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of ustring )
print v.Count            '' 0

v.Push( "a" ) : v.Push( "b" )
print v.Count            '' 2

'' The valid indices are 0 to Count-1
for i as int32 = 0 to v.Count - 1
    print i & ": " & v[ i ]
next
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
