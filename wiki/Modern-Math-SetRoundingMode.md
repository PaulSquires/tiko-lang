[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **SetRoundingMode**

# SetRoundingMode

## Syntax

```freebasic
SetRoundingMode( m )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' PROCESS-WIDE AND STICKY: it changes every later floating-point
'' operation in the program, not just the next one. Put it back.
dim as int32 was = GetRoundingMode( )

print SetRoundingMode( ROUND_TOWARD_ZERO )       '' true
print GetRoundingMode( ) = ROUND_TOWARD_ZERO     '' -1 (true)

SetRoundingMode( was )
print GetRoundingMode( ) = was                   '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
