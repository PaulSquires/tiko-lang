[Home](Home) › [For Each](Category-For-Each) › [For Each](Category-For-Each) › **Value**

# Value

## Syntax

```freebasic
Value( )
```

## Examples

```freebasic
#import "std/containers"
using FB

dim v as Array( of int32 )
v.Push( 1 ) : v.Push( 2 )

dim it as ArrayIterator( of int32 ) = v.GetIterator( )
print it.Value( )            '' 1 -- the element the iterator is on

'' Array's Value( ) returns BYREF, so `for each byref x in v` can modify
'' elements in place. Returning byval would make that impossible.
it.Value( ) = 99
print v[ 0 ]                 '' 99

'' Only valid while IsValid( ) is true
```

---

**Library:** [For Each](Category-For-Each)  
**Category:** [For Each](Category-For-Each)  
**Documented under:** What Can Be Walked  
**Source:** `docs/for_each/for-each.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
