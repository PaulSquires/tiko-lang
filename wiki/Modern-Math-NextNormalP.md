[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NextNormalP**

# NextNormalP

## Syntax

```freebasic
NextNormalP( mean, sd )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim r as Rng = RngFromEntropy( )

'' Gaussian with a given mean and standard deviation
dim as float64 total = 0
for i as int32 = 1 to 2000
    total += r.NextNormalP( 100.0, 15.0 )
next
dim as float64 mean_ = total / 2000

print mean_ > 95 andalso mean_ < 105      '' -1 (true)

'' NextNormal( ) is the standard one -- mean 0, sd 1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
