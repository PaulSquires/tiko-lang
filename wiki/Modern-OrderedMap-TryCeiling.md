[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.TryCeiling**

# OrderedMap.TryCeiling

## Syntax

```freebasic
TryCeiling( k, byref outk ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using FB

dim m as OrderedMap( of integer, ustring )
m.Put( 10, "ten" ) : m.Put( 20, "twenty" ) : m.Put( 30, "thirty" )

dim as integer k

'' The smallest key that is NOT LESS than the argument
if m.TryCeiling( 25, k ) then print k  '' 30
if m.TryCeiling( 30, k ) then print k  '' 30 -- k itself when present
print m.TryCeiling( 99, k )            '' false -- every key is smaller

'' Floor and Ceiling together bracket a value that is not in the map
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
