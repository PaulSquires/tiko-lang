[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAsech**

# CAsech

The inverse hyperbolic secant.

## Syntax

```freebasic
CAsech( byref z as Complex ) as Complex
```

## Notes

- `CAcosh( CReciprocal( z ) )`.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CAsech( CSet( 2, 1 ) ) )    '' 0.21561241855582966-1.1692099351270904i
print CToString( CAsech( CSet( 0.5, 0 ) ) )  '' 1.3169578969248166-0i   -- real, since 1/0.5 is above 1
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
