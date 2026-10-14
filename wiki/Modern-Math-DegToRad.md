[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **DegToRad**

# DegToRad

Converts degrees to radians.

## Syntax

```freebasic
DegToRad( byval x as float64 ) as float64
```

## Notes

- Multiplies by pi/180 using the full-precision constant, rather than a literal a caller typed from memory.
- Every trigonometric function here takes radians, so this is the conversion at the boundary with a user interface or a file format that uses degrees.
- Overloaded on `float64` and `float32`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print DegToRad( 180.0 )      '' 3.141592653589793
print DegToRad( 90.0 )       '' 1.570796326794897

'' Round-trips with RadToDeg
print RadToDeg( DegToRad( 45.0 ) )            '' 45
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
