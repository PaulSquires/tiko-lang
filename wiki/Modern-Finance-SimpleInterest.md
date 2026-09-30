[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **SimpleInterest**

# SimpleInterest

## Syntax

```freebasic
SimpleInterest( principal, annualRate, yearFraction )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Interest that does not compound: principal x rate x time.  EXACT.
dim as Decimal p = DecimalParse( "10000" ).Value( )
dim as Decimal r = DecimalParse( "0.05" ).Value( )

print SimpleInterest( p, r, DecimalOne( ) ).ToString( )                     '' 500.00
print SimpleInterest( p, r, DecimalParse( "0.5" ).Value( ) ).ToString( )    '' 250.000

'' Any zero factor gives exactly zero.
print SimpleInterest( p, r, DecimalZero( ) ).IsZero( )                      '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
