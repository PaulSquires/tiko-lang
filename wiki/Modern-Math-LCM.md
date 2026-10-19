[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **LCM**

# LCM

Returns the least common multiple of two whole numbers, or 0 if either is 0.

## Syntax

```freebasic
LCM( a, b )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as int32 a = 4, b = 6
print LCM( a, b )            '' 12

'' LCM with zero is zero -- the absorbing element, matching the maths
dim as int32 z = 0
print LCM( a, z )            '' 0
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
