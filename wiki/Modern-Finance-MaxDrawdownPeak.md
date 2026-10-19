[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MaxDrawdownPeak**

# MaxDrawdownPeak

Returns the index of the peak the worst drawdown fell from, or empty if none.

## Syntax

```freebasic
MaxDrawdownPeak( periodReturns( ) )
```

## Examples

```freebasic
#import "std/money"
using money

'' The index of the peak the worst drawdown fell FROM.
''
'' AN Optional, not a Result: a series that never drew down has no peak,
'' and that is the finding rather than a failure.
dim as float64 r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as float64 b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print MaxDrawdownPeak( r( ) ).HasValue( )    '' true
print MaxDrawdownPeak( r( ) ).Value( )       '' 3

dim as float64 up_( 0 to 3 ) = { 0.01, 0.02, 0.01, 0.03 }
print MaxDrawdownPeak( up_( ) ).HasValue( )  '' false
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finport.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
