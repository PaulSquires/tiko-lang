[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanBalanceAt**

# LoanBalanceAt

## Syntax

```freebasic
LoanBalanceAt( loanTerms, period )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The closed form, O(1) -- it does NOT walk, so it does not include
'' per-payment rounding drift.  Use it for a chart with a thousand
'' points; use LoanRowAt for anything a ledger will post.
dim as LoanTerms t = LoanTermsUsMortgage( DecimalParse( "400000" ).Value( ), _
                                          DecimalParse( "0.0595" ).Value( ), 30 )

print LoanBalanceAt( t, 0 ).Value( ).ToString( )         '' 400000
print LoanBalanceAt( t, 180 ).Value( ).ToStringFixed( 2 )  '' 283580.06

'' THE SCHEDULE IS AUTHORITATIVE where the two disagree; they agree to
'' within the rounding unit times the period number.
print LoanRowAt( t, 180 ).Value( ).ClosingBalance_.ToStringFixed( 2 )   '' 283580.13
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finloan.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
