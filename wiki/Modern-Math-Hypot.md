[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Hypot**

# Hypot

The length of the hypotenuse, sqrt(x*x + y*y), without intermediate overflow.

## Syntax

```freebasic
Hypot( x, y )
```

## Notes

- Delegates to libm's `hypot`, which is required not to overflow for a representable result.
- `Sqr( x*x + y*y )` overflows at about 1.3e154 for a double, which is why the hand-rolled version is wrong at the extremes: `Hypot( 1e200, 1e200 )` is finite where `sqr( 1e200*1e200 + 1e200*1e200 )` is +inf.
- Overloaded on `float64` and on `float32`, so a single-precision call does not silently widen and narrow.
- **BOUNDED** accuracy: correct to a stated ulp bound, with the platform libm as the dependency.

## Examples

```freebasic
#import "std/numeric"
using numeric

print Hypot( 3.0, 4.0 )      '' 5

'' It does NOT overflow for a representable result: sqr( x*x + y*y )
'' overflows at about 1.3e154 for a double, which is why the
'' hand-rolled version is wrong at the extremes
print Hypot( 1e200, 1e200 )  '' 1.414213562373095e+200
print sqr( 1e200*1e200 + 1e200*1e200 )        '' 1.#INF
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
