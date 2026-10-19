[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CImag**

# CImag

Returns the imaginary part of a complex number, without the i.

## Syntax

```freebasic
CImag( byref z as Complex ) as float64
```

## Notes

- Returns the **coefficient** of i, not `im·i`. `CImag( CSet( 3, 4 ) )` is `4`.
- See `CReal` for why the accessor exists beside the field.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )

print CImag( z )           '' 4
print CImag( CConj( z ) )  '' -4   -- the conjugate flips it
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
