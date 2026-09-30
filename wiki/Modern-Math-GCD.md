[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **GCD**

# GCD

## Syntax

```freebasic
GCD( a, b )
```

## Examples

```freebasic
#import "std/numeric"
using FB

dim as int32 a = 12, b = 18
print GCD( a, b )            '' 6

'' GCD with zero is the other operand, which is the identity that makes
'' a fold over a list work with no special first case
dim as int32 z = 0
print GCD( a, z )            '' 12
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
