[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.TryLast**

# OrderedMap.TryLast

O(log n)  largest key

## Syntax

```freebasic
TryLast( byref outk, byref outv )
```

## Notes

- O(log n) — largest key

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of ustring, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

dim as ustring k
dim as integer v
if ages.TryLast( k, v ) then print k & " " & v      '' bob 41

'' TryFirst and TryLast are O(log n): walk left, or walk right
dim e as OrderedMap( of ustring, integer )
print e.TryLast( k, v )                '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
