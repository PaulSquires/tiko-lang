[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FutureValue**

# FutureValue

## Syntax

```freebasic
FutureValue( annuityTerms )
```

## Examples

```freebasic
#import "std/money"
using FB

'' What a stream of payments will be worth at the end of the term.
dim as Decimal i = DecimalParse( "0.005" ).Value( )

dim as AnnuityTerms t = AnnuityTermsMake( i, 120, DecimalParse( "-200" ).Value( ), _
                                          DecimalZero( ), DecimalZero( ), _
                                          PAY_END_OF_PERIOD )
print FutureValue( t ).Value( ).ToStringFixed( 2 )       '' 32775.87

'' A loan repaid on schedule has a future value of zero -- that is what
'' "fully amortized" means, and it is a good check on a payment.
dim as AnnuityTerms loan_ = AnnuityTermsMake( i, 120, DecimalZero( ), _
                                              DecimalParse( "20000" ).Value( ), _
                                              DecimalZero( ), PAY_END_OF_PERIOD )
dim as Decimal pmt = PaymentAmount( loan_ ).Value( )
dim as AnnuityTerms done_ = AnnuityTermsMake( i, 120, pmt, _
                                              DecimalParse( "20000" ).Value( ), _
                                              DecimalZero( ), PAY_END_OF_PERIOD )
print FutureValue( done_ ).Value( ).ToStringFixed( 2 )        '' 0.00
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fintvm.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
