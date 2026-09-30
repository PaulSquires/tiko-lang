[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Set**

# Set

A hash set.

## Syntax

```freebasic
Set( of T )
```

## Notes

- A **Map with the value machinery removed**, rather than a wrapper around one -- so it costs one slot per element instead of two.
- `Add` returns FALSE when the element was already present, which is what makes `if seen.Add( x ) then` the natural spelling of "process each thing once".
- The **hash contract** is `fb/hash.bi`'s: `HashOf( v )` must resolve, `v = v` must compare, and equal elements must hash equal.
- Same implementation and same **unspecified iteration order** as Map.

## Examples

```freebasic
#import "std/containers"
using FB

dim seen as Set( of integer )

print seen.Add( 42 )         '' true -- first time
print seen.Add( 42 )         '' false -- already there
print seen.Count             '' 1

'' Which is what makes this the way to process each thing once
dim as integer x = 7
if seen.Add( x ) then print "new"
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
