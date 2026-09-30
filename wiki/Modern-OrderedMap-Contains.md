[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Contains**

# OrderedMap.Contains

## Syntax

```freebasic
Contains( k ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using FB

dim ages as OrderedMap( of ustring, integer )
ages.Put( "ada", 36 )

print ages.Contains( "ada" )      '' true
print ages.Contains( "alan" )     '' false
print ages.Count                  '' 1 -- Contains does not insert
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
