[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Fail**

# Fail

## Syntax

```freebasic
Fail( of T, E )
Fail( of long, ustring )
```

## Examples

```freebasic
#include once "fb/result.bi"
using FB

dim r as Result( of long, ustring ) = Fail( of long, ustring )( "not a number" )

print r.IsOk( )              '' false
print r.Failure( )           '' not a number

'' T and E MAY BE THE SAME TYPE -- Result( of ustring, ustring ) is a normal
'' thing to want. The slots stay distinct because they are two fields,
'' not a union.
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
