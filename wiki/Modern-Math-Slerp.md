[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Slerp**

# Slerp

Spherical linear interpolation between two rotations.

## Syntax

```freebasic
Slerp( byref a as Quat, byref b as Quat, byval t as float32 ) as Quat
```

## Notes

- **Constant angular velocity** -- which a component-wise `Lerp` between quaternions does not give, and that difference is visible as a rotation that speeds up in the middle.
- `t` runs 0 to 1 and is not clamped.
- It takes the **shorter arc**: if the two rotations are more than 180 degrees apart it negates one first, because a quaternion and its negation are the same rotation.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Quat a = type<Quat>( 0, 0, 0, 1 )
dim as Quat b = type<Quat>( 0, 0, 0, 1 )

dim as Quat h = Slerp( a, b, 0.5 )
print h.w                    '' 1

'' Constant angular velocity is the whole point: a component-wise Lerp
'' between rotations speeds up in the middle
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
