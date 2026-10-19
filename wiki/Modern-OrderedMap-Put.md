[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Put**

# OrderedMap.Put

Stores a value under a key, replacing any old one; returns true if the key was new.

## Syntax

```freebasic
Put( k, v ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as OrderedMap( of ustring, integer )

print ages.Put( "bob", 41 )      '' true -- the key was new
print ages.Put( "bob", 42 )      '' false -- existed, and was OVERWRITTEN
print ages[ "bob" ]              '' 42

'' The ordering contract is '<' on TK and nothing else -- no HashOf and
'' no '=' are needed, unlike containers.Map
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members
