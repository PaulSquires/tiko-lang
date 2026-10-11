[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalInvalid**

# DecimalInvalid

## Syntax

```freebasic
DecimalInvalid( )
```

## Examples

```freebasic
#import "std/money"
using money

'' The one representation that is not a number -- scale 255, which no
'' value can have.  Overflow, division by zero and a conversion that will
'' not fit all produce it
print DecimalInvalid( ).ToString( )   '' Invalid
print DecimalInvalid( ).IsValid( )    '' false

print ( DecimalMaxValue( ) + DecimalOne( ) ).IsValid( )   '' false
print ( DecimalOne( ) / DecimalZero( ) ).IsValid( )       '' false

'' It is INFECTIOUS: anything touching it is Invalid too
print ( DecimalInvalid( ) * DecimalOne( ) ).IsValid( )    '' false

'' and INVALID = INVALID IS FALSE, the same rule currency.tiko and
'' std/chrono use.  Test with IsValid( ), never with =
print ( DecimalInvalid( ) = DecimalInvalid( ) )           '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/decimal/decimal.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
