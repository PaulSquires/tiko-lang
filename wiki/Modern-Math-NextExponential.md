[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextExponential**

# NextExponential

## Syntax

```freebasic
NextExponential( lambda )
```

## Examples

```freebasic
#import "std/numeric"
using FB

dim r as Rng = RngFromEntropy( )

'' The waiting time between events arriving at rate lambda. Its mean is
'' 1/lambda, so a bigger lambda gives shorter gaps.
dim as float64 total = 0
for i as int32 = 1 to 2000
    total += r.NextExponential( 2.0 )
next
dim as float64 mean_ = total / 2000

print mean_ > 0.35 andalso mean_ < 0.65   '' -1 (true), around 0.5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
