[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DecimalZero**

# DecimalZero

Returns zero, the same value a new Decimal starts with.

## Syntax

```freebasic
DecimalZero( )
```

## Examples

```freebasic
#import "std/money"
using money

'' Zero at scale 0.  A default-constructed Decimal is the same thing --
'' zero is the meaningful default for a number, so there is no
'' uninitialised state to guard against
dim as Decimal fresh
print DecimalZero( ).ToString( )    '' 0
print DecimalZero( ).IsZero( )      '' true
print DecimalZero( ).IsValid( )     '' true
print fresh.IsZero( )               '' true

'' A zero mantissa never carries a sign, so there is no negative zero to
'' have to compare against
print ( -DecimalZero( ) ).IsNegative( )   '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword
