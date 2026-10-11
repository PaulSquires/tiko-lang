[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CReal**

# CReal

The real part.

## Syntax

```freebasic
CReal( byref z as Complex ) as float64
```

## Notes

- `z.re` reads the same field. `CReal( z )` is the documented spelling because it survives a field rename and because it says at the call site that the operand is complex.
- `vector.tiko` used to spell this `Real`. That name is gone with the rest of the mixed scheme — every function in `complex.tiko` now carries a `C` prefix, and the `complex.tiko` section of [Math Library](Category-Math-Library) says why.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )

print CReal( z )  '' 3
print CImag( z )  '' 4
print z.re        '' 3   -- the field, same value
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
