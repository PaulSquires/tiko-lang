[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalFromUInt**

# DecimalFromUInt

## Syntax

```freebasic
DecimalFromUInt( u )
```

## Examples

```freebasic
#import "std/money"
using money

'' A ULONGINT, exactly.  The whole 64-bit range fits inside the 96-bit
'' mantissa, so nothing is lost at the top end either
print DecimalFromUInt( 0ull ).ToString( )   '' 0
print DecimalFromUInt( 18446744073709551615ull ).ToString( )
'' 18446744073709551615
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
