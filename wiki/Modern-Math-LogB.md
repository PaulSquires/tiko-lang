[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **LogB**

# LogB

Returns the binary exponent of a number as a floating-point value.

## Syntax

```freebasic
LogB( x )
```

## Notes

- The power of two a number lies between: `LogB( 1000.0 )` is 9 because 1000 is from 512 up to 1024.
- 0 gives minus infinity.
- `Frexp` gives the exponent together with the fraction.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.

## Examples

```freebasic
#import "std/numeric"
using numeric

print LogB( 1024.0 )         '' 10
print LogB( 1000.0 )         '' 9
print LogB( 0.75 )           '' -1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
