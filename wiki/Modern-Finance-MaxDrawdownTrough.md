[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MaxDrawdownTrough**

# MaxDrawdownTrough

## Syntax

```freebasic
MaxDrawdownTrough( periodReturns( ) )
```

## Examples

```freebasic
#import "std/money"
using money

'' The index of the bottom of the worst drawdown.  Always at or after
'' the peak.
dim as float64 r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as float64 b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print MaxDrawdownTrough( r( ) ).Value( )     '' 4
print MaxDrawdownPeak( r( ) ).Value( )       '' 3

dim as boolean afterPeak = ( MaxDrawdownTrough( r( ) ).Value( ) > _
                             MaxDrawdownPeak( r( ) ).Value( ) )
print afterPeak                              '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finport.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
