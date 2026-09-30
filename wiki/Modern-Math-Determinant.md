[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Determinant**

# Determinant

The determinant of a matrix.

## Syntax

```freebasic
Determinant( byref a as Mat4 ) as single
```

## Notes

- **Zero means the matrix is singular** and has no inverse -- which is what `TryInverse` checks before doing any work.
- Its sign says whether the transform flips handedness, which is what turns a surface inside out.
- Its magnitude is the volume scale factor of the transform.

## Examples

```freebasic
#include once "fb/vector.bi"
using FB

dim as Mat4 m
for i as long = 0 to 15
    m.m( i ) = 0
next
for i as long = 0 to 3
    m.m( i * 4 + i ) = 1     '' the identity
next

print Determinant( m )       '' 1

'' A singular matrix has determinant zero and no inverse
dim as Mat4 s = m
s.m( 0 ) = 0
print Determinant( s )       '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
