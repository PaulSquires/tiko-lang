[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TransformVector**

# TransformVector

Transforms a direction by a matrix, ignoring its translation.

## Syntax

```freebasic
TransformVector( byref a as Mat4, byref v as Vec3 ) as Vec3
```

## Notes

- A **direction** has no position, so the translation column is skipped -- the w=0 case.
- Using `TransformPoint` on a normal or a velocity is the classic bug: it moves something that only has an orientation.
- Note that a **non-uniform scale** still needs the inverse transpose for normals; this applies the matrix as given.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as Mat4 m
for i as int32 = 0 to 15
    m.m( i ) = 0
next
for i as int32 = 0 to 3
    m.m( i * 4 + i ) = 1
next
m.m( 12 ) = 10               '' translation, which a direction ignores

dim as Vec3 d = type<Vec3>( 1, 0, 0 )
dim as Vec3 r = TransformVector( m, d )
print r.x                    '' 1 -- NOT 11
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
