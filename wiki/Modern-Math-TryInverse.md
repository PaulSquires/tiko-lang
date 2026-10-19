[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **TryInverse**

# TryInverse

Writes the inverse of a matrix into a second one, or returns false if there is none.

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
#import "std/numeric"
using numeric

dim as Mat4 m
for i as int32 = 0 to 15
    m.m( i ) = 0
next
for i as int32 = 0 to 3
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

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
