[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSinh**

# CSinh

The hyperbolic sine.

## Syntax

```freebasic
CSinh( byref z as Complex ) as Complex
```

## Notes

- `sinh(re)·cos(im) + i·cosh(re)·sin(im)`, written out on libm's `Sinh` and `Cosh` from `fb/math.bi`.
- **Not routed through `CSin`**, although `sinh z = -i·sin( iz )` is exact: the rotation arrives with the signed zeros negated on the real axis, and the sign of a zero is what decides a branch cut.
- `CCosh² - CSinh² = 1` holds to within rounding for every operand.
- Spelled with the `C` prefix because a function of the unprefixed name in namespace `FB` would shadow the FreeBASIC intrinsic for every later header — measured, it broke `fb/random.bi` — after which the intrinsic cannot be called back.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as Complex z = CSet( 3, 4 )

print CToString( CSinh( CZero( ) ) )  '' 0+0i   -- exactly zero
print CToString( CSinh( z ) )         '' -6.5481200409110025-7.61923172032141i
print CToString( CSinh( -z ) )        '' 6.5481200409110025+7.61923172032141i   -- odd
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
