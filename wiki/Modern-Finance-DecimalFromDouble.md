[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalFromDouble**

# DecimalFromDouble

## Syntax

```freebasic
DecimalFromDouble( d )
```

## Examples

```freebasic
#include once "fb/decimal.bi"
using FB

'' NAMED, because it is not exact -- the DOUBLE 0.1 is not one tenth.
'' Fifteen significant digits, trailing zeros stripped, which is what
'' .NET's double -> decimal conversion does
print DecimalFromDouble( 0.1 ).ToString( )       '' 0.1
print DecimalFromDouble( 1.0 / 3.0 ).ToString( ) '' 0.333333333333333

'' Storing all seventeen digits would store the ERROR rather than the
'' number: the DOUBLE 0.1 is really
'' 0.1000000000000000055511151231257827

'' NaN and the infinities have no decimal value
print DecimalFromDouble( 0.0 / 0.0 ).IsValid( )  '' false
print DecimalFromDouble( 1.0e300 ).IsValid( )    '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
