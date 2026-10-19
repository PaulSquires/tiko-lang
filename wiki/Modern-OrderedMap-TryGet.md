[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.TryGet**

# OrderedMap.TryGet

Copies the value for a key into a variable; returns false, adding nothing, if absent.

## Syntax

```freebasic
TryGet( k, byref outv ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as OrderedMap( of ustring, integer )
ages.Put( "ada", 36 )

dim as integer got
if ages.TryGet( "ada", got ) then print got     '' 36

'' Reading through m[ k ] INSERTS a default value when k is absent;
'' TryGet does not. This is exactly containers.Map's rule.
got = -1
print ages.TryGet( "nobody", got )    '' false
print got                              '' -1, untouched
print ages.Count                       '' 1
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members
