[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSech**

# CSech

Returns the hyperbolic secant of a complex number, one over its cosh.

## Syntax

```freebasic
CSech( byref z as Complex ) as Complex
```

## Notes

- `CReciprocal( CCosh( z ) )`.
- One of the six reciprocal hyperbolic functions AfxNova supplies and .NET does not.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 0.5, 0.25 )

print CToString( CSech( z ) )         '' 0.902703693945398-0.10651712464877593i
print CToString( CSech( CZero( ) ) )  '' 1-0i   -- sech 0 = 1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
