[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Truncate**

# Truncate

## Syntax

```freebasic
Truncate( x )
```

## Examples

```freebasic
#import "std/numeric"
using FB

'' TOWARDS ZERO, whichever side of it you are on
print Truncate( 2.7 )        '' 2
print Truncate( -2.7 )       '' -2

'' Floor and Ceil are the ones that pick a direction on the number line
'' rather than a direction relative to zero
print Floor( -2.7 )          '' -3
print Ceil( -2.7 )           '' -2
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
