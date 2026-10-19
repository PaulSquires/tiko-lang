[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Log1p**

# Log1p

Returns the natural logarithm of one plus a number, accurately near zero.

## Syntax

```freebasic
Log1p( x )
```

## Notes

- For a tiny `x`, `1.0 + x` rounds to 1 before the logarithm sees it. `Log1p` never forms that sum.
- `Expm1` is its inverse; -1 gives minus infinity.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Log1p( 1e-17 )         '' 1e-017
print log( 1.0 + 1e-17 )     '' 0 -- the 1.0 swallowed it
print Log1p( -1.0 )          '' -1.#INF
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
