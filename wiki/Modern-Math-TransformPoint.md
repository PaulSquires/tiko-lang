[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TransformPoint**

# TransformPoint

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Transforms a point by a matrix, including its translation.

## Syntax

```freebasic
TransformPoint( byref a as Mat4, byref v as Vec3 ) as Vec3
```

## Notes

- A **point** has a position, so the translation column applies -- this is the w=1 case.
- `TransformVector` is the w=0 case for directions, and using the wrong one is the classic bug that translates a surface normal.
- It divides by w afterwards, so a projection matrix works.

## Examples

```freebasic
#include once "fb/vector.bi"
using FB

dim as Mat4 m
for i as long = 0 to 15
    m.m( i ) = 0
next
for i as long = 0 to 3
    m.m( i * 4 + i ) = 1
next
m.m( 12 ) = 10               '' the translation column

dim as Vec3 p = type<Vec3>( 1, 2, 3 )
dim as Vec3 r = TransformPoint( m, p )
print r.x                    '' 11 -- translated

'' A DIRECTION must not be translated -- that is TransformVector
dim as Vec3 d = TransformVector( m, p )
print d.x                    '' 1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
