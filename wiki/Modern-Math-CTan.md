[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CTan**

# CTan

The tangent.

## Syntax

```freebasic
CTan( byref z as Complex ) as Complex
```

## Notes

- **The stabilised form, from .NET.** `CSin( z ) / CCos( z )` is `inf/inf` — that is, NaN — for an imaginary part above about 710, because `cosh` overflows there while the tangent itself is heading calmly for ±i. This uses the double-angle identity, and above `|im| = 4` divides through by `cosh` so that neither operand can overflow.
- **Both axes are answered directly**, which is both exact and correct about the sign of a zero: `CTan( 1 - 0i )` is `tan(1) - 0i`, and the general path gives the last digit of `tan(1)` wrong and the zero the wrong sign.
- Spelled with the `C` prefix because a function of the unprefixed name in namespace `FB` would shadow the FreeBASIC intrinsic for every later header — measured, it broke `fb/random.bi` — after which the intrinsic cannot be called back.

## Examples

```freebasic
#include once "fb/complex.bi"
using FB

dim as Complex z = CSet( 3, 4 )

print CToString( CTan( z ) )                                     '' -0.00018734620462947842+0.9993559873814732i
print CToString( CTan( CSet( 1, 750 ) ) )                        '' 0+1i   -- still finite -- heading for i
print CIsNaN( CSin( CSet( 1, 750 ) ) / CCos( CSet( 1, 750 ) ) )  '' true   -- the naive route, for comparison
print CToString( CTan( CSet( 1, 0 ) ) )                          '' 1.5574077246549023+0i   -- exactly the real tangent
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
