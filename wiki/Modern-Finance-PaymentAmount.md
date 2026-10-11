[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **PaymentAmount**

# PaymentAmount

## Syntax

```freebasic
PaymentAmount( annuityTerms )
```

## Examples

```freebasic
#import "std/money"
using money

'' The level payment that amortizes a principal over a term.
''
'' IT IS NEGATIVE when the present value is positive, and that surprises
'' everyone exactly once: you RECEIVED the loan, so you PAY it back.
'' finloan.tiko flips the convention for schedules, deliberately.
dim as Decimal i = RatePerPeriod( DecimalParse( "0.0595" ).Value( ), COMPOUND_MONTHLY ).Value( )

dim as AnnuityTerms t = AnnuityTermsMake( i, 360, DecimalZero( ), _
                                          DecimalParse( "400000" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
print PaymentAmount( t ).Value( ).ToStringFixed( 2 )     '' -2385.36

'' A zero-rate loan divides the principal evenly, exactly.
dim as AnnuityTerms z = AnnuityTermsMake( DecimalZero( ), 24, DecimalZero( ), _
                                          DecimalParse( "2400" ).Value( ), _
                                          DecimalZero( ), PAY_END_OF_PERIOD )
print PaymentAmount( z ).Value( ).ToString( )            '' -100
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fintvm.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
