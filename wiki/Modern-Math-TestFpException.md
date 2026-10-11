[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TestFpException**

# TestFpException

## Syntax

```freebasic
TestFpException( e )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' The flags are STICKY: once raised they stay raised until cleared, so
'' a test after a long computation says "this happened at some point",
'' not "this just happened"
ClearFpExceptions( )
print TestFpException( FP_OVERFLOW )      '' false

dim as float64 big = 1e308
dim as float64 r = big * 10
print TestFpException( FP_OVERFLOW )      '' true
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
