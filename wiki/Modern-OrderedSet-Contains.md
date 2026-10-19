[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.Contains**

# OrderedSet.Contains

Returns true if the value is in the set.

## Syntax

```freebasic
Contains( v ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim s as OrderedSet( of integer )
s.Add( 42 )

print s.Contains( 42 )   '' true
print s.Contains( 7 )    '' false

'' O(log n), against containers.Set's average O(1) -- the price of the ordering
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members
