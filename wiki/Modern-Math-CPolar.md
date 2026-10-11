[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CPolar**

# CPolar

Builds a complex number from a modulus and a phase.

## Syntax

```freebasic
CPolar( byval r as float64, byval theta as float64 ) as Complex
```

## Notes

- The inverse of `CAbs` and `CArg` taken together: `CPolar( CAbs( z ), CArg( z ) )` reproduces `z`.
- `theta` is in **radians**, measured anticlockwise from the positive real axis.
- A zero modulus collapses to the origin whatever the angle.
- AfxNova spelled this both `CPolar` and `CFromPolarCoordinates`; .NET calls it `FromPolarCoordinates`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CPolar( 2.0, 0.0 ) )                   '' 2+0i   -- theta = 0 is the positive real axis
print CToString( CPolar( 5.0, CArg( CSet( 3, 4 ) ) ) )  '' 3.0000000000000004+3.9999999999999996i   -- back to 3+4i, near enough
print CAbs( CPolar( 1.5, 2.0 ) )                        '' 1.5   -- the modulus survives any angle
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
