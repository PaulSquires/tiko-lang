[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinSolverOptionsDefault**

# FinSolverOptionsDefault

## Syntax

```freebasic
FinSolverOptionsDefault( )
```

## Examples

```freebasic
#import "std/money"
using FB

'' The standard settings: bracket a rate, 128 iterations, |f| <= 1e-12.
dim as FinSolverOptions o = FinSolverOptionsDefault( )

print o.LowerBound_                      '' about -0.9999999 -- a rate above -100%
print o.UpperBound_                      '' 1000000
print o.Tolerance_                       '' 1e-012
print o.BracketSteps_                    '' 64

'' Guess_ is NaN, meaning "no caller seed" -- each entry point then
'' supplies its own domain seed.
print IsNaN( o.Guess_ )                  '' true
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finsolve.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
