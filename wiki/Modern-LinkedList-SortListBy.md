[Home](Home) › [LinkedList](Category-LinkedList) › [LinkedList](Category-LinkedList) › **SortListBy**

# SortListBy

ascending, by a comparer

## Syntax

```freebasic
SortListBy( l, less )
```

## Notes

- ascending, by a comparer

## Examples

```freebasic
#import "std/containers"
using containers

dim q as LinkedList( of ustring )
q.PushBack( "pear" ) : q.PushBack( "fig" ) : q.PushBack( "banana" )

'' Sort by length, with a caller-supplied strict '<'
SortListBy( q, function( byref x as ustring, byref y as ustring ) as boolean
    return len( x ) < len( y )
end function )

for each v in q
    print v
next                     '' fig / pear / banana

'' Stable, so equal-length names would keep their original order
```

---

**Library:** [LinkedList](Category-LinkedList)  
**Category:** [LinkedList](Category-LinkedList)  
**Documented under:** Sorting
