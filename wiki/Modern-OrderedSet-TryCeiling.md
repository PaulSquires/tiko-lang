[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.TryCeiling**

# OrderedSet.TryCeiling

## Syntax

```freebasic
TryCeiling( v, byref outv )
```

## Examples

```freebasic
#import "std/containers"
using containers

dim s as OrderedSet( of integer )
s.Add( 10 ) : s.Add( 20 ) : s.Add( 30 )

dim as integer v

'' The smallest element that is NOT LESS than the argument
if s.TryCeiling( 25, v ) then print v  '' 30
if s.TryCeiling( 10, v ) then print v  '' 10 -- itself when present
print s.TryCeiling( 99, v )            '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
