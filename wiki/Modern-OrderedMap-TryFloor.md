[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.TryFloor**

# OrderedMap.TryFloor

Finds the largest key at or below a given one; returns false if there is none.

## Syntax

```freebasic
TryFloor( k, byref outk ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim m as OrderedMap( of integer, ustring )
m.Put( 10, "ten" ) : m.Put( 20, "twenty" ) : m.Put( 30, "thirty" )

dim as integer k

'' The largest key that is NOT GREATER than the argument
if m.TryFloor( 25, k ) then print k    '' 20
if m.TryFloor( 20, k ) then print k    '' 20 -- k itself when present
print m.TryFloor( 5, k )               '' false -- every key is greater

'' Call first, THEN read: `print m.TryFloor( 25, k ) & " " & k` prints
'' the OLD k, because the operand is fetched before the call runs
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members
