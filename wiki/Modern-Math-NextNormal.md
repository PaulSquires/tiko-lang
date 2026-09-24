[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextNormal**

# NextNormal

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A draw from the standard normal distribution: mean 0, standard deviation 1.

## Syntax

```freebasic
NextNormal( ) as double
```

## Notes

- Gaussian, so values far from 0 are rare but **unbounded** -- there is no maximum, and a loop that assumes one will eventually be surprised.
- `NextNormalP` is the version that takes a mean and a standard deviation.
- About 68% of draws fall within 1 of the mean and 95% within 2, which is the cheapest way to sanity-check that it is working.

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

dim as double total = 0
dim as long within = 0
for i as long = 1 to 2000
    dim as double v = r.NextNormal( )
    total += v
    if abs( v ) <= 1.0 then within += 1
next

print abs( total / 2000 ) < 0.2               '' -1 (true) -- mean near 0
print within > 1200 andalso within < 1500     '' -1 (true) -- about 68%
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
