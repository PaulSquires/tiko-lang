[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AnnuityTerms**

# AnnuityTerms

## Syntax

```freebasic
t.RatePerPeriod_  t.Periods_  t.Payment_  t.PresentValue_  t.FutureValue_  t.Timing_
```

## Examples

```freebasic
#import "std/money"
using money

'' The five quantities of an annuity in one record, so a transposed
'' argument is visible at the call site rather than a plausible wrong
'' number.  Everything in fintvm.tiko rearranges
''
''     PV + PMT * a( i, n, timing ) + FV * v( i, n ) = 0
dim as Decimal i = RatePerPeriod( DecimalParse( "0.06" ).Value( ), COMPOUND_MONTHLY ).Value( )

dim as AnnuityTerms t = AnnuityTermsMake( i, 360, DecimalZero( ), _
                                          DecimalParse( "400000" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
print t.Periods_                         '' 360
print t.PresentValue_.ToString( )        '' 400000
print PaymentAmount( t ).Value( ).ToStringFixed( 2 )    '' -2398.20
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fintvm.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
