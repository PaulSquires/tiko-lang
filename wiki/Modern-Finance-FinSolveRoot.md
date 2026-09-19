[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinSolveRoot**

# FinSolveRoot

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
FinSolveRoot( objective, ctx, options )
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

private function fRoot( byval x as double, byval ctx as any ptr ) as double
    return x * x - 2.0
end function

'' One root finder, used by every implied rate in the module.  Newton is
'' a FAST PATH only -- abandoned the moment an iterate leaves the bounds
'' or fails to reduce |f| -- and then a bracket plus Brent, which given a
'' bracket cannot fail to converge.
dim as FinSolverOptions o = FinSolverOptionsWithGuess( 1.0 )
o.LowerBound_ = -1.0e6
o.UpperBound_ =  1.0e6

var r = FinSolveRoot( @fRoot, 0, o )
print r.IsOk( )                          '' true
print r.Value( ).Root_                   '' 1.414213562373095

'' No sign change anywhere in range is FIN_NO_BRACKET, and the error
'' still carries the closest approach it managed.
dim as FinSolverOptions tight = FinSolverOptionsWithGuess( 1.0 )
tight.LowerBound_ = 5.0
tight.UpperBound_ = 9.0
var miss = FinSolveRoot( @fRoot, 0, tight )
print miss.IsOk( )                       '' false
print miss.Failure( ).Message( )         '' could not bracket a root
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finsolve.bi` in the tiko-lang repository.
