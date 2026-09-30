[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Insert**

# Insert

O(n)

## Syntax

```freebasic
Insert( byval i as int32, byref v as T )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/containers"
using FB

dim v as Array( of ustring )
v.Push( "a" ) : v.Push( "c" )

v.Insert( 1, "b" )       '' O(n) -- everything after i shifts up
print v[ 0 ] & v[ 1 ] & v[ 2 ]     '' abc

'' An index of Count appends; anything outside 0..Count is a no-op
v.Insert( 3, "d" )
v.Insert( 99, "z" )
print v.Count            '' 4

'' Inserting an element of the array itself works -- the value is copied
'' before the shift
v.Insert( 0, v[ 3 ] )
print v[ 0 ]             '' d
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members  
**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
