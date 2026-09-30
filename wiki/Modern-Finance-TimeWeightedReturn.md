[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **TimeWeightedReturn**

# TimeWeightedReturn

## Syntax

```freebasic
TimeWeightedReturn( subPeriodReturns( ) )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Geometric linking of sub-period returns -- it measures the MANAGER,
'' because it removes the effect of when money was added or withdrawn.
''
'' IT IS A TRUE TWR ONLY IF you cut a sub-period at EVERY external flow.
'' Pass monthly returns with mid-month contributions and you get a
'' plausible number that is not a TWR.
dim as double r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as double b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print TimeWeightedReturn( r( ) ).Value( )                '' 0.1410864155548182

'' MULTIPLICATIVE, not additive: a 50% gain then a 50% loss is -25%, not
'' zero, which is the classic result and a good check on the linking.
dim as double gl( 0 to 1 ) = { 0.5, -0.5 }
print TimeWeightedReturn( gl( ) ).Value( )               '' -0.25

'' A total loss is -100%; anything worse is refused.
dim as double wipe( 0 to 1 ) = { -1.0, 0.1 }
print TimeWeightedReturn( wipe( ) ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
