[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **ClearFpException**

# ClearFpException

## Syntax

```freebasic
ClearFpException( e )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' Clears ONE flag, leaving the others alone -- for code that cares
'' about a single condition inside a larger computation
ClearFpExceptions( )

dim as float64 z = 0.0
dim as float64 r = 1.0 / z
print TestFpException( FP_DIVBYZERO )     '' true

ClearFpException( FP_DIVBYZERO )
print TestFpException( FP_DIVBYZERO )     '' false
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
