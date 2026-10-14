[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextDoubleRange**

# NextDoubleRange

A double in [lo, hi).

## Syntax

```freebasic
NextDoubleRange( byval lo as float64, byval hi as float64 ) as float64
```

## Notes

- Half-open like `NextDouble`: `lo` can come up, `hi` cannot.
- Computed as `lo + NextDouble( ) * ( hi - lo )`, so the spacing is uniform in the interval.
- A reversed pair -- `hi` below `lo` -- is the caller's mistake and is not checked.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )

dim as float64 v = r.NextDoubleRange( 10.0, 20.0 )
print v >= 10.0 andalso v < 20.0              '' -1 (true)

dim as int32 outside = 0
for i as int32 = 1 to 1000
    dim as float64 x = r.NextDoubleRange( -1.0, 1.0 )
    if x < -1.0 orelse x >= 1.0 then outside += 1
next
print outside                '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
