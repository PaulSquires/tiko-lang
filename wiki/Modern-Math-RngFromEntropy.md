[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **RngFromEntropy**

# RngFromEntropy

## Syntax

```freebasic
RngFromEntropy( )
```

## Examples

```freebasic
#include once "fb/random.bi"
using FB

'' A generator seeded from the OS entropy source, so two runs differ.
'' Rng( seed ) is the reproducible alternative.
dim r as Rng = RngFromEntropy( )

dim as longint lo = 1, hi = 6
dim as longint roll = r.NextInt( lo, hi )
print roll >= 1 andalso roll <= 6         '' -1 (true)

'' Seed it explicitly when a test has to be reproducible
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
