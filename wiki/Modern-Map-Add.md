[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Add**

# Add

does NOT overwrite

## Syntax

```freebasic
Add( k, v ) as boolean
```

## Examples

```freebasic
#include once "fb/map.bi"
using FB

dim ages as Map( of ustring, integer )

print ages.Add( "ada", 36 )      '' true -- inserted
print ages.Add( "ada", 99 )      '' false -- already there, NOT overwritten
print ages[ "ada" ]              '' 36 -- the original value survives

'' That refusal is the whole difference from Put
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
