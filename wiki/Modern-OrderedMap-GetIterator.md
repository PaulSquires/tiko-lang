[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.GetIterator**

# OrderedMap.GetIterator

Returns an iterator over the entries in ascending key order.

## Syntax

```freebasic
GetIterator( )
```

## Notes

- O(log n)

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as OrderedMap( of ustring, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

'' ASCENDING KEY ORDER, always -- the entire reason to choose this over
'' containers.Map, whose order is unspecified and changes as it grows
for each kv in ages
    print kv.key & " " & kv.value      '' ada 36 / bob 41
next

dim it as OrderedMapIterator( of ustring, integer ) = ages.GetIterator( )
print it.Value( ).key                  '' ada -- the smallest key
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members
