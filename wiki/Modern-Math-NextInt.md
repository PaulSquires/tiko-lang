[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextInt**

# NextInt

INCLUSIVE both ends, matching FB's TO

## Syntax

```freebasic
NextInt( lo, hi )
```

## Notes

- INCLUSIVE both ends, matching FB's TO

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )
dim as longint lo = 1, hi = 6

'' INCLUSIVE at both ends, and UNBIASED -- it rejects and retries rather
'' than taking a modulus, which would favour the low end of the range
dim as longint v = r.NextInt( lo, hi )
print v >= lo andalso v <= hi             '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
