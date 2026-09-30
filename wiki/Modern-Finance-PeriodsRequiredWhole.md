[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **PeriodsRequiredWhole**

# PeriodsRequiredWhole

## Syntax

```freebasic
PeriodsRequiredWhole( annuityTerms )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The convenience that ceils, named so the rounding is visible at the
'' call site rather than hidden inside PeriodsRequired.
dim as Decimal i = DecimalParse( "0.05" ).Value( )

dim as AnnuityTerms t = AnnuityTermsMake( i, 0, DecimalParse( "-100" ).Value( ), _
                                          DecimalParse( "1000" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
print PeriodsRequired( t ).Value( )      '' 14.20669908289047
print PeriodsRequiredWhole( t ).Value( ) '' 15 -- the last one is smaller

'' A term that IS whole comes back whole, not pushed up by a double's
'' noise: a 360-month mortgage is 360 payments, never 361.
dim as Decimal r = RatePerPeriod( DecimalParse( "0.0595" ).Value( ), COMPOUND_MONTHLY ).Value( )
dim as AnnuityTerms m = AnnuityTermsMake( r, 360, DecimalZero( ), _
                                          DecimalParse( "400000" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
dim as Decimal pmt = PaymentAmount( m ).Value( )
dim as AnnuityTerms n = AnnuityTermsMake( r, 0, pmt, _
                                          DecimalParse( "400000" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
print PeriodsRequiredWhole( n ).Value( ) '' 360
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fintvm.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
