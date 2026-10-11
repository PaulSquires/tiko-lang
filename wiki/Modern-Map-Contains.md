[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Contains**

# Contains

## Syntax

```freebasic
Contains( k ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )

print ages.Contains( "ada" )     '' true
print ages.Contains( "alan" )    '' false

'' Contains does not insert. Reading through m[ "alan" ] would have.
print ages.Count                 '' 1
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
