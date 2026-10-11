[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **MaxDrawdown**

# MaxDrawdown

## Syntax

```freebasic
MaxDrawdown( periodReturns( ) )
```

## Examples

```freebasic
#import "std/money"
using money

'' The worst peak-to-trough fall, as a POSITIVE magnitude.
dim as float64 r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as float64 b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print MaxDrawdown( r( ) ).Value( )       '' 0.02500000000000009

'' A series that only ever rose returns exactly zero -- and POSITIVE
'' zero, because a drawdown printing as -0 reads as a defect.
dim as float64 up_( 0 to 3 ) = { 0.01, 0.02, 0.01, 0.03 }
print MaxDrawdown( up_( ) ).Value( )     '' 0

'' A monotonic decline draws down to the whole compounded loss.
dim as float64 down_( 0 to 2 ) = { -0.1, -0.1, -0.1 }
print MaxDrawdown( down_( ) ).Value( )   '' 0.2709999999999999
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finport.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
