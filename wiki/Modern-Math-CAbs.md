[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CAbs**

# CAbs

The modulus — the distance from the origin.

## Syntax

```freebasic
CAbs( byref z as Complex ) as float64
```

## Notes

- **Factors out the larger component**, so it does not overflow for operands near the type maximum where the naive `sqr( x*x + y*y )` does. Identical in .NET and in AfxNova, and worth keeping.
- An infinite component makes the whole modulus infinite, NaN or not.
- For comparisons use `CNorm` instead: `CAbs(a) < CAbs(b)` costs two square roots for a question that needs none.
- `vector.tiko` used to spell this `AbsValue`. AfxNova spelled it `CAbs`, `CMagnitude`, `CModulus` and `CMod`; one name survives here.

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as Complex big_ = CSet( 1e200, 1e200 )

print CAbs( CSet( 3, 4 ) )                   '' 5   -- exact: the 3-4-5 triangle
print CAbs( big_ )                           '' 1.414213562373095e+200   -- the scaled form survives
print big_.re * big_.re + big_.im * big_.im  '' 1.#INF   -- the naive one does not
print CAbs( CSet( Infinity( ), 1.0 ) )       '' 1.#INF   -- one infinite part is enough
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
