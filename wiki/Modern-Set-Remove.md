[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Remove**

# Remove

## Syntax

```freebasic
Remove( byref v as T ) as boolean
```

## Examples

```freebasic
#include once "fb/set.bi"
using FB

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
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
