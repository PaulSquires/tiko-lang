[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Pow**

# Pow

Returns one floating-point number raised to the power of another.

## Syntax

```freebasic
Pow( x, y )
```

## Notes

- The floating-point power under a name, for code that wants to say so. It is not a replacement for `^`, and whole-number powers belong to `IPow`, which is exact.
- A negative base with a fractional power is NaN.
- Overloaded on `float64` and on `float32`: a single-precision argument takes the single-precision path and does not widen.
- **BOUNDED** accuracy: correct to the platform library's stated ulp bound.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Pow( 2.0, 10.0 )       '' 1024
print Pow( 2.0, 0.5 )        '' 1.414213562373095
print Pow( -8.0, 1.0 / 3.0 ) '' -1.#IND -- use Cbrt for a cube root
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** The libm surface
