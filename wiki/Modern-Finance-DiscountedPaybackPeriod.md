[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DiscountedPaybackPeriod**

# DiscountedPaybackPeriod

## Syntax

```freebasic
DiscountedPaybackPeriod( flows( ), ratePerPeriod )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Payback measured on DISCOUNTED flows, so later money counts for less.
'' Always at least as long as the undiscounted figure.
dim as Decimal f( 0 to 4 ) = { DecimalParse( "-1000" ).Value( ), _
                               DecimalParse( "300" ).Value( ), _
                               DecimalParse( "400" ).Value( ), _
                               DecimalParse( "500" ).Value( ), _
                               DecimalParse( "200" ).Value( ) }

print PaybackPeriod( f( ) ).Value( )                                   '' 2.6
print DiscountedPaybackPeriod( f( ), DecimalParse( "0.10" ).Value( ) ).Value( )   '' 3.154...

'' Discounting can turn a paying project into a non-paying one, which is
'' the whole reason to compute it.
dim as Decimal thin_( 0 to 3 ) = { DecimalParse( "-1000" ).Value( ), _
                                   DecimalFromInt( 340 ), DecimalFromInt( 340 ), _
                                   DecimalFromInt( 340 ) }
print PaybackPeriod( thin_( ) ).HasValue( )                            '' true
print DiscountedPaybackPeriod( thin_( ), DecimalParse( "0.20" ).Value( ) ).HasValue( )  '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincash.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
