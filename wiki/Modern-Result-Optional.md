[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Optional**

# Optional

Holds one value or nothing at all; a new one is empty.

## Syntax

```freebasic
Optional( of T )
```

## Notes

- "nothing is here"

## Examples

```freebasic
#import "std/outcome"
using outcome

'' Optional is Result's smaller sibling: absence with no explanation.
'' Use Optional when the miss needs no reason -- a lookup that found
'' nothing -- and Result when it does.

dim o as Optional( of integer ) = Some( 42 )
print o.HasValue( )          '' true
print o.Value( )             '' 42

dim r as Result( of int32, ustring ) = Fail( of int32, ustring )( "not a number" )
print r.IsOk( )              '' false
print r.Failure( )           '' not a number -- the part Optional cannot carry
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Result Or Optional?
