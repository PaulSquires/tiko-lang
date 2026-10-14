[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **IsSortedBy**

# IsSortedBy

## Syntax

```freebasic
IsSortedBy( a, less ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of ustring )
v.Push( "fig" ) : v.Push( "pear" ) : v.Push( "banana" )

'' Ordered by length, which is not the same question as alphabetically
print IsSortedBy( v, function( byref x as ustring, byref y as ustring ) as boolean
    return len( x ) < len( y )
end function )               '' true

print IsSorted( v )          '' false -- not in alphabetical order

'' Use the same comparison here that was used to sort, or the answer is
'' about a different ordering than the one that was applied
```

---

**Library:** [Sorting](Category-Sorting)  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures
