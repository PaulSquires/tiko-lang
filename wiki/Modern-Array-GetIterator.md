[Home](Home) › [Array](Category-Array) › [Array Container](Category-Array) › **GetIterator**

# GetIterator

Returns an iterator over the elements, for stepping through them by hand.

## Syntax

```freebasic
GetIterator( ) as ArrayIterator( of T )
```

## Examples

```freebasic
#import "std/containers"
using containers

dim v as Array( of int32 )
v.Push( 1 ) : v.Push( 2 ) : v.Push( 3 )

'' The iterator protocol -- IsValid / Value / MoveNext -- which is what
'' `for each` is built on
dim it as ArrayIterator( of int32 ) = v.GetIterator( )
while it.IsValid( )
    print it.Value( )
    it.MoveNext( )
wend

'' Value( ) returns BYREF, so an iterator can modify in place
dim jt as ArrayIterator( of int32 ) = v.GetIterator( )
jt.Value( ) = 99
print v[ 0 ]             '' 99
```

---

**Library:** [Array Container](Category-Array)  
**Category:** [Array](Category-Array)  
**Documented under:** Members
