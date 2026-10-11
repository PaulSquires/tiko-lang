[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinanceError**

# FinanceError

## Syntax

```freebasic
err.Code( )  err.Message( )  err.Iterations( )  err.Residual( )  err.BestGuess( )
```

## Examples

```freebasic
#import "std/numeric"
#import "std/money"
using money, numeric

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
**Source:** `pkg/std/money/finerror.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
