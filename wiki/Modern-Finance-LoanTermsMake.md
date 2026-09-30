[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanTermsMake**

# LoanTermsMake

## Syntax

```freebasic
LoanTermsMake( principal, nominalAnnualRate, termMonths, paymentFrequency, compounding )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The general constructor, for anything the two named mortgage forms do
'' not cover -- here a five-year car loan paying weekly.
dim as LoanTerms t = LoanTermsMake( DecimalParse( "30000" ).Value( ), _
                                    DecimalParse( "0.079" ).Value( ), _
                                    60, PAY_WEEKLY, COMPOUND_MONTHLY )

print t.TermMonths_                      '' 60
print LoanPayment( t ).Value( ).ToStringFixed( 2 )       '' 139.69

'' Defaults it fills in: payments at period end, no balloon, cents.
dim as boolean atEnd = ( t.Timing_ = PAY_END_OF_PERIOD )
print atEnd                              '' true
print t.BalloonAmount_.IsZero( )         '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
