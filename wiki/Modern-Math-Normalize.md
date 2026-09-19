[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Normalize**

# Normalize

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The unit vector pointing the same way.

## Syntax

```freebasic
Normalize( byref a as Vec3 ) as Vec3
```

## Notes

- **A zero vector normalises to zero**, not to a NaN: there is no direction to preserve, and returning zero is the answer that does not poison everything downstream.
- Overloaded for `Vec2`, `Vec3` and `Quat` -- a quaternion has to stay normalised to represent a rotation at all.
- One square root, so the result is accurate to that bound rather than exact.

## Examples

```freebasic
#include once "fb/vector.bi"
using FB

dim as Vec3 v = type<Vec3>( 3, 4, 0 )
dim as Vec3 n = Normalize( v )

print Length( n )            '' 1
print n.x & " " & n.y        '' 0.6 0.8

'' A ZERO vector gives zero rather than a NaN
dim as Vec3 z = type<Vec3>( 0, 0, 0 )
dim as Vec3 zn = Normalize( z )
print zn.x & " " & zn.y & " " & zn.z          '' 0 0 0
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
