[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **LoanImpliedRate**

# LoanImpliedRate

## Syntax

```freebasic
LoanImpliedRate( principal, payment, termMonths, paymentFrequency, compounding )
```

## Examples

```freebasic
#import "std/money"
using money

'' The rate a known payment implies -- the phase-3 root finder reaching
'' this surface.  Returns the NOMINAL ANNUAL rate at the given
'' compounding, so it is comparable with the quoted rate.
dim as Decimal p = DecimalParse( "400000" ).Value( )
dim as Decimal pmt = DecimalParse( "2385.36" ).Value( )

var r = LoanImpliedRate( p, pmt, 360, PAY_MONTHLY, COMPOUND_MONTHLY )
print r.Value( ).ToStringFixed( 6 )      '' 0.059500

'' It recovers the quoted rate to four places, not twelve -- the payment
'' it was given had already been ROUNDED TO CENTS, so the rate implied by
'' 2385.36 differs slightly from the one that produced it.
print r.Value( ).Round( 4 ).ToString( )  '' 0.0595
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finloan.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
