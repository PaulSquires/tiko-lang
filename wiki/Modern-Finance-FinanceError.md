[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinanceError**

# FinanceError

## Syntax

```freebasic
err.Code( )  err.Message( )  err.Iterations( )  err.Residual( )  err.BestGuess( )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' Every fallible finance call returns Result( of T, FinanceError ).
'' The error carries a code, and -- for solvers -- how close it got.
var bad = GrowthFactor( DecimalParse( "-2" ).Value( ), 5 )

print bad.IsOk( )                        '' false
print bad.Failure( ).Code( )             '' 1 = FIN_INVALID_RATE
print bad.Failure( ).Message( )          '' invalid rate

'' Iterations/Residual/BestGuess are filled by solvers only; elsewhere
'' they are zero and BestGuess is NaN -- absence said in the value.
print bad.Failure( ).Iterations( )       '' 0
print IsNaN( bad.Failure( ).BestGuess( ) )   '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finerror.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
