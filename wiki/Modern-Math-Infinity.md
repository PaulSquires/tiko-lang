[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Infinity**

# Infinity

## Syntax

```freebasic
Infinity( )
```

## Examples

```freebasic
#import "std/numeric"
using numeric

dim as float64 inf = Infinity( )

print IsInfinite( inf )      '' true
print inf > 1e308            '' -1 (true)

'' Arithmetic on it stays infinite, and the indeterminate forms are NaN
print IsInfinite( inf + 1 )  '' true
print IsNaN( inf - inf )     '' true
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
