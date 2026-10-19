[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Add**

# OrderedMap.Add

Adds a key and value if the key is new; an existing value is left alone.

## Syntax

```freebasic
Add( k, v ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as OrderedMap( of ustring, integer )

print ages.Add( "ada", 36 )      '' true -- inserted
print ages.Add( "ada", 99 )      '' false -- already there, NOT overwritten
print ages[ "ada" ]              '' 36

'' Two keys are the SAME key when neither is less than the other --
'' std::map's equivalence, not equality
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members
