[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Count**

# Count

How many elements the array holds.

## Syntax

```freebasic
Count( a( ) as T ) as uint64
```

## Notes

- Present so that a statistic and its sample size come from the same place -- `ubound( a ) - lbound( a ) + 1` is the same number written three ways to get wrong.
- It is also a `RunningStats` member, where it counts what has been added so far.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as float64 a( 0 to 4 ) = { 2.0, 4.0, 4.0, 4.0, 6.0 }

print Count( a( ) )          '' 5

'' The same number, without the off-by-one arithmetic
print ubound( a ) - lbound( a ) + 1           '' 5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
