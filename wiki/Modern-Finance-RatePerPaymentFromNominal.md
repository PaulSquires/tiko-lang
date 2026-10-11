[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RatePerPaymentFromNominal**

# RatePerPaymentFromNominal

## Syntax

```freebasic
RatePerPaymentFromNominal( nominalAnnual, compounding, paymentFrequency )
```

## Examples

```freebasic
#import "std/money"
using money

'' THE FUNNEL every loan function goes through, and the reason this
'' module exists.  Compounding and payment frequency are SEPARATE, so
'' one code path serves both mortgage conventions.
dim as Decimal j = DecimalParse( "0.0595" ).Value( )

'' US: compounds monthly, pays monthly -- the two collapse, and the rate
'' is exactly j/12.
var us = RatePerPaymentFromNominal( j, COMPOUND_MONTHLY, PAY_MONTHLY )
print ( us.Value( ) = ( j / DecimalFromInt( 12 ) ) )        '' true

'' CANADA: the Interest Act requires semi-annual quoting, while payments
'' are monthly -- so the rate is ( 1 + j/2 )^(1/6) - 1.  ONE ENUM apart.
var ca = RatePerPaymentFromNominal( j, COMPOUND_SEMIANNUAL, PAY_MONTHLY )
print ca.Value( ).ToStringFixed( 12 )

'' They differ, and on a mortgage that difference is real money.
print ( ca.Value( ) < us.Value( ) )                         '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/fincore.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
