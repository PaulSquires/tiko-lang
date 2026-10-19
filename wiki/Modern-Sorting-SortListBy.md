[Home](Home) › [Sorting](Category-Sorting) › [Sorting](Category-Sorting) › **SortListBy**

# SortListBy

Sorts a LinkedList by your comparer, relinking nodes; equal elements keep order.

## Syntax

```freebasic
SortListBy( l, less )
```

## Notes

- O(n log n) worst — O(1) extra, STABLE

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of ustring )
q.PushBack( "pear" ) : q.PushBack( "fig" ) : q.PushBack( "banana" )

SortListBy( q, function( byref x as ustring, byref y as ustring ) as boolean
    return len( x ) < len( y )
end function )

for each v in q
    print v
next                         '' fig / pear / banana

'' The 'prv' pointers are rewritten as the chain is relinked, which is
'' the only difference from the singly-linked version of this algorithm
```

---

**Library:** [Sorting](Category-Sorting)  
**Category:** [Sorting](Category-Sorting)  
**Documented under:** Procedures
