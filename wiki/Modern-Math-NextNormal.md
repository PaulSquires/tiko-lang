[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextNormal**

# NextNormal

A draw from the standard normal distribution: mean 0, standard deviation 1.

## Syntax

```freebasic
NextNormal( ) as float64
```

## Notes

- Gaussian, so values far from 0 are rare but **unbounded** -- there is no maximum, and a loop that assumes one will eventually be surprised.
- `NextNormalP` is the version that takes a mean and a standard deviation.
- About 68% of draws fall within 1 of the mean and 95% within 2, which is the cheapest way to sanity-check that it is working.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )

dim as float64 total = 0
dim as int32 within = 0
for i as int32 = 1 to 2000
    dim as float64 v = r.NextNormal( )
    total += v
    if abs( v ) <= 1.0 then within += 1
next

print abs( total / 2000 ) < 0.2               '' -1 (true) -- mean near 0
print within > 1200 andalso within < 1500     '' -1 (true) -- about 68%
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
