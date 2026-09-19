[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MinSubnormalDouble**

# MinSubnormalDouble

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
MinSubnormalDouble( )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

dim as double m = MinSubnormalDouble( )

'' The SMALLEST NON-ZERO double there is -- one bit of significand left
print m > 0                  '' -1 (true)
print IsSubnormal( m )       '' true

'' Halving it underflows to zero, which is where the number line stops
print m / 2 = 0              '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
