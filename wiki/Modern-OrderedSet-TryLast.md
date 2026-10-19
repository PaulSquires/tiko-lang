[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.TryLast**

# OrderedSet.TryLast

Copies the largest value into a variable; returns false if the set is empty.

## Syntax

```freebasic
TryLast( byref outv )
```

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using containers, numeric

dim s as OrderedSet( of integer )
s.Add( 30 ) : s.Add( 10 ) : s.Add( 20 )

dim as integer v
if s.TryLast( v ) then print v         '' 30 -- the largest

dim e as OrderedSet( of integer )
print e.TryLast( v )                   '' false
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members
