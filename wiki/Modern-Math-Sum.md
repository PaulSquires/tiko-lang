[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Sum**

# Sum

compensated -- Neumaier

## Syntax

```freebasic
Sum( a( ) )
```

## Notes

- compensated -- Neumaier

## Examples

```freebasic
#import "std/numeric"
using numeric

'' COMPENSATED summation (Neumaier), so the running error is tracked and
'' folded back in rather than accumulating
dim as float64 a( 0 to 3 ) = { 1e16, 1.0, -1e16, 1.0 }

print Sum( a( ) )            '' 2 -- both 1.0s survive
print NaiveSum( a( ) )       '' 1 -- the naive loop lost one of them

'' The difference is not a rounding detail: half the answer is missing
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
