[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CTanh**

# CTanh

The hyperbolic tangent.

## Syntax

```freebasic
CTanh( byref z as Complex ) as Complex
```

## Notes

- **Routed through `CTan`** — `tanh z = -i·tan( iz )` — precisely so that it inherits `CTan`'s overflow guard instead of carrying a second copy of it. A large **real** part is the case that would otherwise be `inf/inf` here.
- Both axes are answered directly, for the accuracy and the signed zeros.
- Approaches ±1 for a large real part.
- Spelled with the `C` prefix because a function of the unprefixed name in namespace `FB` would shadow the FreeBASIC intrinsic for every later header — measured, it broke `fb/random.bi` — after which the intrinsic cannot be called back.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as Complex z = CSet( 3, 4 )

print CToString( CTanh( z ) )               '' 1.000709536067233+0.00490825806749606i
print CToString( CTanh( CSet( 750, 1 ) ) )  '' 1+0i   -- heading for 1, not inf/inf
print CToString( CTanh( CSet( 1, 0 ) ) )    '' 0.7615941559557649+0i   -- exactly the real tanh
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
