[Home](Home) › [For Each](Category-For-Each) › [For Each](Category-For-Each) › **MoveNext**

# MoveNext

## Syntax

```freebasic
MoveNext( )
```

## Examples

```freebasic
#import "std/containers"
using FB

dim v as Array( of int32 )
v.Push( 1 ) : v.Push( 2 )

dim it as ArrayIterator( of int32 ) = v.GetIterator( )
print it.Value( )            '' 1
it.MoveNext( )               '' advance -- it returns nothing
print it.Value( )            '' 2
it.MoveNext( )
print it.IsValid( )          '' false

'' The order is always IsValid -> Value -> MoveNext. An iterator that
'' advanced inside Value( ) could not be read twice.
```

---

**Library:** [For Each](Category-For-Each)  
**Category:** [For Each](Category-For-Each)  
**Documented under:** What Can Be Walked  
**Source:** `docs/for_each/for-each.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
