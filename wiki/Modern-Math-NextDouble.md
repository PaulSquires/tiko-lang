[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextDouble**

# NextDouble

A double in [0, 1).

## Syntax

```freebasic
NextDouble( ) as double
```

## Notes

- **Half-open**: 0 is possible, 1 is not. That is what makes `lo + NextDouble( ) * ( hi - lo )` never produce `hi`.
- 53 bits of randomness -- the full significand, not a scaled integer with gaps in it.
- `NextDoubleRange` is the version that takes bounds.

## Examples

```freebasic
#include once "fb/random.bi"
using FB

dim r as Rng = RngFromEntropy( )

dim as double v = r.NextDouble( )
print v >= 0.0 andalso v < 1.0                '' -1 (true)

'' Half-open, so scaling never reaches the upper bound
dim as long hits = 0
for i as long = 1 to 1000
    if r.NextDouble( ) >= 1.0 then hits += 1
next
print hits                   '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
