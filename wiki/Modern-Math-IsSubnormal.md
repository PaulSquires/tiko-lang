[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsSubnormal**

# IsSubnormal

## Syntax

```freebasic
IsSubnormal( x )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' Below the smallest normal, where the exponent has bottomed out and
'' precision is being lost bit by bit
print IsSubnormal( MinSubnormalDouble( ) )    '' true
print IsSubnormal( 1.0 )                       '' false
print IsSubnormal( 0.0 )                       '' false -- zero is neither

'' Worth testing when a result is suspiciously small: it means the
'' computation has already lost significance
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
