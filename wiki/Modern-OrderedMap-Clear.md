[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Clear**

# OrderedMap.Clear

O(n)

## Syntax

```freebasic
Clear( )
```

## Notes

- O(n)

## Examples

```freebasic
#import "std/containers"
using FB

dim ages as OrderedMap( of ustring, integer )
ages.Put( "ada", 36 )
ages.Put( "bob", 41 )

ages.Clear( )                     '' frees every node
print ages.Count                  '' 0
print ages.Contains( "ada" )      '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
