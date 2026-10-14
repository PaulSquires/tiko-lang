[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.Remove**

# OrderedSet.Remove

## Syntax

```freebasic
Remove( v ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim s as OrderedSet( of integer )
s.Add( 42 )

print s.Remove( 42 )     '' true
print s.Remove( 42 )     '' false -- already gone
print s.Count            '' 0
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members
