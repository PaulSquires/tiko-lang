[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Complex operators**

# Complex operators

Arithmetic on complex numbers: `= <> + - * / ^`, each with a `float64` on either side.

## Syntax

```freebasic
operator +  ( byref a as Complex, byref b as Complex ) as Complex
operator +  ( byref z as Complex, byval x as float64 ) as Complex
operator +  ( byval x as float64,  byref z as Complex ) as Complex
''  - * / ^ likewise, and unary -
operator =  ( byref a as Complex, byref b as Complex ) as boolean
operator =  ( byref z as Complex, byval x as float64 ) as boolean
operator =  ( byval x as float64,  byref z as Complex ) as boolean
''  <> likewise, in all three arrangements
```

## Notes

- **Every operator has all three arrangements** — `Complex` with `Complex`, `float64` with `Complex`, `Complex` with `float64`. That is why there is no `CAddReal`/`CMulImag` family: `z + 3.0` and `z * 2.0` already say it, and better.
- **Division uses Smith's formula**, in all three overloads. The naive `(ac+bd)/(c²+d²)` overflows its denominator once the components pass about `1.3e154`, where the true quotient is an ordinary number.
- **Multiplication is the plain four-multiply form**, matching .NET. C99's infinity-recovery path is deliberately not implemented — it costs a branch on every multiply for a case that only arises in deliberate infinity arithmetic.
- **`^` is `CPow`.** `z ^ 2.0`, `z ^ w` and `2.0 ^ z` all resolve to it.
- **`z = 3.0` means equal to the real number *and* on the real axis** — the imaginary part must be exactly zero. Either sign of zero counts, because `-0.0 = 0.0` as numbers.
- **No `<` `>` `<=` `>=`.** There is no ordering on ℂ. The same reasoning declined lexicographic ordering on tuples.
- Two global UDT operators do not chain through a temporary in fbc — `( a / b ) * b` is *error 3, Expected End-of-Line*. Split it across two locals.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as Complex a = CSet( 3, 4 ), b = CSet( -1, 2 )

print CToString( a + b )    '' 2+6i
print CToString( a * b )    '' -11+2i
print CToString( a / b )    '' 1-2i
print CToString( a + 2.0 )  '' 5+4i   -- the mixed form
print CToString( 2.0 - a )  '' -1-4i
print CToString( a ^ 2.0 )  '' -6.999999999999998+24.000000000000004i
print a = CSet( 3, 4 )      '' true
print a <> b                '' true
print CSet( 3, 0 ) = 3.0    '' true   -- on the real axis, and equal
print CSet( 3, 1 ) = 3.0    '' false   -- equal real part, but not on the axis
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
