[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Optional**

# Optional

"nothing is here"

## Syntax

```freebasic
Optional( of T )
```

## Notes

- "nothing is here"

## Examples

```freebasic
#include once "fb/result.bi"
using FB

'' Optional is Result's smaller sibling: absence with no explanation.
'' Use Optional when the miss needs no reason -- a lookup that found
'' nothing -- and Result when it does.
#include once "fb/optional.bi"

dim o as Optional( of integer ) = Some( 42 )
print o.HasValue( )          '' true
print o.Value( )             '' 42

dim r as Result( of long, ustring ) = Fail( of long, ustring )( "not a number" )
print r.IsOk( )              '' false
print r.Failure( )           '' not a number -- the part Optional cannot carry
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Result Or Optional?  
**Source:** `docs/result/result.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
