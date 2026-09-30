[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **DivMod**

# DivMod

returns a TUPLE

## Syntax

```freebasic
DivMod( a, b )
```

## Notes

- returns a TUPLE

## Examples

```freebasic
#import "std/numeric"
using FB

'' Quotient and remainder from ONE divide, returned as a TUPLE -- which
'' is where the tuple feature earns its keep
dim as int32 a = 17, b = 5

'' DESTRUCTURE it. The fields are named in the signature but the value
'' is taken apart positionally, so `.quotient` is error 18.
var (q, r) = DivMod( a, b )

print q                      '' 3
print r                      '' 2

'' Tuple identity is STRUCTURAL, so DivMod on LONG and on LONGINT give
'' different types and neither converts to the other
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
