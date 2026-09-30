[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **RateEffectiveFromNominal**

# RateEffectiveFromNominal

## Syntax

```freebasic
RateEffectiveFromNominal( nominalAnnual, compounding )
```

## Examples

```freebasic
#import "std/money"
using FB

'' What a quoted rate actually earns over a year once it compounds.
dim as Decimal j = DecimalParse( "0.0595" ).Value( )

'' Semi-annual: ( 1 + j/2 )^2 - 1, and the expansion terminates, so this
'' is exact to the last digit.
print RateEffectiveFromNominal( j, COMPOUND_SEMIANNUAL ).Value( ).ToString( )  '' 0.0603850625

'' More frequent compounding earns more on the same quoted rate.
print ( RateEffectiveFromNominal( j, COMPOUND_MONTHLY ).Value( ) > _
        RateEffectiveFromNominal( j, COMPOUND_SEMIANNUAL ).Value( ) )         '' true

'' Annual compounding is the identity.
print ( RateEffectiveFromNominal( j, COMPOUND_ANNUAL ).Value( ) = j )         '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
