[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **RemoveSwap**

# RemoveSwap

Removes the element at a position quickly by moving the last element into its place.

## Syntax

```freebasic
RemoveSwap( byval i as int32 )
```

## Notes

- O(1) — does NOT preserve order

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of ustring )
v.Push( "a" ) : v.Push( "b" ) : v.Push( "c" ) : v.Push( "d" )

'' O(1), but the LAST element moves into the hole -- order is not preserved.
'' Named so it cannot be picked by accident.
v.RemoveSwap( 0 )
print v[ 0 ] & v[ 1 ] & v[ 2 ]     '' dbc
print v.Count            '' 3
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members
