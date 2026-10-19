[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextDouble**

# NextDouble

Returns a random Double from 0 up to but not including 1, with 53 random bits.

## Syntax

```freebasic
NextDouble( ) as float64
```

## Notes

- **Half-open**: 0 is possible, 1 is not. That is what makes `lo + NextDouble( ) * ( hi - lo )` never produce `hi`.
- 53 bits of randomness -- the full significand, not a scaled integer with gaps in it.
- `NextDoubleRange` is the version that takes bounds.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )

dim as float64 v = r.NextDouble( )
print v >= 0.0 andalso v < 1.0                '' -1 (true)

'' Half-open, so scaling never reaches the upper bound
dim as int32 hits = 0
for i as int32 = 1 to 1000
    if r.NextDouble( ) >= 1.0 then hits += 1
next
print hits                   '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
