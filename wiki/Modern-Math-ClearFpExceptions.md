[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **ClearFpExceptions**

# ClearFpExceptions

## Syntax

```freebasic
ClearFpExceptions( )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' Clears every sticky flag at once. They ACCUMULATE until cleared, so
'' the sequence is always: clear, compute, test.
ClearFpExceptions( )
print TestFpException( FP_DIVBYZERO )     '' false

dim as float64 z = 0.0
dim as float64 r = 1.0 / z
print TestFpException( FP_DIVBYZERO )     '' true
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
