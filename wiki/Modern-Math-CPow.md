[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CPow**

# CPow

Raises a complex number to a complex or real power.

## Syntax

```freebasic
CPow( byref z as Complex, byref w as Complex ) as Complex
CPow( byref z as Complex, byval p as double  ) as Complex
CPow( byval x as double,  byref w as Complex ) as Complex
```

## Notes

- The `^` operator resolves to this in all three arrangements.
- **Two answers here are .NET's and are wrong, and they are pinned by a test rather than quietly corrected.** `CPow( 0, 0 )` is `1` — the zero-exponent test comes first — and `CPow( 0, w )` is `0` for **every** other `w`, including negative `w`, where the true answer is infinite. Kept for source compatibility with both of this header's sources; changing it should be a deliberate act.
- For a non-zero base it is `exp( w · log z )` evaluated in polar form, so it inherits `CLog`'s branch cut.
- `CPow( z, 0.5 )` and `CSqrt( z )` agree; `CSqrt` is the more accurate of the two.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

print CToString( CPow( CSet( 3, 4 ), 2.0 ) )        '' -6.999999999999998+24.000000000000004i
print CToString( CSet( 3, 4 ) ^ 2.0 )               '' -6.999999999999998+24.000000000000004i   -- the operator agrees
print CToString( E ^ CSet( 0, PI ) )                '' -1+1.2246063538223773e-016i   -- Euler again, through the operator
print CToString( CPow( CZero( ), CSet( -1, 0 ) ) )  '' 0+0i   -- pinned: .NET's answer, and wrong
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
