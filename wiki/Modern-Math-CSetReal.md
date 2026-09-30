[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSetReal**

# CSetReal

Assigns the real part in place.

## Syntax

```freebasic
CSetReal( byref z as Complex, byval x as float64 )
```

## Notes

- A **sub**, not a function: it modifies its argument and returns nothing.
- `z.re = x` does the same thing. This exists so that code written against the accessors does not have to reach for the field on the one occasion it assigns.

## Examples

```freebasic
#import "std/numeric"
using FB

dim as Complex z = CSet( 3, 4 )
CSetReal( z, 9 )

print CToString( z )  '' 9+4i   -- after CSetReal( z, 9 )
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
