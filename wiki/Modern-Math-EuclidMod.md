[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **EuclidMod**

# EuclidMod

Returns a remainder that is never negative, whatever the signs.

## Syntax

```freebasic
EuclidMod( byval a as T, byval b as T ) as T
```

## Examples

```freebasic
#import "std/numeric"
using numeric

'' The remainder that is ALWAYS NON-NEGATIVE, whatever the signs
dim as int32 a = -1, b = 5
print EuclidMod( a, b )      '' 4

dim as int32 c = -1, d = -5
print EuclidMod( c, d )      '' 4 -- still non-negative
print FloorMod( c, d )       '' -1 -- follows the divisor's sign instead
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
