[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Count**

# OrderedMap.Count

Returns the number of entries; reading an absent key with m[ k ] adds one.

## Syntax

```freebasic
Count( ) as int32
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as OrderedMap( of ustring, integer )
print ages.Count                  '' 0

ages.Put( "ada", 36 )
ages.Put( "ada", 37 )             '' an overwrite, not an insertion
print ages.Count                  '' 1

print ages[ "nobody" ]            '' 0 -- and the read INSERTED it
print ages.Count                  '' 2
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members
