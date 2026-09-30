[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Conjugate**

# Conjugate

The conjugate of a quaternion.

## Syntax

```freebasic
Conjugate( byref a as Quat ) as Quat
```

## Notes

- For a **normalised** quaternion the conjugate is the inverse rotation, which is why an inverse transform costs three negations rather than a matrix inversion.
- **For a complex number this is [CConj](Modern-Math-CConj) in `fb/complex.bi`**, not this function. Complex numbers left `fb/vector.bi` when that header got its own; `Conjugate` here applies only to quaternions.
- It is not the inverse for a quaternion that is not normalised.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as Quat q = type<Quat>( 0, 0, 0, 1 )      '' identity rotation
dim as Quat c = Conjugate( q )
print c.w                    '' 1

'' Not related: the complex conjugate lives in the other header
'' #include once "fb/complex.bi"
'' print CToString( CConj( CSet( 3, 4 ) ) )   '' 3-4i
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
