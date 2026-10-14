[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **IsEmpty**

# IsEmpty

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )
print ages.IsEmpty               '' true

ages.Put( "ada", 36 )
print ages.IsEmpty               '' false

ages.Clear( )
print ages.IsEmpty               '' true
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members
