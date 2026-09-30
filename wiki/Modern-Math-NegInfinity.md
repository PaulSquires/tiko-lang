[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NegInfinity**

# NegInfinity

## Syntax

```freebasic
NegInfinity( )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

dim as double ninf = NegInfinity( )

print IsInfinite( ninf )     '' true
print IsNegative( ninf )     '' true
print ninf < -1e308          '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
