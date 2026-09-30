[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationTermsMake**

# DepreciationTermsMake

## Syntax

```freebasic
DepreciationTermsMake( cost, salvage, lifePeriods )
```

## Examples

```freebasic
#import "std/money"
using FB

'' Construction by named free function.  It defaults RateFactor_ to 2,
'' PlacedInService_ to 1 and the rounding policy to cents.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

print DepreciationStraightLine( t, 1 ).Value( ).ToStringFixed( 2 )       '' 6428.57

'' The depreciable base is cost MINUS salvage -- 45000 here, not 50000.
dim as Decimal total = DecimalZero( )
for k as int32 = 1 to 7
    total = total + DepreciationStraightLine( t, k ).Value( )
next
print total.ToStringFixed( 2 )           '' 45000.00
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/findeprec.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
