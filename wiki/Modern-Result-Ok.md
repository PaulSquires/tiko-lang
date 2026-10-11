[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Ok**

# Ok

## Syntax

```freebasic
Ok( of T, E )
Ok( of int32, ustring )
```

## Examples

```freebasic
#import "std/outcome"
using outcome

dim r as Result( of int32, ustring ) = Ok( of int32, ustring )( 42 )

print r.IsOk( )              '' true
print r.Value( )             '' 42

'' Both type arguments are written out because only T appears in the
'' parameter list -- E cannot be inferred from anything
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
