[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalFromScaled**

# DecimalFromScaled

## Syntax

```freebasic
DecimalFromScaled( mantissa, scale )
```

## Examples

```freebasic
#import "std/money"
using FB

'' value = mantissa / 10 ^ scale, exactly.  The usual way to write a
'' literal amount without going through text
print DecimalFromScaled( 1999, 2 ).ToString( )   '' 19.99
print DecimalFromScaled( -1999, 2 ).ToString( )  '' -19.99

'' the smallest value the type has
print DecimalFromScaled( 1, 28 ).ToString( )
'' 0.0000000000000000000000000001

'' the scale must be 0..28; anything else is Invalid rather than clamped
print DecimalFromScaled( 1, 29 ).IsValid( )      '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
