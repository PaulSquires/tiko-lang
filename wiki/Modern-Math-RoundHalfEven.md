[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **RoundHalfEven**

# RoundHalfEven

banker's:             2.5 -> 2,  -2.5 -> -2

## Syntax

```freebasic
RoundHalfEven( x )
RoundHalfEven( x, digits )
```

## Notes

- banker's: — 2.5 -> 2, — -2.5 -> -2

## Examples

```freebasic
#include once "fb/math.bi"
using FB

'' BANKER'S ROUNDING: a half goes to the EVEN neighbour, so a long run
'' of halves does not drift upwards the way half-away-from-zero does
print RoundHalfEven( 2.5 )   '' 2
print RoundHalfEven( 3.5 )   '' 4
print RoundHalfEven( -2.5 )  '' -2

'' This is the IEEE default and what the FPU already does
print Round( 2.5 )           '' 3 -- the other rule, for comparison
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
