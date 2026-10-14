[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Clamp**

# Clamp

## Syntax

```freebasic
Clamp( v, lo, hi )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 lo = 0.0, hi = 10.0

print Clamp( 5.0, lo, hi )   '' 5 -- already inside
print Clamp( -3.0, lo, hi )  '' 0 -- pulled up to the floor
print Clamp( 99.0, lo, hi )  '' 10 -- pushed down to the ceiling

'' Reads better than Max( lo, Min( hi, x ) ) and says what it is for
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
