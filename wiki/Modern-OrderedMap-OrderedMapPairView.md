[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap](Category-OrderedMap) › **OrderedMapPairView**

# OrderedMapPairView

The iterator type behind `OrderedMap.Pairs( )`.

## Syntax

```freebasic
OrderedMapPairView( of TK, TV )
```

## Notes

- A view holding a pointer to the map, for `for each` to consume. It copies nothing.
- **In ascending key order**, which is the difference from the Map equivalents.
- An in-order walk of the tree, so it is O(n) overall and O(log n) in stack.

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as OrderedMap( of ustring, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

for each kv in ages
    print kv.key & " " & kv.value             '' ada 36 / bob 41
next

for each (who, age) in ages.Pairs( )
    print who                '' ada / bob
next
```

---

**Library:** [OrderedMap](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
