[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinSolverOptions**

# FinSolverOptions

## Syntax

```freebasic
o.Guess_  o.LowerBound_  o.UpperBound_  o.Tolerance_  o.StepTolerance_  o.MaxIterations_  o.BracketSteps_
```

## Examples

```freebasic
#import "std/numeric"
#import "std/money"
using money, numeric

'' How the root finder should search.  THE DEFAULT BOUNDS ARE RATE
'' BOUNDS -- a periodic rate at or below -100% is meaningless -- so a
'' general-purpose objective must widen them or its root is excluded by
'' construction.
dim as FinSolverOptions o = FinSolverOptionsDefault( )

print o.LowerBound_                      '' about -0.9999999 -- a rate above -100%
print o.MaxIterations_                   '' 128
print IsNaN( o.Guess_ )                  '' true -- no caller seed

o.LowerBound_ = -1.0e6
o.UpperBound_ =  1.0e6
o.Tolerance_  = 1.0e-14
print o.Tolerance_                       '' 1e-014
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finsolve.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
