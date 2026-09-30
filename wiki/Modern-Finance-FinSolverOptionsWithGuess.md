[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinSolverOptionsWithGuess**

# FinSolverOptionsWithGuess

## Syntax

```freebasic
FinSolverOptionsWithGuess( guess )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

'' The defaults, plus a starting point.  A good seed saves iterations; it
'' never changes the answer, because the bracket owns the guarantee.
dim as FinSolverOptions o = FinSolverOptionsWithGuess( 0.05 )

print o.Guess_                           '' 0.05
print IsNaN( o.Guess_ )                  '' false

'' Where a series has several roots, the seed is how you choose between
'' them -- see InternalRateOfReturn.
print o.MaxIterations_                   '' 128
```

---

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finsolve.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
