[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.Count**

# OrderedSet.Count

Returns the number of values in the set.

## Syntax

```freebasic
Count( )
```

## Examples

```freebasic
#import "std/containers"
using containers

dim s as OrderedSet( of integer )
print s.Count            '' 0

s.Add( 1 )
s.Add( 1 )               '' a duplicate is not an insertion
print s.Count            '' 1
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members
