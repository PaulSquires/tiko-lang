[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **DepreciationDecliningBalance**

# DepreciationDecliningBalance

Returns one period's expense as a fixed fraction of the remaining book value.

## Syntax

```freebasic
DepreciationDecliningBalance( terms, period )
```

## Examples

```freebasic
#import "std/money"
using money

'' A fixed fraction of the REMAINING book value each period, so the
'' expense falls away geometrically.  RateFactor_ chooses the speed.
dim as DepreciationTerms t = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                    DecimalParse( "5000" ).Value( ), 7 )

t.RateFactor_ = DecimalParse( "1.5" ).Value( )        '' 150% declining balance

print DepreciationDecliningBalance( t, 1 ).Value( ).ToStringFixed( 2 )   '' 10714.29
print DepreciationDecliningBalance( t, 2 ).Value( ).ToStringFixed( 2 )   '' 8418.37

'' A slower factor always writes off less early than double declining.
dim as DepreciationTerms fast = DepreciationTermsMake( DecimalParse( "50000" ).Value( ), _
                                                       DecimalParse( "5000" ).Value( ), 7 )
dim as boolean slower = ( DepreciationDecliningBalance( t, 1 ).Value( ) < _
                          DepreciationDoubleDeclining( fast, 1 ).Value( ) )
print slower                             '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/findeprec.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
