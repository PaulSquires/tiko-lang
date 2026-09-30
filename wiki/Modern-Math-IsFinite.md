[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsFinite**

# IsFinite

## Syntax

```freebasic
IsFinite( x )
```

## Examples

```freebasic
#include once "fb/math.bi"
using FB

print IsFinite( 1.0 )         '' true
print IsFinite( Infinity( ) ) '' false
print IsFinite( NaN( ) )      '' false

'' Neither infinite NOR NaN -- the check to make before trusting a value
'' to be arithmetic
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
