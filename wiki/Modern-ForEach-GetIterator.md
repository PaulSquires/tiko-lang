[Home](Home) › [For Each](Category-For-Each) › [For Each](Category-For-Each) › **GetIterator**

# GetIterator

## Syntax

```freebasic
GetIterator( )
```

## Examples

```freebasic
#import "std/containers"
using containers

'' A type is iterable when it has GetIterator( ), and the
'' iterator it hands back has IsValid( ), Value( ) and MoveNext( ).
'' `for each` is rewritten into exactly those three calls.
dim v as Array( of int32 )
v.Push( 1 ) : v.Push( 2 ) : v.Push( 3 )

for each x in v
    print x;
next
print                        '' 1 2 3

'' Which is this, written out:
dim it as ArrayIterator( of int32 ) = v.GetIterator( )
while it.IsValid( )
    print it.Value( );
    it.MoveNext( )
wend
print                        '' 1 2 3
```

---

**Library:** [For Each](Category-For-Each)  
**Category:** [For Each](Category-For-Each)  
**Documented under:** What Can Be Walked
