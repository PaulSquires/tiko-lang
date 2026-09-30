[Home](Home) › [For Each](Category-For-Each) › [For Each](Category-For-Each) › **IsValid**

# IsValid

## Syntax

```freebasic
IsValid( )
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

'' Asked BEFORE every element, including the first: it is the loop
'' condition, so an empty container runs the body zero times.
dim v as Array( of long )

dim it as ArrayIterator( of long ) = v.GetIterator( )
print it.IsValid( )          '' false -- nothing to visit

v.Push( 7 )
dim jt as ArrayIterator( of long ) = v.GetIterator( )
print jt.IsValid( )          '' true

jt.MoveNext( )
print jt.IsValid( )          '' false -- past the last element
```

---

**Library:** [For Each](Category-For-Each)  
**Category:** [For Each](Category-For-Each)  
**Documented under:** What Can Be Walked  
**Source:** `docs/for_each/for-each.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
