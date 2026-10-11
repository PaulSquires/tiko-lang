[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.TryFirst**

# OrderedSet.TryFirst

## Syntax

```freebasic
TryFirst( byref outv )
```

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using containers, numeric

dim s as OrderedSet( of integer )
s.Add( 30 ) : s.Add( 10 ) : s.Add( 20 )

dim as integer v
if s.TryFirst( v ) then print v        '' 10 -- the smallest

'' FALSE on an empty set, leaving the output alone
dim e as OrderedSet( of integer )
print e.TryFirst( v )                  '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
