[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CLog10**

# CLog10

Returns the base-ten logarithm of a complex number.

## Syntax

```freebasic
CLog10( byref z as Complex ) as Complex
```

## Notes

- `CLog( z ) / LN10`, so it inherits `CLog`'s branch cut along the negative real axis.
- `CLog( z, 10.0 )` is the same value by the same route; this exists because base ten is the one worth a name.

## Examples

```freebasic
#import "std/numeric"
using numeric

print CToString( CLog10( CSet( 100, 0 ) ) )    '' 2+0i
print CToString( CLog10( CSet( 0.001, 0 ) ) )  '' -2.9999999999999996+0i
print CToString( CLog10( CSet( -1, 0.0 ) ) )   '' 0+1.3643763538418412i   -- the cut is inherited
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
