[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextBoolean**

# NextBoolean

TRUE or FALSE with equal probability.

## Syntax

```freebasic
NextBoolean( ) as boolean
```

## Notes

- One bit of the generator, not a comparison against 0.5 -- so it costs nothing extra and cannot be skewed by floating point.
- `NextBooleanP` is the weighted version.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )

dim as int32 hits = 0
for i as int32 = 1 to 1000
    if r.NextBoolean( ) then hits += 1
next

print hits > 400 andalso hits < 600           '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
