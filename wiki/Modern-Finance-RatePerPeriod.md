[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RatePerPeriod**

# RatePerPeriod

## Syntax

```freebasic
RatePerPeriod( nominalAnnual, compounding )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The quoted annual rate divided by its compounding frequency.  EXACT --
'' a plain Decimal division, not reduced, so the claim below holds.
dim as Decimal j = DecimalParse( "0.0595" ).Value( )

print RatePerPeriod( j, COMPOUND_MONTHLY ).Value( ).ToString( )
print ( RatePerPeriod( j, COMPOUND_MONTHLY ).Value( ) = _
        ( j / DecimalFromInt( 12 ) ) )                    '' true, exactly

'' Simple interest has no per-period compounding to divide into, and
'' continuous has no "per period" at all -- a named refusal, not a
'' division by zero.
print RatePerPeriod( j, COMPOUND_SIMPLE ).Value( ).ToString( )              '' 0.0595
dim as boolean refused = _
    ( RatePerPeriod( j, COMPOUND_CONTINUOUS ).Failure( ).Code( ) = FIN_INVALID_BASIS )
print refused                                                              '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
