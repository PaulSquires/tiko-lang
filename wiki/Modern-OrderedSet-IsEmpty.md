[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.IsEmpty**

# OrderedSet.IsEmpty

Returns true if the set has no values.

## Syntax

```freebasic
IsEmpty( )
```

## Notes

- O(1)

## Examples

```freebasic
#import "std/containers"
using containers

dim s as OrderedSet( of integer )
print s.IsEmpty          '' true

s.Add( 1 )
print s.IsEmpty          '' false

s.Clear( )
print s.IsEmpty          '' true
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members
