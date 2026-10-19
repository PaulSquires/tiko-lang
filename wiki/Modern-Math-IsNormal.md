[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsNormal**

# IsNormal

Returns true if the value is finite, not zero and not subnormal.

## Syntax

```freebasic
IsNormal( x )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

print IsNormal( 1.0 )         '' true
print IsNormal( 0.0 )         '' false -- zero is not normal
print IsNormal( MinSubnormalDouble( ) )       '' false
print IsNormal( NaN( ) )      '' false

'' Normal means full precision: finite, non-zero, and not subnormal
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
