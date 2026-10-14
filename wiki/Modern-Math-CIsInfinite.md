[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CIsInfinite**

# CIsInfinite

True when either component is infinite.

## Syntax

```freebasic
CIsInfinite( byref z as Complex ) as boolean
```

## Notes

- **Either** component. A complex number with one infinite part is infinite whatever the other part is — including when the other part is NaN.
- That is why `CAbs` of such a number is `Infinity( )` rather than NaN: the infinity already determines the modulus.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CIsInfinite( CInfinity( ) )                 '' true
print CIsInfinite( CSet( NegInfinity( ), 1.0 ) )  '' true
print CIsInfinite( CSet( Infinity( ), NaN( ) ) )  '' true   -- infinite, not NaN
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
