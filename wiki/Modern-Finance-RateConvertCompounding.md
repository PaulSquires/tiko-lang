[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RateConvertCompounding**

# RateConvertCompounding

## Syntax

```freebasic
RateConvertCompounding( nominalAnnual, fromCompounding, toCompounding )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Restate a quoted rate under a different compounding frequency, so two
'' quotes can actually be compared.  It goes through the effective annual
'' rate, which is the only common ground the two have.
dim as Decimal j = DecimalParse( "0.0595" ).Value( )

'' 5.95% semi-annual is a LOWER monthly-quoted rate for the same return.
print RateConvertCompounding( j, COMPOUND_SEMIANNUAL, COMPOUND_MONTHLY ).Value( ).ToStringFixed( 8 )

'' Converting to the same frequency changes nothing.
print ( RateConvertCompounding( j, COMPOUND_MONTHLY, COMPOUND_MONTHLY ).Value( ) = j )  '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
