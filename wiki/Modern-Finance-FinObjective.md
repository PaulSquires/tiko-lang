[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinObjective**

# FinObjective

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Finance](Category-Finance), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
type FinObjective as function ( byval x as double, byval ctx as any ptr ) as double
```

## Examples

```freebasic
#include once "fb/finance.bi"
using FB

private function fRoot( byval x as double, byval ctx as any ptr ) as double
    return x * x - 2.0
end function

'' A function pointer plus an opaque context -- not a capturing lambda,
'' because the objective is stored in a record and called two levels
'' down, where a capture's lifetime rules are the wrong tool.
dim as FinObjective f = @fRoot

print f( 1.0, 0 )                        '' -1
print f( 2.0, 0 )                        '' 2

'' A sign change between those two brackets the root.
dim as boolean brackets = ( f( 1.0, 0 ) * f( 2.0, 0 ) < 0.0 )
print brackets                           '' true
```

---

**Library:** [Finance](Category-Finance) ✨  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `src/inc/fb/finsolve.bi` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
