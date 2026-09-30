[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **FloorMod**

# FloorMod

## Syntax

```freebasic
FloorMod(-7,3)
```

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

'' The remainder with the SIGN OF THE DIVISOR, which is what a wrapping
'' index wants -- unlike MOD, which follows the dividend
dim as long a = -1, b = 5
print FloorMod( a, b )       '' 4
print a mod b                '' -1 -- the built-in, for comparison

'' Which makes it the right one for "wrap this index into range"
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
