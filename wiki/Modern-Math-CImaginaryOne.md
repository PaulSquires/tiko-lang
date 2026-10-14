[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CImaginaryOne**

# CImaginaryOne

The imaginary unit, i.

## Syntax

```freebasic
CImaginaryOne( ) as Complex
```

## Notes

- `i² = -1` exactly — no rounding, because the four-multiply form of `*` produces `(0·0 - 1·1, 0·1 + 1·0)`.
- Multiplying by `i` is a quarter turn anticlockwise, which is why several bodies in this header rotate by hand rather than calling out to a multiply.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CImaginaryOne( ) )                     '' 0+1i
print CToString( CImaginaryOne( ) * CImaginaryOne( ) )  '' -1+0i   -- exactly -1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
