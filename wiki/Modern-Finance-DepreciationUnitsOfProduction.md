[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationUnitsOfProduction**

# DepreciationUnitsOfProduction

Returns one period's expense from the units it produced out of the lifetime total.

## Syntax

```freebasic
DepreciationUnitsOfProduction( terms, unitsThisPeriod, totalUnits )
```

## Examples

```freebasic
#import "std/money"
using money

'' Depreciation by USE rather than by time -- the base times this
'' period's share of the asset's total expected output.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

'' A tenth of the lifetime units is a tenth of the 45000 base.
print DepreciationUnitsOfProduction( t, DecimalParse( "1000" ).Value( ), _
                                     DecimalParse( "10000" ).Value( ) ).Value( ).ToString( )   '' 4500

print DepreciationUnitsOfProduction( t, DecimalZero( ), _
                                     DecimalParse( "10000" ).Value( ) ).Value( ).IsZero( )     '' true

'' Zero total units is a named refusal, not an infinity.
print DepreciationUnitsOfProduction( t, DecimalParse( "100" ).Value( ), _
                                     DecimalZero( ) ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/findeprec.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
