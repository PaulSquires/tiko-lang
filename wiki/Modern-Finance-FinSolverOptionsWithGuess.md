[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinSolverOptionsWithGuess**

# FinSolverOptionsWithGuess

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

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

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finsolve.bi` in the tiko-lang repository.
