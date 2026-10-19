[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Reflect**

# Reflect

Reflects a vector off a surface, given the surface's normalised normal.

## Syntax

```freebasic
Reflect( byref v as Vec3, byref n as Vec3 ) as Vec3
```

## Notes

- `v - 2 * Dot( v, n ) * n`, which assumes **`n` is already normalised** -- it does not normalise for you, because in a renderer it already is and the root would be wasted.
- The mirror-bounce of a ray or a velocity.
- A vector parallel to the normal comes back negated.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Vec3 v = type<Vec3>( 1, -1, 0 )
dim as Vec3 n = type<Vec3>( 0, 1, 0 )      '' already normalised

dim as Vec3 r = Reflect( v, n )
print r.x & " " & r.y        '' 1 1 -- the y component flipped

'' It does NOT normalise n for you
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
