[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsNormal**

# IsNormal

## Syntax

```freebasic
IsNormal( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print IsNormal( 1.0 )         '' true
print IsNormal( 0.0 )         '' false -- zero is not normal
print IsNormal( MinSubnormalDouble( ) )       '' false
print IsNormal( NaN( ) )      '' false

'' Normal means full precision: finite, non-zero, and not subnormal
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
