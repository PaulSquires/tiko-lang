[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **ArrayIterator**

# ArrayIterator

Holds a position in an Array; steps with IsValid, Value and MoveNext.

## Syntax

```freebasic
ArrayIterator( of T )
```

## Notes

- The iterator protocol -- `IsValid`, `Value`, `MoveNext` -- which is what `for each` is rewritten into. Ordinary code names the type only when the loop has to stop early, resume, or interleave with another.
- `Value( )` returns **byref**, so `for each byref v in a` can modify elements in place.
- It holds a **pointer** to the array, not a copy -- an iterator is created per loop and must not deep-copy the container.
- It is invalidated by anything that reallocates the storage, which a `Push` past the capacity does.

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of int32 )
v.Push( 1 ) : v.Push( 2 ) : v.Push( 3 )

dim it as ArrayIterator( of int32 ) = v.GetIterator( )
while it.IsValid( )
    print it.Value( )        '' 1 / 2 / 3
    it.MoveNext( )
wend

'' Value( ) is byref, so it assigns through
dim jt as ArrayIterator( of int32 ) = v.GetIterator( )
jt.Value( ) = 99
print v[ 0 ]                 '' 99
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members
