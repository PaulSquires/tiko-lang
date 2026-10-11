[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NaN**

# NaN

## Syntax

```freebasic
NaN( )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 n = NaN( )

print IsNaN( n )             '' true

'' It POISONS everything downstream, which is what makes it a useful
'' sentinel and a dangerous one
print IsNaN( n + 1 )         '' true
print IsNaN( n * 0 )         '' true

'' NaNF is the single-precision one
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
