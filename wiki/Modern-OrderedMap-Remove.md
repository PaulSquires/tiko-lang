[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Remove**

# OrderedMap.Remove

## Syntax

```freebasic
Remove( k ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using FB

dim ages as OrderedMap( of ustring, integer )
ages.Put( "ada", 36 )
ages.Put( "bob", 41 )

print ages.Remove( "ada" )        '' true
print ages.Remove( "ada" )        '' false -- already gone
print ages.Count                  '' 1

'' The tree rebalances on removal -- at most three rotations, which is
'' why a red-black tree was chosen over AVL
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
