[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Pairs**

# OrderedMap.Pairs

Returns a view that lets for each (k, v) walk keys and values in key order.

## Syntax

```freebasic
Pairs( )
```

## Notes

- O(1) — the tuple view

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as OrderedMap( of ustring, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

'' Pairs( ) yields a TUPLE rather than a named pair, so the loop can
'' destructure -- still in ascending key order
for each (who, age) in ages.Pairs( )
    print who & " is " & age           '' ada is 36 / bob is 41
next
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members
