[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FutureValue**

# FutureValue

Returns what a stream of payments will be worth at the end of the term.

## Syntax

```freebasic
FutureValue( annuityTerms )
```

## Examples

```freebasic
#import "std/money"
using money

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
**Source:** `pkg/std/money/fintvm.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
