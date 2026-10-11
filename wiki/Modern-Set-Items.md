[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Items**

# Items

## Syntax

```freebasic
Items( ) as Array( of T )
```

## Examples

```freebasic
#import "std/containers"
using containers

dim seen as Set( of integer )
for i as integer = 1 to 3
    seen.Add( i )
next

'' A snapshot as an Array, not a live view
dim xs as Array( of integer ) = seen.Items( )
print xs.Count               '' 3

'' ITERATION ORDER IS UNSPECIFIED -- sort the snapshot when the output
'' has to be reproducible
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
