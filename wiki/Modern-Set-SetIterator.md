[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **SetIterator**

# SetIterator

The iterator `for each` uses over a `Set( of T )`.

## Syntax

```freebasic
SetIterator( of T )
```

## Notes

- The iterator protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- `Value( )` is byref, but **do not modify an element through it** -- changing a value changes its hash, and the set would no longer find it.
- Iteration order is unspecified.

## Examples

```freebasic
#import "std/containers"
using containers

dim seen as Set( of integer )
for i as integer = 1 to 3
    seen.Add( i )
next

dim it as SetIterator( of integer ) = seen.GetIterator( )
dim as integer total
while it.IsValid( )
    total += it.Value( )
    it.MoveNext( )
wend
print total                  '' 6
```

---

**Library:** [Set](Category-Set)  
**Category:** [Set](Category-Set)  
**Documented under:** Members
