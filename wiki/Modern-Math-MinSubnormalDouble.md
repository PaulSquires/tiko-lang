[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MinSubnormalDouble**

# MinSubnormalDouble

## Syntax

```freebasic
MinSubnormalDouble( )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 m = MinSubnormalDouble( )

'' The SMALLEST NON-ZERO double there is -- one bit of significand left
print m > 0                  '' -1 (true)
print IsSubnormal( m )       '' true

'' Halving it underflows to zero, which is where the number line stops
print m / 2 = 0              '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
