[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinSolveResult**

# FinSolveResult

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
r.Root_  r.Residual_  r.Iterations_  r.Converged_  r.Bracketed_
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

private function fRoot( byval x as double, byval ctx as any ptr ) as double
    return x * x - 2.0
end function

dim as FinSolverOptions o = FinSolverOptionsWithGuess( 1.0 )
o.LowerBound_ = -1.0e6
o.UpperBound_ =  1.0e6

var r = FinSolveRoot( @fRoot, 0, o )

print r.Value( ).Root_                   '' 1.414213562373095
print r.Value( ).Converged_              '' true

'' Bracketed_ is false when the Newton fast path alone got there -- the
'' answer never depends on which path was taken, only the cost does.
print r.Value( ).Bracketed_              '' false
print ( abs( r.Value( ).Residual_ ) <= 1.0e-12 )   '' -1 (an integer comparison)
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finsolve.bi` in the tiko-lang repository.
