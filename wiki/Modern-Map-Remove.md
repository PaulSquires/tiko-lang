[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Remove**

# Remove

## Syntax

```freebasic
Remove( k ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using FB

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )
ages.Put( "grace", 45 )

print ages.Remove( "ada" )       '' true -- something was removed
print ages.Remove( "ada" )       '' false -- already gone
print ages.Count                 '' 1

'' The slot becomes a TOMBSTONE rather than empty, so a probe chain
'' through it still finds what lies beyond
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
