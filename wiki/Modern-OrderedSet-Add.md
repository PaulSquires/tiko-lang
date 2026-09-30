[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.Add**

# OrderedSet.Add

## Syntax

```freebasic
Add( v ) as boolean
```

## Examples

```freebasic
#import "std/containers"
using FB

dim s as OrderedSet( of integer )

print s.Add( 42 )        '' true -- inserted
print s.Add( 42 )        '' false -- already present
print s.Count            '' 1

'' Like FB.Set, that FALSE is the natural "have I seen this before" --
'' but iteration here comes out in ascending order
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
