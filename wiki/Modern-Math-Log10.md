[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Log10**

# Log10

Returns the base-10 logarithm of a number.

## Syntax

```freebasic
Log10( x )
```

## Notes

- Exact for a power of ten, which `log( x ) / log( 10 )` is not always.
- 0 gives minus infinity and a negative number gives NaN.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Log10( 1000.0 )        '' 3
print Log10( 2.0 )           '' 0.3010299956639812
print Log10( 0.001 )         '' -3

'' The ratio of natural logs is not exactly 3
print log( 1000.0 ) / log( 10.0 ) = 3.0   '' 0 (false)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
