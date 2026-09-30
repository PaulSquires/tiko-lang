[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsInfinite**

# IsInfinite

## Syntax

```freebasic
IsInfinite( x )
```

## Examples

```freebasic
#import "std/numeric"
using FB

print IsInfinite( Infinity( ) )       '' true
print IsInfinite( NegInfinity( ) )    '' true -- either sign
print IsInfinite( NaN( ) )            '' false
print IsInfinite( 1.0 )               '' false
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
