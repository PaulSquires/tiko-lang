[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryInverse**

# TryInverse

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The inverse of a matrix, if it has one.

## Syntax

```freebasic
TryInverse( byref a as Mat4, byref outm as Mat4 ) as boolean
```

## Notes

- **FALSE when the matrix is singular**, rather than filling the output with infinities -- the determinant is checked first.
- The output is written only on success.
- For a pure rotation, `Transpose` is the inverse and is far cheaper.

## Examples

```freebasic
#include once "fb/vector.bi"
using FB

dim as Mat4 m
for i as long = 0 to 15
    m.m( i ) = 0
next
for i as long = 0 to 3
    m.m( i * 4 + i ) = 2     '' uniform scale by 2
next

dim as Mat4 inv
print TryInverse( m, inv )   '' true
print inv.m( 0 )             '' 0.5

'' A singular matrix answers FALSE instead of producing infinities
dim as Mat4 s = m
s.m( 0 ) = 0
print TryInverse( s, inv )   '' false
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
