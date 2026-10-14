[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **ToMatrix**

# ToMatrix

The rotation matrix equivalent to a quaternion.

## Syntax

```freebasic
ToMatrix( byref q as Quat ) as Mat4
```

## Notes

- Worth doing when **many** vectors are to be rotated: the conversion costs once and each transform is then a matrix multiply.
- Assumes the quaternion is normalised.
- The result is orthonormal, so its `Transpose` is its inverse.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Quat q = type<Quat>( 0, 0, 0, 1 )      '' identity
dim as Mat4 m = ToMatrix( q )

print m.m( 0 )               '' 1
print Determinant( m )       '' 1 -- a rotation preserves volume
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
