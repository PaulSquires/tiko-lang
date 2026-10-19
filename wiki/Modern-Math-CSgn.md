[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CSgn**

# CSgn

Returns a complex number scaled to modulus 1, or zero for zero.

## Syntax

```freebasic
CSgn( byref z as Complex ) as Complex
```

## Notes

- `z / CAbs( z )`, and `CZero( )` for zero. This is Mathematica's `Sign[z]` and the only meaning of *sign* that survives on ℂ.
- **Deliberately different from AfxNova**, whose `CSgn` returned a `LONG`: `+1` if the real part was positive, else `-1` if negative, else the same test on the imaginary part. That is a lexicographic tie-break, not a sign, and this header declines to give ℂ an ordering. Code ported from AfxNova gets a **compile error** at the assignment rather than a silently different number.
- The result has modulus 1 and the same argument as the operand.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex z = CSet( 3, 4 )

print CToString( CSgn( z ) )         '' 0.6+0.8i
print CAbs( CSgn( z ) )              '' 1   -- always 1
print CToString( CSgn( CZero( ) ) )  '' 0+0i
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members
