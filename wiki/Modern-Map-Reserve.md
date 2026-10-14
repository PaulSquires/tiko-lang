[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Reserve**

# Reserve

O(n)

## Syntax

```freebasic
Reserve( byval n as int32 )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )

'' Size it once up front and the fill does no rehashing
ages.Reserve( 1000 )
print ages.Capacity              '' 2048 -- power of two, with room for
                                 '' the 0.75 load factor
print ages.Count                 '' 0
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members
