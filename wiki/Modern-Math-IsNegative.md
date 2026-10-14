[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **IsNegative**

# IsNegative

## Syntax

```freebasic
IsNegative( x )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

print IsNegative( -1.0 )      '' true
print IsNegative( 1.0 )       '' false

'' THE SIGN BIT, not the value -- so NEGATIVE ZERO answers true where
'' `x < 0` answers false. That distinction is the whole reason this
'' exists.
print IsNegative( -0.0 )      '' true
print ( -0.0 < 0 )            '' 0 -- i.e. false: the VALUE is not below
                              '' zero, only its sign bit is set
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
