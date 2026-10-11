[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Frexp**

# Frexp

Splits a value into a fraction in [0.5, 1) and a power of two.

## Syntax

```freebasic
Frexp( byval x as float64, byref expo as int32 ) as float64
```

## Notes

- Returns the fraction and writes the exponent through `expo`, so `fraction * 2 ^ expo` reconstructs the input **exactly**.
- The pair to `ScaleB`, which puts it back together.
- Zero gives a fraction of 0 and an exponent of 0.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as int32 e
dim as float64 f = Frexp( 1024.0, e )

print f                      '' 0.5
print e                      '' 11

'' It round-trips exactly through ScaleB
print ScaleB( f, e )         '' 1024
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
