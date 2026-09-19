[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Transpose**

# Transpose

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Math Library](Category-Math-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A matrix with its rows and columns exchanged.

## Syntax

```freebasic
Transpose( byref a as Mat4 ) as Mat4
```

## Notes

- For a **rotation** matrix the transpose is the inverse, which is why a view matrix can be built without inverting anything.
- The storage is **column-major** -- `m( column * 4 + row )` -- so transposing is also the conversion to and from a row-major API.
- Its own inverse.

## Examples

```freebasic
#include once "fb/vector.bi"
using FB

dim as Mat4 m
for i as long = 0 to 15
    m.m( i ) = i
next

dim as Mat4 t = Transpose( m )
print t.m( 1 )               '' 4 -- row and column exchanged

'' Its own inverse
print Transpose( t ).m( 1 )  '' 1
```

---

**Library:** [Math Library](Category-Math-Library) ✨  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the tiko-lang repository.
