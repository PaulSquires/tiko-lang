[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Reserve**

# Reserve

O(n)

## Syntax

```freebasic
Reserve( byval n as int32 )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/containers"
using FB

dim seen as Set( of integer )

seen.Reserve( 1000 )
print seen.Capacity          '' 2048 -- sized so the 0.75 load factor
                             '' still fits 1000 elements without a rehash
print seen.Count             '' 0
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
