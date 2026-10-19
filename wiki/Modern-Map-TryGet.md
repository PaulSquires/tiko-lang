[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **TryGet**

# TryGet

Copies the value for a key into a variable; returns false, adding nothing, if absent.

## Syntax

```freebasic
TryGet( k, byref out as V ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )

dim as integer got
if ages.TryGet( "ada", got ) then print got        '' 36

'' A miss leaves the output alone and does NOT insert -- unlike m[ k ]
got = -1
print ages.TryGet( "alan", got )    '' false
print got                            '' -1, untouched
print ages.Count                     '' 1 -- still just "ada"
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members
