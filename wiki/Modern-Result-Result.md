[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Result**

# Result

"nothing is here, AND this is why"

## Syntax

```freebasic
Result( of T, E )
Result( of ustring, ustring )
```

## Notes

- "nothing is here, AND this is why"

## Examples

```freebasic
#import "std/outcome"
using FB

'' A value, or the reason there isn't one. The difference from Optional
'' is the E: Optional says "nothing is here", Result says "nothing is
'' here, AND this is why".
dim r as Result( of int32, ustring )

'' A DEFAULT-CONSTRUCTED RESULT IS A FAILURE. That is deliberate: a
'' Result nobody has set must not read as success, or every forgotten
'' assignment becomes a silent Ok.
print r.IsOk( )              '' false

r = Ok( of int32, ustring )( 42 )
print r.IsOk( )              '' true
print r.Value( )             '' 42
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Result Or Optional?  
**Source:** `docs/result/result.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
