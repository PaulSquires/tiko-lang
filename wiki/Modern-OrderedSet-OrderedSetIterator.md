[Home](Home) › [OrderedSet](Category-OrderedSet) › [OrderedSet](Category-OrderedSet) › **OrderedSetIterator**

# OrderedSetIterator

Holds a position in an OrderedSet, stepping in ascending order.

## Syntax

```freebasic
OrderedSetIterator( of T )
```

## Notes

- The iterator protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- **In ascending order**, which is the difference from `SetIterator`.
- An in-order tree walk.

## Examples

```freebasic
#import "std/containers"
using containers

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
