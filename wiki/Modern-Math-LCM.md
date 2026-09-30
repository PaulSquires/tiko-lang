[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **LCM**

# LCM

## Syntax

```freebasic
LCM( a, b )
```

## Examples

```freebasic
#include once "fb/mathint.bi"
using FB

dim as long a = 4, b = 6
print LCM( a, b )            '' 12

'' LCM with zero is zero -- the absorbing element, matching the maths
dim as long z = 0
print LCM( a, z )            '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
