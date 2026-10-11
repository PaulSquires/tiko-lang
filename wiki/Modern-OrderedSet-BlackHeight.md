[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedMap and OrderedSet](Category-OrderedSet) › **OrderedSet.BlackHeight**

# OrderedSet.BlackHeight

## Syntax

```freebasic
BlackHeight( ) as int32
```

## Examples

```freebasic
#import "std/containers"
using containers

dim s as OrderedSet( of integer )
for i as integer = 1 to 10
    s.Add( i )
next

'' Black nodes on any root-to-null path, or -1 when the paths disagree --
'' the red-black invariant, stated by the container itself
if s.BlackHeight( ) >= 0 then print "invariant holds"

'' O(n). A diagnostic, not something normal code calls.
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
