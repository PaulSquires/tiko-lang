[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Modf**

# Modf

Splits a value into its integer and fractional parts.

## Syntax

```freebasic
Modf( byval x as float64, byref ipart as float64 ) as float64
```

## Notes

- Returns the fraction and writes the integer part through `ipart`. **Both keep the sign of the input**, which is what makes the two parts add back to it.
- That sign rule is the difference from `Floor`: `Modf( -2.5 )` gives -2 and -0.5, not -3 and 0.5.
- The integer part comes back as a `float64`, so it is exact for any magnitude the type can hold.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as float64 ip
print Modf( 2.75, ip )       '' 0.75
print ip                     '' 2

'' BOTH parts keep the sign, so they add back to the input
print Modf( -2.5, ip )       '' -0.5
print ip                     '' -2
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
