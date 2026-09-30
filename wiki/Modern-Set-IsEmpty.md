[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **IsEmpty**

# IsEmpty

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#include once "fb/set.bi"
using FB

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
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
