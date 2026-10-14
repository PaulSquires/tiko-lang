[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSin**

# CSin

The sine.

## Syntax

```freebasic
CSin( byref z as Complex ) as Complex
```

## Notes

- `sin(re)·cosh(im) + i·cos(re)·sinh(im)`, written out directly.
- **It overflows for a large imaginary part**, and correctly so: `cosh` of 750 is beyond `float64`. The sine of a complex number really is unbounded — it is `CTan` that stays finite there, and `CTan` is the one with a guard.
- `CSin² + CCos² = 1` holds to within rounding for every operand.
- Spelled with the `C` prefix because, when this library was a header in namespace `FB`, a function of the unprefixed name shadowed the FreeBASIC intrinsic for every later header — measured, it broke what is now `random.tiko` — after which the intrinsic could not be called back. The name stayed when the header became `std/numeric`.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )

print CToString( CSin( CZero( ) ) )        '' 0+0i   -- exactly zero
print CToString( CSin( z ) )               '' 3.853738037919377-27.016813258003936i
print CIsFinite( CSin( CSet( 1, 750 ) ) )  '' false   -- unbounded, and honestly so
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
