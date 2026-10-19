[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextPoisson**

# NextPoisson

Returns a random count of events in one interval at rate lambda; its mean is lambda.

## Syntax

```freebasic
NextPoisson( lambda )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )

'' How many events arrive in one interval at rate lambda. Its mean IS
'' lambda, and it is a count, so it never comes back negative.
dim as int64 total = 0
for i as int32 = 1 to 2000
    total += r.NextPoisson( 4.0 )
next
dim as float64 mean_ = total / 2000

print mean_ > 3.5 andalso mean_ < 4.5     '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
