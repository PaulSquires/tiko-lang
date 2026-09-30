[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSet**

# CSet

Builds a complex number from its real and imaginary parts.

## Syntax

```freebasic
CSet( byval re as float64, byval im as float64 ) as Complex
```

## Notes

- The documented way to construct one. `type<Complex>( 3, 4 )` produces the same value and is not wrong, but it names the layout rather than the meaning.
- AfxNova spelled this `CSet` and `CRect`, which were the same function twice; only `CSet` survives here.

## Examples

```freebasic
#import "std/numeric"
using FB

print CToString( CSet( 3, 4 ) )    '' 3+4i
print CToString( CSet( 0, -1 ) )   '' 0-1i
print CToString( CSet( 2.5, 0 ) )  '' 2.5+0i   -- a real number is still a Complex
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
