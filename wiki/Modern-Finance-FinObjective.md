[Home](Home) › [Finance](Category-Finance) › [Finance](Category-Finance) › **FinObjective**

# FinObjective

## Syntax

```freebasic
type FinObjective as function ( byval x as float64, byval ctx as any ptr ) as float64
```

## Examples

```freebasic
#import "std/money"
using money

private function fRoot( byval x as float64, byval ctx as any ptr ) as float64
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

**Library:** [Finance](Category-Finance)  
**Category:** [Finance](Category-Finance)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `pkg/std/money/finsolve.tiko` in the [tiko repository](https://github.com/PaulSquires/tiko-lang).
