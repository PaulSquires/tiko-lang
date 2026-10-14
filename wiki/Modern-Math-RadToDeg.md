[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **RadToDeg**

# RadToDeg

Converts radians to degrees.

## Syntax

```freebasic
RadToDeg( byval x as float64 ) as float64
```

## Notes

- The inverse of `DegToRad`, using the same full-precision constant.
- For presenting an angle, not for computing with one -- the trigonometric functions all take radians.
- Overloaded on `float64` and `float32`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print RadToDeg( 3.141592653589793 )           '' 180
print RadToDeg( 1.570796326794897 )           '' 90

print DegToRad( RadToDeg( 1.0 ) )             '' 1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
