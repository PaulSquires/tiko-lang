[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **AnnuityTermsMake**

# AnnuityTermsMake

## Syntax

```freebasic
AnnuityTermsMake( ratePerPeriod, periods, payment, presentValue, futureValue, timing )
```

## Examples

```freebasic
#import "std/money"
using money

'' Construction by named free function, never a one-argument constructor
'' -- the same rule decimal.tiko follows.
dim as Decimal i = DecimalParse( "0.01" ).Value( )

'' A savings plan: nothing now, 100 a month for 120 months.
dim as AnnuityTerms save_ = AnnuityTermsMake( i, 120, DecimalParse( "-100" ).Value( ), _
                                              DecimalZero( ), DecimalZero( ), _
                                              PAY_END_OF_PERIOD )
print FutureValue( save_ ).Value( ).ToStringFixed( 2 )   '' 23003.87

'' The UNKNOWN field is ignored: PaymentAmount does not read Payment_.
dim as AnnuityTerms loan_ = AnnuityTermsMake( i, 120, DecimalZero( ), _
                                              DecimalParse( "10000" ).Value( ), _
                                              DecimalZero( ), PAY_END_OF_PERIOD )
print PaymentAmount( loan_ ).Value( ).ToStringFixed( 2 )  '' -143.47
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fintvm.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
