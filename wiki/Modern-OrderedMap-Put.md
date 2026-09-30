[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.Put**

# OrderedMap.Put

## Syntax

```freebasic
Put( k, v ) as boolean
```

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of ustring, integer )

print ages.Put( "bob", 41 )      '' true -- the key was new
print ages.Put( "bob", 42 )      '' false -- existed, and was OVERWRITTEN
print ages[ "bob" ]              '' 42

'' The ordering contract is '<' on TK and nothing else -- no HashOf and
'' no '=' are needed, unlike FB.Map
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
