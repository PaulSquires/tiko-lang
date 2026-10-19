[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Floor**

# Floor

Rounds down, towards negative infinity, so Floor(-2.1) is -3.

## Syntax

```freebasic
Floor( x )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

print Floor( 2.7 )           '' 2
print Floor( -2.1 )          '' -3 -- TOWARDS NEGATIVE INFINITY, not zero

'' That is the difference from Truncate, and it is the whole reason both
'' exist
print Truncate( -2.1 )       '' -2
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
