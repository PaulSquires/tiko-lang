[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedSet](Category-OrderedSet) › **OrderedSet**

# OrderedSet

A red-black tree set: always sorted.

## Syntax

```freebasic
OrderedSet( of T )
```

## Notes

- Iteration is in **ascending order, always** -- and `Items( )` comes back sorted, so it needs no sort afterwards.
- The ordering contract is `<` on T, with no hash and no `=` required.
- `containers.Set` unless the order is what you need: O(1) against O(log n).
- It also offers what a hash set cannot: `TryFirst`, `TryLast`, `TryFloor` and `TryCeiling`.

## Examples

```freebasic
#import "std/containers"
using containers

dim s as OrderedSet( of integer )
s.Add( 30 ) : s.Add( 10 ) : s.Add( 20 )

for each v in s
    print v;                 '' 10 20 30
next
print

'' The navigation a hash set cannot offer
dim as integer v
if s.TryCeiling( 15, v ) then print v         '' 20
```

---

**Library:** [OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
