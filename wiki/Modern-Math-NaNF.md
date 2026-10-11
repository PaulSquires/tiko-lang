[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NaNF**

# NaNF

## Syntax

```freebasic
NaNF( )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float32 n = NaNF( )

print IsNaN( n )             '' true

'' The single-precision NaN. Kept separate from NaN( ) so that a single
'' expression does not silently widen to double and back.
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
