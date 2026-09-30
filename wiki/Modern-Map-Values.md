[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Values**

# Values

## Syntax

```freebasic
Values( ) as Array( of V )
```

## Examples

```freebasic
#import "std/containers"
using FB

dim ages as Map( of ustring, integer )
ages.Put( "ada", 36 )
ages.Put( "grace", 45 )

dim vs as Array( of integer ) = ages.Values( )
print vs.Count                   '' 2

dim as integer total
for i as int32 = 0 to vs.Count - 1
    total += vs[ i ]
next
print total                      '' 81
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
