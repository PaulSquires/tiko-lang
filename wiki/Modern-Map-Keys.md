[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Keys**

# Keys

## Syntax

```freebasic
Keys( ) as Array( of K )
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )
ages.Put( "grace", 45 )

'' A snapshot, as an Array -- not a live view of the map
dim ks as Array( of ustring ) = ages.Keys( )
print ks.Count                   '' 2

'' ITERATION ORDER IS UNSPECIFIED, so sort before printing if the
'' output has to be reproducible
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
