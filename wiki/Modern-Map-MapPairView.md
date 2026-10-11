[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **MapPairView**

# MapPairView

The iterator type behind `Map.Pairs( )`.

## Syntax

```freebasic
MapPairView( of TK, TV )
```

## Notes

- Returned by `Pairs( )` and consumed immediately by `for each`.
- A **view**, not a container: it holds a pointer to the map and exists only to give `for each` something to iterate. It copies nothing.
- Iteration order is unspecified, like the map's own.

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )

'' The named-halves form
for each kv in ages
    print kv.key & " " & kv.value             '' ada 36
next

'' The destructuring form, through Pairs( )
for each (who, age) in ages.Pairs( )
    print who & " is " & age                  '' ada is 36
next
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
