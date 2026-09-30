[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Clear**

# Clear

O(n)

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )
dim as integer x = 42
seen.Add( x )

seen.Clear( )
print seen.Count             '' 0
print seen.Contains( x )     '' false
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
