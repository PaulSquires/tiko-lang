[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.Add**

# OrderedSet.Add

Adds a value; returns false if it was already there.

## Syntax

```freebasic
Add( v ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using containers

dim s as OrderedSet( of integer )

print s.Add( 42 )        '' true -- inserted
print s.Add( 42 )        '' false -- already present
print s.Count            '' 1

'' Like containers.Set, that FALSE is the natural "have I seen this before" --
'' but iteration here comes out in ascending order
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members
