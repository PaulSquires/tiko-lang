[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Transpose**

# Transpose

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
#import "std/numeric"
using numeric

dim as Mat4 m
for i as int32 = 0 to 15
    m.m( i ) = i
next

dim as Mat4 t = Transpose( m )
print t.m( 1 )               '' 4 -- row and column exchanged

'' Its own inverse
print Transpose( t ).m( 1 )  '' 1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
