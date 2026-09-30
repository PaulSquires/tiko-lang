[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **GrowthFactor**

# GrowthFactor

## Syntax

```freebasic
GrowthFactor( ratePerPeriod, periods )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' ( 1 + i )^n for an INTEGER n, EXACT, by binary exponentiation -- about
'' thirteen Decimal multiplies for a 360-period term rather than 360.
dim as Decimal i = DecimalParse( "0.005" ).Value( )

print GrowthFactor( i, 0 ).Value( ).ToString( )          '' 1
print GrowthFactor( i, 12 ).Value( ).ToStringFixed( 8 )  '' 1.06167781

'' A terminating rate stays exact: 1.5^8.
print GrowthFactor( DecimalParse( "0.5" ).Value( ), 8 ).Value( ).ToString( )   '' 25.62890625

'' Past a 96-bit mantissa it is a NAMED refusal, not a silent loss.
dim as boolean overflowed = _
    ( GrowthFactor( DecimalFromInt( 2 ), 200 ).Failure( ).Code( ) = FIN_OVERFLOW )
print overflowed                                         '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/fincore.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
