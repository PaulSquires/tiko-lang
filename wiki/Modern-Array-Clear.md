[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **Clear**

# Clear

O(n)   drops elements, KEEPS capacity

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n) — drops elements, KEEPS capacity

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of ustring )
v.Push( "a" ) : v.Push( "b" )

v.Clear( )
print v.Count            '' 0
print v.Capacity         '' 8 -- the capacity is KEPT, so a refill loop
                         '' does not reallocate

'' The slots are reset, so a T holding a resource releases it now rather
'' than at the array's destruction
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members
