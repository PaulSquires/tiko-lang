[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **TrackingError**

# TrackingError

## Syntax

```freebasic
TrackingError( assetReturns( ), benchmarkReturns( ), frequency )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The SAMPLE standard deviation of the active return -- asset minus
'' benchmark -- annualized.  How tightly the portfolio follows its index.
dim as float64 r( 0 to 11 ) = { 0.02, -0.01, 0.03, 0.015, -0.025, 0.04, _
                               0.01, -0.005, 0.02, 0.03, -0.015, 0.025 }
dim as float64 b( 0 to 11 ) = { 0.018, -0.012, 0.025, 0.012, -0.02, 0.035, _
                               0.008, -0.004, 0.018, 0.028, -0.012, 0.022 }

print TrackingError( r( ), b( ), RETURN_MONTHLY ).Value( )       '' 0.01038793005892372

'' A portfolio identical to its benchmark tracks it exactly.
print TrackingError( b( ), b( ), RETURN_MONTHLY ).Value( )       '' 0

'' Mismatched lengths are a named refusal.
dim as float64 short_( 0 to 4 ) = { 0.01, 0.02, 0.01, 0.02, 0.01 }
print TrackingError( r( ), short_( ), RETURN_MONTHLY ).Failure( ).Message( )
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finport.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
