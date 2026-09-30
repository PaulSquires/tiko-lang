[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.IsEmpty**

# OrderedSet.IsEmpty

O(1)

## Syntax

```freebasic
IsEmpty( )
```

## Notes

- O(1)

## Examples

```freebasic
#include once "fb/orderedset.bi"
using FB

dim s as OrderedSet( of integer )
print s.IsEmpty          '' true

s.Add( 1 )
print s.IsEmpty          '' false

s.Clear( )
print s.IsEmpty          '' true
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
