[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Count**

# Count

## Syntax

```freebasic
Count( ) as long
```

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of integer )
print seen.Count             '' 0

dim as integer x = 1
seen.Add( x )
seen.Add( x )                '' a duplicate is not an insertion
print seen.Count             '' 1
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
