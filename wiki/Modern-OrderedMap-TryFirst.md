[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.TryFirst**

# OrderedMap.TryFirst

Copies the smallest key and its value into variables; returns false if the map is empty.

## Syntax

```freebasic
TryFirst( byref outk, byref outv )
```

## Notes

- O(log n) — smallest key

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using containers, numeric

dim ages as OrderedMap( of ustring, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

dim as ustring k
dim as integer v
if ages.TryFirst( k, v ) then print k & " " & v     '' ada 36

'' FALSE on an empty map, and both outputs are left alone -- which is
'' why this is not a Front( ) returning a blank
dim e as OrderedMap( of ustring, integer )
print e.TryFirst( k, v )               '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members
