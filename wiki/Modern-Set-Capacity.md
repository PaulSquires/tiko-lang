[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Capacity**

# Capacity

## Syntax

```freebasic
Capacity( ) as int32
```

## Examples

```freebasic
#import "std/containers"
using containers

dim seen as Set( of integer )
print seen.Capacity          '' 0 -- nothing allocated yet

dim as integer x = 1
seen.Add( x )
print seen.Capacity          '' 8 -- the minimum

'' Power-of-two capacity, doubling at a load factor of 0.75
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
