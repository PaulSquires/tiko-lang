[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Truncate**

# Truncate

Drops the fraction, rounding towards zero, so Truncate(-2.7) is -2.

## Syntax

```freebasic
Truncate( x )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

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
