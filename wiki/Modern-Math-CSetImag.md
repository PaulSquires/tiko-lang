[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSetImag**

# CSetImag

Assigns the imaginary part in place.

## Syntax

```freebasic
CSetImag( byref z as Complex, byval y as float64 )
```

## Notes

- A **sub**, not a function — see `CSetReal`.
- `y` is the coefficient of i, so `CSetImag( z, 4 )` makes the imaginary part `4i`.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )
CSetImag( z, -2 )

print CToString( z )  '' 3-2i   -- after CSetImag( z, -2 )
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
