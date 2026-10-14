[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **GetRoundingMode**

# GetRoundingMode

## Syntax

```freebasic
GetRoundingMode( )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' The FPU's current rounding direction. TO NEAREST by default, which
'' is why RoundHalfEven agrees with the hardware and Round does not.
print GetRoundingMode( ) = ROUND_TO_NEAREST      '' -1 (true)

'' The names are ROUND_*, not the C FE_* spellings -- ROUND_TO_NEAREST,
'' ROUND_TOWARD_NEGATIVE, ROUND_TOWARD_POSITIVE, ROUND_TOWARD_ZERO
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
