[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **NegInfinity**

# NegInfinity

## Syntax

```freebasic
NegInfinity( )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 ninf = NegInfinity( )

print IsInfinite( ninf )     '' true
print IsNegative( ninf )     '' true
print ninf < -1e308          '' -1 (true)
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
