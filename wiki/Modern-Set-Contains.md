[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Contains**

# Contains

## Syntax

```freebasic
Contains( byref v as T ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using FB

dim seen as Set( of integer )
dim as integer x = 42
seen.Add( x )

print seen.Contains( x )     '' true

dim as integer y = 7
print seen.Contains( y )     '' false
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
