[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalMinValue**

# DecimalMinValue

## Syntax

```freebasic
DecimalMinValue( )
```

## Examples

```freebasic
#import "std/money"
using FB

'' -(2^96-1) at scale 0 -- the most negative value the type holds.  The
'' range is SYMMETRIC, unlike a two's-complement integer, because the sign
'' is a separate bit rather than part of the magnitude
print DecimalMinValue( ).ToString( )
'' -79228162514264337593543950335

print ( DecimalMaxValue( ) + DecimalMinValue( ) ).IsZero( )   '' true
print DecimalMinValue( ).AbsValue( ) = DecimalMaxValue( )     '' true

'' which is why AbsValue( ) can never overflow here, where Currency's and
'' every integer type's can
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
