[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Sum**

# Sum

Adds up an array with compensated summation, so small values are not lost.

## Syntax

```freebasic
Sum( byref a as Array( of T ) ) as float64
```

## Notes

- compensated -- Neumaier

## Examples

```freebasic
#import "std/numeric"
#import "std/containers"
using numeric
using containers

'' COMPENSATED summation (Neumaier), so the running error is tracked and
'' folded back in rather than accumulating
dim as Array( of float64 ) a = { 1e16, 1.0, -1e16, 1.0 }

print Sum( a )            '' 2 -- both 1.0s survive
print NaiveSum( a )       '' 1 -- the naive loop lost one of them

'' The difference is not a rounding detail: half the answer is missing
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
