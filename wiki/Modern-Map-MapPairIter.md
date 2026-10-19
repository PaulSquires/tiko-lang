[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **MapPairIter**

# MapPairIter

Holds a position in Map.Pairs; each step gives the key and value as a tuple.

## Syntax

```freebasic
MapPairIter( of TK, TV )
```

## Notes

- The iterator protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- It yields a **tuple** instead of a named pair, so a loop can destructure into two variables -- at the cost of one extra copy of both.
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
