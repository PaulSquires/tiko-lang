[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CExp**

# CExp

Returns e raised to a complex power.

## Syntax

```freebasic
CExp( byref z as Complex ) as Complex
```

## Notes

- `exp( re )` scaled by `cos( im )` and `sin( im )` — that is, a rotation by the imaginary part and a scale by the real one.
- **On the real axis the answer is exactly real.** Going through `cos`/`sin` would leave rounding dust in the imaginary part where zero belongs, so that case is answered directly.
- Euler's identity holds: `CExp( i·π )` is `-1`.
- Spelled with the `C` prefix because, when this library was a header in namespace `FB`, `Exp` there shadowed the intrinsic for every later header — measured, it broke what is now `random.tiko`. The name stayed when the header became `std/numeric`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CExp( CZero( ) ) )       '' 1+0i
print CToString( CExp( CSet( 1, 0 ) ) )   '' 2.718281828459045+0i   -- exactly real
print CToString( CExp( CSet( 0, PI ) ) )  '' -1+1.2246063538223773e-016i   -- Euler, to within rounding
print CToString( CExp( CSet( 3, 4 ) ) )   '' -13.128783081462158-15.200784463067954i
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
