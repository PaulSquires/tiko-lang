[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinSolverOptionsWithGuess**

# FinSolverOptionsWithGuess

Returns the standard solver settings with a starting guess.

## Syntax

```freebasic
FinSolverOptionsWithGuess( guess )
```

## Examples

```freebasic
#import "std/numeric"
#import "std/money"
using money, numeric

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
**Source:** `pkg/std/money/finsolve.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
