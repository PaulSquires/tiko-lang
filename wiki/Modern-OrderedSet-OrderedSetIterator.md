[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedSet](Category-OrderedSet) › **OrderedSetIterator**

# OrderedSetIterator

The iterator `for each` uses over an `OrderedSet( of T )`.

## Syntax

```freebasic
OrderedSetIterator( of T )
```

## Notes

- The RFC-0002 protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- **In ascending order**, which is the difference from `SetIterator`.
- An in-order tree walk.

## Examples

```freebasic
#import "std/containers"
using FB

dim s as OrderedSet( of integer )
s.Add( 30 ) : s.Add( 10 ) : s.Add( 20 )

dim it as OrderedSetIterator( of integer ) = s.GetIterator( )
while it.IsValid( )
    print it.Value( );       '' 10 20 30
    it.MoveNext( )
wend
print
```

---

**Library:** [OrderedSet](Category-OrderedSet)  
**Category:** [OrderedSet](Category-OrderedSet)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
