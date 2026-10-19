[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Log2**

# Log2

Returns the base-2 logarithm of a number.

## Syntax

```freebasic
Log2( x )
```

## Notes

- Exact for a power of two.
- 0 gives minus infinity and a negative number gives NaN.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Log2( 1024.0 )         '' 10
print Log2( 3.0 )            '' 1.584962500721156
print Log2( 0.0 )            '' -1.#INF
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
