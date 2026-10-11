[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CCos**

# CCos

The cosine.

## Syntax

```freebasic
CCos( byref z as Complex ) as Complex
```

## Notes

- `cos(re)·cosh(im) - i·sin(re)·sinh(im)`, written out directly.
- Even: `CCos( -z )` is `CCos( z )`.
- Overflows for a large imaginary part, like `CSin` and for the same reason.
- Spelled with the `C` prefix because, when this library was a header in namespace `FB`, a function of the unprefixed name shadowed the FreeBASIC intrinsic for every later header — measured, it broke what is now `random.tiko` — after which the intrinsic could not be called back. The name stayed when the header became `std/numeric`.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )

print CToString( CCos( CZero( ) ) )  '' 1-0i   -- exactly one
print CToString( CCos( z ) )         '' -27.034945603074224-3.8511533348117775i
print CToString( CCos( -z ) )        '' -27.034945603074224-3.8511533348117775i   -- even
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
