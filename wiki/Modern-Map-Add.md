[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Add**

# Add

Adds a key and value if the key is new; an existing value is left alone.

## Syntax

```freebasic
Add( k, v ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

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
