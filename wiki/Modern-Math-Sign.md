[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Sign**

# Sign

## Syntax

```freebasic
Sign( x ) as LONG
```

## Examples

```freebasic
#import "std/numeric"
using numeric

print Sign( 42.0 )           '' 1
print Sign( -42.0 )          '' -1
print Sign( 0.0 )            '' 0

'' Three-valued, so it cannot answer the negative-zero question -- use
'' IsNegative for the sign BIT
print Sign( -0.0 )           '' 0
print IsNegative( -0.0 )     '' true
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
