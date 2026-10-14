[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **MinSubnormalSingle**

# MinSubnormalSingle

## Syntax

```freebasic
MinSubnormalSingle( )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float32 m = MinSubnormalSingle( )

print m > 0                  '' -1 (true)
print IsSubnormal( m )       '' true

'' The single-precision counterpart of MinSubnormalDouble
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
