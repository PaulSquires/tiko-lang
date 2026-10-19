[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap](Category-OrderedMap) › **OrderedMapIterator**

# OrderedMapIterator

Holds a position in an OrderedMap, stepping in ascending key order.

## Syntax

```freebasic
OrderedMapIterator( of TK, TV )
```

## Notes

- The iterator protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
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
