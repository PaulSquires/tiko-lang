[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **IsEmpty**

# IsEmpty

Returns true if the set has no values.

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim seen as Set( of integer )
print seen.IsEmpty           '' true

dim as integer x = 1
seen.Add( x )
print seen.IsEmpty           '' false

seen.Clear( )
print seen.IsEmpty           '' true
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members
