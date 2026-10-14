[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **Round**

# Round

half away from zero:  2.5 -> 3,  -2.5 -> -3

## Syntax

```freebasic
Round( x )
Round( x, digits )
```

## Notes

- half away from zero: — 2.5 -> 3, — -2.5 -> -3
- 0..17 decimal places

## Examples

```freebasic
#import "std/numeric"
using numeric

'' HALF AWAY FROM ZERO -- the school rule, and NOT what the CPU does
print Round( 2.5 )           '' 3
print Round( -2.5 )          '' -3
print Round( 2.4 )           '' 2

'' RoundHalfEven is the banker's rule, and is what the hardware uses by
'' default -- so the two disagree on exactly the halves
print RoundHalfEven( 2.5 )   '' 2
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Nothing Becomes A Keyword
