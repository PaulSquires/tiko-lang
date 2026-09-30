[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSqrt**

# CSqrt

The principal square root.

## Syntax

```freebasic
CSqrt( byref z as Complex ) as Complex
CSqrt( byval x as float64 ) as Complex
```

## Notes

- **The principal root, always in the right half plane** — the real part is never negative.
- **This is the .NET Core 3.0 algorithm, not the polar form.** `fb/vector.bi` and AfxNova both shipped `FromPolar( sqr(|z|), Arg(z)/2 )`, which is .NET Framework 4.7's and loses most of its significant digits near the negative real axis, where `Arg` is the difference of two nearly-equal quantities.
- **The cut is the negative real axis and the sign of a zero imaginary part decides the side**: `CSqrt( -4 + 0i )` is `+2i` and `CSqrt( -4 - 0i )` is `-2i`. Both source libraries test `imaginary == 0` and return the positive root for both, which puts half the axis on the wrong branch.
- The `float64` overload is the square root of a real that may be negative — AfxNova's `CSqrReal`, expressed as an overload because it is the same concept with a different argument type.
- Operands near the type maximum take a rescale-by-¼ path, so `CSqrt` of `1e308 + 1e308i` is finite.

## Examples

```freebasic
#import "std/numeric"
using FB

print CToString( CSqrt( CSet( 3, 4 ) ) )          '' 2+1i   -- exact: (2+i)^2 = 3+4i
print CToString( CSqrt( -1.0 ) )                  '' 0+1i   -- the double overload
print CToString( CSqrt( CSet( -4, 0.0 ) ) )       '' 0+2i   -- above the cut
print CToString( CSqrt( CSet( -4, -0.0 ) ) )      '' 0-2i   -- below it
print CIsFinite( CSqrt( CSet( 1e308, 1e308 ) ) )  '' true   -- the rescale path
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
