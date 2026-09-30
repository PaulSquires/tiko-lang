[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap and OrderedSet](Category-OrderedMap) › **OrderedMap.BlackHeight**

# OrderedMap.BlackHeight

## Syntax

```freebasic
BlackHeight( ) as int32
```

## Examples

```freebasic
#import "std/containers"
using FB

dim m as OrderedMap( of integer, ustring )
for i as integer = 1 to 10
    m.Put( i, "v" & i )
next

'' The number of black nodes on any root-to-null path, or -1 if the
'' paths disagree -- which is precisely the red-black invariant that a
'' broken rebalance breaks.
if m.BlackHeight( ) >= 0 then print "invariant holds"

'' O(n), and nothing in normal use calls it. It lives on the container
'' rather than in the test suite because a type whose correctness rests
'' on an invariant should be able to state whether it holds.
```

---

**Library:** [OrderedMap and OrderedSet](Category-OrderedMap)  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
