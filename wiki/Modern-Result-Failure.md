[Home](Home) › [Result](Category-Result) › [Result](Category-Result) › **Failure**

# Failure

## Syntax

```freebasic
Failure( ) byref as E
```

## Examples

```freebasic
#import "std/outcome"
using outcome

dim r as Result( of int32, ustring ) = Fail( of int32, ustring )( "not a number" )

print r.Failure( )           '' not a number

'' Byref, like Value( )
r.Failure( ) = "bad input"
print r.Failure( )           '' bad input

'' On a SUCCESSFUL Result this raises, symmetrically with Value( ) on a
'' failure. IsOk( ) is the guard for both.
```

---

**Library:** [Result](Category-Result)  
**Category:** [Result](Category-Result)  
**Documented under:** Members  
**Source:** `docs/result/result.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
