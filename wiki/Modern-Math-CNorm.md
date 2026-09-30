[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CNorm**

# CNorm

The modulus squared — the square root is not taken.

## Syntax

```freebasic
CNorm( byref z as Complex ) as float64
```

## Notes

- **The one to use for comparisons.** `CNorm(a) < CNorm(b)` answers the same question as `CAbs(a) < CAbs(b)` without either square root.
- `z * CConj( z )` is `CNorm( z )` with a zero imaginary part — that identity is what the name means.
- It **does** overflow where `CAbs` does not: it is the squared quantity, and squaring `1e200` is `inf`.
- AfxNova spelled this `CNorm`, `CAbs2` and `CAbsSqr`.

## Examples

```freebasic
#import "std/numeric"
using FB

print CNorm( CSet( 3, 4 ) )                              '' 25
print CToString( CSet( 3, 4 ) * CConj( CSet( 3, 4 ) ) )  '' 25+0i   -- real, and equal to CNorm
print CNorm( CSet( 1e200, 1e200 ) )                      '' 1.#INF   -- this one DOES overflow -- use CAbs
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
