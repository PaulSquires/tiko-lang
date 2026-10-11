[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CToStringPolar**

# CToStringPolar

The text form in polar coordinates.

## Syntax

```freebasic
CToStringPolar( byref z as Complex ) as string
```

## Notes

- Modulus, then the phase inside an exponential — `r * exp(θi)`. Unambiguous and ASCII, which an angle sign would not be.
- Both numbers go through `ToString`, so both round-trip.
- AfxNova's `CStrPolar`, with the same format.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToStringPolar( CSet( 3, 4 ) )     '' 5 * exp(0.9272952180016122i)
print CToStringPolar( CSet( -1, 0.0 ) )  '' 1 * exp(3.141592653589793i)
print CToStringPolar( COne( ) )          '' 1 * exp(0i)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
