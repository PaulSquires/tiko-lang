[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAsinh**

# CAsinh

The inverse hyperbolic sine.

## Syntax

```freebasic
CAsinh( byref z as Complex ) as Complex
```

## Notes

- Reached through the inverse **trigonometric** functions, so it inherits the Hull–Fairgrieve–Tang conditioning rather than carrying its own copy. `asinh z = -i·asin( iz )`.
- The real axis is answered directly, which is both more accurate and correct about the sign of a zero.
- **`asinh( ±0 )` is special-cased because mingw-w64's `asinh( +0.0 )` returns `-0.0`.** The function is odd and owes the sign of its argument back; that is a platform defect, not an inherited one.
- There is no `float64` overload: the real `asinh` is defined everywhere, so there is nothing for one to fix. Use `Asinh` from `math.tiko`, in the same module.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CAsinh( CSet( 0.5, 0.25 ) ) )  '' 0.49267568342077056+0.22432845263466752i
print CToString( CAsinh( CSet( 0, 1 ) ) )       '' 0+1.5707963267948966i   -- PI/2 -- NaN before the fast path
print CToString( CAsinh( CSet( 1, 0 ) ) )       '' 0.8813735870195429+0i   -- the real asinh
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
