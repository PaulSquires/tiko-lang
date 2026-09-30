[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.IsEmpty**

# OrderedMap.IsEmpty

## Syntax

```freebasic
IsEmpty( ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using FB

dim ages as OrderedMap( of ustring, integer )
print ages.IsEmpty                '' true

ages.Put( "ada", 36 )
print ages.IsEmpty                '' false

ages.Clear( )
print ages.IsEmpty                '' true
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
