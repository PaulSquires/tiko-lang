[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CConj**

# CConj

The conjugate — the imaginary part negated.

## Syntax

```freebasic
CConj( byref z as Complex ) as Complex
```

## Notes

- `z * CConj( z )` is real and equals `CNorm( z )`. That is the identity the conjugate is for, and it is how a complex division is derived.
- `CConj( CConj( z ) )` is `z`, exactly — the operation is its own inverse and involves no arithmetic.
- AfxNova spelled this `CConj` and `CConjugate`. `Conjugate` in `fb/vector.bi` now applies only to quaternions.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as Complex z = CSet( 3, 4 )

print CToString( CConj( z ) )           '' 3-4i
print CToString( z * CConj( z ) )       '' 25+0i   -- real, and equal to CNorm( z )
print CToString( CConj( CConj( z ) ) )  '' 3+4i   -- its own inverse
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
