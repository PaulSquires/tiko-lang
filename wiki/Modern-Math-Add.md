[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Add**

# Add

Adds one value to a running accumulator.

## Syntax

```freebasic
RunningStats.Add( byval x as float64 )
```

## Notes

- `RunningStats` computes mean, variance and extremes in **one pass and constant memory**, so a stream that does not fit in an array can still be summarised.
- It uses Welford's method, which is numerically stable -- the naive sum-of-squares formula loses catastrophically when the mean is large relative to the spread.
- `Merge` combines two accumulators, which is what makes it parallelisable.

## Examples

```freebasic
#import "std/numeric"
using FB

dim rs as RunningStats

for i as int32 = 1 to 5
    rs.Add( i )
next

print rs.Count( )            '' 5
print rs.Mean( )             '' 3
print rs.MinValue( )         '' 1
print rs.MaxValue( )         '' 5

'' Constant memory: the values themselves are never stored
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
