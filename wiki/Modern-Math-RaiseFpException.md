[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **RaiseFpException**

# RaiseFpException

## Syntax

```freebasic
RaiseFpException( e )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' Raises a flag by hand, so a routine can report a condition through
'' the same channel the hardware uses
ClearFpExceptions( )
print RaiseFpException( FP_INVALID )      '' true

print TestFpException( FP_INVALID )       '' true
ClearFpExceptions( )
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
