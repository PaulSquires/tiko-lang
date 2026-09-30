[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanInterestBetween**

# LoanInterestBetween

## Syntax

```freebasic
LoanInterestBetween( loanTerms, fromPeriod, toPeriod )
```

## Examples

```freebasic
#import "std/money"
using FB

'' Interest posted across a range of periods -- what a year-end
'' statement reports.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

'' The first year.
print LoanInterestBetween( t, 1, 12 ).Value( ).ToStringFixed( 2 )      '' 23666.23

'' The whole term, which equals the summary's total.
print LoanInterestBetween( t, 1, 360 ).Value( ).ToStringFixed( 2 )     '' 458728.63

'' Adjacent ranges sum to the whole.
dim as Decimal a = LoanInterestBetween( t, 1, 180 ).Value( )
dim as Decimal b = LoanInterestBetween( t, 181, 360 ).Value( )
print ( a + b ).ToStringFixed( 2 )                                     '' 458728.63
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
