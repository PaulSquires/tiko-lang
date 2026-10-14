[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAsec**

# CAsec

The inverse secant.

## Syntax

```freebasic
CAsec( byref z as Complex ) as Complex
CAsec( byval x as float64 ) as Complex
```

## Notes

- `CAcos( CReciprocal( z ) )`, so it inherits the Hull–Fairgrieve–Tang conditioning.
- The `float64` overload is AfxNova's `CArcSecReal`: the real arcsecant is undefined inside `(-1, 1)` while the complex one is not.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CAsec( CSet( 2, 1 ) ) )  '' 1.1692099351270904+0.21561241855582966i
print CToString( CAsec( 0.5 ) )           '' 0-1.3169578969248166i   -- inside the real function's hole
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
