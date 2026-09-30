[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **PresentValue**

# PresentValue

## Syntax

```freebasic
PresentValue( annuityTerms )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' What a stream of payments plus a final lump is worth today.
'' CASH-FLOW SIGNS: money received is positive, money paid is negative,
'' which is what makes the identity balance to zero.
dim as Decimal i = DecimalParse( "0.005" ).Value( )

'' Receiving 100 a month for 24 months costs this much today.
dim as AnnuityTerms t = AnnuityTermsMake( i, 24, DecimalParse( "-100" ).Value( ), _
                                          DecimalZero( ), DecimalZero( ), _
                                          PAY_END_OF_PERIOD )
print PresentValue( t ).Value( ).ToStringFixed( 2 )      '' 2256.29

'' At a zero rate it is simply the sum of the payments -- taken by an
'' explicit limit rather than a division by zero.
dim as AnnuityTerms z = AnnuityTermsMake( DecimalZero( ), 24, _
                                          DecimalParse( "-100" ).Value( ), _
                                          DecimalZero( ), DecimalZero( ), _
                                          PAY_END_OF_PERIOD )
print PresentValue( z ).Value( ).ToString( )             '' 2400
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fintvm.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
