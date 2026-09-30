[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **EuclidMod**

# EuclidMod

## Syntax

```freebasic
EuclidMod(-7,-3)
```

## Examples

```freebasic
#import "std/numeric"
using FB

'' The remainder that is ALWAYS NON-NEGATIVE, whatever the signs
dim as int32 a = -1, b = 5
print EuclidMod( a, b )      '' 4

dim as int32 c = -1, d = -5
print EuclidMod( c, d )      '' 4 -- still non-negative
print FloorMod( c, d )       '' -1 -- follows the divisor's sign instead
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
