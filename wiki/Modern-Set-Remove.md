[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Remove**

# Remove

## Syntax

```freebasic
Remove( byref v as T ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim seen as Set( of integer )
dim as integer x = 42
seen.Add( x )

print seen.Remove( x )       '' true -- something was removed
print seen.Remove( x )       '' false -- already gone
print seen.Count             '' 0
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members
