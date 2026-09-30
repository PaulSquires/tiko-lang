[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextDoubleRange**

# NextDoubleRange

A double in [lo, hi).

## Syntax

```freebasic
NextDoubleRange( byval lo as double, byval hi as double ) as double
```

## Notes

- Half-open like `NextDouble`: `lo` can come up, `hi` cannot.
- Computed as `lo + NextDouble( ) * ( hi - lo )`, so the spacing is uniform in the interval.
- A reversed pair -- `hi` below `lo` -- is the caller's mistake and is not checked.

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

dim as double v = r.NextDoubleRange( 10.0, 20.0 )
print v >= 10.0 andalso v < 20.0              '' -1 (true)

dim as long outside = 0
for i as long = 1 to 1000
    dim as double x = r.NextDoubleRange( -1.0, 1.0 )
    if x < -1.0 orelse x >= 1.0 then outside += 1
next
print outside                '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
